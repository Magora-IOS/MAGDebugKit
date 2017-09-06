#import "MAGUDSettingsStorage.h"


@interface MAGUDSettingsStorage ()

@property (nonatomic) NSUserDefaults *ud;
@property (nonatomic) NSMutableDictionary <NSString *, void (^)(id)> *reactions;

@end


@implementation MAGUDSettingsStorage

#pragma mark - Lifecycle

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults {
	self = [self init];
	if (!self) {
		return nil;
	}
	
	_ud = userDefaults;
	_reactions = [[NSMutableDictionary alloc] init];

	return self;
}

#pragma mark - Public methods

- (void)setReaction:(void (^)(id))reaction forKey:(NSString *)key defaultValue:(id)defaultValue {
	self.reactions[key] = reaction;
	
	id storedValue = [self.ud valueForKey:key];
	if (storedValue) {
		reaction(storedValue);
	} else {
		[self.ud setObject:defaultValue forKey:key];
		reaction(defaultValue);
	}
}

- (void)setSetting:(id)value forKey:(NSString *)key {
	[self.ud setObject:value forKey:key];
	
	void(^reaction)(id) = self.reactions[key];
	if (reaction) {
		reaction(value);
	}
}

- (id)settingForKey:(NSString *)key {
	return [self.ud objectForKey:key];
}

@end
