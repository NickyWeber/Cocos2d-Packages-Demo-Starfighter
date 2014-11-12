#import <Foundation/Foundation.h>
#import "SFKeyEventHandlingDelegate.h"

@interface SFKeyEventHandler : NSObject <SFKeyEventHandlingDelegate>

@property (nonatomic) CGPoint velocity;
@property (nonatomic) BOOL firing;

@end