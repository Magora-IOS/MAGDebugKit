//
//  DebugVideoPlayer.m
//  SMSCenter
//
//  Created by Matveev on 20/10/16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import "MAGDebugVideoPlayer.h"
#import <MAGMatveevReusable/UIView+MAGMore.h>
#import <YKMediaPlayerKit/YKMediaPlayerKit.h>

@interface MAGDebugVideoPlayer ()

@property (strong, nonatomic) id<YKVideo> parsedVideo;

@end

@implementation MAGDebugVideoPlayer

+ (instancetype)sharedInstance {
    static MAGDebugVideoPlayer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [MAGDebugVideoPlayer new];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)playOverWindowVideoWithURL:(NSURL *)fileurl {
    //Variable to hold parsed video
//    id<YKVideo> video;
    
    //You can use YouTube, Vimeo, or direct video URL too.
//    NSString *videoURL = fileurl;// @"https://www.youtube.com/watch?v=GJey_oygU3Y";
    
    YKMediaPlayerKit *player = [[YKMediaPlayerKit alloc] initWithURL:fileurl];
    [player parseWithCompletion:^(YKVideoTypeOptions videoType, id<YKVideo> parsedVideo, NSError *error) {
        
        //Save parsed video to a class level property.
        self.parsedVideo = parsedVideo;
		UIViewController *vc = [self.parsedVideo movieViewController:YKQualityHigh];
		[[UIView mag_appTopViewController] presentViewController:vc animated:YES completion:nil];
//		[self.parsedVideo play:YKQualityHigh];
        //Get thumbnails
        //        [player thumbWithCompletion:^(UIImage *thumb, NSError *error) {
        //            if (thumb) {
        //                //set thumbnail to respective UIImageView.
        //                self.imageView.image = thumb;
        //            }
        //        }];
    }];
    
    //Play parsed video
//    - (IBAction)playButtonPressed {
//        [self.video play:YKQualityMedium];
//    }
}

@end
