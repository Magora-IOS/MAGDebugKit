#import "MAGJSONLogFormatter.h"


@implementation MAGJSONLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
	NSDictionary *map = @{
			@"date": @(logMessage->_timestamp.timeIntervalSince1970),
			@"message": logMessage->_message,
			@"source": [NSString stringWithFormat:@"%@:%@ %@",
				logMessage->_fileName, @(logMessage->_line), logMessage->_function],
			@"context": @(logMessage->_context),
			@"level": @(logMessage->_level),
		};
	NSData *data = [NSJSONSerialization dataWithJSONObject:map options:0 error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


@end
