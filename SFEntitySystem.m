#import "SFEntitySystem.h"
#import "SFEntityManager.h"


@implementation SFEntitySystem

- (instancetype)initWithEntityManager:(SFEntityManager *)entityManager
{
    self = [super init];
    if (self)
    {
        self.entityManager = entityManager;
    }

    return self;
}

- (void)update:(CCTime)delta
{

}

@end
