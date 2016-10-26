#import "MAGDebugPanel.h"


@interface MAGDebugPanel ()

@property (nonatomic) MAGDebugPanelAppearanceStyle appearanceStyle;

@end


@implementation MAGDebugPanel

#pragma mark - Lifecycle

- (instancetype)initWithAppearanceStyle:(MAGDebugPanelAppearanceStyle)appearanceStyle {
	NSAssert(appearanceStyle != MAGDebugPanelAppearanceStyleUnknown, @"Appearance style must be defined.");
	
	self = [super init];
	if (!self) {
		return nil;
	}
	
	_appearanceStyle = appearanceStyle;
	
	return self;
}

+ (instancetype)rightPanel {
	return [[self alloc] initWithAppearanceStyle:MAGDebugPanelAppearanceStyleRight];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Public methods

- (void)integrate {
	
}

@end
