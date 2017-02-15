//
//  ScreenshotCollector.h
//  Pods
//
//  Created by Matveev on 11/10/16.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ScreenshotQuality) {
    ScreenshotQuality1of5 = 0,
    ScreenshotQuality1of4 = 1,
    ScreenshotQuality1of2 = 3,
    ScreenshotQualityX1 = 5,
    ScreenshotQualityX2 = 6,
    ScreenshotQualityX3 = 7,
};

typedef NS_ENUM(NSInteger, ScreenshotTakingFPS) {
    ScreenshotTakingFPS10 = 10,
    ScreenshotTakingFPS15 = 15,
    ScreenshotTakingFPS20 = 20,
    ScreenshotTakingFPS25 = 25,
    ScreenshotTakingFPS30 = 30,
    ScreenshotTakingFPS40 = 40,
    ScreenshotTakingFPS50 = 50,
    ScreenshotTakingFPS60 = 60,
};

typedef void(^ScreenshotBlock)(UIImage *screenshot);

typedef void(^ScreenshotCollectioningBlock)(ScreenshotTakingFPS desiredTakingFPS, CGFloat scale);

@interface MAGScreenshotCollector : NSObject

@property (readonly, nonatomic) ScreenshotQuality pickedQuality;
@property (readonly, nonatomic) CGFloat pickedQualityFloatValue;

@property (readonly, nonatomic) ScreenshotTakingFPS pickedTakingFPS;

@property (strong, nonatomic) ScreenshotBlock didOneMoreScreenshotCapturedBlock;


+ (instancetype)sharedInstance;

- (void)configureCollectioningWithQuality:(ScreenshotQuality)quality desiredTakingFPS:(ScreenshotTakingFPS)takingFPS completion:(ScreenshotCollectioningBlock)completion;
- (void)startCollectioningInBackground;
- (void)stopWithCompletion:(dispatch_block_t)completion;

@end
