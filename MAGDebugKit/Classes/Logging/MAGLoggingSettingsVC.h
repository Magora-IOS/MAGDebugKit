#import "MAGSettingsPanelVC.h"
#import "MAGLogging.h"


typedef NS_ENUM(NSUInteger, MAGLoggingLevel) {
	MAGLoggingLevelUndefined = 0,
	MAGLoggingLevelOff,
	MAGLoggingLevelError,
	MAGLoggingLevelWarning,
	MAGLoggingLevelInfo,
	MAGLoggingLevelDebug,
	MAGLoggingLevelVerbose,
	MAGLoggingLevelAll
};
extern DDLogLevel ddLogLevelForLoggingLevel(MAGLoggingLevel level);


@interface MAGLoggingSettingsVC : MAGSettingsPanelVC
@end
