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
//	[self addSection:[BOTableViewSection sectionWithHeaderTitle:nil
//		handler:^(BOTableViewSection *section) {
//			[self setupLifecycleLoggingEnabledItemInSection:section];
//		}]];
}

//- (void)setupLifecycleLoggingEnabledItemInSection:(BOTableViewSection *)section {
//	[section addCell:[BOSwitchTableViewCell cellWithTitle:@"Log init/dealloc events"
//		key:MAGDebugPanelSettingKeyLogVCLifecycleEnabled
//		handler:^(BOSwitchTableViewCell *cell) {
//				[RACObserve(cell, setting.value) subscribeNext:^(NSNumber *enabled) {
//					if (enabled.boolValue) {
//						[MAGVCLifecycleLogging enableInitDeallocLogging];
//					} else {
//						[MAGVCLifecycleLogging disableInitDeallocLogging];
//					}
//				}];
//			}]];
//}

@end
