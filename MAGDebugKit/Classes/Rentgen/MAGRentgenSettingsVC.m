#import "MAGRentgenSettingsVC.h"
#import "MAGDebugPanelSettingsKeys.h"
#import "MAGRentgen.h"
#import "MAGTapRentgen.h"

#import <Bohr/BOTableViewCell+Subclass.h>
#import <ReactiveObjC/ReactiveObjC.h>


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
			[self setupRespondersEnabledItemInSection:section];
			[self setupEnabledItemInSection:section];
			[self setupAllViewsItemInSection:section];
			[self setupClassCaptionsItemInSection:section];
		}]];
}

- (void)setupRespondersEnabledItemInSection:(BOTableViewSection *)section {
	[section addCell:[BOSwitchTableViewCell cellWithTitle:@"Highlight responders"
		key:MAGDebugPanelSettingKeyRentgenRespondersEnabled
		handler:^(BOSwitchTableViewCell *cell) {
				[RACObserve(cell, setting.value) subscribeNext:^(NSNumber *enabled) {
					if (enabled.boolValue) {
						[[MAGTapRentgen sharedInstance] start];
					} else {
						[[MAGTapRentgen sharedInstance] stop];
					}
				}];
			}]];
}


- (void)setupEnabledItemInSection:(BOTableViewSection *)section {
	[section addCell:[BOSwitchTableViewCell cellWithTitle:@"Highlight views"
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
