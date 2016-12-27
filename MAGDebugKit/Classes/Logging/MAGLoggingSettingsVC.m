#import "MAGLoggingSettingsVC.h"
#import "MAGDebugPanelSettingsKeys.h"

#import <Bohr/BOTableViewCell+Subclass.h>
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface MAGLoggingSettingsVC ()
@end


@implementation MAGLoggingSettingsVC

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Logging";
	[self setupMenuActions];

}

#pragma mark - Private methods

- (void)setupMenuActions {
	[self addSection:[BOTableViewSection sectionWithHeaderTitle:nil
		handler:^(BOTableViewSection *section) {
			[self setupFileLoggingItemInSection:section];
		}]];
}

- (void)setupFileLoggingItemInSection:(BOTableViewSection *)section {
	[section addCell:[BOSwitchTableViewCell cellWithTitle:@"File logging"
		key:MAGDebugPanelSettingKeyFileLoggingEnabled
		handler:^(BOSwitchTableViewCell *cell) {
				[RACObserve(cell, setting.value) subscribeNext:^(NSNumber *enabled) {
					if (enabled.boolValue) {

					} else {

					}
				}];
			}]];
}

@end
