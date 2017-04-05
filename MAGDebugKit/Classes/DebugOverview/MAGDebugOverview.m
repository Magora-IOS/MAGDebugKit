








#import "MAGDebugOverview.h"
#import "MAGDragDetector.h"
#import "MAGCommonDefines.h"
#import "MAGRentgen.h"

#import "UIView+MAGMore.h"
#import "NSObject+MAGMore.h"
#import "MAGCommonDefines.h"
#import "UIView+MAGAnimatedBorder.h"

#import "extobjc.h"


@interface MAGDebugOverview ()

@property (nonatomic) UIWindow *coveringWindow;
@property (strong, nonatomic) MAGDragDetector *dragDetector;

@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@end


@implementation MAGDebugOverview

static MAGDebugOverview *_sharedInstance = nil;

+ (instancetype)sharedInstance {
    if (!_sharedInstance) {
		NSBundle *podBundle = [NSBundle bundleForClass:self.class];
		NSURL *bundleURL = [podBundle URLForResource:@"MAGDebugKit" withExtension:@"bundle"];
		NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
		_sharedInstance = [bundle loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;

//		_sharedInstance = [podBundle loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    };
    return _sharedInstance;
}

+ (instancetype)addToWindow {
	// Foolproof.
    if (IS_THIS_BUILD_DOWNLOADED_FROM_APPSTORE) {
		return nil;
	}
	
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	
	MAGDebugOverview *debugOverview = [[self class] sharedInstance];
	[window addSubview:debugOverview];
	
	debugOverview.frame = CGRectMake(
			window.width - debugOverview.width,
			window.height - debugOverview.height,
			debugOverview.width,
			debugOverview.height
		);

	if (debugOverview.coveringWindow) {
		[debugOverview.coveringWindow removeFromSuperview];
		debugOverview.coveringWindow = nil;
	}
	
	[debugOverview setupDragDetector];
	
	return debugOverview;
}

+ (instancetype)addToStatusBar {
	// Foolproof.
    if (IS_THIS_BUILD_DOWNLOADED_FROM_APPSTORE) {
		return nil;
	}
	
	MAGDebugOverview *debugOverview = [[self class] sharedInstance];

	UIWindow *appWindow = [UIApplication sharedApplication].keyWindow;
	
	if (!debugOverview.coveringWindow) {
		debugOverview.coveringWindow = [[UIWindow alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
		debugOverview.coveringWindow.windowLevel = UIWindowLevelStatusBar;
		[debugOverview.coveringWindow makeKeyAndVisible];
	}
	
	[debugOverview.coveringWindow addSubview:debugOverview];
	debugOverview.frame = debugOverview.coveringWindow.bounds;
	
	[appWindow makeKeyWindow];
	
	return debugOverview;
}

+ (void)dismissSharedInstance {
	[[MAGDebugOverview sharedInstance] removeFromSuperview];
	_sharedInstance = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
	
	self.userInteractionEnabled = NO;
	self.versionLabel.text = [self fullBuildVersionString];
	self.messageLabel.text = nil;
}

- (NSString *)fullBuildVersionString {
    NSString *appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
	
	NSString *compileDateString = [NSString stringWithFormat:@"%@ %@",
		[NSString stringWithUTF8String:__DATE__],
		[NSString stringWithUTF8String:__TIME__]];
	
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	df.dateFormat = @"MMM d yyyy HH:mm:ss";
	NSDate *compileDate = [df dateFromString:compileDateString];
	df.dateFormat = @"yyyy-MM-dd HH:mm:ss";

	compileDateString = [df stringFromDate:compileDate];
	
	NSString *result = [NSString stringWithFormat:@"v %@, build %@ from %@",
		appVersionString, appBuildString, compileDateString];
	
	return result;
}

- (void)setupDragDetector {
    self.dragDetector = [[MAGDragDetector alloc] initWithFundamentView:[UIApplication sharedApplication].keyWindow];

    self.dragDetector.enabled = YES;
    
    @weakify(self);
    self.dragDetector.canHandleDragWhenTouchDownAtLocationBlock = ^(CGPoint location) {
        @strongify(self);
        
        BOOL result = NO;
        CGPoint translatedLocation = [UIView mag_pointAtScreenCoordinates:location usedAtView:self.window];
        CGRect translatedSelfFrame = [self mag_viewFrameAtScreenCoordinates];
		
        if (CGRectContainsPoint(translatedSelfFrame, translatedLocation)) {
            result = YES;
        }
		
        return result;
    };
	
    self.dragDetector.dragLocationChangedBlock =
		^(CGPoint location, CGPoint fromLocationMoved, CGPoint touchDownPoint, CGPoint panRecognizedAtPoint) {
        @strongify(self);
         
        CGFloat newX = self.x + (location.x - fromLocationMoved.x) ;
        CGFloat newY = self.y + (location.y - fromLocationMoved.y) ;
			
        if (newX < 0) {
            newX = 0;
        }
        if (newY < 20) {
            newY = 20;
        }
        
        if (newX + self.width > self.window.width) {
            newX = self.window.width - self.width;
        }
        if (newY + self.height > self.window.height) {
            newY = self.window.height - self.height;
        }
        
        self.origin = CGPointMake(newX, newY);
    };
}

- (void)displayMessage:(NSString *)message {
	self.messageLabel.text = message;
}

@end
