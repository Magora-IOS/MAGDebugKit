#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>


extern DDLogLevel magDebugKitLogLevel;
extern BOOL magDebugKitAsyncLogs;
#define LOG_ASYNC_ENABLED magDebugKitAsyncLogs
#define LOG_LEVEL_DEF magDebugKitLogLevel


@interface MAGLogging : NSObject

+ (instancetype)sharedInstance;
+ (void)addToWindowWithFrame:(CGRect)frame;

@property (nonatomic) BOOL fileLoggingEnabled;
@property (nonatomic) BOOL consoleLoggingEnabled;
@property (nonatomic) BOOL antennaLoggingEnabled;

@end
