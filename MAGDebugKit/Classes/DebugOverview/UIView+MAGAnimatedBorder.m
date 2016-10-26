#import "UIView+MAGAnimatedBorder.h"
#import <libextobjc/extobjc.h>


@interface UIView (MAGAnimatedBorderPrivate)

@property (nonatomic, strong) CAShapeLayer *mag_dashedBorder;

@end


@implementation UIView (MAGAnimatedBorderPrivate)

@synthesizeAssociation(UIView, mag_dashedBorder)

@end


@implementation UIView (MAGAnimatedBorder)

- (void)mag_addAnimatedDashedBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
	cornerRadius:(CGFloat)cornerRadius {
	
	if (self.mag_dashedBorder) {
		return;
	}

	self.mag_dashedBorder = [CAShapeLayer layer];
	self.mag_dashedBorder.frame = self.layer.bounds;
	self.mag_dashedBorder.fillColor = [UIColor clearColor].CGColor;
	self.mag_dashedBorder.strokeColor = borderColor.CGColor;
	self.mag_dashedBorder.lineWidth = borderWidth;

	CGFloat dashWidth = borderWidth * 4;
	CGFloat spaceWidth = borderWidth * 3;
	CGFloat totalPatternWidth = dashWidth + spaceWidth;
	self.mag_dashedBorder.lineDashPattern = @[@(dashWidth), @(spaceWidth)];

	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, self.layer.bounds);
	self.mag_dashedBorder.path = path;
	CGPathRelease(path);

	[self.layer addSublayer:self.mag_dashedBorder];

	CABasicAnimation *dashAnimation;
	dashAnimation = [CABasicAnimation animationWithKeyPath:@keypath(self.mag_dashedBorder, lineDashPhase)];
	dashAnimation.fromValue = @(0);
	dashAnimation.toValue = @(totalPatternWidth);
	dashAnimation.duration = 0.5 * totalPatternWidth / 10.0;
	dashAnimation.repeatCount = HUGE_VALF;
	[self.mag_dashedBorder addAnimation:dashAnimation forKey:@keypath(self.mag_dashedBorder, lineDashPhase)];
}

- (void)mag_removeAnimatedDashedBorder {
	[self.mag_dashedBorder removeAllAnimations];
	[self.mag_dashedBorder removeFromSuperlayer];
	self.mag_dashedBorder = nil;
}

@end
