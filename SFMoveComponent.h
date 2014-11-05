#import <Foundation/Foundation.h>
#import "SFComponent.h"

@interface SFMoveComponent : SFComponent

@property (assign) CGPoint velocity;

- (instancetype)initWithVelocity:(CGPoint)velocity;

@end