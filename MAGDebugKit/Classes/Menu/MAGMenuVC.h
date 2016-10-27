#import <UIKit/UIKit.h>


@interface MAGMenuVC : UIViewController

- (void)addAction:(void(^)(void))action withTitle:(NSString *)actionTitle;
- (void)addAction:(void(^)(void))action withTitle:(NSString *)actionTitle description:(NSString *)description;
- (void)addSubscreen:(UIViewController *)subscreen withTitle:(NSString *)actionTitle;
- (void)addSubscreen:(UIViewController *)subscreen withTitle:(NSString *)actionTitle description:(NSString *)description;

@end
