#import <Foundation/Foundation.h>


@protocol MAGMenuAction <NSObject>

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;
@property (nonatomic) BOOL enabled;

- (void)perform;

@end


@interface MAGMenuActionBlock : NSObject <MAGMenuAction>

@property (nonatomic, copy) void(^block)(void);

@end
