#import <UIKit/UIKit.h>


@protocol MAGMenuAction;


@interface MAGMenuVC : UITableViewController

- (void)addAction:(id<MAGMenuAction>)action;
- (id<MAGMenuAction>)addBlockAction:(void(^)(void))actionBlock withTitle:(NSString *)actionTitle;
- (id<MAGMenuAction>)addSubscreen:(UIViewController *)subscreen withTitle:(NSString *)actionTitle;

@end
