#import <Foundation/Foundation.h>


@class MAGPanelSeparator;


@protocol MAGPanelCell <NSObject>

@property (nonatomic, weak) MAGPanelSeparator *separator;

@end
