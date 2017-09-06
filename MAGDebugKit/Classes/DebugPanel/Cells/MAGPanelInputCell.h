#import <UIKit/UIKit.h>
#import "MAGPanelCell.h"


@interface MAGPanelInputCell : UIView <MAGPanelCell>

@property (nonatomic) NSString *value;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void(^action)(NSString *value);
@property (nonatomic, copy) void(^returnKeyAction)();

@property (nonatomic, readonly) UITextField *input;

@end
