#import "MAGRentgenSettingsVC.h"
#import "MAGDebugPanelSettingsKeys.h"


@implementation MAGRentgenSettingsVC

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"Rentgen mode";
	[self setupMenuActions];
}

#pragma mark - Private methods

- (void)setupMenuActions {
	[self addSection:[BOTableViewSection sectionWithHeaderTitle:nil
		handler:^(BOTableViewSection *section) {
			[self setupEnabledItemInSection:section];
		}]];
}

- (void)setupEnabledItemInSection:(BOTableViewSection *)section {
	[section addCell:[BOSwitchTableViewCell cellWithTitle:@"Enabled"
		key:MAGDebugPanelSettingKeyRentgenEnabled
		handler:^(BOSwitchTableViewCell *cell) {
			}]];
}

@end
