
#import <Foundation/Foundation.h>

@interface RCTapDetector : NSObject

@property (copy, nonatomic) dispatch_block_t didTappedBlock;
@property (readonly, strong, nonatomic) UITapGestureRecognizer *recognizer;

- (void)attachToTargetView:(UIView *)targetView;

@end
