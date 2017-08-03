#import "MAGSettingsPanelVC.h"
#import "MAGPanelGeometry.h"
#import "MAGPanelButtonCell.h"
#import "MAGPanelSeparator.h"
#import "MAGPanelTitleCell.h"
#import "MAGPanelToggleCell.h"
#import "MAGPanelInputCell.h"

#import <Masonry/Masonry.h>


@interface MAGSettingsPanelVC ()

@property (nonatomic) UIStackView *stackView;

@end


@implementation MAGSettingsPanelVC

#pragma mark - Lifecycle

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

- (MAGPanelToggleCell *)addToggleWithTitle:(NSString *)title key:(NSString *)key action:(void(^)(BOOL value))action {
	MAGPanelToggleCell *toggle = [[MAGPanelToggleCell alloc] init];
	toggle.title = title;
	toggle.action = action;
	[self.stackView addArrangedSubview:toggle];
	[self.stackView addArrangedSubview:[MAGPanelSeparator new]];
	
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

@end
