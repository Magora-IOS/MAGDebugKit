#import <UIKit/UIKit.h>


@class MAGPanelButtonCell;
@class MAGPanelTitleCell;
@class MAGPanelToggleCell;
@class MAGPanelInputCell;
@class MAGPanelPickerManager;


@interface MAGSettingsPanelVC : UIViewController

- (MAGPanelTitleCell *)addTitle:(NSString *)title;

- (MAGPanelButtonCell *)addButtonWithTitle:(NSString *)title action:(void(^)(void))action;

- (MAGPanelToggleCell *)addToggleWithTitle:(NSString *)title key:(NSString *)key action:(void(^)(BOOL value))action;

- (MAGPanelInputCell *)addInputWithTitle:(NSString *)title key:(NSString *)key action:(void(^)(NSString *value))action;

- (MAGPanelPickerManager *)addPickerWithTitle:(NSString *)title key:(NSString *)key
	options:(NSArray *)options optionRenderer:(NSString *(^)(id value))renderer
	action:(void(^)(id value))action;

@end
