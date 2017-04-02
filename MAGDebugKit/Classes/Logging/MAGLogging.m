#import "MAGLogging.h"
#import "MAGRemoteLogger.h"
#import "MAGJSONLogFormatter.h"


#ifdef DEBUG
	DDLogLevel magDebugKitLogLevel = DDLogLevelVerbose;
	BOOL magDebugKitAsyncLogs = YES;
#else
	DDLogLevel magDebugKitLogLevel = DDLogLevelWarning;
	BOOL magDebugKitAsyncLogs = YES;
#endif


@interface MAGLogging ()

@property (nonatomic) DDFileLogger *fileLogger;
@property (nonatomic) DDTTYLogger *ttyLogger;
@property (nonatomic) MAGRemoteLogger *remoteLogger;

@end


@implementation MAGLogging

+ (instancetype)sharedInstance {
    static MAGLogging *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MAGLogging alloc] init];
    });
    return sharedInstance;
}

- (void)setConsoleLoggingEnabled:(BOOL)consoleLoggingEnabled {
	if (_consoleLoggingEnabled == consoleLoggingEnabled) {
		return;
	}

	_consoleLoggingEnabled = consoleLoggingEnabled;
	
	if (self.consoleLoggingEnabled) {
		self.ttyLogger = [DDTTYLogger sharedInstance];
		[DDLog addLogger:self.ttyLogger];
	} else {
		[DDLog removeLogger:self.ttyLogger];
		self.ttyLogger = nil;
	}
}

- (void)setFileLoggingEnabled:(BOOL)fileLoggingEnabled {
	if (_fileLoggingEnabled == fileLoggingEnabled) {
		return;
	}
	
	_fileLoggingEnabled = fileLoggingEnabled;
	
	if (self.fileLoggingEnabled) {
		self.fileLogger = [[DDFileLogger alloc] init];
		self.fileLogger.rollingFrequency = 60*60;
		self.fileLogger.logFileManager.maximumNumberOfLogFiles = 48;
		[DDLog addLogger:self.fileLogger];
	} else {
		[DDLog removeLogger:self.fileLogger];
		self.fileLogger = nil;
	}
}

- (void)setRemoteLoggingEnabled:(BOOL)remoteLoggingEnabled {
	if (_remoteLoggingEnabled == remoteLoggingEnabled) {
		return;
	}
	
	_remoteLoggingEnabled = remoteLoggingEnabled;
	
	[DDLog removeLogger:self.remoteLogger];
	self.remoteLogger = nil;

	if (self.remoteLoggingEnabled) {
		self.remoteLogger = [[MAGRemoteLogger alloc] initWithHost:self.remoteLoggingHost port:self.remoteLoggingPort.unsignedIntegerValue];
		self.remoteLogger.logFormatter = [MAGJSONLogFormatter new];
		[DDLog addLogger:self.remoteLogger];
	} else {
		[DDLog removeLogger:self.remoteLogger];
		self.remoteLogger = nil;
	}
}

@end
