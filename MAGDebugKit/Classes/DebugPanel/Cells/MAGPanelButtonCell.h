#import <UIKit/UIKit.h>


@interface MAGPanelButtonCell : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void(^action)(void);

@end
