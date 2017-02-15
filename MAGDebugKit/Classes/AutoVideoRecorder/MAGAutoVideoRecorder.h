








#import <Foundation/Foundation.h>

typedef  NS_ENUM(NSInteger, RecordingStatus) {
	RecordingStatusPreparing = 0,
	RecordingStatusRecording = 1,
	RecordingStatusSaving = 2,
	RecordingStatusIdle = 3,
};

/**
		@brief WARN: add code to appDelegate:

		- (void)applicationWillTerminate:(UIApplication *)application {
			[[AutoDebugVideoRecorder sharedInstance] stop];//		for writing video on disk before final termination
		}
*/

@interface MAGAutoVideoRecorder : NSObject

@property (readonly, nonatomic) RecordingStatus status;

+ (instancetype)sharedInstance;

- (void)startVideoRecording;
- (void)stop;

@end
