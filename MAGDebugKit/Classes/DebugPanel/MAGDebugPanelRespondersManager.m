#import "MAGDebugPanelRespondersManager.h"


@interface MAGDebugPanelRespondersManager ()

@property (strong, nonatomic) NSMutableArray <UIResponder *> *responderViews;

@end


@implementation MAGDebugPanelRespondersManager

- (instancetype)init {
	self = [super init];
	if (!self) {
		return nil;
	}
	
	_responderViews = [NSMutableArray array];
	
	return self;
}

- (instancetype)initWithViews:(NSArray *)views {
    self = [self init];
    if (!self) {
		return  nil;
	}
	
	_responderViews = [NSMutableArray arrayWithArray:views];
	
    return self;
}

- (void)addViews:(NSArray *)views {
    [self.responderViews addObjectsFromArray:views];
}

- (void)insertViews:(NSArray *)views atIndexes:(NSIndexSet *)indexes {
    [self.responderViews insertObjects:views atIndexes:indexes];
}

- (void)removeView:(UIView *)view {
    [self.responderViews removeObject:view];
}

- (void)setFocusToPreviousView {
    NSInteger index = [self.responderViews indexOfObject:self.activeView];
	index -= 1;
    UIResponder *nextView = [self viewResponderByIndex:index];
	if (nextView) {
		[nextView becomeFirstResponder];
	} else {
		[self.activeView resignFirstResponder];
	}
}

- (void)setFocusToNextView {
    NSInteger index = [self.responderViews indexOfObject:self.activeView];
	index += 1;
    UIResponder *nextView = [self viewResponderByIndex:index];
	if (nextView) {
		[nextView becomeFirstResponder];
	} else {
		[self.activeView resignFirstResponder];
	}
}

#pragma mark - Accessor methods

- (UIView *)activeView {
	for (UIView *view in self.responderViews) {
		if ([view isFirstResponder]) {
			return view;
		}
	}
	
	return nil;
}

- (NSArray *)views {
    return self.responderViews;
}

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;

	self.initialInsets = scrollView.contentInset;

    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(onKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(onKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods

- (UIResponder *)viewResponderByIndex:(NSInteger)index {
    if (index < 0  || index >= self.responderViews.count) {
        return nil;
    }
	
    return self.responderViews[index];
}

#pragma mark - Keyboard notification

- (void)onKeyboardWillChangeFrame:(NSNotification *)notification {
    
    CGRect keyboardFrame = ((NSValue *)notification.userInfo[UIKeyboardFrameEndUserInfoKey]).CGRectValue;
	CGRect keyboardFrameOnScreen = CGRectIntersection(keyboardFrame, [UIScreen mainScreen].bounds);
    CGFloat keyboardHeight = CGRectGetHeight(keyboardFrameOnScreen);
    
    UIEdgeInsets contentInsets = (UIEdgeInsets) {
		.top = self.initialInsets.top,
		.left = self.initialInsets.left,
		.bottom = MAX(keyboardHeight, self.initialInsets.bottom),
		.right = self.initialInsets.right};
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
	
	if ([self.activeView isKindOfClass:[UIView class]]) {
		UIView *activeView = (UIView *)self.activeView;
		CGRect aRect = self.scrollView.frame;
		aRect.size.height -= keyboardHeight;
		if (!CGRectContainsPoint(aRect, activeView.frame.origin) ) {
			[self.scrollView scrollRectToVisible:activeView.frame animated:YES];
		}
	}
}

- (void)onKeyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInsets = self.initialInsets;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}
@end
