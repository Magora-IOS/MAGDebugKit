#import <Foundation/Foundation.h>


#ifdef LOG_LEVEL_DEF
	#undef LOG_LEVEL_DEF
#endif
#define LOG_LEVEL_DEF magDebugKitLogLevel

#import <CocoaLumberjack/CocoaLumberjack.h>

extern DDLogLevel magDebugKitLogLevel;


@interface MAGLogging : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic) DDLogLevel logLevel;

@property (nonatomic) BOOL fileLoggingEnabled;
@property (nonatomic) BOOL ttyLoggingEnabled;
@property (nonatomic) BOOL aslLoggingEnabled;

// Send logs via TCP socket.
@property (nonatomic) BOOL remoteLoggingEnabled;
@property (nonatomic, copy) NSString *remoteLoggingHost;
@property (nonatomic) NSNumber *remoteLoggingPort;
@property (nonatomic, copy) NSDictionary *remoteLoggingDictionary;

@end
