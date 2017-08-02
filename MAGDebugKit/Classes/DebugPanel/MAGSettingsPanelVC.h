#import <UIKit/UIKit.h>


@class MAGPanelButtonCell;
@class MAGPanelTitleCell;


@interface MAGSettingsPanelVC : UIViewController

- (MAGPanelTitleCell *)addTitle:(NSString *)title;
- (MAGPanelButtonCell *)addButtonWithTitle:(NSString *)title action:(void(^)(void))action;

@end
