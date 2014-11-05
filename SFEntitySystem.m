#import "SFEntitySystem.h"
#import "SFEntityManager.h"
#import "SFGamePlaySceneDelegate.h"


@implementation SFEntitySystem


- (instancetype)initWithEntityManager:(SFEntityManager *)entityManager delegate:(id <SFGamePlaySceneDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.entityManager = entityManager;
        self.delegate = delegate;
    }

    return self;
}

- (void)update:(CCTime)delta
{
    NSAssert(NO, @"Override me!");
}

@end
