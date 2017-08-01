#import "MAGDebugOverviewSettingsVC.h"
#import "MAGDebugPanelSettingsKeys.h"

#import "MAGDebugOverview.h"

#import <ReactiveObjC/ReactiveObjC.h>


@interface MAGDebugOverviewSettingsVC ()
@end


@implementation MAGDebugOverviewSettingsVC

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"Overview";
//	[self setupMenuActions];
}

#pragma mark - Private methods

//- (void)setupMenuActions {
//	[self addSection:[BOTableViewSection sectionWithHeaderTitle:nil
//		handler:^(BOTableViewSection *section) {
//			[self setupOverviewEnabledItemInSection:section];
//			[self setupOverviewFlowModeItemInSection:section];
//		}]];
//}
//
//- (void)setupOverviewEnabledItemInSection:(BOTableViewSection *)section {
//	[section addCell:[BOSwitchTableViewCell cellWithTitle:@"Enabled"
//		key:MAGDebugPanelSettingKeyOverviewEnabled
//		handler:^(BOSwitchTableViewCell *cell) {
//				[RACObserve(cell, setting.value) subscribeNext:^(NSNumber *enabled) {
//					if (enabled.boolValue) {
//						if ([[BOSetting settingWithKey:MAGDebugPanelSettingKeyOverviewFlowMode].value boolValue]) {
//							[MAGDebugOverview addToWindow];
//						} else {
//							[MAGDebugOverview addToStatusBar];
//						}
//					} else {
//						[MAGDebugOverview dismissSharedInstance];
//					}
//				}];
//			}]];
//}
//
//- (void)setupOverviewFlowModeItemInSection:(BOTableViewSection *)section {
//	[section addCell:[BOSwitchTableViewCell cellWithTitle:@"Flow mode"
//		key:MAGDebugPanelSettingKeyOverviewFlowMode
//		handler:^(BOSwitchTableViewCell *cell) {
//				[RACObserve(cell, setting.value) subscribeNext:^(NSNumber *enabled) {
//					if ([[BOSetting settingWithKey:MAGDebugPanelSettingKeyOverviewEnabled].value boolValue]) {
//						if (enabled.boolValue) {
//							[MAGDebugOverview addToWindow];
//						} else {
//							[MAGDebugOverview addToStatusBar];
//						}
//					}
//				}];
//			}]];
//}

@end
