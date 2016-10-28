#import "MAGRentgenSettingsVC.h"
#import "MAGDebugPanelSettingsKeys.h"
#import "MAGRentgen.h"

#import <Bohr/BOTableViewCell+Subclass.h>
#import <ReactiveCocoa/ReactiveCocoa.h>


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
				[RACObserve(cell, setting.value) subscribeNext:^(NSNumber *enabled) {
					if (enabled.boolValue) {
						[[MAGRentgen sharedInstance] start];
					} else {
						[[MAGRentgen sharedInstance] stop];
					}
				}];
			}]];
}

@end
