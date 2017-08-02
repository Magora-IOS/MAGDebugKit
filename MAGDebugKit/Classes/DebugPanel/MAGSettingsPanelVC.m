#import "MAGSettingsPanelVC.h"
#import "MAGPanelGeometry.h"
#import "MAGPanelButtonCell.h"
#import "MAGPanelSeparator.h"
#import "MAGPanelTitleCell.h"

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

@end
