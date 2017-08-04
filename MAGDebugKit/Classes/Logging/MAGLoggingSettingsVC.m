#import "MAGLoggingSettingsVC.h"
#import "MAGDebugPanelSettingsKeys.h"
#import "MAGPanelPickerCell.h"
#import "MAGPanelPickerManager.h"
#import "MAGLogging.h"

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

//@property (nonatomic) BOTextTableViewCell *hostCell;
//@property (nonatomic) BOTextTableViewCell *portCell;

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
	
	[self setupLogLevelSection];
	[self setupLocalSection];
	[self setupRemoteSection];
}

- (void)setupLogLevelSection {
	[self addTitle:@"Log level"];

	NSArray *options = loggingLevelOptions();
	MAGPanelPickerManager *pickerManager = [self addPickerWithTitle:@"Verbosity"
		key:MAGDebugPanelSettingKeyLoggingVerbosity
		options:options optionRenderer:^NSString *(id value) {
			MAGLoggingLevel level = [value unsignedIntegerValue];
			return titleForLoggingLevel(level);
		} action:^(id value) {
			MAGLoggingLevel level = [value unsignedIntegerValue];
			[[MAGLogging sharedInstance] setLogLevel:ddLogLevelForLoggingLevel(level)];
		}];
	
	pickerManager.value = @(MAGLoggingLevelAll);
}

- (void)setupLocalSection {
	[self addTitle:@"Local"];
	
	[self addToggleWithTitle:@"File"
		key:MAGDebugPanelSettingKeyFileLoggingEnabled
		action:^(NSNumber *value) {
			[[MAGLogging sharedInstance] setFileLoggingEnabled:value.boolValue];
		}];
	
	[self addToggleWithTitle:@"TTY"
		key:MAGDebugPanelSettingKeyTTYLoggingEnabled
		action:^(NSNumber *value) {
			[[MAGLogging sharedInstance] setTtyLoggingEnabled:value.boolValue];
		}];
	
	[self addToggleWithTitle:@"ASL"
		key:MAGDebugPanelSettingKeyASLLoggingEnabled
		action:^(NSNumber *value) {
			[[MAGLogging sharedInstance] setAslLoggingEnabled:value.boolValue];
		}];
}

- (void)setupRemoteSection {
	[self addTitle:@"Remote"];
	
	[self addInputWithTitle:@"Host"
		key:MAGDebugPanelSettingKeyAntennaLoggingHost
		action:^(NSString *value) {
			[MAGLogging sharedInstance].remoteLoggingHost = value;
		}];
	
	[self addInputWithTitle:@"Port"
		key:MAGDebugPanelSettingKeyAntennaLoggingPort
		action:^(NSString *value) {
			[MAGLogging sharedInstance].remoteLoggingPort = @(value.integerValue);
		}];

	[self addToggleWithTitle:@"Enabled"
		key:MAGDebugPanelSettingKeyAntennaLoggingEnabled
		action:^(NSNumber *value) {
			[MAGLogging sharedInstance].remoteLoggingEnabled = value.boolValue;
		}];
}

//- (void)setupVerbosityLevelInSection:(BOTableViewSection *)section {
//	BOSetting *setting = [BOSetting settingWithKey:MAGDebugPanelSettingKeyLoggingVerbosity];
//	NSNumber *savedValue = setting.value;
//	if (!savedValue) {
//		setting.value = @(loggingLevelForDDLogLevel([MAGLogging sharedInstance].logLevel) - MAGLoggingLevelOff);
//	}
//
//	[section addCell:[BOChoiceTableViewCell cellWithTitle:@"Log level"
//		key:MAGDebugPanelSettingKeyLoggingVerbosity handler:^(BOChoiceTableViewCell *cell) {
//			NSMutableArray *levels = [[NSMutableArray alloc] init];
//			for (MAGLoggingLevel level = MAGLoggingLevelOff; level <= MAGLoggingLevelAll; ++level) {
//				[levels addObject:titleForLoggingLevel(level)];
//			}
//			cell.options = levels;
//			
//			[[RACObserve(cell, setting.value) filter:^BOOL(NSNumber *level) {
//				return level != nil;
//			}] subscribeNext:^(NSNumber *level) {
//				[[MAGLogging sharedInstance] setLogLevel:
//					ddLogLevelForLoggingLevel([level unsignedIntegerValue] + MAGLoggingLevelOff)];
//			}];
//
//		}]];
//}

//- (void)setupAntennaLoggingHostItemInSection:(BOTableViewSection *)section {
//	self.hostCell = [BOTextTableViewCell cellWithTitle:@"Host"
//		key:MAGDebugPanelSettingKeyAntennaLoggingHost
//		handler:^(BOTextTableViewCell *cell) {
//				cell.textField.keyboardType = UIKeyboardTypeURL;
//				cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
//				cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//				cell.textField.spellCheckingType = UITextSpellCheckingTypeNo;
//				cell.textField.enabled = ![[BOSetting settingWithKey:MAGDebugPanelSettingKeyAntennaLoggingEnabled].value boolValue];
//				// Sync model with view using two-way binding.
//				MAGLogging *logging = [MAGLogging sharedInstance];
//				RACChannelTerminal *c1 = RACChannelTo(cell, setting.value);
//				RACChannelTerminal *c2 = RACChannelTo(logging, remoteLoggingHost);
//				[c1 subscribe:c2];
//				[c2 subscribe:c1];
//			}];
//	[section addCell:self.hostCell];
//}
//
//- (void)setupAntennaLoggingPortItemInSection:(BOTableViewSection *)section {
//	self.portCell = [BONumberTableViewCell cellWithTitle:@"Port"
//		key:MAGDebugPanelSettingKeyAntennaLoggingPort
//		handler:^(BOTextTableViewCell *cell) {
//				cell.textField.keyboardType = UIKeyboardTypeNumberPad;
//				cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
//				cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//				cell.textField.spellCheckingType = UITextSpellCheckingTypeNo;
//				cell.textField.enabled = ![[BOSetting settingWithKey:MAGDebugPanelSettingKeyAntennaLoggingEnabled].value boolValue];
//				// Sync model with view using two-way binding.
//				MAGLogging *logging = [MAGLogging sharedInstance];
//				RACChannelTerminal *c1 = RACChannelTo(cell, setting.value);
//				RACChannelTerminal *c2 = RACChannelTo(logging, remoteLoggingPort);
//				[c1 subscribe:c2];
//				[c2 subscribe:c1];
//			}];
//
//	[section addCell:self.portCell];
//}
//

NSArray *loggingLevelOptions() {
	return @[
		@(MAGLoggingLevelOff),
		@(MAGLoggingLevelError),
		@(MAGLoggingLevelWarning),
		@(MAGLoggingLevelInfo),
		@(MAGLoggingLevelDebug),
		@(MAGLoggingLevelVerbose),
		@(MAGLoggingLevelAll)
	];
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
