









#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

#import <MAGMatveevReusable/MAGFreeNameProvider.h>
#import <MAGMatveevReusable/MAGFileSystem.h>

#import "MAGCommonDefines.h"
#import "MAGVideoCreator.h"
#import "MAGRealTimingVideoCreator.h"

@interface MAGVideoCreator ()
{
	CVPixelBufferRef _buffer;
}

@property (nonatomic) CGSize imageSize;
@property (nonatomic) CGFloat contextScale;
@property (nonatomic) NSInteger takingFPS;

@property (nonatomic) NSInteger frameCount;
@property (nonatomic) CGFloat frameDuration;

@property (strong, nonatomic) AVAssetWriterInputPixelBufferAdaptor *adaptor;
@property (strong, nonatomic) AVAssetWriter *videoWriter;
@property (strong, nonatomic) AVAssetWriterInput *videoWriterInput;

@property (strong, nonatomic) NSString *videoOutputPath;
@property (strong, nonatomic) NSError *currentError;

@property (nonatomic) CMTime currentFrameTime;

@property (strong, nonatomic) NSMutableArray *frameTimes;//		NSValue from CMTime

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *finishedDate;

@end

@implementation MAGVideoCreator

+ (NSString *)videosDestinationPath {
	NSString *result = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	return result;
}

- (void)createVideoWithImageSize:(CGSize)imageSize contextScaleWhereThemCreated:(CGFloat)contextScale fpsWithWhichScreenshotsTaken:(ScreenshotTakingFPS)takingFPS {
	self.imageSize = imageSize;
	self.contextScale = contextScale;
	self.takingFPS = takingFPS;
	
	NSError *error = nil;
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	NSString *documentsDirectory = [[self class] videosDestinationPath];
	NSLog(@"video path:   %@", [MAGVideoCreator videosDestinationPath]);
	MAGFreeNameProvider *provider = [[MAGFreeNameProvider alloc] initWithBasepath:[MAGVideoCreator videosDestinationPath] formatWithSingleArgumentForNumberText:@"video %@"];
	NSString *shortFilename = [provider generateShortFreeNamesCount:1 indexFromWhichStart:nil][0];
	shortFilename = [shortFilename stringByAppendingString:@".mp4"];
	self.videoOutputPath = [documentsDirectory stringByAppendingPathComponent:shortFilename];
	if ([fileMgr removeItemAtPath:self.videoOutputPath error:&error] != YES) {
		NSLog(@"Unable to delete file: %@", [error localizedDescription]);
	}
	self.currentError = error;
	
	
	//    CGSize imageSize = [MAGCommonDefines mainScreenBoundsPortrait].size;// CGSizeMake(320, 568);
	
	NSLog(@"Start building video from defined frames.");
	
	self.videoWriter = [[AVAssetWriter alloc] initWithURL:
						[NSURL fileURLWithPath:self.videoOutputPath] fileType:AVFileTypeMPEG4
													error:&error];
	NSParameterAssert(self.videoWriter);
	
	//    UIImage *firstImage = [images firstObject];
	NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
								   AVVideoCodecH264, AVVideoCodecKey,
								   [NSNumber numberWithInt:imageSize.width], AVVideoWidthKey,
								   [NSNumber numberWithInt:imageSize.height], AVVideoHeightKey,
								   nil];
	
	self.videoWriterInput = [AVAssetWriterInput
							 assetWriterInputWithMediaType:AVMediaTypeVideo
							 outputSettings:videoSettings];
	
	
	self.adaptor = [AVAssetWriterInputPixelBufferAdaptor
					assetWriterInputPixelBufferAdaptorWithAssetWriterInput:self.videoWriterInput
					sourcePixelBufferAttributes:nil];
	
	NSParameterAssert(self.videoWriterInput);
	NSParameterAssert([self.videoWriter canAddInput:self.videoWriterInput]);
	self.videoWriterInput.expectsMediaDataInRealTime = YES;
	[self.videoWriter addInput:self.videoWriterInput];
	
	[self.videoWriter startWriting];
	[self.videoWriter startSessionAtSourceTime:kCMTimeZero];
	
	_buffer = NULL;
	
	self.frameCount = 0;
	self.frameDuration = 1;
	
	self.frameTimes = @[].mutableCopy;
	
	self.startDate = [NSDate date];
}

- (void)addImage:(UIImage *)image {
	_buffer = [[self class] pixelBufferFromImage:image contextScaleWhereThemCreated:self.contextScale];
	
	BOOL append_ok = NO;
	int j = 0;
	while (!append_ok && j < self.takingFPS) {
		if (self.adaptor.assetWriterInput.readyForMoreMediaData)  {
			//            NSLog(@"Processing video frame (%d)",self.frameCount);
			
			self.currentFrameTime = CMTimeMake(self.frameCount * self.frameDuration,(int32_t) self.takingFPS);
			NSValue *timeValue = [NSValue valueWithCMTime:self.currentFrameTime];
			[self.frameTimes addObject:timeValue];
			
			//            NSLog(@"frame time %@ %@", @(frameTime.value), @(frameTime.timescale));
			append_ok = [self.adaptor appendPixelBuffer:_buffer withPresentationTime:self.currentFrameTime];
			if(!append_ok){
				NSError *error = self.videoWriter.error;
				self.currentError = error;
				if(error!=nil) {
					NSLog(@"Unresolved error %@,%@.", error, [error userInfo]);
				}
			} else {
				CVBufferRelease(_buffer);
			}
		}
		else {
			printf("adaptor not ready %ld, %d\n", (long)self.frameCount, j);
			[NSThread sleepForTimeInterval:0.1];
		}
		j++;
	}
	if (!append_ok) {
		printf("error appending image %ld times %d\n, with error.", (long)self.frameCount, j);
	}
	self.frameCount++;
}

- (void)finishVideoCreation {
	NSLog(@"**************************************************");
	
	self.finishedDate = [NSDate date];

	
	[self.videoWriterInput markAsFinished];
	[self.videoWriter finishWriting];
	NSLog(@"Write Ended");
	
	NSTimeInterval videoLength = [self.finishedDate timeIntervalSinceDate:self.startDate];
//	CGFloat videoLength = self.currentFrameTime.value / self.currentFrameTime.timescale;
	NSLog(@"VIDEO TIME LENGTH %@",@(videoLength).stringValue);
	
	unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:self.videoOutputPath error:nil] fileSize];
	CGFloat mbSize = (CGFloat)fileSize / (1024.0*1024.0);
	NSLog(@"Video creation finished. Result:\n\nDESIRED FPS %@\nfilesize: %@  mb\nvideopath: %@", @(self.takingFPS).stringValue, @(mbSize).stringValue, self.videoOutputPath);
	NSURL *resultVideoURL = [NSURL fileURLWithPath:self.videoOutputPath];
	
	if ([MAGFileSystem fileWithPathExists:resultVideoURL.path]) {
		MAGRealTimingVideoCreator *finalVideoCreator = [[MAGRealTimingVideoCreator alloc] init];
		[finalVideoCreator createVideoFromPreparedVideoURL:resultVideoURL frameTimes:self.frameTimes videoLength:videoLength imageSize:self.imageSize contextScaleWhereThemCreated:self.contextScale completion:self.didVideoCreationFinishedBlock];
	}
}

+ (CVPixelBufferRef)pixelBufferFromImage:(UIImage *)sourceImage contextScaleWhereThemCreated:(CGFloat)contextScale {
	
	CGImageRef image = [sourceImage CGImage];
	CGSize size = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
							 [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
							 nil];
	CVPixelBufferRef pxbuffer = NULL;
	
	CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
										  size.width,
										  size.height,
										  kCVPixelFormatType_32ARGB,
										  (__bridge CFDictionaryRef) options,
										  &pxbuffer);
	if (status != kCVReturnSuccess){
		NSLog(@"Failed to create pixel buffer");
	}
	
	CVPixelBufferLockBaseAddress(pxbuffer, 0);
	void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
	
	CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(pxdata, size.width,
												 size.height, 8, 4*size.width, rgbColorSpace,
												 kCGImageAlphaPremultipliedFirst);
	//kCGImageAlphaNoneSkipFirst);
	CGFloat multiplierForFitScreen = 1.0 / contextScale;
	CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
	CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image)*multiplierForFitScreen,
										   CGImageGetHeight(image)*multiplierForFitScreen), image);
	CGColorSpaceRelease(rgbColorSpace);
	CGContextRelease(context);
	
	CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
	
	return pxbuffer;
}

@end
