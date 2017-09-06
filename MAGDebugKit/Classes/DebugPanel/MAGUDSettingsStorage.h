#import <Foundation/Foundation.h>
#import "MAGSettingsReactor.h"


@interface MAGUDSettingsStorage : NSObject <MAGSettingsReactor>

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults;

@end
