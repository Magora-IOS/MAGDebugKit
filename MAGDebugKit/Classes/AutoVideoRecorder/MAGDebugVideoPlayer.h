//
//  DebugVideoPlayer.h
//  SMSCenter
//
//  Created by Matveev on 20/10/16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAGDebugVideoPlayer : NSObject

+ (instancetype)sharedInstance;
- (void)playOverWindowVideoWithURL:(NSURL *)fileurl;

@end
