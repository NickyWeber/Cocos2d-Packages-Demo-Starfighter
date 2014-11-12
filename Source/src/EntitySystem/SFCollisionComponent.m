#import "SFCollisionComponent.h"


@implementation SFCollisionComponent

- (id)init
{
    return [self initWithDespawnAfterCollision:NO];
}

- (instancetype)initWithDespawnAfterCollision:(BOOL)despawnAfterCollision
{
    self = [super init];
    if (self)
    {
        self.despawnAfterCollision = despawnAfterCollision;
    }

    return self;
}

@end
