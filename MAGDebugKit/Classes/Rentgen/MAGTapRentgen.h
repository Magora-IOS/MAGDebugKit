#import <Foundation/Foundation.h>


@interface MAGTapRentgen : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, readonly) BOOL active;

- (void)start;
- (void)stop;

@end
