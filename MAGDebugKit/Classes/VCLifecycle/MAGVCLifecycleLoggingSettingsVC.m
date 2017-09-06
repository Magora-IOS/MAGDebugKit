#import "MAGVCLifecycleLoggingSettingsVC.h"
#import "MAGDebugPanelSettingsKeys.h"
#import "MAGVCLifecycleLogging.h"

#import <ReactiveObjC/ReactiveObjC.h>


@interface MAGVCLifecycleLoggingSettingsVC ()

@end


@implementation MAGVCLifecycleLoggingSettingsVC

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"VC lifecycle";
	[self setupMenuActions];
}

#pragma mark - Private methods

- (void)setupMenuActions {
	[self addTitle:nil];
	
	[self addToggleWithTitle:@"Log init/dealloc events" key:MAGDebugPanelSettingKeyLogVCLifecycleEnabled];
}

@end
