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
	
	[self addToggleWithTitle:@"Enabled" key:MAGDebugPanelSettingKeyOverviewEnabled];
	[self addToggleWithTitle:@"Flow mode" key:MAGDebugPanelSettingKeyOverviewFlowMode];
}

@end
