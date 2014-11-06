#import "SFMoveComponent.h"

@implementation SFMoveComponent

- (instancetype)initWithVelocity:(CGPoint)velocity
{
    self = [super init];
    if (self)
    {
        self.velocity = velocity;
    }

    return self;
}

@end