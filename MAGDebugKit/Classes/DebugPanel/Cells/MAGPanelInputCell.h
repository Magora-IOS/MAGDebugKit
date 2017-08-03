#import <UIKit/UIKit.h>


@interface MAGPanelInputCell : UIView

@property (nonatomic) NSString *value;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void(^action)(NSString *value);

@property (nonatomic, readonly) UITextField *input;

@end
