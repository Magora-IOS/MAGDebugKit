#import "MAGDebugPanel.h"
#import "MAGDebugOverviewSettingsVC.h"
#import "MAGRentgenSettingsVC.h"
#import "MAGLoggingSettingsVC.h"
#import "MAGSandboxBrowserVC.h"
#import "MAGVCLifecycleLoggingSettingsVC.h"

#import <Masonry/Masonry.h>
#import <libextobjc/extobjc.h>


@interface MAGDebugPanel ()

@property (nonatomic) MAGDebugPanelAppearanceStyle appearanceStyle;
@property (nonatomic) UIWindow *window;

//@property (nonatomic) BOTableViewSection *customActions;

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
	self.title = @"Settings";
	
	[self setupMenuActions];
}

#pragma mark - Public methods

- (void)integrateAboveWindow:(UIWindow *)appWindow {
	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self];
	nc.navigationBar.translucent = NO;

	CGRect screenRect = [UIScreen mainScreen].bounds;
	screenRect.origin.x = screenRect.size.width;
	self.window = [[UIWindow alloc] initWithFrame:screenRect];
	self.window.rootViewController = nc;
	self.window.windowLevel = appWindow.windowLevel + 1;
	
	[self setupAppearanceFromWindow:appWindow];
	
	[self setupCloseButton];
}

- (void)desintegrate {
	[self.navigationController.view removeFromSuperview];
	[self.navigationController removeFromParentViewController];
	self.window.rootViewController = nil;
	self.window = nil;
}

- (void)addAction:(void(^)(void))action withTitle:(NSString *)title {
//	BOTableViewCell *cell = [BOButtonTableViewCell cellWithTitle:title key:nil
//		handler:^(BOButtonTableViewCell *cell) {
//			cell.actionBlock = action;
//		}];
//
//	[self.customActions addCell:cell];
}

#pragma mark - UI actions

- (void)rightEdgeAppearanceGRAction:(UIScreenEdgePanGestureRecognizer *)gr {
	UIView *appWindow = gr.view;
	CGFloat translation = [gr translationInView:gr.view].x;

	if (gr.state == UIGestureRecognizerStateBegan ||
		gr.state == UIGestureRecognizerStateChanged) {
		
		CGRect panelRect = appWindow.bounds;
		panelRect.origin.x = appWindow.frame.size.width + translation;
		self.window.frame = panelRect;
		self.window.hidden = NO;
	} else {
		[self stickToNearestEdge];
	}
}

- (void)closeButtonTap:(id)sender {
	[self hideAnimated:YES];
}

#pragma mark - Private methods

- (void)setupAppearanceFromWindow:(UIWindow *)appWindow {
	UIGestureRecognizer *gr = nil;
	switch (self.appearanceStyle) {
		case MAGDebugPanelAppearanceStyleRight: {
			gr = ({
				UIScreenEdgePanGestureRecognizer *edgeGR = [[UIScreenEdgePanGestureRecognizer alloc]
					initWithTarget:self action:@selector(rightEdgeAppearanceGRAction:)];
				edgeGR.edges = UIRectEdgeRight;
				edgeGR.minimumNumberOfTouches = 1;
				edgeGR.maximumNumberOfTouches = 1;
				edgeGR;
			});
			break;
		}
		default: {
			NSAssert(NO, @"Appearance style must be defined.");
			break;
		}
	}
	
	[appWindow addGestureRecognizer:gr];
}

- (void)stickToNearestEdge {
	CGFloat finalPosition = NAN;
	if (self.window.frame.origin.x < self.window.frame.size.width/2) {
		finalPosition = 0;
		self.window.hidden = NO;
	} else {
		finalPosition = self.window.frame.size.width;
		self.window.hidden = YES;
	}
	
	CGRect finalRect = self.window.frame;
	finalRect.origin.x = finalPosition;

	[UIView animateWithDuration:0.25 animations:^{
			self.window.frame = finalRect;
		}];
}

- (void)hideAnimated:(BOOL)animated {
	CGRect finalRect = self.window.frame;
	finalRect.origin.x = self.window.frame.size.width;

	if (animated) {
		//[UIView animateWithDuration:0.25 animations:^{
		[UIView
			animateWithDuration:0.25
			animations:^{
				self.window.frame = finalRect;
			}
			completion:^(BOOL finished) {
				self.window.hidden = YES;
			}];
	} else {
		self.window.frame = finalRect;
		self.window.hidden = YES;
	}
}

- (void)setupCloseButton {
	UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]
		initWithBarButtonSystemItem:UIBarButtonSystemItemDone
		target:self action:@selector(closeButtonTap:)];
	self.navigationItem.leftBarButtonItem = closeButton;
}

- (void)setupMenuActions {
	@weakify(self);
	
	[self addTitle:@"Logging"];
	
	[self addButtonWithTitle:@"Logging" action:^{
			@strongify(self);
			[self loggingAction];
		}];
	
	[self addTitle:@"Views"];

	[self addButtonWithTitle:@"Overview" action:^{
			@strongify(self);
			[self overviewAction];
		}];
	
	[self addButtonWithTitle:@"Rentgen" action:^{
			@strongify(self);
			[self rentgenAction];
		}];

	[self addButtonWithTitle:@"VC lifecycle" action:^{
			@strongify(self);
			[self vcLifecycleAction];
		}];

	[self addTitle:@"Sandbox"];

	[self addButtonWithTitle:@"Disk browser" action:^{
			@strongify(self);
			[self sandboxBrowserAction];
		}];

//	self.customActions = [BOTableViewSection sectionWithHeaderTitle:nil handler:nil];
//	[self addSection:self.customActions];
}

- (void)loggingAction {
	
}

- (void)overviewAction {

}

- (void)rentgenAction {
	
}

- (void)vcLifecycleAction {

}

- (void)sandboxBrowserAction {
	MAGSandboxBrowserVC *vc = [[MAGSandboxBrowserVC alloc] initWithURL:nil];
	[self.navigationController pushViewController:vc animated:YES];
}

@end
