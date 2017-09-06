#import "MAGLogging.h"
#import "MAGRemoteLogger.h"
#import "MAGJSONLogFormatter.h"


#if DEBUG
	DDLogLevel magDebugKitLogLevel = DDLogLevelAll;
#else
	DDLogLevel magDebugKitLogLevel = DDLogLevelWarning;
#endif


@interface MAGLogging ()

@property (nonatomic) DDFileLogger *fileLogger;
@property (nonatomic) DDTTYLogger *ttyLogger;
@property (nonatomic) DDASLLogger *aslLogger;

@property (nonatomic) MAGRemoteLogger *remoteLogger;
@property (nonatomic) MAGJSONLogFormatter *remoteLogFormatter;

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

- (void)setLogLevel:(DDLogLevel)logLevel {
	magDebugKitLogLevel = logLevel;
}

- (DDLogLevel)logLevel {
	return magDebugKitLogLevel;
}

- (void)setTtyLoggingEnabled:(BOOL)ttyLoggingEnabled {
	if (_ttyLoggingEnabled == ttyLoggingEnabled) {
		return;
	}

	_ttyLoggingEnabled = ttyLoggingEnabled;
	
	if (self.ttyLoggingEnabled) {
		self.ttyLogger = [DDTTYLogger sharedInstance];
		[DDLog addLogger:self.ttyLogger];
	} else {
		[DDLog removeLogger:self.ttyLogger];
		self.ttyLogger = nil;
	}
}

- (void)setAslLoggingEnabled:(BOOL)aslLoggingEnabled {
	if (_aslLoggingEnabled == aslLoggingEnabled) {
		return;
	}

	_aslLoggingEnabled = aslLoggingEnabled;
	
	if (self.aslLoggingEnabled) {
		self.aslLogger = [DDASLLogger sharedInstance];
		[DDLog addLogger:self.aslLogger];
	} else {
		[DDLog removeLogger:self.aslLogger];
		self.aslLogger = nil;
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

- (void)setRemoteLoggingHost:(NSString *)remoteLoggingHost {
	_remoteLoggingHost = [remoteLoggingHost copy];
	if (self.remoteLoggingEnabled) {
		[self refreshConnection];
	}
}

- (void)setRemoteLoggingPort:(NSNumber *)remoteLoggingPort {
	_remoteLoggingPort = remoteLoggingPort;
	if (self.remoteLoggingEnabled) {
		[self refreshConnection];
	}
}

- (void)setRemoteLoggingEnabled:(BOOL)remoteLoggingEnabled {
	if (_remoteLoggingEnabled == remoteLoggingEnabled) {
		return;
	}
	
	_remoteLoggingEnabled = remoteLoggingEnabled;
	
	[self refreshConnection];
}

- (void)setRemoteLoggingDictionary:(NSDictionary *)dict {
	_remoteLoggingDictionary = dict;
	[self updatePermanentLogValuesFromDictionary];
}

- (void)updatePermanentLogValuesFromDictionary {
	if (self.remoteLogger && self.remoteLogger.logFormatter) {
		for (NSString *key in self.remoteLoggingDictionary) {
			[self.remoteLogFormatter
				setPermanentLogValue:self.remoteLoggingDictionary[key] field:key];
		}
	}
}

#pragma mark - Private methods

- (void)refreshConnection {
	[DDLog removeLogger:self.remoteLogger];
	self.remoteLogger = nil;

	if (self.remoteLoggingEnabled) {
		self.remoteLogger = [[MAGRemoteLogger alloc] initWithHost:self.remoteLoggingHost port:self.remoteLoggingPort.unsignedIntegerValue];
		self.remoteLogFormatter = [[MAGJSONLogFormatter alloc] init];
		MAGJSONLogFormatter *formatter = self.remoteLogFormatter;
		[formatter setPermanentLogValue:@"log" field:@"type"];
		[formatter setPermanentLogValue:[NSProcessInfo processInfo].operatingSystemVersionString field:@"os"];

		NSString *appIdString = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
		[formatter setPermanentLogValue:appIdString field:@"app_id"];

		NSString *appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
		NSString *appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
		NSString *fullVersionString = [NSString stringWithFormat:@"%@(%@)", appVersionString, appBuildString];
		[formatter setPermanentLogValue:fullVersionString field:@"app_version"];
		[self updatePermanentLogValuesFromDictionary];
		
		self.remoteLogger.logFormatter = formatter;
		[DDLog addLogger:self.remoteLogger];
	} else {
		[DDLog removeLogger:self.remoteLogger];
		self.remoteLogger.logFormatter = nil;
		self.remoteLogFormatter = nil;
		self.remoteLogger = nil;
	}
}

@end
