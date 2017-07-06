#import "MAGRemoteLogger.h"
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import <ReactiveObjC/ReactiveObjC.h>


static NSTimeInterval const idleConnection = 10.0;
static NSTimeInterval const retryInterval = 10.0;


NSDictionary *mag_encodedLogMessage(DDLogMessage *message) {
	NSMutableDictionary *encoded = [[NSMutableDictionary alloc] init];
	
	encoded[@keypath(DDLogMessage.new, message)] = message.message;
	encoded[@keypath(DDLogMessage.new, level)] = @(message.level);
	encoded[@keypath(DDLogMessage.new, flag)] = @(message.flag);
	encoded[@keypath(DDLogMessage.new, context)] = @(message.context);
	encoded[@keypath(DDLogMessage.new, file)] = message.file;
	encoded[@keypath(DDLogMessage.new, function)] = message.function;
	encoded[@keypath(DDLogMessage.new, line)] = @(message.line);
	encoded[@keypath(DDLogMessage.new, tag)] = message.tag;
	encoded[@keypath(DDLogMessage.new, options)] = @(message.options);
	encoded[@keypath(DDLogMessage.new, timestamp)] = message.timestamp;
	
	return encoded;
}

DDLogMessage *mag_decodedLogMessage(NSDictionary *encoded) {
	DDLogMessage *message = [[DDLogMessage alloc]
		initWithMessage:encoded[@keypath(DDLogMessage.new, message)]
		level:[encoded[@keypath(DDLogMessage.new, level)] unsignedIntegerValue]
		flag:[encoded[@keypath(DDLogMessage.new, flag)] unsignedIntegerValue]
		context:[encoded[@keypath(DDLogMessage.new, context)] integerValue]
		file:encoded[@keypath(DDLogMessage.new, file)]
		function:encoded[@keypath(DDLogMessage.new, function)]
		line:[encoded[@keypath(DDLogMessage.new, line)] unsignedIntegerValue]
		tag:encoded[@keypath(DDLogMessage.new, tag)]
		options:[encoded[@keypath(DDLogMessage.new, options)] integerValue]
		timestamp:encoded[@keypath(DDLogMessage.new, timestamp)]];
	
	return message;
}

@interface MAGRemoteLogger () <GCDAsyncSocketDelegate>

@property (nonatomic, copy) NSString *host;
@property (nonatomic) NSUInteger port;
@property (nonatomic) GCDAsyncSocket *socket;

@property (nonatomic) NSMutableArray <DDLogMessage *> *logsToShip;
@property (atomic) dispatch_queue_t loggingQueue;
@property (nonatomic) NSURL *diskQueue;
@property (nonatomic) dispatch_block_t disconnectionBlock;

@property (nonatomic) DDLogMessage *shippingLog;

@end


@implementation MAGRemoteLogger

#pragma mark - Lifecycle

- (instancetype)initWithHost:(NSString *)host port:(NSUInteger)port {
	self = [self init];
	if (!self) {
		return nil;
	}
	
	_logsToShip = [[NSMutableArray alloc] init];
	_loggingQueue = dispatch_queue_create("loggingQueue", DISPATCH_QUEUE_SERIAL);

	_host = [host copy];
	_port = port;
	_socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_loggingQueue];
	
	NSString *cachesDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
	NSString *fileId = [NSString stringWithFormat:@"%@:%@", host, @(port)];
	NSData *fileIdData = [fileId dataUsingEncoding:NSUTF8StringEncoding];
	NSString *fileName = [fileIdData base64EncodedStringWithOptions:0];
	NSString *path = [cachesDir stringByAppendingPathComponent:fileName];
	_diskQueue = [NSURL fileURLWithPath:path];
	[self loadDiskQueue];
	
	return self;
}

#pragma mark - Public methods

- (void)logMessage:(DDLogMessage *)logMessage {
	dispatch_async(self.loggingQueue, ^{
		[self.logsToShip addObject:logMessage];
		[self saveDiskQueue];
		[self shipFromQueue];
	});
}

#pragma mark - Private methods

- (void)loadDiskQueue {
	NSArray *diskQueue = [[NSArray alloc] initWithContentsOfURL:self.diskQueue];
	if (diskQueue) {
		for (NSDictionary *encoded in diskQueue) {
			DDLogMessage *message = mag_decodedLogMessage(encoded);
			[self.logsToShip addObject:message];
		}
		
		[self shipFromQueue];
	}
}

- (void)saveDiskQueue {
	NSMutableArray *encodedLogs = [[NSMutableArray alloc] initWithCapacity:self.logsToShip.count];
	for (DDLogMessage *message in self.logsToShip) {
		NSDictionary *encoded = mag_encodedLogMessage(message);
		[encodedLogs addObject:encoded];
	}

	[encodedLogs writeToURL:self.diskQueue atomically:YES];
}

- (void)shipFromQueue {
	if (self.logsToShip.count == 0) {
		[self scheduleDisconnect];
		return;
	}
	
	if (self.shippingLog) {
		return;
	}
	
	self.shippingLog = self.logsToShip.firstObject;
	
	if (self.socket.isConnected) {
		[self writeShippingLogToSocket];
	} else {
		NSError *__autoreleasing error = nil;
		[self.socket connectToHost:self.host onPort:self.port error:&error];
		
		if (error) {
			self.shippingLog = nil;
		}
	}
}

- (void)writeShippingLogToSocket {
	NSString *string = [self.logFormatter formatLogMessage:self.shippingLog];
	NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
	[self.socket writeData:data withTimeout:10 tag:0];
}

- (void)scheduleDisconnect {
	if (self.disconnectionBlock) {
		dispatch_block_cancel(self.disconnectionBlock);
		self.disconnectionBlock = nil;
	}

	self.disconnectionBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS,
		^{
			if (self.socket.isDisconnected) {
				return;
			}
		
			// Don't disconnect if queue became non-empty during a timeout.
			if (self.shippingLog || self.logsToShip.count > 0) {
				return;
			}
			
			[self.socket disconnectAfterReadingAndWriting];
		}
	);

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(idleConnection * NSEC_PER_SEC)),
		dispatch_get_main_queue(), self.disconnectionBlock);
}

#pragma mark - Socket delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
	[self writeShippingLogToSocket];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
	[self.logsToShip removeObject:self.shippingLog];
	[self saveDiskQueue];
	
	self.shippingLog = nil;
	
	[self shipFromQueue];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err {
	if (err) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(retryInterval * NSEC_PER_SEC)),
			self.loggingQueue, ^{
				[self shipFromQueue];
			});
	}
}

@end
