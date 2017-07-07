#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>


extern DDLogLevel magDebugKitLogLevel;
extern BOOL magDebugKitAsyncLogs;

#ifdef LOG_ASYNC_ENABLED
	#undef LOG_ASYNC_ENABLED
#endif
#define LOG_ASYNC_ENABLED magDebugKitAsyncLogs

#ifdef LOG_LEVEL_DEF
	#undef LOG_LEVEL_DEF
#endif
#define LOG_LEVEL_DEF magDebugKitLogLevel


@interface MAGLogging : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic) DDLogLevel logLevel;

@property (nonatomic) BOOL fileLoggingEnabled;
@property (nonatomic) BOOL ttyLoggingEnabled;
@property (nonatomic) BOOL aslLoggingEnabled;

// Send logs via TCP socket.
@property (nonatomic) NSNumber *remoteLoggingEnabled;
@property (nonatomic, copy) NSString *remoteLoggingHost;
@property (nonatomic) NSNumber *remoteLoggingPort;
@property (nonatomic, copy) NSDictionary *remoteLoggingDictionary;

@end
