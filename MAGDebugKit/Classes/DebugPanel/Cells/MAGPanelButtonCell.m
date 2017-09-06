#import "MAGPanelButtonCell.h"
#import "MAGPanelGeometry.h"
#import <Masonry/Masonry.h>


@interface MAGPanelButtonCell ()

@property (nonatomic) UIButton *button;

@end


@implementation MAGPanelButtonCell
@synthesize separator;

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

	self.button = [UIButton buttonWithType:UIButtonTypeSystem];
	self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	self.button.contentEdgeInsets = magPanelCellEdgeInsets;
	[self.button setTitleColor:[UIColor magPanelCellText] forState:UIControlStateNormal];
	[self.button setTitle:self.title forState:UIControlStateNormal];
	self.button.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
	[self.button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
	
	[self addSubview:self.button];
	[self.button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self);
		}];
}

#pragma mark - Accessors

- (void)setTitle:(NSString *)title {
	_title = title;
	[self.button setTitle:self.title forState:UIControlStateNormal];
}

#pragma mark - UI actions

- (void)buttonTap:(UIButton *)sender {
	if (self.action) {
		self.action();
	}
}

@end
