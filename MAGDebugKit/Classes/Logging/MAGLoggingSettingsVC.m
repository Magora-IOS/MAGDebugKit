#import "MAGLoggingSettingsVC.h"
#import "MAGDebugPanelSettingsKeys.h"
#import "MAGLogging.h"

#import <Bohr/BOTableViewCell+Subclass.h>
#import <ReactiveObjC/ReactiveObjC.h>


typedef NS_ENUM(NSUInteger, MAGLoggingLevel) {
	MAGLoggingLevelUndefined = 0,
	MAGLoggingLevelOff,
	MAGLoggingLevelError,
	MAGLoggingLevelWarning,
	MAGLoggingLevelInfo,
	MAGLoggingLevelDebug,
	MAGLoggingLevelVerbose,
	MAGLoggingLevelAll
};

@interface MAGLoggingSettingsVC ()

@property (nonatomic) BOTextTableViewCell *hostCell;
@property (nonatomic) BOTextTableViewCell *portCell;

@end


@implementation MAGLoggingSettingsVC

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Logging";
	[self setupMenuActions];

}

#pragma mark - Private methods

- (void)setupMenuActions {
	[self addSection:[BOTableViewSection sectionWithHeaderTitle:nil
		handler:^(BOTableViewSection *section) {
			[self setupVerbosityLevelInSection:section];
		}]];

	[self addSection:[BOTableViewSection sectionWithHeaderTitle:nil
		handler:^(BOTableViewSection *section) {
			[self setupFileLoggingItemInSection:section];
			[self setupConsoleLoggingItemInSection:section];
		}]];

	[self addSection:[BOTableViewSection sectionWithHeaderTitle:nil
		handler:^(BOTableViewSection *section) {
			[self setupAntennaLoggingItemInSection:section];
			[self setupAntennaLoggingHostItemInSection:section];
			[self setupAntennaLoggingPortItemInSection:section];
		}]];
}

- (void)setupFileLoggingItemInSection:(BOTableViewSection *)section {
	[section addCell:[BOSwitchTableViewCell cellWithTitle:@"File"
		key:MAGDebugPanelSettingKeyFileLoggingEnabled
		handler:^(BOSwitchTableViewCell *cell) {
				[RACObserve(cell, setting.value) subscribeNext:^(NSNumber *enabled) {
					[[MAGLogging sharedInstance] setFileLoggingEnabled:enabled.boolValue];
				}];
			}]];
}

- (void)setupVerbosityLevelInSection:(BOTableViewSection *)section {
	BOSetting *setting = [BOSetting settingWithKey:MAGDebugPanelSettingKeyLoggingVerbosity];
	NSNumber *savedValue = setting.value;
	if (!savedValue) {
		setting.value = @(loggingLevelForDDLogLevel([MAGLogging sharedInstance].logLevel) - MAGLoggingLevelOff);
	}

	[section addCell:[BOChoiceTableViewCell cellWithTitle:@"Log level"
		key:MAGDebugPanelSettingKeyLoggingVerbosity handler:^(BOChoiceTableViewCell *cell) {
			NSMutableArray *levels = [[NSMutableArray alloc] init];
			for (MAGLoggingLevel level = MAGLoggingLevelOff; level <= MAGLoggingLevelAll; ++level) {
				[levels addObject:titleForLoggingLevel(level)];
			}
			cell.options = levels;
			
			[[RACObserve(cell, setting.value) filter:^BOOL(NSNumber *level) {
				return level != nil;
			}] subscribeNext:^(NSNumber *level) {
				[[MAGLogging sharedInstance] setLogLevel:
					ddLogLevelForLoggingLevel([level unsignedIntegerValue] + MAGLoggingLevelOff)];
			}];

		}]];
}

- (void)setupConsoleLoggingItemInSection:(BOTableViewSection *)section {
	[section addCell:[BOSwitchTableViewCell cellWithTitle:@"Console"
		key:MAGDebugPanelSettingKeyConsoleLoggingEnabled
		handler:^(BOSwitchTableViewCell *cell) {
				[RACObserve(cell, setting.value) subscribeNext:^(NSNumber *enabled) {
					[[MAGLogging sharedInstance] setConsoleLoggingEnabled:enabled.boolValue];
				}];
			}]];
}

- (void)setupAntennaLoggingItemInSection:(BOTableViewSection *)section {
	[section addCell:[BOSwitchTableViewCell cellWithTitle:@"Remote"
		key:MAGDebugPanelSettingKeyAntennaLoggingEnabled
		handler:^(BOSwitchTableViewCell *cell) {
				[RACObserve(cell, setting.value) subscribeNext:^(NSNumber *enabled) {
					self.hostCell.textField.enabled = !enabled.boolValue;
					self.portCell.textField.enabled = !enabled.boolValue;
				
					NSString *host = [BOSetting settingWithKey:MAGDebugPanelSettingKeyAntennaLoggingHost].value;
					[[MAGLogging sharedInstance] setRemoteLoggingHost:host];
					
					NSString *port = [BOSetting settingWithKey:MAGDebugPanelSettingKeyAntennaLoggingPort].value;
					[[MAGLogging sharedInstance] setRemoteLoggingPort:@(port.integerValue)];
					
					[[MAGLogging sharedInstance] setRemoteLoggingEnabled:enabled.boolValue];
				}];
			}]];
}

- (void)setupAntennaLoggingHostItemInSection:(BOTableViewSection *)section {
	self.hostCell = [BOTextTableViewCell cellWithTitle:@"Host"
		key:MAGDebugPanelSettingKeyAntennaLoggingHost
		handler:^(BOTextTableViewCell *cell) {
				cell.textField.keyboardType = UIKeyboardTypeURL;
				cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
				cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
				cell.textField.spellCheckingType = UITextSpellCheckingTypeNo;
				cell.textField.enabled = ![[BOSetting settingWithKey:MAGDebugPanelSettingKeyAntennaLoggingEnabled].value boolValue];
			
				[RACObserve(cell, setting.value) subscribeNext:^(NSString *text) {
					[[MAGLogging sharedInstance] setRemoteLoggingHost:text];
				}];
			}];
	[section addCell:self.hostCell];
}

- (void)setupAntennaLoggingPortItemInSection:(BOTableViewSection *)section {
	self.portCell = [BOTextTableViewCell cellWithTitle:@"Port"
		key:MAGDebugPanelSettingKeyAntennaLoggingPort
		handler:^(BOTextTableViewCell *cell) {
				cell.textField.keyboardType = UIKeyboardTypeNumberPad;
				cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
				cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
				cell.textField.spellCheckingType = UITextSpellCheckingTypeNo;
				cell.textField.enabled = ![[BOSetting settingWithKey:MAGDebugPanelSettingKeyAntennaLoggingEnabled].value boolValue];
			
				[RACObserve(cell, setting.value) subscribeNext:^(NSString *text) {
					[[MAGLogging sharedInstance] setRemoteLoggingPort:@(text.integerValue)];
				}];
			}];

	[section addCell:self.portCell];
}

NSString *titleForLoggingLevel(MAGLoggingLevel level) {
	static NSDictionary *levels = nil;
	if (!levels) {
		levels = @{
			@(MAGLoggingLevelOff) : @"Off",
			@(MAGLoggingLevelError) : @"Error",
			@(MAGLoggingLevelWarning) : @"Warning",
			@(MAGLoggingLevelInfo) : @"Info",
			@(MAGLoggingLevelDebug) : @"Debug",
			@(MAGLoggingLevelVerbose) : @"Verbose",
			@(MAGLoggingLevelAll) : @"All"
		};
	}
	
	return levels[@(level)];
}

DDLogLevel ddLogLevelForLoggingLevel(MAGLoggingLevel level) {
	static NSDictionary *levels = nil;
	if (!levels) {
		levels = @{
			@(MAGLoggingLevelOff) : @(DDLogLevelOff),
			@(MAGLoggingLevelError) : @(DDLogLevelError),
			@(MAGLoggingLevelWarning) : @(DDLogLevelWarning),
			@(MAGLoggingLevelInfo) : @(DDLogLevelInfo),
			@(MAGLoggingLevelDebug) : @(DDLogLevelDebug),
			@(MAGLoggingLevelVerbose) : @(DDLogLevelVerbose),
			@(MAGLoggingLevelAll) : @(DDLogLevelAll)
		};
	}
	
	return [levels[@(level)] unsignedIntegerValue];
}

MAGLoggingLevel loggingLevelForDDLogLevel(DDLogLevel level) {
	static NSDictionary *levels = nil;
	if (!levels) {
		levels = @{
			@(DDLogLevelOff): @(MAGLoggingLevelOff),
			@(DDLogLevelError): @(MAGLoggingLevelError),
			@(DDLogLevelWarning): @(MAGLoggingLevelWarning),
			@(DDLogLevelInfo):@(MAGLoggingLevelInfo),
			@(DDLogLevelDebug): @(MAGLoggingLevelDebug),
			@(DDLogLevelVerbose): @(MAGLoggingLevelVerbose),
			@(DDLogLevelAll): @(MAGLoggingLevelAll)
		};
	}
	
	return [levels[@(level)] unsignedIntegerValue];
}

@end
