#import <UIKit/UIKit.h>


@interface MAGPanelPickerCell : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic) id value;
@property (nonatomic, copy) NSString *(^renderer)(id value);
@property (nonatomic, copy) void(^action)(id value);

@property (nonatomic) UIPickerView *inputView;

@end
