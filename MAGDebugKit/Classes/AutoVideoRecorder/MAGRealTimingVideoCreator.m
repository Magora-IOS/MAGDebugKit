









#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

#import <MAGMatveevReusable/MAGFileSystem.h>
#import <MAGMatveevReusable/MAGFreeNameProvider.h>

#import "MAGCommonDefines.h"
#import "MAGRealTimingVideoCreator.h"
#import "MAGVideoCreator.h"


/**
		@brief Here using real captured frame count and video length we recalculate time intervals between frames and create final video file with real positions of frames
*/
@interface MAGRealTimingVideoCreator () {

}

@property (strong, nonatomic) NSString *videoOutputPath;
@property (strong, nonatomic) NSError *currentError;
@property (strong, nonatomic) NSURL *rawVideoURL;
@property (copy, nonatomic) VideoBlock completion;
@end

@implementation MAGRealTimingVideoCreator

- (void)createVideoFromPreparedVideoURL:(NSURL *)rawVideoURL frameTimes:(NSArray <NSValue *> *)frameTimes videoLength:(CGFloat)videoLength imageSize:(CGSize)imageSize contextScaleWhereThemCreated:(CGFloat)contextScale completion:(VideoBlock)completion {
	
	self.rawVideoURL = rawVideoURL;
	self.completion = completion;
	
	self.realTakingFPS = (CGFloat)frameTimes.count / videoLength;
	
	NSError *error = nil;
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	NSString *documentsDirectory = [MAGVideoCreator videosDestinationPath];
	NSLog(@"video path:   %@", [MAGVideoCreator videosDestinationPath]);
	MAGFreeNameProvider *provider = [[MAGFreeNameProvider alloc] initWithBasepath:[MAGVideoCreator videosDestinationPath] formatWithSingleArgumentForNumberText:@"finalvideo %@"];
	NSString *shortFilename = [provider generateShortFreeNamesCount:1 indexFromWhichStart:nil][0];
	shortFilename = [shortFilename stringByAppendingString:@".mp4"];
	self.videoOutputPath = [documentsDirectory stringByAppendingPathComponent:shortFilename];
	if ([fileMgr removeItemAtPath:self.videoOutputPath error:&error] != YES) {
		NSLog(@"Unable to delete file: %@", [error localizedDescription]);
	}
	self.currentError = error;

	AVAsset *asset = [AVAsset assetWithURL:rawVideoURL];
	
	
	AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
	AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] lastObject];
	self.currentError = error;
	
	NSDictionary *readerOutputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
										  [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange], kCVPixelBufferPixelFormatTypeKey,
										  nil];
	AVAssetReaderTrackOutput* readerOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:videoTrack
																						outputSettings:readerOutputSettings];
	[reader addOutput:readerOutput];
	[reader startReading];
	
	NSMutableArray *samples = [[NSMutableArray alloc] init];
	
	CMSampleBufferRef sample;
	BOOL willContinue = YES;
	while(willContinue) {
		sample = [readerOutput copyNextSampleBuffer];
		if (sample) {
			[samples addObject:(__bridge id)sample];
			CFRelease(sample);
		} else {
			willContinue = NO;
		}
	}
	
	AVAssetWriter *writer = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:self.videoOutputPath]
													  fileType:AVFileTypeMPEG4
														 error:&error];
	self.currentError = error;
//														 NSNumber *dataRate = videoTrack.estimatedDataRate;
	NSNumber *rate = @(videoTrack.estimatedDataRate);
	NSLog(@"ESTIMATED DATA RATE %@", rate.stringValue);
	if (rate.doubleValue > 200000) {
		rate = @(200000);
	}
	NSDictionary *videoCompressionProps = @{
										   AVVideoAverageBitRateKey: rate,
//										   AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel ,
//											AVVideoQualityKey : @(0.5)
										   };
//	NSNumber *bitRate = @(videoTrack.estimatedDataRate / 4.0);
//	NSNumber *bitRate1 = @(videoTrack. );
//	NSNumber *bitRate = @(videoTrack.estimatedDataRate);

	NSNumber *widthNumber = [NSNumber numberWithInt:videoTrack.naturalSize.width];
	NSNumber *heightNumber = [NSNumber numberWithInt:videoTrack.naturalSize.height];
	
//	NSDictionary *settings = @{AVVideoCodecKey:AVVideoCodecH264,
//                           AVVideoWidthKey:@(video_width),
//                           AVVideoHeightKey:@(video_height),
//                           AVVideoCompressionPropertiesKey:
//                               @{AVVideoAverageBitRateKey:@(desired_bitrate),
//                                 AVVideoProfileLevelKey:AVVideoProfileLevelH264Main31, /* Or whatever profile & level you wish to use */
//                                 AVVideoMaxKeyFrameIntervalKey:@(desired_keyframe_interval)}};

	NSDictionary *writerOutputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
										  AVVideoCodecH264, AVVideoCodecKey,
										  widthNumber, AVVideoWidthKey,
										  heightNumber, AVVideoHeightKey,
										  videoCompressionProps, AVVideoCompressionPropertiesKey,
										  nil];
	AVAssetWriterInput *writerInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo
																	 outputSettings:writerOutputSettings
																   sourceFormatHint:(__bridge CMFormatDescriptionRef)[videoTrack.formatDescriptions lastObject]];
	[writerInput setExpectsMediaDataInRealTime:NO];
	
	AVAssetWriterInputPixelBufferAdaptor *pixelBufferAdaptor = [[AVAssetWriterInputPixelBufferAdaptor alloc] initWithAssetWriterInput:writerInput
																										  sourcePixelBufferAttributes:nil];
	[writer addInput:writerInput];
	
	[writer startWriting];
	[writer startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp((__bridge CMSampleBufferRef)samples[0])];

	for(NSInteger i = 0; i < samples.count; i++) {
		//    CMTime presentationTime = CMSampleBufferGetPresentationTimeStamp((__bridge CMSampleBufferRef)samples[i]);
		CVPixelBufferRef imageBufferRef = CMSampleBufferGetImageBuffer((__bridge CMSampleBufferRef)samples[i]);
		
		while (!writerInput.readyForMoreMediaData) {
			[NSThread sleepForTimeInterval:0.1];
			//NSLog(@"WRITER UNPUT NOT READY");
		}
		
		CMTime realCurrentFrameTime = CMTimeMake(i ,(int32_t) self.realTakingFPS);
		
		CMTime presentationTime = realCurrentFrameTime;
		[pixelBufferAdaptor appendPixelBuffer:imageBufferRef
						 withPresentationTime:presentationTime];
	}
	
	[writerInput markAsFinished];
	[writer finishWritingWithCompletionHandler:^{
		[self completeFinish];
	}];
}

- (void)completeFinish {
	unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:self.videoOutputPath error:nil] fileSize];
	CGFloat mbSize __unused = (CGFloat)fileSize / (1024.0*1024.0);
	NSLog(@"Video creation finished. Result:\n\nREAL FPS %@\nfilesize: %@  mb\nvideopath: %@", @(self.realTakingFPS).stringValue, @(mbSize).stringValue, self.videoOutputPath);
	
	NSURL *outputURL = [NSURL fileURLWithPath:self.videoOutputPath];
	
	if ([MAGFileSystem fileWithPathExists:[outputURL path]]) {//		remove temp video
		[[NSFileManager defaultManager] removeItemAtURL:self.rawVideoURL error:nil];
	}
	RUN_BLOCK(self.completion, outputURL, self.currentError);
}

@end
