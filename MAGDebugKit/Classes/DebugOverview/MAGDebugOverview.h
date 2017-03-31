








#import <UIKit/UIKit.h>

@interface MAGDebugOverview : UIView

+ (instancetype)sharedInstance;
+ (instancetype)addToWindow;
+ (instancetype)addToStatusBar;
+ (void)dismissSharedInstance;

- (void)displayMessage:(NSString *)message;

@end
