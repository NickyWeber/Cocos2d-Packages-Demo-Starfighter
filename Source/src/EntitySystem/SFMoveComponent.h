#import <Foundation/Foundation.h>
#import "SFComponent.h"

@interface SFMoveComponent : SFComponent

@property (assign) CGPoint velocity;

@property (nonatomic) CGFloat spaceshipSpeed;

- (instancetype)initWithVelocity:(CGPoint)velocity;

@end