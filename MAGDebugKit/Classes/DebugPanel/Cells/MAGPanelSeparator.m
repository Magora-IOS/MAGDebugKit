#import "MAGPanelSeparator.h"
#import "MAGPanelGeometry.h"
#import <Masonry/Masonry.h>


@implementation MAGPanelSeparator

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		[self setupMAGPanelSeparator];
	}
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		[self setupMAGPanelSeparator];
	}
	
	return self;
}

- (void)setupMAGPanelSeparator {
	[self mas_makeConstraints:^(MASConstraintMaker *make) {
			make.height.equalTo(@(magPanelSeparatorHeight));
		}];
	
	self.backgroundColor = [UIColor magPanelSeparator];
}

@end
