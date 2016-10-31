#import <UIKit/UIKit.h>


@interface UIView (MAGRentgenProperties)

@property (nonatomic, strong) CATextLayer *mag_classCaption;
@property (nonatomic, strong) UIColor *mag_initialBGColor;

// As some classes may use nil color as a default,
// we can't rely on nil/non-nil value to check if color is saved.
@property (nonatomic, strong) NSNumber *mag_initialBGColorSaved;

@end
