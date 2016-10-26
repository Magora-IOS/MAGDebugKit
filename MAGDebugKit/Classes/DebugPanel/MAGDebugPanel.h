#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, MAGDebugPanelAppearanceStyle) {
    MAGDebugPanelAppearanceStyleUnknown = 0,
    MAGDebugPanelAppearanceStyleRight,
};


@interface MAGDebugPanel : UIViewController

@property (nonatomic, readonly) MAGDebugPanelAppearanceStyle appearanceStyle;

// Must be initialized with predefined appearance style.
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithAppearanceStyle:(MAGDebugPanelAppearanceStyle)appearanceStyle;

// Initialize an instance with MAGDebugPanelAppearanceStyleRight.
+ (instancetype)rightPanel;

// Add panel to window, and setup gesture recognizer according to appearance style.
- (void)integrateAboveWindow:(UIWindow *)appWindow;
- (void)desintegrate;

@end
