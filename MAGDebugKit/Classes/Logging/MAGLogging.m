#import "MAGLogging.h"
#import <DDAntennaLogger/DDAntennaLogger.h>
#import <Antenna/Antenna.h>


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
@property (nonatomic) DDAntennaLogger *antennaLogger;

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

- (void)setAntennaLoggingEnabled:(BOOL)antennaLoggingEnabled {
	if (_antennaLoggingEnabled == antennaLoggingEnabled) {
		return;
	}
	
	_antennaLoggingEnabled = antennaLoggingEnabled;
	
	NSString *serverURLString = @"http://192.168.16.32:3205/log";
	NSString *serverLogMethod = @"POST";
	Antenna *antenna = [Antenna sharedLogger];
	[antenna addChannelWithURL:[NSURL URLWithString:serverURLString]
		method:serverLogMethod];
	[antenna startLoggingApplicationLifecycleNotifications];
	
	if (self.antennaLoggingEnabled) {
		self.antennaLogger = [[DDAntennaLogger alloc] initWithAntenna:antenna];
		[DDLog addLogger:self.antennaLogger];
	} else {
		[DDLog removeLogger:self.antennaLogger];
		self.antennaLogger = nil;
	}
}

@end
