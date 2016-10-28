#import <Foundation/Foundation.h>


@interface MAGRentgen : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic) UIWindow *window;

@property (nonatomic, readonly) BOOL active;

- (void)start;
- (void)stop;

@end
