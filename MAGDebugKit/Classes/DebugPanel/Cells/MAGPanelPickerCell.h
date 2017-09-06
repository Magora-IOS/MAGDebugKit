#import <UIKit/UIKit.h>
#import "MAGPanelCell.h"


@interface MAGPanelPickerCell : UIView <MAGPanelCell>

@property (nonatomic, copy) NSString *title;
@property (nonatomic) id value;
@property (nonatomic, copy) NSString *(^renderer)(id value);
@property (nonatomic, copy) void(^action)(id value);

@property (nonatomic) UIPickerView *inputView;

@end
