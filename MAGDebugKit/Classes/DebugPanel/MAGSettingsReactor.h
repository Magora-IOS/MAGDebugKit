#import <Foundation/Foundation.h>


@protocol MAGSettingsReactor <NSObject>

@property (nonatomic, readonly) NSDictionary <NSString *, void (^)(id)> *reactions;

- (void)setReaction:(void(^)(id value))reaction forKey:(NSString *)key defaultValue:(id)defaultValue;

- (void)setSetting:(id)value forKey:(NSString *)key;
- (id)settingForKey:(NSString *)key;

@end
