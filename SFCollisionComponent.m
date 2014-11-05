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
        self.collisionExceptionTags = [NSMutableSet set];
    }

    return self;
}

@end
