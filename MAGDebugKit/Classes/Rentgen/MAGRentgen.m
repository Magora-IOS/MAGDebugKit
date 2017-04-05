#import "MAGRentgen.h"
#import "MAGDebugOverview.h"

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
	// Don't preparate debug overview.
	// Don't show fullscreen system windows, that cover the whole app.
    if ([view isMemberOfClass:[MAGDebugOverview class]] ||
		[NSStringFromClass(view.class) isEqualToString:@"UITextEffectsWindow"] ||
		[NSStringFromClass(view.class) isEqualToString:@"UIRemoteKeyboardWindow"]) {
		
		return;
	}
	
//	int depth = [NSThread callStackSymbols].count;
//	NSMutableString *indent = [[NSMutableString alloc] initWithCapacity:depth];
//	for (int i = 0; i< depth; ++i) {
//		[indent appendString:@"  "];
//	}
//	
//	NSLog(@"%@%@ %@", indent, view.class, NSStringFromCGRect(view.frame));
	
	BOOL shouldHighlight = [self shouldHighlight:view];
	if (shouldHighlight && !view.mag_initialBGColorSaved.boolValue) {
		view.mag_initialBGColor = view.backgroundColor;
		view.mag_initialBGColorSaved = @YES;
		view.backgroundColor = [self colorForView:view];
	} else if (!shouldHighlight && view.mag_initialBGColorSaved.boolValue) {
		view.backgroundColor = view.mag_initialBGColor;
		view.mag_initialBGColor = nil;
		view.mag_initialBGColorSaved = @NO;
	}
	
	[self refreshCaptionForView:view];
	[self refreshCaptureFrameForView:view];
	
	for (UIView *subview in view.subviews) {
		[self changeView:subview];
	}
}

- (BOOL)shouldHighlight:(UIView *)view {
	return self.highlightAllViews ||
		[view isKindOfClass:[UIWindow class]] ||
		[view isKindOfClass:[UIControl class]] ||
		[view isKindOfClass:[UILabel class]] ||
		[view isKindOfClass:[UIImageView class]];
}

- (UIColor *)colorForView:(UIView *)view {
	static NSDictionary *colors = nil;
	if (!colors) {
		colors = @{
			NSStringFromClass([UIWindow class]): RGBA(200, 200, 200, 1),
			NSStringFromClass([UIControl class]): RGBA(26, 85, 224, 0.35),
			NSStringFromClass([UILabel class]): RGBA(255, 210, 249, 0.35),
			NSStringFromClass([UIImageView class]): RGBA(0, 200, 60, 0.35),
		};
	}

	UIColor *__block color = nil;
	[colors enumerateKeysAndObjectsUsingBlock:^(NSString *className, UIColor *classColor, BOOL *stop) {
			Class class = NSClassFromString(className);
			if ([view isKindOfClass:class]) {
				color = classColor;
				*stop = YES;
			}
		}];
	
	if (!color) {
		color = [self.class randomColor];
	}
	
	return color;
}

- (void)refreshCaptionForView:(UIView *)view {
	BOOL needCaption = self.showClassCaptions && [self shouldHighlight:view];
	BOOL hasCaption = view.mag_classCaption != nil;
	
	if (needCaption && !hasCaption) {
		view.mag_classCaption = [[CATextLayer alloc] init];
		view.mag_classCaption.contentsScale = [UIScreen mainScreen].scale;
		view.mag_classCaption.fontSize = 6;
		view.mag_classCaption.foregroundColor = [UIColor redColor].CGColor;
		view.mag_classCaption.string = NSStringFromClass([view class]);
		[view.layer addSublayer:view.mag_classCaption];
	} else if (hasCaption && !needCaption) {
		[view.mag_classCaption removeFromSuperlayer];
		view.mag_classCaption = nil;
	}
}

- (void)refreshCaptureFrameForView:(UIView *)view {
	CGRect captionFrame = view.layer.bounds;
	
	if (view.superview.mag_classCaption) {
		CGRect superViewClassCaptionFrame = [view.superview
			convertRect:view.superview.mag_classCaption.frame toView:view];
		CGFloat minY = CGRectGetMinY(superViewClassCaptionFrame) + 8;
		captionFrame.origin.y = MAX(captionFrame.origin.y, minY);
	}
	
	view.mag_classCaption.frame = captionFrame;
}

+ (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:0.08];
    return color;
}

@end
