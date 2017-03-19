#import "MAGViewController.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <MAGDebugKit/MAGLogging.h>

#import "MAGAutoVideoRecorder.h"

@interface MAGViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *stopVideoRecordingButton;

@end


@implementation MAGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - UI events

- (IBAction)buttonTap:(id)sender {
	DDLogInfo(@"Button tap.");
}

- (IBAction)stopVideoRecordingAction {
	[[MAGAutoVideoRecorder sharedInstance] stop];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

@end
