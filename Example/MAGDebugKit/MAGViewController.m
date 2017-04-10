#import "MAGViewController.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <MAGDebugKit/MAGLogging.h>

#import "MAGAutoVideoRecorder.h"

@interface MAGViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *stopVideoRecordingButton;

@end


@implementation MAGViewController

#pragma mark - UI events

- (IBAction)buttonTap:(id)sender {
	DDLogInfo(@"Button tap.");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	DDLogDebug(@"Text field should return.");
	return NO;
}

@end
