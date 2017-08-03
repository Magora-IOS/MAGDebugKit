#import "MAGPanelGeometry.h"


CGFloat const magPanelCellHeight = 44.0f;
UIEdgeInsets const magPanelCellEdgeInsets = (UIEdgeInsets) {8.0f, 16.0f, 8.0f, 16.0f};
UIEdgeInsets const magPanelTitleCellEdgeInsets = (UIEdgeInsets) {16.0f, 16.0f, 4.0f, 16.0f};;

CGFloat const magPanelSeparatorHeight = 0.5f;


@implementation UIColor (magPanelColors)

+ (UIColor *)magPanelBackground {
	return [UIColor colorWithWhite:0.9f alpha:1.0f];
}

+ (UIColor *)magPanelCellBackground {
	return [UIColor colorWithWhite:1.0f alpha:1.0f];
}

+ (UIColor *)magPanelSeparator {
	return [UIColor colorWithWhite:0.75f alpha:1.0f];
}

+ (UIColor *)magPanelCellText {
	return [UIColor colorWithWhite:0.0f alpha:1.0f];
}

+ (UIColor *)magPanelTitleCellText {
	return [UIColor colorWithWhite:0.5f alpha:1.0f];
}

@end
