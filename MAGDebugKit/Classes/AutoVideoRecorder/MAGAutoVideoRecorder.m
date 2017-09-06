//#import <ExceptionHandling/NSExceptionHandler.h>

#import <libextobjc/EXTScope.h>
#import <MAGMatveevReusable/MAGCommonDefines.h>
#import "MAGAutoVideoRecorder.h"
#import "MAGScreenshotCollector.h"
#import "MAGVideoCreator.h"
#import "MAGCacheCleaner.h"

#define kMaxVideoLength		10*60
#define kMaxStorableVideoCount		15


@interface MAGAutoVideoRecorder ()

@property (readwrite, nonatomic) RecordingStatus status;
@property (strong, nonatomic) MAGVideoCreator *videoCreator;

@end


@implementation MAGAutoVideoRecorder

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
        [self prepareAll];
    }
    return self;
}

- (void)prepareAll {
	self.status= RecordingStatusIdle;

//	[[NSExceptionHandler defaultExceptionHandler] setExceptionHandlingMask:NSLogAndHandleEveryExceptionMask];
//	[[NSExceptionHandler defaultExceptionHandler] setDelegate:self];
    NSSetUncaughtExceptionHandler (&exceptionHandler);
	signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
}

- (void)startVideoRecording {
    @weakify(self);
	[[MAGCacheCleaner sharedInstance] removeOldFilesOverCount:kMaxStorableVideoCount atDirPath:[MAGVideoCreator videosDestinationPath]];
	
    self.videoCreator = [MAGVideoCreator new];
    self.videoCreator.didVideoCreationFinishedBlock = ^(NSURL *url, NSError *error) {
    };
	self.status = RecordingStatusPreparing;
	[[MAGScreenshotCollector sharedInstance] configureCollectioningWithQuality:ScreenshotQualityX1 desiredTakingFPS:ScreenshotTakingFPS15 completion:^(ScreenshotTakingFPS desiredTakingFPS, CGFloat scale) {
        @strongify(self);
	self.status = RecordingStatusRecording;
        CGSize desiredScreenshotSize = [MAGCommonDefines mainScreenBoundsPortrait].size;
        [self.videoCreator createVideoWithImageSize:desiredScreenshotSize contextScaleWhereThemCreated:scale fpsWithWhichScreenshotsTaken:desiredTakingFPS];
        
        [[MAGScreenshotCollector sharedInstance] startCollectioningInBackground];
        [MAGScreenshotCollector sharedInstance].didOneMoreScreenshotCapturedBlock = ^(UIImage *screenshot) {
            @strongify(self);
            [self.videoCreator addImage:screenshot];
        };
        NSInteger stopRecordingAfterSeconds = kMaxVideoLength;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(stopRecordingAfterSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[MAGAutoVideoRecorder sharedInstance] stop];
        });
	}];
}

- (void)stop {
    @weakify(self);
	self.status = RecordingStatusSaving;
    [[MAGScreenshotCollector sharedInstance] stopWithCompletion:^() {
        @strongify(self);
		[self.videoCreator finishVideoCreation];
		self.status = RecordingStatusIdle;
    }];
}

void exceptionHandler (NSException *exception) {
	processException(exception);
//    NSString * exceptionDescription = [[NSString alloc] initWithFormat:@"CallStackSymbols %@", [exception callStackSymbols]];
//    NSLog(@"EXCEPTION DESCRIPTION: %@",exceptionDescription);
//    
//    [[AutoDebugVideoRecorder sharedInstance] stop];
}

void SignalHandler(int signal) {
	processException(nil);
}

void processException(NSException *exception) {
	NSLog(@"EXCEPTION PROCESSING STARTED");
    [[MAGAutoVideoRecorder sharedInstance] stop];
	NSLog(@"EXCEPTION PROCESSING FINISHED");
}

//- (void)precessException:(NSException *)exception {
//	NSString * exceptionDescription = [[NSString alloc] initWithFormat:@"CallStackSymbols %@", [exception callStackSymbols]];
//    NSLog(@"EXCEPTION DESCRIPTION: %@",exceptionDescription);
//    
//    [[AutoDebugVideoRecorder sharedInstance] stop];
//}

//- (BOOL)exceptionHandler:(NSExceptionHandler *)sender shouldLogException:(NSException *)exception mask:(NSUInteger)aMask {
//	NSLog(@"SHOULD LOG EXCEPTION");
//	[self processException:exception];
//}
//
//- (BOOL)exceptionHandler:(NSExceptionHandler *)sender shouldHandleException:(NSException *)exception mask:(NSUInteger)aMask {
//	NSLog(@"SHOULD HANDLE EXCEPTION");
//	[self processException:exception];
//}

@end
