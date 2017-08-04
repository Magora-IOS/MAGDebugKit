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

	[self addToggleWithTitle:@"Highlight responders"
		key:MAGDebugPanelSettingKeyRentgenRespondersEnabled
		action:^(NSNumber *value) {
			if (value.boolValue) {
				[[MAGTapRentgen sharedInstance] start];
			} else {
				[[MAGTapRentgen sharedInstance] stop];
			}
		}];

	[self addToggleWithTitle:@"Highlight views"
		key:MAGDebugPanelSettingKeyRentgenEnabled
		action:^(NSNumber *value) {
			if (value.boolValue) {
				[[MAGRentgen sharedInstance] start];
			} else {
				[[MAGRentgen sharedInstance] stop];
			}
		}];

	[self addToggleWithTitle:@"Highlight all views"
		key:MAGDebugPanelSettingKeyHighlightAllViewsEnabled
		action:^(NSNumber *value) {
			[MAGRentgen sharedInstance].highlightAllViews = value.boolValue;
		}];
	
	[self addToggleWithTitle:@"Display class captions"
		key:MAGDebugPanelSettingKeyRentgenClassCaptionsEnabled
		action:^(NSNumber *value) {
			[MAGRentgen sharedInstance].showClassCaptions = value.boolValue;
		}];
}

@end
