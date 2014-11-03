#import <Foundation/Foundation.h>
#import "SFKeyEventHandlingDelegate.h"

@interface KeyEventHandler : NSObject <SFKeyEventHandlingDelegate>

@property (nonatomic) CGPoint velocity;
@property (nonatomic) BOOL firing;

@end