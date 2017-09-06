#import "MAGPanelInputCell.h"
#import "MAGPanelGeometry.h"
#import <Masonry/Masonry.h>


@interface MAGPanelInputCell () <UITextFieldDelegate>

@property (nonatomic) UILabel *label;
@property (nonatomic) UITextField *input;

@end


@implementation MAGPanelInputCell

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		[self setupMAGPanelInputCell];
	}
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		[self setupMAGPanelInputCell];
	}
	
	return self;
}

- (void)setupMAGPanelInputCell {
	[self mas_makeConstraints:^(MASConstraintMaker *make) {
			make.height.equalTo(@(magPanelCellHeight));
		}];
	
	self.backgroundColor = [UIColor magPanelCellBackground];

	self.label = [[UILabel alloc] init];
	
	self.label = [[UILabel alloc] init];
	self.label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
	self.label.textColor = [UIColor magPanelCellText];
	self.label.text = self.title;
	[self addSubview:self.label];

	self.input = [[UITextField alloc] init];
	self.input.text = self.value;
	self.input.placeholder = self.title;
	self.input.textAlignment = NSTextAlignmentRight;
	self.input.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
	self.input.delegate = self;
	[self.input addTarget:self action:@selector(inputChanged:) forControlEvents:UIControlEventEditingChanged];
	[self addSubview:self.input];

	[self.label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.equalTo(self).with.insets(magPanelTitleCellEdgeInsets);
			make.centerY.equalTo(self);
		}];
	
	[self.input mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.equalTo(self.label.mas_trailing).with.offset(magPanelCellElementsOffset);
			make.top.equalTo(self).with.insets(magPanelCellEdgeInsets);
			make.bottom.equalTo(self).with.insets(magPanelCellEdgeInsets);
			make.trailing.equalTo(self).with.insets(magPanelCellEdgeInsets);
			make.width.greaterThanOrEqualTo(self).dividedBy(3.0f);
		}];
	
	[self.input setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
	[self.label setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - Accessors

- (void)setTitle:(NSString *)title {
	_title = title;
	self.label.text = title;
	self.input.placeholder = title;
}

- (void)setValue:(NSString *)value {
	_value = value;
	self.input.text = self.value;
}

#pragma mark - UIResponder methods

- (BOOL)canBecomeFirstResponder {
	return self.input.canBecomeFirstResponder;
}

- (BOOL)becomeFirstResponder {
	return [self.input becomeFirstResponder];
}

- (BOOL)isFirstResponder {
	return self.input.isFirstResponder;
}

- (BOOL)canResignFirstResponder {
	return self.input.canResignFirstResponder;
}

- (BOOL)resignFirstResponder {
	return [self.input resignFirstResponder];
}

#pragma mark - UI actions

- (void)inputChanged:(UITextField *)sender {
	if (self.action) {
		_value = self.input.text;
		self.action(self.input.text);
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (self.returnKeyAction) {
		self.returnKeyAction();
	}
	
	return NO;
}

@end
