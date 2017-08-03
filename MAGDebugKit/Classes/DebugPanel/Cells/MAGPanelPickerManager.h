#import <UIKit/UIKit.h>


@class MAGPanelPickerCell;


@interface MAGPanelPickerManager : NSObject

@property (nonatomic) id value;

+ (instancetype)managerForPickerCell:(MAGPanelPickerCell *)pickerCell options:(NSArray *)options
	optionRenderer:(NSString *(^)(id value))renderer;

@end
