
#import "RCTapDetector.h"

@interface RCTapDetector () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) UIView *targetView;

@end


@implementation RCTapDetector

- (void)attachToTargetView:(UIView *)targetView {
    self.targetView = targetView;
    _recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    self.recognizer.numberOfTouchesRequired = 1;
    [self.targetView addGestureRecognizer:self.recognizer];
}

- (void)handleSingleTap {
    RUN_BLOCK(self.didTappedBlock);
}

@end
