#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>


extern DDLogLevel magDebugKitLogLevel;
extern BOOL magDebugKitAsyncLogs;
#define LOG_ASYNC_ENABLED magDebugKitAsyncLogs
#define LOG_LEVEL_DEF magDebugKitLogLevel


@interface MAGLogging : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic) BOOL fileLoggingEnabled;
@property (nonatomic) BOOL consoleLoggingEnabled;

@property (nonatomic) BOOL antennaLoggingEnabled;
@property (nonatomic, copy) NSString *antennaLoggingHost;
@property (nonatomic) NSNumber *antennaLoggingPort;

@end
