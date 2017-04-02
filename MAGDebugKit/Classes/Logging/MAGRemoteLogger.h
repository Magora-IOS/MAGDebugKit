#import <CocoaLumberjack/CocoaLumberjack.h>


@interface MAGRemoteLogger : DDAbstractLogger

- (instancetype)initWithHost:(NSString *)host port:(NSUInteger)port;

@end
