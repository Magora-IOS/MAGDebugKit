#import <UIKit/UIKit.h>


@interface MAGPanelToggleCell : UIView

@property (nonatomic) BOOL value;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void(^action)(BOOL value);

@end
