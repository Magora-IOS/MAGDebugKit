#import <UIKit/UIKit.h>


@class MAGPanelButtonCell;
@class MAGPanelTitleCell;
@class MAGPanelToggleCell;


@interface MAGSettingsPanelVC : UIViewController

- (MAGPanelTitleCell *)addTitle:(NSString *)title;
- (MAGPanelButtonCell *)addButtonWithTitle:(NSString *)title action:(void(^)(void))action;
- (MAGPanelToggleCell *)addToggleWithTitle:(NSString *)title key:(NSString *)key action:(void(^)(BOOL value))action;

@end
