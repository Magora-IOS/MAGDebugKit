#import <UIKit/UIKit.h>
#import "MAGPanelCell.h"


@interface MAGPanelButtonCell : UIView <MAGPanelCell>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void(^action)(void);

@end
