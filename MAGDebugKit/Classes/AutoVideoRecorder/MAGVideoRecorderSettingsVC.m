#import "MAGVideoRecorderSettingsVC.h"
#import "MAGPanelButtonCell.h"
#import "MAGDebugPanelSettingsKeys.h"
#import "MAGAutoVideoRecorder.h"


@interface MAGVideoRecorderSettingsVC ()

@property (nonatomic, strong) MAGPanelButtonCell *button;

@end


@implementation MAGVideoRecorderSettingsVC

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"Auto video recorder";
	[self setupMenuActions];
}

#pragma mark - Private methods

- (void)setupMenuActions {
	[self addTitle:nil];

	[self addToggleWithTitle:@"Start recording on app start" key:MAGDebugPanelSettingKeyVideoRecordAutostartEnabled];
	
	MAGAutoVideoRecorder *recorder = [MAGAutoVideoRecorder sharedInstance];
	if (recorder.status == RecordingStatusIdle) {
		[self showStartButton];
	} else {
		[self showStopButton];
	}
}

- (void)showStartButton {
	if (self.button) {
		[self removeCell:self.button];
		self.button = nil;
	}

	__typeof__(self) weakSelf = self;
	self.button = [self addButtonWithTitle:@"Start" action:^{
			__typeof__(weakSelf) self = weakSelf;
			[[MAGAutoVideoRecorder sharedInstance] startVideoRecording];
			[self showStopButton];
		}];
}

- (void)showStopButton {
	if (self.button) {
		[self removeCell:self.button];
		self.button = nil;
	}

	__typeof__(self) weakSelf = self;
	self.button = [self addButtonWithTitle:@"Stop" action:^{
			__typeof__(weakSelf) self = weakSelf;
			[[MAGAutoVideoRecorder sharedInstance] stop];
			[self showStartButton];
		}];
}

@end
