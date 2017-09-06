#import "MAGPanelTitleCell.h"
#import "MAGPanelGeometry.h"
#import <Masonry/Masonry.h>


@interface MAGPanelTitleCell ()

@property (nonatomic) UILabel *label;

@end


@implementation MAGPanelTitleCell
@synthesize separator;

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
	self.backgroundColor = [UIColor clearColor];

	self.label = [[UILabel alloc] init];
	self.label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
	self.label.textColor = [UIColor magPanelTitleCellText];
	self.label.text = self.title;
	[self addSubview:self.label];

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
