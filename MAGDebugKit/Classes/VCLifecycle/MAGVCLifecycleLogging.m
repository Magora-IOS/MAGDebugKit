#import "MAGVCLifecycleLogging.h"
#import "MAGSwizzling.h"
#import <objc/runtime.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <MAGDebugKit/MAGLogging.h>



@interface UIViewController (MAGVCLifecycleLogging)
@end

@implementation UIViewController (MAGVCLifecycleLogging)

- (instancetype)mag_initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
	DDLogDebug(@"init: %@", self);
	return [self mag_initWithNibName:nibName bundle:bundle];
}

- (instancetype)mag_initWithCoder:(NSCoder *)aDecoder {
	DDLogDebug(@"init: %@", self);
	return [self mag_initWithCoder:aDecoder];
}

- (void)mag_dealloc {
	DDLogDebug(@"dealloc: %@", self);
	[self mag_dealloc];
}

+ (BOOL)mag_initAndDeallocSwizzled {
	return NO;
}

+ (BOOL)mag_initAndDeallocNotSwizzled {
	return YES;
}

@end


@implementation MAGVCLifecycleLogging

+ (void)enableInitDeallocLogging {
	if ([UIViewController mag_initAndDeallocNotSwizzled]) {
		[self swizzleInitAndDealloc];
	}
}

+ (void)disableInitDeallocLogging {
	if ([UIViewController mag_initAndDeallocSwizzled]) {
		[self swizzleInitAndDealloc];
	}
}

+ (void)swizzleInitAndDealloc {
	mag_swizzle([UIViewController class],
		@selector(initWithNibName:bundle:), @selector(mag_initWithNibName:bundle:));
	
	mag_swizzle([UIViewController class],
		@selector(initWithCoder:), @selector(mag_initWithCoder:));
	
	mag_swizzle([UIViewController class],
		NSSelectorFromString(@"dealloc"), @selector(mag_dealloc));

	Class vcMetaClass = objc_getMetaClass("UIViewController");
	mag_swizzle(vcMetaClass,
		@selector(mag_initAndDeallocSwizzled), @selector(mag_initAndDeallocNotSwizzled));
}

@end
