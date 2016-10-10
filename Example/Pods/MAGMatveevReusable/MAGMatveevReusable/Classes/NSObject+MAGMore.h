
#import <Foundation/Foundation.h>

@interface NSObject(MAGMore)

- (NSString *)mag_className;
+ (NSString *)mag_className;

- (id)selfOrEmptyStringIfNil;

@end
