#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>


extern DDLogLevel magDebugKitLogLevel;
extern BOOL magDebugKitAsyncLogs;
#define LOG_ASYNC_ENABLED magDebugKitAsyncLogs
#define LOG_LEVEL_DEF magDebugKitLogLevel


@interface MAGLogging : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic) DDLogLevel logLevel;

@property (nonatomic) BOOL fileLoggingEnabled;
@property (nonatomic) BOOL consoleLoggingEnabled;

// Send logs via TCP socket.
@property (nonatomic) BOOL remoteLoggingEnabled;
@property (nonatomic, copy) NSString *remoteLoggingHost;
@property (nonatomic) NSNumber *remoteLoggingPort;

@end
