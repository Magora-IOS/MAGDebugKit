#import "MAGSettingsPanelVC.h"
#import "MAGPanelGeometry.h"
#import "MAGPanelCell.h"
#import "MAGPanelButtonCell.h"
#import "MAGPanelSeparator.h"
#import "MAGPanelTitleCell.h"
#import "MAGPanelToggleCell.h"
#import "MAGPanelInputCell.h"
#import "MAGPanelPickerCell.h"
#import "MAGPanelPickerManager.h"
#import "MAGSettingsReactor.h"
#import "MAGDebugPanelRespondersManager.h"
#import <Masonry/Masonry.h>


@interface MAGSettingsPanelVC ()

@property (nonatomic) id<MAGSettingsReactor> settingsReactor;
@property (nonatomic) MAGDebugPanelRespondersManager *respondersManager;

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
	scroller.bounces = YES;
	scroller.alwaysBounceVertical = YES;
	scroller.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	
	[self.view addSubview:scroller];
	[scroller mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self.view);
		}];

	[scroller addSubview:self.stackView];
	[self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(scroller);
			make.width.equalTo(self.view);
		}];
	
	self.respondersManager = [[MAGDebugPanelRespondersManager alloc] init];
	self.respondersManager.scrollView = scroller;
	
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
	[self addSeparatorFor:button];
	
	return button;
}

- (MAGPanelToggleCell *)addToggleWithTitle:(NSString *)title key:(NSString *)key {
	MAGPanelToggleCell *toggle = [[MAGPanelToggleCell alloc] init];
	toggle.title = title;
	
	NSNumber *storedValue = [self.settingsReactor settingForKey:key];
	toggle.value = storedValue;
	
	[self.stackView addArrangedSubview:toggle];
	[self addSeparatorFor:toggle];

	toggle.action = ^(NSNumber *value) {
		[self.settingsReactor setSetting:value forKey:key];
	};
	
	return toggle;
}

- (MAGPanelInputCell *)addInputWithTitle:(NSString *)title key:(NSString *)key {
	MAGPanelInputCell *input = [[MAGPanelInputCell alloc] init];
	input.title = title;

	NSString *storedValue = [self.settingsReactor settingForKey:key];
	input.value = storedValue;
	
	input.action = ^(NSString *value) {
		[self.settingsReactor setSetting:value forKey:key];
	};

	__typeof__(self) weakSelf = self;
	input.returnKeyAction = ^{
		__typeof__(weakSelf) strongSelf = weakSelf;
		[strongSelf.respondersManager setFocusToNextView];
	};
	
	[self.stackView addArrangedSubview:input];
	[self addSeparatorFor:input];
	
	[self.respondersManager addViews:@[input]];
	
	return input;
}

- (MAGPanelPickerManager *)addPickerWithTitle:(NSString *)title key:(NSString *)key
	options:(NSArray *)options optionRenderer:(NSString *(^)(id value))renderer {

	MAGPanelPickerCell *picker = [[MAGPanelPickerCell alloc] init];
	picker.title = title;
	picker.renderer = renderer;
	[self.stackView addArrangedSubview:picker];
	[self addSeparatorFor:picker];
	
	MAGPanelPickerManager *pickerManager = [MAGPanelPickerManager managerForPickerCell:picker
		options:options optionRenderer:renderer];
	[self.pickerManagers addObject:pickerManager];

	NSNumber *storedValue = [self.settingsReactor settingForKey:key];
	picker.value = storedValue;
	pickerManager.value = storedValue;
	
	picker.action = ^(NSNumber *value) {
		[self.settingsReactor setSetting:value forKey:key];
	};
	
	return pickerManager;
}

- (void)removeCell:(__kindof UIView<MAGPanelCell> *)cell {
	[cell.separator removeFromSuperview];
	[cell removeFromSuperview];
}

#pragma mark - Private methods

- (MAGPanelSeparator *)addSeparatorFor:(id<MAGPanelCell>)cell {
	MAGPanelSeparator *separator = [MAGPanelSeparator new];
	[self.stackView addArrangedSubview:separator];
	cell.separator = separator;
	return separator;
}

@end
