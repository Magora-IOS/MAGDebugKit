#import "MAGSettingsPanelVC.h"
#import "MAGPanelGeometry.h"
#import "MAGPanelButtonCell.h"
#import "MAGPanelSeparator.h"
#import "MAGPanelTitleCell.h"
#import "MAGPanelToggleCell.h"
#import "MAGPanelInputCell.h"
#import "MAGPanelPickerCell.h"
#import "MAGPanelPickerManager.h"
#import "MAGSettingsReactor.h"

#import <Masonry/Masonry.h>


@interface MAGSettingsPanelVC ()

@property (nonatomic) id<MAGSettingsReactor> settingsReactor;

@property (nonatomic) UIStackView *stackView;
@property (nonatomic) NSMutableArray *pickerManagers;

@end


@implementation MAGSettingsPanelVC

#pragma mark - Lifecycle

- (instancetype)initWithSettings:(id<MAGSettingsReactor>)settingsReactor {
	self = [super initWithNibName:nil bundle:nil];
	
	if (!self) {
		return nil;
	}
	
	_settingsReactor = settingsReactor;
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	self.view.backgroundColor = [UIColor magPanelBackground];
	
	self.stackView = [[UIStackView alloc] init];
	self.stackView.axis = UILayoutConstraintAxisVertical;
	
	UIScrollView *scroller = [[UIScrollView alloc] init];
	[self.view addSubview:scroller];
	[scroller mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self.view);
		}];

	[scroller addSubview:self.stackView];
	[self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(scroller);
			make.width.equalTo(self.view);
		}];
	
	self.pickerManagers = [[NSMutableArray alloc] init];
}

#pragma mark - Public methods

- (MAGPanelTitleCell *)addTitle:(NSString *)title {
	MAGPanelTitleCell *titleView = [[MAGPanelTitleCell alloc] init];
	titleView.title = title;
	[self.stackView addArrangedSubview:titleView];
	
	return titleView;
}

- (MAGPanelButtonCell *)addButtonWithTitle:(NSString *)title action:(void(^)(void))action {
	MAGPanelButtonCell *button = [[MAGPanelButtonCell alloc] init];
	button.title = title;
	button.action = action;
	[self.stackView addArrangedSubview:button];
	[self.stackView addArrangedSubview:[MAGPanelSeparator new]];
	
	return button;
}

- (MAGPanelToggleCell *)addToggleWithTitle:(NSString *)title key:(NSString *)key {
	MAGPanelToggleCell *toggle = [[MAGPanelToggleCell alloc] init];
	toggle.title = title;
	
	NSNumber *storedValue = [self.settingsReactor settingForKey:key];
	toggle.value = storedValue;
	
	[self.stackView addArrangedSubview:toggle];
	[self.stackView addArrangedSubview:[MAGPanelSeparator new]];

	toggle.action = ^(NSNumber *value) {
		[self.settingsReactor setSetting:value forKey:key];
	};
	
	return toggle;
}

- (MAGPanelInputCell *)addInputWithTitle:(NSString *)title key:(NSString *)key action:(void(^)(NSString *value))action {
	MAGPanelInputCell *input = [[MAGPanelInputCell alloc] init];
	input.title = title;
	input.action = action;
	[self.stackView addArrangedSubview:input];
	[self.stackView addArrangedSubview:[MAGPanelSeparator new]];
	
	return input;
}

- (MAGPanelPickerManager *)addPickerWithTitle:(NSString *)title key:(NSString *)key
	options:(NSArray *)options optionRenderer:(NSString *(^)(id value))renderer
	action:(void(^)(id value))action {

	MAGPanelPickerCell *picker = [[MAGPanelPickerCell alloc] init];
	picker.title = title;
	picker.action = action;
	picker.renderer = renderer;
	[self.stackView addArrangedSubview:picker];
	[self.stackView addArrangedSubview:[MAGPanelSeparator new]];
	
	MAGPanelPickerManager *pickerManager = [MAGPanelPickerManager managerForPickerCell:picker
		options:options optionRenderer:renderer];
	
	[self.pickerManagers addObject:pickerManager];
	
	return pickerManager;
}

@end
