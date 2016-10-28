#import "MAGMenuAction.h"
#import "MAGCommonDefines.h"


@implementation MAGMenuActionBlock

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize enabled = _enabled;

#pragma mark - Public methods

- (void)perform {
	RUN_BLOCK(self.block);
}

@end
