








#import <Foundation/Foundation.h>

typedef void(^VideoBlock)(NSURL *url, NSError *error);

@interface MAGRealTimingVideoCreator : NSObject

@property (nonatomic) NSInteger realTakingFPS;

- (void)createVideoFromPreparedVideoURL:(NSURL *)url frameTimes:(NSArray <NSValue *> *)frameTimes videoLength:(CGFloat)videoLength imageSize:(CGSize)imageSize contextScaleWhereThemCreated:(CGFloat)contextScale completion:(VideoBlock)completion;

@end
