//
//  MAGAppDelegate.m
//  MAGDebugKit
//
//  Created by Evgeniy Stepanov on 10/05/2016.
//  Copyright (c) 2016 Evgeniy Stepanov. All rights reserved.
//

#import "MAGAppDelegate.h"
#import <MAGDebugKit/MAGDebugKit.h>
#import <libextobjc/extobjc.h>
#import "MAGAutoVideoRecorder.h"


@implementation MAGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		MAGDebugPanel *panel = [MAGDebugPanel rightPanel];
		
		@weakify(panel);
		[panel addAction:^{
				@strongify(panel);
				[panel desintegrate];
			} withTitle:@"Desintegrate panel"];
		
		[panel integrateAboveWindow:self.window];
    });
	
//	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//		[[MAGAutoVideoRecorder sharedInstance] startVideoRecording];
//	});

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[MAGAutoVideoRecorder sharedInstance] stop];//		for writing video on disk before final termination
}

@end
