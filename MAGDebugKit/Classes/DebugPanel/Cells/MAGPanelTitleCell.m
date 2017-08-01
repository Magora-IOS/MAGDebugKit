#import "MAGPanelTitleCell.h"
#import "MAGPanelGeometry.h"
#import <Masonry/Masonry.h>


@interface MAGPanelTitleCell ()

@property (nonatomic) UILabel *label;

@end


@implementation MAGPanelTitleCell

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		[self setupMAGPanelTitleCell];
	}
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		[self setupMAGPanelTitleCell];
	}
	
	return self;
}

- (void)setupMAGPanelTitleCell {
//	[self mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.height.equalTo(@(magPanelCellHeight));
//		}];
	
	self.backgroundColor = [UIColor clearColor];

	self.label = [[UILabel alloc] init];
	self.label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
	self.label.textColor = [UIColor magPanelTitleCellText];
	[self addSubview:self.label];
	
//	self.button = [UIButton buttonWithType:UIButtonTypeSystem];
//	self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//	self.button.contentEdgeInsets = magPanelCellEdgeInsets;
//	[self.button setTitleColor:[UIColor magPanelCellText] forState:UIControlStateNormal];
//	[self.button setTitle:self.title forState:UIControlStateNormal];
//	self.button.titleLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
//	[self.button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
//	
//	[self addSubview:self.button];
	[self.label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self).with.insets(magPanelTitleCellEdgeInsets);
		}];
}

#pragma mark - Accessors

- (void)setTitle:(NSString *)title {
	_title = title;
	self.label.text = self.title;
}

@end
