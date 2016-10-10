
#import "NSObject+MAGMore.h"
#import <objc/runtime.h>

@implementation NSObject(MAGMore)

- (NSString *)mag_className {
	return [NSString stringWithUTF8String:class_getName([self class])];
}

+ (NSString *)mag_className {
	return [NSString stringWithUTF8String:class_getName(self)];
}

- (id)selfOrEmptyStringIfNil {
    id result = self;
    if (!result) {
        result = @"";
    }
    return result;
}

@end
