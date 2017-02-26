#import <UIKit/UIKit.h>


@interface MAGSandboxBrowserVC : UITableViewController

@property (nonatomic, readonly) NSURL *url;

- (instancetype)initWithURL:(NSURL *)url NS_DESIGNATED_INITIALIZER;

@end
