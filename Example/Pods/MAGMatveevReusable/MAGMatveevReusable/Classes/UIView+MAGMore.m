
#import "UIView+MAGMore.h"
#import "NSObject+MAGMore.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation UIView (MAGMore)

+ (UIViewController *)mag_appTopViewController {
    UIViewController *result = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (result.presentedViewController && !result.presentedViewController.popoverPresentationController) {
        result = result.presentedViewController;
    }
    return result;
}

+ (CGFloat)mag_heightForDesireWidth:(CGFloat)desireWidth withAspectRatioWidth:(CGFloat)width toHeight:(CGFloat)height {
    CGFloat result = desireWidth * height / width;
    return result;
}

- (CGPoint) origin
{
	return self.frame.origin;
}

- (CGSize) size
{
	return self.frame.size;
}

- (CGFloat) x
{
	return self.frame.origin.x;
}

- (CGFloat) y
{
	return self.frame.origin.y;
}

- (CGFloat) width
{
	return self.frame.size.width;
}

- (CGFloat) height
{
	return self.frame.size.height;
}

- (CGFloat) bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat) right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void) setOrigin:(CGPoint) newOrigin
{
	CGRect selfFrame = self.frame;
	
	selfFrame.origin = newOrigin;
	
	self.frame = selfFrame;
}

- (void) setSize:(CGSize) newSize
{
	CGRect selfFrame = self.frame;
	
	selfFrame.size = newSize;
	
	self.frame = selfFrame;
}

- (void) setX:(CGFloat) newX
{
	CGRect selfFrame = self.frame;
	
	selfFrame.origin.x = newX;
	
	self.frame = selfFrame;
}

- (void) setY:(CGFloat) newY
{
	CGRect selfFrame = self.frame;
	
	selfFrame.origin.y = newY;
	
	self.frame = selfFrame;
}

- (void) setWidth:(CGFloat) newWidth
{
	CGRect selfFrame = self.frame;
	
	selfFrame.size.width = newWidth;
	
	self.frame = selfFrame;
}

- (void) setHeight:(CGFloat) newHeight
{
	CGRect selfFrame = self.frame;
	
	selfFrame.size.height = newHeight;
	
	self.frame = selfFrame;
}

- (void) setBottom:(CGFloat)bottom {
    self.y = bottom - self.height;
}

- (void) setRight:(CGFloat)right {
    self.x = right - self.width;
}

+ (instancetype)mag_loadFromNib {
    return [self mag_loadFromNib:[self mag_className]];
}

+ (instancetype)mag_loadFromNib:(NSString *)nibName {
    return [self mag_loadFromNib:nibName withOwner:nil];
}

+ (instancetype)mag_loadFromNib:(NSString *)nibName withOwner:(id) owner {
    NSArray *loadedObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil];
    for (id obj in loadedObjects) {
        Class classNamedAsNib = NSClassFromString(nibName);
        if ([obj isKindOfClass:classNamedAsNib]) {
            return obj;
        }
    }
    return nil;
}

- (CGFloat)mag_fittingHeight {
    CGFloat result;
    [self setNeedsLayout];
    [self layoutIfNeeded];
    result = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return result;
}

- (void)mag_setBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius {
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.cornerRadius = cornerRadius;
    
    self.clipsToBounds = YES;
}

- (void)mag_setShadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius shadowOpacity:(CGFloat)shadowOpacity {
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOffset = shadowOffset;
    self.layer.shadowRadius = shadowRadius;
    self.layer.shadowOpacity = shadowOpacity;
    
    self.clipsToBounds = NO;
}

- (BOOL)mag_hasFirstResponder {
    BOOL result = [self mag_findViewThatIsFirstResponder] != nil;
    return result;
}

- (UIView *)mag_findViewThatIsFirstResponder
{
    UIView *result;
    if ([self isKindOfClass:[UITextField class]]) {
        NSLog(@"");
    }
    if ([self isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)self;
        if (textField.isEditing) {
            result = self;
        }
    } else if (self.isFirstResponder) {
        result = self;
    } else {
        if ([self isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)self;
            [tableView.tableHeaderView mag_findViewThatIsFirstResponder];
            [tableView.tableFooterView mag_findViewThatIsFirstResponder];
        }
        for (UIView *subView in self.subviews) {
            UIView *firstResponder = [subView mag_findViewThatIsFirstResponder];
            if (firstResponder != nil) {
                result = firstResponder;
                break;
            }
        }
    }
    
    return result;
}

- (CGPoint)mag_viewOriginAtScreenCoordinates
{
    CGPoint resultPoint = [self.superview convertPoint:self.frame.origin toView:nil];
    return resultPoint;
}

- (CGPoint)mag_viewOriginAtViewCoordinates:(UIView *)view
{
    CGPoint resultPoint = [self.superview convertPoint:self.frame.origin toView:view];
    return resultPoint;
}

- (CGRect)mag_viewFrameAtScreenCoordinates
{
    CGRect resultFrame = [self.superview convertRect:self.frame toView:nil];
    return resultFrame;
}

- (CGRect)mag_viewFrameAtViewCoordinates:(UIView *)view
{
    CGRect resultFrame = [self.superview convertRect:self.frame toView:view];
    return resultFrame;
}


+ (CGPoint)mag_pointAtScreenCoordinates:(CGPoint)point usedAtView:(UIView *)view
{
    CGPoint resultPoint = [view convertPoint:point toView:nil];
    return resultPoint;
}

- (void)mag_inscribeSubview:(UIView *)view {
    [self addSubview:view];
    view.frame = self.bounds;
}

- (void)mag_relayout {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
