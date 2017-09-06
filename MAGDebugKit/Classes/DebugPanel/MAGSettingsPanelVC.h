#import <UIKit/UIKit.h>


@class MAGPanelButtonCell;
@class MAGPanelTitleCell;
@class MAGPanelToggleCell;
@class MAGPanelInputCell;
@class MAGPanelPickerManager;
@protocol MAGSettingsReactor;
@protocol MAGPanelCell;


@interface MAGSettingsPanelVC : UIViewController

@property (nonatomic, readonly) id<MAGSettingsReactor> settingsReactor;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithSettings:(id<MAGSettingsReactor>)settingsReactor;

- (MAGPanelTitleCell *)addTitle:(NSString *)title;

- (MAGPanelButtonCell *)addButtonWithTitle:(NSString *)title action:(void(^)(void))action;

- (MAGPanelToggleCell *)addToggleWithTitle:(NSString *)title key:(NSString *)key;

- (MAGPanelInputCell *)addInputWithTitle:(NSString *)title key:(NSString *)key;

- (MAGPanelPickerManager *)addPickerWithTitle:(NSString *)title key:(NSString *)key
	options:(NSArray *)options optionRenderer:(NSString *(^)(id value))renderer;

- (void)removeCell:(__kindof UIView<MAGPanelCell> *)cell;

@end
