#import "MAGPanelToggleCell.h"
#import "MAGPanelGeometry.h"
#import <Masonry/Masonry.h>


@interface MAGPanelToggleCell ()

@property (nonatomic) UILabel *label;
@property (nonatomic) UISwitch *toggle;

@end


@implementation MAGPanelToggleCell

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		[self setupMAGPanelButtonCell];
	}
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		[self setupMAGPanelButtonCell];
	}
	
	return self;
}

- (void)setupMAGPanelButtonCell {
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

	self.toggle = [[UISwitch alloc] init];
	self.toggle.on = self.value;
	[self.toggle addTarget:self action:@selector(switchToggle:) forControlEvents:UIControlEventValueChanged];
	[self addSubview:self.toggle];

	[self.label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.equalTo(self).with.insets(magPanelTitleCellEdgeInsets);
			make.centerY.equalTo(self);
		}];
	
	[self.toggle mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.equalTo(self.label.mas_trailing);
			make.trailing.equalTo(self).with.insets(magPanelTitleCellEdgeInsets);
			make.centerY.equalTo(self);
		}];
}

#pragma mark - Accessors

- (void)setTitle:(NSString *)title {
	_title = title;
	self.label.text = title;
}

#pragma mark - UI actions

- (void)switchToggle:(UISwitch *)sender {
	if (self.action) {
		self.action(self.toggle.on);
	}
}

@end
