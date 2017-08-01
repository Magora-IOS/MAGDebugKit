#import <Foundation/Foundation.h>


extern CGFloat const magPanelCellHeight;
extern UIEdgeInsets const magPanelCellEdgeInsets;
extern UIEdgeInsets const magPanelTitleCellEdgeInsets;

extern CGFloat const magPanelSeparatorHeight;

@interface UIColor (magPanelColors)

+ (UIColor *)magPanelBackground;
+ (UIColor *)magPanelCellBackground;
+ (UIColor *)magPanelSeparator;
+ (UIColor *)magPanelCellText;
+ (UIColor *)magPanelTitleCellText;

@end
