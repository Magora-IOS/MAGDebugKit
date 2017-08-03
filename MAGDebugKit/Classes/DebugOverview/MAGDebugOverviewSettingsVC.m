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
	[self setupMenuActions];
}

#pragma mark - Private methods

- (void)setupMenuActions {
	[self addTitle:nil];
	
	[self addToggleWithTitle:@"Enabled"
		key:MAGDebugPanelSettingKeyOverviewEnabled
		action:^(BOOL value) {
			if (value) {
//					if ([[BOSetting settingWithKey:MAGDebugPanelSettingKeyOverviewFlowMode].value boolValue]) {
				if (NO) {
					[MAGDebugOverview addToWindow];
				} else {
					[MAGDebugOverview addToStatusBar];
				}
			} else {
				[MAGDebugOverview dismissSharedInstance];
			}
		}];

	[self addToggleWithTitle:@"Flow mode"
		key:MAGDebugPanelSettingKeyOverviewFlowMode
		action:^(BOOL value) {
//			if ([[BOSetting settingWithKey:MAGDebugPanelSettingKeyOverviewEnabled].value boolValue]) {
			if (NO) {
				if (value) {
					[MAGDebugOverview addToWindow];
				} else {
					[MAGDebugOverview addToStatusBar];
				}
			}
		}];
}

@end
