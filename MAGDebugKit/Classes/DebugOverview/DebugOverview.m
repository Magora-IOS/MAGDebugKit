








#import "DebugOverview.h"
#import "DragDetector.h"
#import "MAGCommonDefines.h"
#import "RCDoubleTapDetector.h"

#import "UIView+MAGMore.h"
#import "NSObject+MAGMore.h"
#import "MAGCommonDefines.h"
#import "UIView+MAGAnimatedBorder.h"

#import "extobjc.h"

@interface DebugOverview ()

@property (strong, nonatomic) DragDetector *dragDetector;

@property (strong, nonatomic) IBOutlet UILabel *buildLabel;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *tappedControlLabel;

@property (strong, nonatomic) NSTimer *rentgenTimer;

@property (strong, nonatomic) NSMutableArray *array;

@property (strong, nonatomic) RCDoubleTapDetector *doubleTapDetector;

@end

@implementation DebugOverview

+ (instancetype)sharedInstance {
    static DebugOverview *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //sharedInstance = [DebugOverview mag_loadFromNib];// [[self alloc] init];
        NSBundle *bundle = [NSBundle bundleForClass:self.class];
        sharedInstance = [bundle loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    });
    return sharedInstance;
}

+ (void)addToWindowWithFrame:(CGRect)frame {
    if (!IS_THIS_BUILD_DOWNLOADED_FROM_APPSTORE) {//        protection against the human-factor errors
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        DebugOverview *debugOverview = [[self class] sharedInstance];// [DebugOverview mag_loadFromNib];
        [window addSubview:debugOverview];
        debugOverview.frame = CGRectMake(window.width - debugOverview.width, window.height - debugOverview.height, debugOverview.width, debugOverview.height);
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSLog(@"%@ fdssdf ",self);
    NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    self.buildLabel.text = appBuildString;
    self.versionLabel.text = appVersionString;
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@",[NSString stringWithUTF8String:__DATE__],[NSString stringWithUTF8String:__TIME__]];

    NSLog(@"%@ %@",[NSString stringWithUTF8String:__DATE__],[NSString stringWithUTF8String:__TIME__]);
    
    self.dragDetector = [[DragDetector alloc] initWithFundamentView:[UIApplication sharedApplication].keyWindow];
    [self prepareDragDetector];

    self.doubleTapDetector = [RCDoubleTapDetector new];
    [self.doubleTapDetector attachToTargetView:self];
    
    __weak typeof(self) wSelf = self;
    self.doubleTapDetector.didTappedBlock = ^() {
		if (!wSelf.rentgenTimer) {
			[wSelf startRentgen];
		}
    };
}

- (void)startRentgen {
    [self rentgenTimerTicked:nil];
    self.rentgenTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rentgenTimerTicked:) userInfo:nil repeats:YES];
}

- (void)rentgenTimerTicked:(NSTimer *)timer {
    NSLog(@"TOP VC %@",[[UIView mag_appTopViewController] class]);
    UIViewController *vc = [UIView mag_appTopViewController];
    NSLog(@"");
    NSLog(@"");
    NSLog(@"");
    
    self.array = [NSMutableArray array];
        self.window.backgroundColor = [UIColor whiteColor];
        for (UIView *subview in self.window.subviews) {
            [self changeView:subview];
        }
        
//        for (UIView *view in self.array) {
//            NSLog(@"Z position %@",[view class]);
//        }

}

- (void)changeView:(UIView *)view {
//    [self.array addObject:view];
    
    if (![view isMemberOfClass:[DebugOverview class]]) {
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
            //        view.backgroundColor = RGBA(255,210,249,1);
            //        view.alpha = 0.3;
        }
        
            for (UIView *subview in view.subviews) {
                [self changeView:subview];
            }
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

+ (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

- (void)prepareDragDetector {
    self.dragDetector.enabled = YES;
    
    @weakify(self);
    self.dragDetector.canHandleDragWhenTouchDownAtLocationBlock = ^(CGPoint location) {
        @strongify(self);
        
        BOOL result = NO;
        CGPoint translatedLocation = [UIView mag_pointAtScreenCoordinates:location usedAtView:self.window];
        CGRect translatedSelfFrame = [self mag_viewFrameAtScreenCoordinates];
//        CGRect translatedFloatViewHeaderViewFrame = translatedFloatViewFrame;
//        if ([self displayedState] == FloatViewStateMenuFullscreen
//            || [self displayedState] == FloatViewStateMenuHalfscreen) {
//            translatedFloatViewHeaderViewFrame.size.height = 50;//      for menu we should begin drag only for top view
//        } else {//      it it details then we can drag it by any point
//        }
////        NSLog(@"location %@ translated %@",NSStringFromCGPoint(location),NSStringFromCGPoint(translatedLocation));
        if (CGRectContainsPoint(translatedSelfFrame, translatedLocation)) {
            result = YES;
//            self.floatView.userInteractionEnabled = NO;
//            self.floatView.userInteractionEnabled = YES;
//            self.scrollView.scrollEnabled = NO;
        }
//        NSLog(@"CAN RESULT %i",result);
        return result;
    };
    self.dragDetector.willHandleDragWhenPanRecognizedAtLocationBlock = ^(CGPoint touchDownPoint, CGPoint panRecognizedAtPoint, CGFloat lesserPositiveAngleInDegreesBetweenCurrentLocationPointAndAxisX) {
//        @strongify(self);
//        BOOL result = YES;
//        self.floatView.height = [self maximumFreeHeight];
//        //        NSLog(@"WILL RESULT %i",result);
//        return result;
        
        @strongify(self);
        
        BOOL result = YES;
//        self.floatView.height = [self maximumFreeHeight];
//        
//        CGPoint translatedLocation = [UIView pointAtScreenCoordinates:touchDownPoint usedAtView:self.floatView];
//        CGRect translatedFloatViewFrame = [self.floatView viewFrameAtScreenCoordinates];
//        CGRect translatedFloatViewHeaderViewFrame = translatedFloatViewFrame;
//        translatedFloatViewHeaderViewFrame.size.height = 50;//      for menu we should begin drag only for top view
//        if (CGRectContainsPoint(translatedFloatViewHeaderViewFrame, translatedLocation)) {
//            //      this is fix situation when in fullscreen when we scroll tableView's content to bottom, then we can slider floatView by top view
//        } else {
//            BOOL startDragDirectionIsToBottom = panRecognizedAtPoint.y > touchDownPoint.y;
//            if ([self displayedState] == FloatViewStateDetailsFullscreen) {
//                if (startDragDirectionIsToBottom) {
//                    BOOL willDrag = [Utils floatNumber:self.projectDetailsTableView.contentOffset.y isEqualToFloatNumber:0];
//                    if (willDrag) {
//                        self.projectDetailsTableView.scrollEnabled = NO;
//                        self.projectDetailsTableView.userInteractionEnabled = NO;
//                        self.projectDetailsTableView.userInteractionEnabled = YES;
//                    } else {
//                        result = NO;
//                        self.projectDetailsTableView.scrollEnabled = YES;
//                    }
//                } else {
//                    result = NO;
//                }
//            } else if ([self displayedState] == FloatViewStateDetailsHalfscreen) {
//    //            result = YES;
//            }
//        }
        
        NSLog(@"WILL DRAG %@",@(result));
        //        NSLog(@"WILL RESULT %i",result);
        return result;
    };
    self.dragDetector.dragLocationChangedBlock = ^(CGPoint location, CGPoint fromLocationMoved, CGPoint touchDownPoint, CGPoint panRecognizedAtPoint) {
        @strongify(self);
        
        NSLog(@"%@ %@ %@",NSStringFromCGPoint(location),NSStringFromCGPoint(touchDownPoint),NSStringFromCGPoint(panRecognizedAtPoint));
        //        NSLog(@"height %@ %@ %@",@(self.view.height),@(self.scrollView.height),@(self.toolbarView.height));
        CGFloat newX = self.x + (location.x - fromLocationMoved.x) ;
        CGFloat newY = self.y + (location.y - fromLocationMoved.y) ;
//        CGFloat newContentViewY = self.floatView.y + (location.y - touchDownPoint.y) - (panRecognizedAtPoint.y - touchDownPoint.y);
//        CGFloat newY = self.y - (touchDownPoint.y - panRecognizedAtPoint.y);
        
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
        
//        if (newContentViewY < [self floatViewFullDisplayedY]) {
//            self.floatView.y = [self floatViewFullDisplayedY];
//        } else {
//            self.floatView.y = newContentViewY;
//        }
    };
    self.dragDetector.dragFinishedAtLocationBlock = ^(CGPoint location, CGPoint fromLocationMoved, CGPoint touchDownPoint) {
        @strongify(self);
        
//        NSLog(@"min 1 %@",@([self floatViewMinYForFullscreen]));
//        NSLog(@"min 2 %@",@([self floatViewMaxYForFullscreen]));
//        
//        NSLog(@"min 3 %@",@([self floatViewMinYForHalfscreen]));
//        NSLog(@"min 4 %@",@([self floatViewMaxYForHalfscreen]));
//        
//        NSLog(@"min 5 %@",@([self floatViewMinYForHidden]));
//        NSLog(@"min 6 %@",@([self floatViewMaxYForHidden]));
        
//        CGPoint translatedFloatViewOrigin = [self.floatView viewOriginAtScreenCoordinates];
//        NSLog(@"translatedFloatViewOrigin %@",NSStringFromCGPoint(translatedFloatViewOrigin));
        
//        CGPoint translatedFloatViewMinYForFullscreen = [UIView pointAtScreenCoordinates:CGPointMake(0,[self floatViewMinYForFullscreen]) usedAtView:self.floatView.superview];
//        CGPoint translatedFloatViewMaxYForHidden = [UIView pointAtScreenCoordinates:CGPointMake(0,[self floatViewMaxYForHidden]) usedAtView:self.floatView.superview];
//        
//        CGPoint translatedFloatViewMenuYForHalfscreen = [UIView pointAtScreenCoordinates:CGPointMake(0,[self floatViewMenuHalfDisplayedY]) usedAtView:self.floatView.superview];
//        CGPoint translatedFloatViewDetailsYForHalfscreen = [UIView pointAtScreenCoordinates:CGPointMake(0,[self floatViewDetailsHalfDisplayedY]) usedAtView:self.floatView.superview];
//        
//        
//        RCDeltaStrategy *strategy = [RCDeltaStrategy new];
//        
//        BOOL beforeDragWasDisplayedAsMenu = self.lastStableFloatViewState == FloatViewStateMenuFullscreen || self.lastStableFloatViewState == FloatViewStateMenuHalfscreen;
//        if (beforeDragWasDisplayedAsMenu) {
//            RCFloatViewState *fullscreen = [[RCFloatViewState alloc] initWithState:FloatViewStateMenuFullscreen positionAtThisState:translatedFloatViewMinYForFullscreen.y beginPos:0 endPos:0];
//            RCFloatViewState *halfscreen = [[RCFloatViewState alloc] initWithState:FloatViewStateMenuHalfscreen positionAtThisState:translatedFloatViewMenuYForHalfscreen.y beginPos:0 endPos:0];
//            RCFloatViewState *hidden = [[RCFloatViewState alloc] initWithState:FloatViewStateHidden positionAtThisState:translatedFloatViewMaxYForHidden.y beginPos:0 endPos:0];
//            strategy.orderedStatesByPositionAscending = @[fullscreen, halfscreen, hidden];
//        } else {
//            RCFloatViewState *fullscreen = [[RCFloatViewState alloc] initWithState:FloatViewStateDetailsFullscreen positionAtThisState:translatedFloatViewMinYForFullscreen.y beginPos:0 endPos:0];
//            RCFloatViewState *halfscreen = [[RCFloatViewState alloc] initWithState:FloatViewStateDetailsHalfscreen positionAtThisState:translatedFloatViewDetailsYForHalfscreen.y beginPos:0 endPos:0];
//            RCFloatViewState *hidden = [[RCFloatViewState alloc] initWithState:FloatViewStateHidden positionAtThisState:translatedFloatViewMaxYForHidden.y beginPos:0 endPos:0];
//            strategy.orderedStatesByPositionAscending = @[fullscreen, halfscreen, hidden];
//        }
//        RCFloatViewState *prevState = [[RCFloatViewState alloc] initWithState:self.lastStableFloatViewState positionAtThisState:0 beginPos:0 endPos:0];
//        RCFloatViewState *newFloatViewState = [strategy stateIfDragFinishedAtPosition:translatedFloatViewOrigin.y whenPreviousStateWas:prevState deltaToBothSides:0];
//        if (!(newFloatViewState.state == FloatViewStateHidden)) {
//            [self displayFloatViewInState:newFloatViewState.state animated:YES timeInterval:nil completion:nil];
//        } else {
//            [self hideFloatViewAnimatedCompletion:nil];
//        }
    };

//      NOT DELETE THIS LONG COMMENT
    BOOL useClassDisplaying = YES;
    self.dragDetector.didTouchedViewBlock = ^(UIView *view) {
        @strongify(self);
        
        __block CGColorRef borderColor = view.layer.borderColor;
        __block NSInteger borderWidth = view.layer.borderWidth;
		
        [view mag_addAnimatedDashedBorderColor:[UIColor orangeColor] borderWidth:5 cornerRadius:view.layer.cornerRadius];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIColor *color = [UIColor colorWithCGColor:borderColor];
            [view mag_removeAnimatedDashedBorder];
        });

        NSString *className = NSStringFromClass([view class]);
        NSLog(@"clicked control class %@",className);
        if ([className isEqualToString:@"UITableViewCellContentView"]) {
            view = view.superview;
            className = NSStringFromClass([view class]);
        }
        NSLog(@"view class %@",className);
        self.tappedControlLabel.text = className;
    };
}

@end
