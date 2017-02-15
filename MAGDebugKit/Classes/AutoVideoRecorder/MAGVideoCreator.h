








#import "MAGScreenshotCollector.h"

typedef void(^VideoBlock)(NSURL *url, NSError *error);

@interface MAGVideoCreator : NSObject

@property (strong, nonatomic) VideoBlock didVideoCreationFinishedBlock;

+ (NSString *)videosDestinationPath;
+ (CVPixelBufferRef)pixelBufferFromImage:(UIImage *)sourceImage contextScaleWhereThemCreated:(CGFloat)contextScale;

- (void)createVideoWithImageSize:(CGSize)imageSize contextScaleWhereThemCreated:(CGFloat)contextScale fpsWithWhichScreenshotsTaken:(ScreenshotTakingFPS)takingFPS;
- (void)addImage:(UIImage *)image;
- (void)finishVideoCreation;

@end
