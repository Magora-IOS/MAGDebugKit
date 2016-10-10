
#import "RCDoubleTapDetector.h"

@implementation RCDoubleTapDetector

- (void)attachToTargetView:(UIView *)targetView {
    [super attachToTargetView:targetView];
    self.recognizer.numberOfTapsRequired = 2;
}

@end
