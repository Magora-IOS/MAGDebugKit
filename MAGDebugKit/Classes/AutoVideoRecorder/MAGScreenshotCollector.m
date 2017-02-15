//
//  ScreenshotCollector.m
//  Pods
//
//  Created by Matveev on 11/10/16.
//
//

#import <MAGMatveevReusable/MAGCommonDefines.h>
#import <libextobjc/EXTScope.h>

#import "MAGScreenshotCollector.h"
#import "MAGVideoCreator.h"
#import "MAGDragDetector.h"

#define kAnalysedTakingFPS        @"kAnalysedTakingFPS"

#define kAnalysingTimeSeconds      7

@interface MAGScreenshotCollector ()

@property (nonatomic) BOOL breakGathering;

@property (strong, nonatomic) MAGDragDetector *dragDetector;

@property (nonatomic) CGSize screenshotSize;

@property (strong, nonatomic) ScreenshotCollectioningBlock didConfiguringFinishedBlock;

@end

@implementation MAGScreenshotCollector

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
		keyWindow.layer.drawsAsynchronously = YES;//		for avoid not stable crash from [window.layer renderInContext:UIGraphicsGetCurrentContext()]; (bcs we call it in background, but it forbidden)

        self.dragDetector = [[MAGDragDetector alloc] initWithFundamentView:keyWindow];
        self.dragDetector.canHandleDragWhenTouchDownAtLocationBlock = ^(CGPoint touchDownPoint) {
            return YES;
        };
        self.dragDetector.willHandleDragWhenPanRecognizedAtLocationBlock = ^(CGPoint touchDownPoint, CGPoint panRecognizedAtPoint, CGFloat lesserPositiveAngleInDegreesBetweenCurrentLocationPointAndAxisX) {
            return YES;
        };
    }
    return self;
}

- (void)configureCollectioningWithQuality:(ScreenshotQuality)quality desiredTakingFPS:(ScreenshotTakingFPS)takingFPS completion:(ScreenshotCollectioningBlock)completion {
    self.breakGathering = NO;
    self.didConfiguringFinishedBlock = completion;
    NSLog(@"GATHERING STARTED");
    
    _pickedQuality = quality;
    _pickedQualityFloatValue = [self contextScaleForQuality:quality];
    _pickedTakingFPS = takingFPS;
	
    CGSize sizeForContext = [UIScreen mainScreen].bounds.size;
    NSInteger integerWidth = sizeForContext.width;
    NSInteger modulo = integerWidth % 16;//     bcs withd of images must be multiple of 16     http://stackoverflow.com/a/9699351/3627460
    NSInteger croppedWidth = integerWidth - modulo;
    
    CGSize croppedSizeForContext = sizeForContext;
    croppedSizeForContext.width = croppedWidth;
    
    self.screenshotSize = croppedSizeForContext;
	RUN_BLOCK(completion, self.pickedTakingFPS, self.pickedQualityFloatValue);
}

- (void)startCollectioningInBackground {
	[self startTakingScreenshotRECURSIVELY];
}

- (CGFloat)contextScaleForQuality:(ScreenshotQuality)quality {
    CGFloat result;
    switch (quality) {
        case ScreenshotQuality1of5:{result = 1.0 / 5.0;} break;
        case ScreenshotQuality1of4:{result = 1.0 / 4.0;} break;
        case ScreenshotQuality1of2:{result = 1.0 / 2.0;} break;
		case ScreenshotQualityX1:{result = 1.0 ;} break;
        case ScreenshotQualityX2:{result = 2.0;} break;
        case ScreenshotQualityX3:{result = 3.0;} break;
            
        default:{result = 1.0 / 2.0;} break;
    }
    return result;
}

- (void)stopWithCompletion:(dispatch_block_t)completion {
    self.breakGathering = YES;
    
    RUN_BLOCK(completion);
}

- (void)startTakingScreenshotRECURSIVELY {
    @weakify(self);
    CGFloat timeBetweenScreenshots = 1.0 / (CGFloat)self.pickedTakingFPS;
    CGFloat scale = self.pickedQualityFloatValue;//      the lower the quality of image lower (as jpeg for example)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        @strongify(self);
        if (!self.breakGathering) {
			
            UIImage *anotherScreenshot = [self takeScreenshotWithScale:scale];
            
            if (!self.breakGathering) {
                self.didOneMoreScreenshotCapturedBlock(anotherScreenshot);
            }
            if (!self.breakGathering) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeBetweenScreenshots * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    @strongify(self);
                    [self startTakingScreenshotRECURSIVELY];
                });
            }
        }
    });
}

- (UIImage *)takeScreenshotWithScale:(CGFloat)scale {
    UIImage *result;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    CGSize contextSize = [MAGCommonDefines mainScreenBoundsPortrait].size;
    UIGraphicsBeginImageContextWithOptions(contextSize, false, scale);

	CGRect rect = CGRectMake(0, 0, contextSize.width, contextSize.height);
	@synchronized (window) {
		[window drawViewHierarchyInRect:rect afterScreenUpdates:NO];
	}
//		[window.layer renderInContext:UIGraphicsGetCurrentContext()];//		this call is reason of strange unstable crash (bcs calledn't from main thread)
	if (self.dragDetector.pointInScreenCoordinatesWhereFingerIsTouchingScreenNow) {
        UIImage *fingerOnScreenImage = IMG(@"target");
        CGRect rect = CGRectMake(0, 0, 30, 30);
        
        CGPoint point = [self.dragDetector.pointInScreenCoordinatesWhereFingerIsTouchingScreenNow CGPointValue];
        rect.origin = point;
        //            CGContextRef c = UIGraphicsGetCurrentContext();
        [fingerOnScreenImage drawInRect:rect];
    }
    
    result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *scaledImage = [[self class] imageWithImage:result scaledToSize:self.screenshotSize scale:scale];
//    NSLog(@"before %@ after %@",NSStringFromCGSize(result.size), NSStringFromCGSize(scaledImage.size));
    return scaledImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize scale:(CGFloat)scale {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
