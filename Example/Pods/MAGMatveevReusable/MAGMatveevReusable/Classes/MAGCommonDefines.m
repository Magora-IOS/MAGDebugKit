








#import "MAGCommonDefines.h"

BOOL mag_isDebugBuild() {
    BOOL result = NO;
#ifdef DEBUG
    result = YES;
#endif
    return result;
}

BOOL mag_isEqualObjects(id obj1, id obj2) {
    BOOL result;
    if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSString class]]) {
        result = [obj1 isEqualToString:obj2];
    } else {
        result = [obj1 isEqual:obj2];
    }
    return result;
}

BOOL mag_isThisBuildDownloadedFromAppStore() {
    BOOL result = NO;
    BOOL isTestBuild = IS_DEBUG_BUILD || [[[[NSBundle mainBundle] appStoreReceiptURL] lastPathComponent] isEqualToString:@"sandboxReceipt"];//        so you can test it on sandbox apple servers when install build via Xcode or install build via apple's test flight. http://stackoverflow.com/a/27398665/3627460
    result = !isTestBuild;
    return result;
}

@implementation MAGCommonDefines

@end
