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
		action:^(BOOL value) {
			if (value) {
				[[MAGTapRentgen sharedInstance] start];
			} else {
				[[MAGTapRentgen sharedInstance] stop];
			}
		}];

	[self addToggleWithTitle:@"Highlight views"
		key:MAGDebugPanelSettingKeyRentgenEnabled
		action:^(BOOL value) {
			if (value) {
				[[MAGRentgen sharedInstance] start];
			} else {
				[[MAGRentgen sharedInstance] stop];
			}
		}];

	[self addToggleWithTitle:@"Highlight all views"
		key:MAGDebugPanelSettingKeyHighlightAllViewsEnabled
		action:^(BOOL value) {
			[MAGRentgen sharedInstance].highlightAllViews = value;
		}];
	
	[self addToggleWithTitle:@"Display class captions"
		key:MAGDebugPanelSettingKeyRentgenClassCaptionsEnabled
		action:^(BOOL value) {
			[MAGRentgen sharedInstance].showClassCaptions = value;
		}];
}

@end
