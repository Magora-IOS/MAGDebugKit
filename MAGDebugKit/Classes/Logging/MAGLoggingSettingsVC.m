#import "MAGLoggingSettingsVC.h"
#import "MAGDebugPanelSettingsKeys.h"
#import "MAGLogging.h"

#import <Bohr/BOTableViewCell+Subclass.h>
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface MAGLoggingSettingsVC ()

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
			[self setupFileLoggingItemInSection:section];
			[self setupConsoleLoggingItemInSection:section];
		}]];

	[self addSection:[BOTableViewSection sectionWithHeaderTitle:nil
		handler:^(BOTableViewSection *section) {
			[self setupAntennaLoggingItemInSection:section];
			[self setupAntennaLoggingHostItemInSection:section];
			[self setupAntennaLoggingPortItemInSection:section];
			[self setupAntennaLoggingReconnectButtonCellInSection:section];
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
	[section addCell:[BOSwitchTableViewCell cellWithTitle:@"Antenna"
		key:MAGDebugPanelSettingKeyAntennaLoggingEnabled
		handler:^(BOSwitchTableViewCell *cell) {
				[RACObserve(cell, setting.value) subscribeNext:^(NSNumber *enabled) {
					[[MAGLogging sharedInstance] setAntennaLoggingEnabled:enabled.boolValue];
				}];
			}]];
}

- (void)setupAntennaLoggingHostItemInSection:(BOTableViewSection *)section {
	[section addCell:[BOTextTableViewCell cellWithTitle:@"Host"
		key:MAGDebugPanelSettingKeyAntennaLoggingHost
		handler:^(BOTextTableViewCell *cell) {
				cell.textField.keyboardType = UIKeyboardTypeURL;
				cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
				cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
				cell.textField.spellCheckingType = UITextSpellCheckingTypeNo;
			
				[RACObserve(cell, setting.value) subscribeNext:^(NSString *text) {
					[[MAGLogging sharedInstance] setAntennaLoggingHost:text];
				}];
			}]];
}

- (void)setupAntennaLoggingPortItemInSection:(BOTableViewSection *)section {
	[section addCell:[BOTextTableViewCell cellWithTitle:@"Port"
		key:MAGDebugPanelSettingKeyAntennaLoggingPort
		handler:^(BOTextTableViewCell *cell) {
				cell.textField.keyboardType = UIKeyboardTypeNumberPad;
				cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
				cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
				cell.textField.spellCheckingType = UITextSpellCheckingTypeNo;
			
				[RACObserve(cell, setting.value) subscribeNext:^(NSString *text) {
					[[MAGLogging sharedInstance] setAntennaLoggingPort:@(text.integerValue)];
				}];
			}]];
}


- (void)setupAntennaLoggingReconnectButtonCellInSection:(BOTableViewSection *)section {
	[section addCell:[BOButtonTableViewCell cellWithTitle:@"Reconnect"
		key:MAGDebugPanelSettingKeyAntennaLoggingReconnect handler:^(BOButtonTableViewCell *cell) {
			cell.actionBlock = ^{
					if ([MAGLogging sharedInstance].antennaLoggingEnabled) {
						[[MAGLogging sharedInstance] setAntennaLoggingEnabled:NO];
						[[MAGLogging sharedInstance] setAntennaLoggingEnabled:YES];
					}
				};
		}]];
}

@end
