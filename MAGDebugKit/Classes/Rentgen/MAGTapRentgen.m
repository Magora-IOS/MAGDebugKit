#import "MAGTapRentgen.h"
#import "MAGDragDetector.h"
#import "MAGDebugOverview.h"
#import "UIView+MAGAnimatedBorder.h"
#import "UIView+VCFinder.h"


@interface MAGTapRentgen ()

@property (nonatomic) BOOL active;
@property (nonatomic, copy) NSArray <MAGDragDetector *> *tapDetectors;

@end


@implementation MAGTapRentgen

#pragma mark - Lifecycle

+ (instancetype)sharedInstance {
    static MAGTapRentgen *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MAGTapRentgen alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
	self = [super init];
	
	if (!self) {
		return nil;
	}
	
	_active = NO;
	
	return self;
}

- (void)setActive:(BOOL)active {
	_active = active;

	if (active) {
		NSMutableArray *tapDetectors = [[NSMutableArray alloc] init];
		for (UIWindow *window in [UIApplication sharedApplication].windows) {
			MAGDragDetector *tapDetector = [self setupTapDetectorForView:window];
			[tapDetectors addObject:tapDetector];
		}
		self.tapDetectors = tapDetectors;
	} else {
		self.tapDetectors = nil;
	}
}

#pragma mark - Public methods

- (void)start {
	if (self.active) {
		return;
	}
	
	self.active = YES;
}

- (void)stop {
	if (!self.active) {
		return;
	}
	
	self.active = NO;
	[[MAGDebugOverview sharedInstance] displayMessage:nil];
}

- (MAGDragDetector *)setupTapDetectorForView:(UIView *)fundamentView {
    MAGDragDetector *tapDetector = [[MAGDragDetector alloc] initWithFundamentView:fundamentView];
    tapDetector.enabled = self.active;

    tapDetector.didTouchedViewBlock = ^(UIView *view) {
        
        [view mag_addAnimatedDashedBorderColor:[UIColor orangeColor] borderWidth:2 cornerRadius:view.layer.cornerRadius];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [view mag_removeAnimatedDashedBorder];
        });

        NSString *className = NSStringFromClass([view class]);

        if ([className isEqualToString:@"UITableViewCellContentView"]) {
            view = view.superview;
            className = NSStringFromClass([view class]);
        }
		
		UIViewController *vc = [view mag_nearestViewController];
		NSString *vcClassName = NSStringFromClass([vc class]);
		
		NSString *message = [NSString stringWithFormat:@"%@ : %@", className, vcClassName];

		[[MAGDebugOverview sharedInstance] displayMessage:message];
	};

	return tapDetector;
}

@end
