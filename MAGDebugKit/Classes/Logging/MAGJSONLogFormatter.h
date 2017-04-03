#import <CocoaLumberjack/CocoaLumberjack.h>


@interface MAGJSONLogFormatter : NSObject <DDLogFormatter>

- (void)setPermanentLogValue:(id)value field:(NSString *)field;

@end
