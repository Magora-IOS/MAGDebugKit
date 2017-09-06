#import <UIKit/UIKit.h>
#import "MAGPanelCell.h"


@interface MAGPanelToggleCell : UIView <MAGPanelCell>

@property (nonatomic) NSNumber *value;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void(^action)(NSNumber *value);

@end
