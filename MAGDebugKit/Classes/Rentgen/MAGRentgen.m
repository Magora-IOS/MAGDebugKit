#import "MAGRentgen.h"
#import "DebugOverview.h"

#import "MAGCommonDefines.h"
#import "UIView+MAGMore.h"
#import "UIView+MAGAnimatedBorder.h"
#import "UIView+MAGRentgenProperties.h"


@interface MAGRentgen ()

@property (nonatomic) BOOL active;
@property (nonatomic) NSTimer *ticker;

@end


@implementation MAGRentgen

#pragma mark - Lifecycle

+ (instancetype)sharedInstance {
    static MAGRentgen *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MAGRentgen alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Public methods

- (void)start {
	if (self.active) {
		return;
	}
	
	self.active = YES;
	
	[self rentgenTimerTicked:nil];
	
	if (!self.ticker) {
		self.ticker = [NSTimer scheduledTimerWithTimeInterval:2 target:self
			selector:@selector(rentgenTimerTicked:) userInfo:nil repeats:YES];
	}
}

- (void)stop {
	if (!self.active) {
		return;
	}
	
	self.active = NO;
	
	for (UIWindow *window in [UIApplication sharedApplication].windows) {
		[self restoreInitialBGColors:window];
	}
}

#pragma mark - Private methods

- (void)restoreInitialBGColors:(UIView *)view {
	if (view.mag_initialBGColorSaved.boolValue) {
		view.backgroundColor = view.mag_initialBGColor;
		view.mag_initialBGColor = nil;
		view.mag_initialBGColorSaved = @NO;
	}
	
	[view.mag_classCaption removeFromSuperlayer];
	view.mag_classCaption = nil;
	
	for (UIView *subview in view.subviews) {
		[self restoreInitialBGColors:subview];
	}
}

- (void)rentgenTimerTicked:(NSTimer *)timer {
    NSLog(@"Top VC: %@\n\n\n",[[UIView mag_appTopViewController] class]);
	
	if (self.active) {
		for (UIWindow *window in [UIApplication sharedApplication].windows) {
			[self changeView:window];
		}
	} else {
		for (UIWindow *window in [UIApplication sharedApplication].windows) {
			[self restoreInitialBGColors:window];
		}
	}
}

- (void)changeView:(UIView *)view  {
	// Don't preparate debug overview itself.
	// Don't show fullscreen system windows, that cover the whole app.
    if ([view isMemberOfClass:[DebugOverview class]] ||
		[NSStringFromClass(view.class) isEqualToString:@"UITextEffectsWindow"] ||
		[NSStringFromClass(view.class) isEqualToString:@"UIRemoteKeyboardWindow"]) {
		
		return;
	}
	
	int depth = [NSThread callStackSymbols].count;
	NSMutableString *indent = [[NSMutableString alloc] initWithCapacity:depth];
	for (int i = 0; i< depth; ++i) {
		[indent appendString:@"  "];
	}
	
	NSLog(@"%@%@ %@", indent, view.class, NSStringFromCGRect(view.frame));
	
	if (!view.mag_initialBGColorSaved.boolValue) {
		view.mag_initialBGColor = view.backgroundColor;
		view.mag_initialBGColorSaved = @YES;
		
		if ([view isKindOfClass:[UIWindow class]]) {
			view.backgroundColor = RGBA(200, 200, 200, 1);
		}
		else if ([view isKindOfClass:[UIControl class]]) {
			view.backgroundColor = RGBA(26, 85, 224, 0.35);
		}
		else if ([view isKindOfClass:[UILabel class]]) {
			view.backgroundColor = RGBA(255, 210, 249, 0.35);
		}
		else if ([view isKindOfClass:[UIImageView class]]) {
			view.backgroundColor = RGBA(0, 200, 60, 0.35);
		} else {
			view.backgroundColor = [self.class randomColor];
		}
	}
	
	if (self.showClassCaptions && !view.mag_classCaption) {
		view.mag_classCaption = [[CATextLayer alloc] init];
		view.mag_classCaption.contentsScale = [UIScreen mainScreen].scale;
		view.mag_classCaption.fontSize = 6;
		view.mag_classCaption.foregroundColor = [UIColor redColor].CGColor;
		view.mag_classCaption.string = NSStringFromClass([view class]);
		[view.layer addSublayer:view.mag_classCaption];
	} else if (!self.showClassCaptions && view.mag_classCaption) {
		[view.mag_classCaption removeFromSuperlayer];
		view.mag_classCaption = nil;
	}

	CGRect captionFrame = view.layer.bounds;
	
	if (view.superview.mag_classCaption) {
		CGRect superViewClassCaptionFrame = [view.superview
			convertRect:view.superview.mag_classCaption.frame toView:view];
		CGFloat minY = CGRectGetMinY(superViewClassCaptionFrame) + 8;
		captionFrame.origin.y = MAX(captionFrame.origin.y, minY);
	}
	
	view.mag_classCaption.frame = captionFrame;
	
	for (UIView *subview in view.subviews) {
		[self changeView:subview];
	}
}

+ (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:0.08];
    return color;
}

@end
