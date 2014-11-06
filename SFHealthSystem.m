#import "SFHealthSystem.h"
#import "SFHealthComponent.h"
#import "SFEntityManager.h"
#import "SFRenderComponent.h"
#import "CCAnimationCache.h"
#import "SFLootComponent.h"
#import "SFGamePlaySceneDelegate.h"
#import "SFEntityFactory.h"
#import "SFCollisionComponent.h"
#import "SFRewardComponent.h"

@implementation SFHealthSystem

- (void)update:(CCTime)delta
{
    NSArray * entities = [self.entityManager allEntitiesPosessingComponentOfClass:[SFHealthComponent class]];
    for (SFEntity *entity in entities)
    {
        SFHealthComponent *healthComponent = [self.entityManager componentOfClass:[SFHealthComponent class] forEntity:entity];

        if (!healthComponent.isAlive
            || healthComponent.healthMax == 0)
        {
            return;
        }

        if (healthComponent.health <= 0)
        {
            healthComponent.isAlive = NO;

            [self dropLootOfEntity:entity];

            [self rewardOfEntity:entity];

            [self explodeEntity:entity];
        }
    }
}

- (void)rewardOfEntity:(SFEntity *)entity
{
    SFRewardComponent *rewardComponent = [self.entityManager componentOfClass:[SFRewardComponent class] forEntity:entity];

    if (rewardComponent)
    {
        [self.delegate addPoints:rewardComponent.points];
    }
}

- (void)dropLootOfEntity:(SFEntity *)entity
{
    SFRenderComponent *renderComponent = [self.entityManager componentOfClass:[SFRenderComponent class] forEntity:entity];
    SFLootComponent *lootComponent = [self.entityManager componentOfClass:[SFLootComponent class] forEntity:entity];

    if (lootComponent)
    {
        [[SFEntityFactory sharedFactory] addLoot:lootComponent atPosition:renderComponent.node.position];
    }
}

- (void)explodeEntity:(SFEntity *)entity
{
    [self.entityManager removeComponent:[SFCollisionComponent class] fromEntity:entity];

    SFRenderComponent *renderComponent = [self.entityManager componentOfClass:[SFRenderComponent class] forEntity:entity];
    [renderComponent.node stopAllActions];

    CCActionAnimate *actionAnimate = [CCActionAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:@"Explosion"]];

    id sequence = [CCActionSequence actions:actionAnimate,
                                            [CCActionCallBlock actionWithBlock:^{
                                                [renderComponent.node removeFromParentAndCleanup:YES];
                                                [self.entityManager removeEntity:entity];
                                            }],
                                            nil];

    [renderComponent.node runAction:sequence];
}

@end