#import "MAGRentgen.h"
#import "DebugOverview.h"

#import "MAGCommonDefines.h"
#import "UIView+MAGMore.h"
#import "UIView+MAGAnimatedBorder.h"


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
    self.ticker = [NSTimer scheduledTimerWithTimeInterval:2 target:self
		selector:@selector(rentgenTimerTicked:) userInfo:nil repeats:YES];

}

- (void)stop {
	if (!self.active) {
		return;
	}
	
	self.active = NO;
	
	[self.ticker invalidate];
	self.ticker = nil;
}

#pragma mark - Private methods

- (void)rentgenTimerTicked:(NSTimer *)timer {
    NSLog(@"Top VC: %@\n\n\n",[[UIView mag_appTopViewController] class]);
	
	for (UIView *subview in self.window.subviews) {
		[self changeView:subview];
	}
}


- (void)changeView:(UIView *)view {
    if ([view isMemberOfClass:[DebugOverview class]]) {
		return;
	}
	
	if ([view isKindOfClass:[UIControl class]]) {
		view.backgroundColor = RGBA(26,85,224,1);
		//        view.alpha = 0.7;
	}
	
	if ([view isKindOfClass:[UILabel class]]) {
		view.backgroundColor = RGBA(255,210,249,1);
		//        view.alpha = 0.3;
	}
	
	if ([view isKindOfClass:[UIImageView class]]) {
		[view mag_addAnimatedDashedBorderColor:[UIColor redColor] borderWidth:1 cornerRadius:0];
	}
	
	for (UIView *subview in view.subviews) {
		[self changeView:subview];
	}

//    if ([view isMemberOfClass:[UIView class]]) {
//        view.backgroundColor = [[self class] randomColor];
//        view.alpha = 0.1;
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
//        label.text = NSStringFromClass([view class]);
//        [view addSubview:label];
//        label.center = view.center;
//        label.alpha = 1.0;
//    }
}

@end
