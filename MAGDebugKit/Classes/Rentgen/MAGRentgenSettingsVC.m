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
			[self setupAllViewsItemInSection:section];
			[self setupClassCaptionsItemInSection:section];
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

- (void)setupClassCaptionsItemInSection:(BOTableViewSection *)section {
	[section addCell:[BOSwitchTableViewCell cellWithTitle:@"Display class captions"
		key:MAGDebugPanelSettingKeyRentgenClassCaptionsEnabled
		handler:^(BOSwitchTableViewCell *cell) {
				[RACObserve(cell, setting.value) subscribeNext:^(NSNumber *enabled) {
					[MAGRentgen sharedInstance].showClassCaptions = enabled.boolValue;
				}];
			}]];
}

- (void)setupAllViewsItemInSection:(BOTableViewSection *)section {
	[section addCell:[BOSwitchTableViewCell cellWithTitle:@"Highlight all views"
		key:MAGDebugPanelSettingKeyHighlightAllViewsEnabled
		handler:^(BOSwitchTableViewCell *cell) {
				[RACObserve(cell, setting.value) subscribeNext:^(NSNumber *enabled) {
					[MAGRentgen sharedInstance].highlightAllViews = enabled.boolValue;
				}];
			}]];
}

@end
