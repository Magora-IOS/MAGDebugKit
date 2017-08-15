#import "MAGRentgenSettingsVC.h"
#import "MAGDebugPanelSettingsKeys.h"
#import "MAGRentgen.h"
#import "MAGTapRentgen.h"

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
	[self addTitle:nil];

	[self addToggleWithTitle:@"Highlight responders" key:MAGDebugPanelSettingKeyRentgenRespondersEnabled];
	[self addToggleWithTitle:@"Highlight views" key:MAGDebugPanelSettingKeyRentgenEnabled];
	[self addToggleWithTitle:@"Highlight all views" key:MAGDebugPanelSettingKeyHighlightAllViewsEnabled];
	[self addToggleWithTitle:@"Display class captions" key:MAGDebugPanelSettingKeyRentgenClassCaptionsEnabled];
}

@end
