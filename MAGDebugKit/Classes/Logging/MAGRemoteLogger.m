#import "MAGRemoteLogger.h"
#import <CocoaAsyncSocket/GCDAsyncSocket.h>


@interface MAGRemoteLogger () <GCDAsyncSocketDelegate>

@property (nonatomic, copy) NSString *host;
@property (nonatomic) NSUInteger port;
@property (nonatomic) GCDAsyncSocket *socket;

#warning Rewrite to make access to the queue thread-safe.
@property (nonatomic) NSMutableArray *logsToShip;
@property (nonatomic) DDLogMessage *shippingLog;

@end


@implementation MAGRemoteLogger

#pragma mark - Lifecycle

- (instancetype)initWithHost:(NSString *)host port:(NSUInteger)port {
	self = [self init];
	if (!self) {
		return nil;
	}
	
	_host = [host copy];
	_port = port;
	_socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	
	_logsToShip = [[NSMutableArray alloc] init];
	
	return self;
}

#pragma mark - Public methods

- (void)logMessage:(DDLogMessage *)logMessage {
	[self.logsToShip addObject:logMessage];
	[self shipFromQueue];
}

#pragma mark - Private methods

- (void)shipFromQueue {
	if (self.logsToShip.count == 0) {
		return;
	}
	
	self.shippingLog = self.logsToShip.firstObject;
	
	NSError *__autoreleasing error = nil;
	[self.socket connectToHost:self.host onPort:self.port error:&error];
	
	if (error) {
		NSLog(@"Failed to connect with error: %@", error);
		self.shippingLog = nil;
	}
}

#pragma mark - Socket delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
	NSString *string = [self.logFormatter formatLogMessage:self.shippingLog];
	NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
	[sock writeData:data withTimeout:10 tag:0];
	[self.socket disconnectAfterReadingAndWriting];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
	[self.logsToShip removeObject:self.shippingLog];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err {
	if (err) {
		NSLog(@"Socket did disconnect with error: %@", err);
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self shipFromQueue];
		});
	} else {
		[self shipFromQueue];
	}
}

@end
