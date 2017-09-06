#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface MAGDebugPanelRespondersManager : NSObject

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIEdgeInsets initialInsets;
@property (nonatomic, readonly) UIResponder *activeView;
@property (nonatomic, readonly) NSArray *views;

- (instancetype)initWithViews:(NSArray <UIResponder *> *)views;

- (void)addViews:(NSArray <UIResponder *> *)views;
- (void)insertViews:(NSArray <UIResponder *> *)views atIndexes:(NSIndexSet *)indexes;
- (void)removeView:(UIResponder *)view;

- (void)setFocusToPreviousView;
- (void)setFocusToNextView;

@end
