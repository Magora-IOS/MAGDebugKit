#import <UIKit/UIKit.h>


@interface UIView (MAGAnimatedBorder)

- (void)mag_addAnimatedDashedBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
	cornerRadius:(CGFloat)cornerRadius;

- (void)mag_removeAnimatedDashedBorder;

@end
