#import "MAGJSONLogFormatter.h"


@interface MAGJSONLogFormatter ()

@property (nonatomic) NSMutableDictionary <NSString *, id> *permanentFields;

@end


@implementation MAGJSONLogFormatter

- (instancetype)init {
	self = [super init];
	if (!self) {
		return nil;
	}
	
	_permanentFields = [[NSMutableDictionary alloc] init];
	
	return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
	NSMutableDictionary *map = [[NSMutableDictionary alloc] initWithDictionary:@{
			@"date": @(logMessage->_timestamp.timeIntervalSince1970),
			@"message": logMessage->_message,
			@"source": [NSString stringWithFormat:@"%@:%@ %@",
				logMessage->_fileName, @(logMessage->_line), logMessage->_function],
			@"context": @(logMessage->_context),
			@"level": levelString(logMessage->_level),
		}];
	
	[map addEntriesFromDictionary:self.permanentFields];
	
	NSData *data = [NSJSONSerialization dataWithJSONObject:map options:0 error:nil];
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	string = [string stringByAppendingString:@"\n"];
	
    return string;
}

- (void)setPermanentLogValue:(id)value field:(NSString *)field {
	self.permanentFields[field] = value;
}


static NSString *levelString(DDLogLevel level) {
	static NSDictionary *levels = nil;
	if (!levels) {
		levels = @{
				@(DDLogLevelError): @"Error",
				@(DDLogLevelWarning): @"Warning",
				@(DDLogLevelInfo): @"Info",
				@(DDLogLevelDebug): @"Debug",
				@(DDLogLevelVerbose): @"Verbose",
			};
	}
	
	NSString *string;
	
	if (level & DDLogFlagError) {
		string = levels[@(DDLogFlagError)];
	} else if (level & DDLogFlagWarning) {
		string = levels[@(DDLogFlagWarning)];
	} else if (level & DDLogFlagInfo) {
		string = levels[@(DDLogFlagInfo)];
	} else if (level & DDLogFlagDebug) {
		string = levels[@(DDLogFlagDebug)];
	} else if (level & DDLogFlagVerbose) {
		string = levels[@(DDLogFlagVerbose)];
	} else {
		string = @"";
	}
	
	return string;
}

@end
