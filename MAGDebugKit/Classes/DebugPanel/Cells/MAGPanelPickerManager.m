#import "MAGPanelPickerManager.h"
#import "MAGPanelPickerCell.h"


@interface MAGPanelPickerManager () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) MAGPanelPickerCell *pickerCell;
@property (nonatomic) NSArray *options;
@property (nonatomic, copy) NSString *(^renderer)(id value);

@end


@implementation MAGPanelPickerManager

#pragma mark - Lifecycle

+ (instancetype)managerForPickerCell:(MAGPanelPickerCell *)pickerCell options:(NSArray *)options
	optionRenderer:(NSString *(^)(id value))renderer {
	
    MAGPanelPickerManager *instance = [[MAGPanelPickerManager alloc] init];
    if (!instance) {
		return nil;
	}
	
	instance.pickerCell = pickerCell;
	instance.options = options;
	instance.renderer = renderer;
	
	pickerCell.inputView.dataSource = instance;
	pickerCell.inputView.delegate = instance;
	
	return instance;
}

#pragma mark - Accessors

- (id)value {
	return self.pickerCell.value;
}

- (void)setValue:(id)value {
	self.pickerCell.value = value;

	NSInteger selectedIndex = [self.options indexOfObject:self.pickerCell.value];
	if (selectedIndex == NSNotFound) {
		[self.pickerCell.inputView reloadAllComponents];
	} else {
		[self.pickerCell.inputView selectRow:selectedIndex inComponent:0 animated:NO];
	}
}

#pragma mark - UIPickerViewDataSource / UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.options.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self titleAtRow:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.pickerCell.value = self.options[row];
}

- (NSString *)titleAtRow:(NSInteger)row {
    if (self.renderer && (self.options.count > row)) {
        return self.renderer(self.options[row]);
    }
	
    return nil;
}

@end
