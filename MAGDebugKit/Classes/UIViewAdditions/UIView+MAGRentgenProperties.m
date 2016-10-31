#import "UIView+MAGRentgenProperties.h"

#import <libextobjc/extobjc.h>


@implementation UIView (MAGRentgenProperties)

@synthesizeAssociation(UIView, mag_classCaption)
@synthesizeAssociation(UIView, mag_initialBGColor)
@synthesizeAssociation(UIView, mag_initialBGColorSaved)

// TODO: update "initial bg color" after self.background color
// is updated in runtime during a rentgen mode.

@end
