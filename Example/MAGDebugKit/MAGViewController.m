#import "MAGViewController.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <MAGDebugKit/MAGLogging.h>


@interface MAGViewController () <UITextFieldDelegate>
@end


@implementation MAGViewController

#pragma mark - UI events

- (IBAction)verboseButtonTap:(id)sender {
	DDLogVerbose(@"Verbose button tap.");
}

- (IBAction)debugButtonTap:(id)sender {
	DDLogDebug(@"Debug button tap.");
}

- (IBAction)infoButtonTap:(id)sender {
	DDLogInfo(@"Info button tap.");
}

- (IBAction)warningButtonTap:(id)sender {
	DDLogWarn(@"Warning button tap.");
}

- (IBAction)errorButtonTap:(id)sender {
	DDLogError(@"Error button tap.");
}

- (IBAction)crashButtonTap:(id)sender {
	NSException *e = [NSException exceptionWithName:NSGenericException
		reason:@"Exception button tap" userInfo:nil];
	
	@throw e;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	DDLogDebug(@"Text field should return.");
	return NO;
}

@end
