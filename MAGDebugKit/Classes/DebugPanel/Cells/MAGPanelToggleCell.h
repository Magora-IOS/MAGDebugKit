#import <UIKit/UIKit.h>


@interface MAGPanelToggleCell : UIView

@property (nonatomic) NSNumber *value;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void(^action)(NSNumber *value);

@end
