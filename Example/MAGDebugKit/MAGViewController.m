#import "MAGViewController.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <MAGDebugKit/MAGLogging.h>


@interface MAGViewController ()

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

@end
