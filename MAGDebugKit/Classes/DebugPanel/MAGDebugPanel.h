#import <Bohr/Bohr.h>


typedef NS_ENUM(NSUInteger, MAGDebugPanelAppearanceStyle) {
    MAGDebugPanelAppearanceStyleUnknown = 0,
    MAGDebugPanelAppearanceStyleRight,
};


@interface MAGDebugPanel : BOTableViewController

@property (nonatomic, readonly) MAGDebugPanelAppearanceStyle appearanceStyle;

// Must be initialized with predefined appearance style.
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithAppearanceStyle:(MAGDebugPanelAppearanceStyle)appearanceStyle;

// Initialize an instance with MAGDebugPanelAppearanceStyleRight.
+ (instancetype)rightPanel;

// Add panel to window, and setup gesture recognizer according to appearance style.
- (void)integrateAboveWindow:(UIWindow *)appWindow;
- (void)desintegrate;

- (void)addAction:(void(^)(void))action withTitle:(NSString *)title;

@end
