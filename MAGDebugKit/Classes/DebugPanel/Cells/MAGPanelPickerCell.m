#import "MAGPanelPickerCell.h"
#import "MAGPanelGeometry.h"
#import <Masonry/Masonry.h>


@interface MAGPanelPickerCell ()

@property (nonatomic) UIButton *button;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *valueLabel;
@property (nonatomic) UITextField *textField;
@property (nonatomic) UIPickerView *pickerView;

@property (nonatomic) UIView *inputAccessoryView;

@end


@implementation MAGPanelPickerCell
@synthesize  separator;

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		[self setupMAGPanelPickerCell];
	}
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		[self setupMAGPanelPickerCell];
	}
	
	return self;
}

- (void)setupMAGPanelPickerCell {
	[self mas_makeConstraints:^(MASConstraintMaker *make) {
			make.height.equalTo(@(magPanelCellHeight));
		}];
	
	self.backgroundColor = [UIColor magPanelCellBackground];

	self.button = [UIButton buttonWithType:UIButtonTypeSystem];
	self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	self.button.contentEdgeInsets = magPanelCellEdgeInsets;
	[self.button setTitle:nil forState:UIControlStateNormal];
	[self.button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
	
	[self addSubview:self.button];
	[self.button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self);
		}];

	self.titleLabel = [[UILabel alloc] init];
	self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
	self.titleLabel.textColor = [UIColor magPanelCellText];
	self.titleLabel.text = self.title;
	[self addSubview:self.titleLabel];
	[self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.equalTo(self).with.insets(magPanelCellEdgeInsets);
			make.centerY.equalTo(self);
		}];
	
	self.valueLabel = [[UILabel alloc] init];
	self.valueLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
	self.valueLabel.textColor = [UIColor magPanelCellValueText];
	
	if (self.renderer) {
		self.valueLabel.text = self.renderer(self.value);
	}
	
	[self addSubview:self.valueLabel];
	[self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.trailing.equalTo(self).with.insets(magPanelCellEdgeInsets);
			make.baseline.equalTo(self.titleLabel);
		}];
	
	self.textField = [[UITextField alloc] init];
	self.textField.frame = CGRectZero;
	[self addSubview:self.textField];
	
	self.pickerView = [[UIPickerView alloc] init];
	self.inputView = self.pickerView;
}

- (BOOL)becomeFirstResponder {
    return [self.textField becomeFirstResponder];
}

- (BOOL)isFirstResponder {
    return [self.textField isFirstResponder];
}

#pragma mark - Accessors

- (void)setTitle:(NSString *)title {
	_title = title;
	
	self.titleLabel.text = self.title;
}

- (void)setValue:(id)value {
	_value = value;
	
	if (self.renderer) {
		self.valueLabel.text = self.renderer(self.value);
	}
	
	if (self.action) {
		self.action(self.value);
	}
}

- (void)setInputView:(UIPickerView *)inputView {
	_inputView = inputView;
    self.textField.inputView = inputView;
}

- (void)setInputAccessoryView:(UIView *)inputAccessoryView {
	_inputAccessoryView = inputAccessoryView;
    self.textField.inputAccessoryView = inputAccessoryView;
}

#pragma mark - UI actions

- (void)buttonTap:(UIButton *)sender {
	if (self.textField.isFirstResponder) {
		[self.textField resignFirstResponder];
	} else {
		[self.textField becomeFirstResponder];
	}
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
    replacementString:(NSString *)string {
        return NO;
}

@end
