#import "UIView+VCFinder.h"


@implementation UIView (VCFinder)


- (UIViewController *)mag_nearestViewController {
    return (UIViewController *)[self mag_traverseResponderChainForUIViewController];
}

- (id)mag_traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder mag_traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

@end
