
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (MAGMore)

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;

+ (UIViewController *)mag_appTopViewController;
+ (CGFloat)mag_heightForDesireWidth:(CGFloat)desireWidth withAspectRatioWidth:(CGFloat)width toHeight:(CGFloat)height;

+ (instancetype)mag_loadFromNib;
+ (instancetype)mag_loadFromNib:(NSString *)nibName;
+ (instancetype)mag_loadFromNib:(NSString *)nibName withOwner:(id)owner;

- (CGFloat)mag_fittingHeight;

- (void)mag_setBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius;
- (void)mag_setShadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius shadowOpacity:(CGFloat)shadowOpacity;

- (BOOL)mag_hasFirstResponder;
- (UIView *)mag_findViewThatIsFirstResponder;

- (CGPoint)mag_viewOriginAtScreenCoordinates;
- (CGPoint)mag_viewOriginAtViewCoordinates:(UIView *)view;
- (CGRect)mag_viewFrameAtScreenCoordinates;
- (CGRect)mag_viewFrameAtViewCoordinates:(UIView *)view;


+ (CGPoint)mag_pointAtScreenCoordinates:(CGPoint)point usedAtView:(UIView *)view;

- (void)mag_inscribeSubview:(UIView *)view;
- (void)mag_relayout;

@end
