#import <Foundation/Foundation.h>


// To log inits of VCs, that are initialized before the MAGDebugKit itself,
// you can call the enableInitDeallocLogging manually
// in next manner (from anywhere inside your project):
//
//
// @interface UIViewController (CustomVCLogging)
// @end
//
//
// @implementation UIViewController (CustomVCLogging)
//
// + (void)load {
//     static dispatch_once_t onceToken;
//     dispatch_once(&onceToken, ^{
//         [MAGVCLifecycleLogging enableInitDeallocLogging];
//     });
// }
//
// @end
//
//
// Still, you should keep in mind, that MAGVCLifecycleLogging uses MAGLogging,
// and some of your VCs may be loaded before that (and won't be logged).
//

@interface MAGVCLifecycleLogging : NSObject

+ (void)enableInitDeallocLogging;
+ (void)disableInitDeallocLogging;

@end

