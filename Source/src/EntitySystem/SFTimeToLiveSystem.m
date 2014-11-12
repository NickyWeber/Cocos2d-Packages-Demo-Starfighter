#import "SFTimeToLiveSystem.h"
#import "SFEntity.h"
#import "SFEntityManager.h"
#import "SFTimeToLiveComponent.h"
#import "SFRenderComponent.h"
#import "SFGamePlaySceneDelegate.h"

@implementation SFTimeToLiveSystem

- (void)update:(CCTime)delta
{
    NSArray *entities = [self.entityManager allEntitiesPosessingComponentOfClass:[SFTimeToLiveComponent class]];
    for (SFEntity *entity in entities)
    {
        SFTimeToLiveComponent *timeToLiveComponent = [self.entityManager componentOfClass:[SFTimeToLiveComponent class] forEntity:entity];

        timeToLiveComponent.timeSinceSpawning += delta;

        if (timeToLiveComponent.timeSinceSpawning >= timeToLiveComponent.timeToLive - timeToLiveComponent.fadeDuration
            && !timeToLiveComponent.fadingOut)
        {
            [self fadeoutEntity:entity];
        }
    }
}

- (void)fadeoutEntity:(SFEntity *)entity
{
    SFRenderComponent *renderComponent = [self.entityManager componentOfClass:[SFRenderComponent class] forEntity:entity];

    SFTimeToLiveComponent *timeToLiveComponent = [self.entityManager componentOfClass:[SFTimeToLiveComponent class] forEntity:entity];
    timeToLiveComponent.fadingOut = YES;

    if (timeToLiveComponent.fadeDuration > 0.0
        && renderComponent)
    {
        CCActionFadeOut *actionFadeOut = [[CCActionFadeOut alloc] initWithDuration:timeToLiveComponent.fadeDuration];

        id sequence = [CCActionSequence actions:actionFadeOut,
                                                [CCActionCallBlock actionWithBlock:^
                                                {
                                                    [renderComponent.node removeFromParentAndCleanup:YES];
                                                    [self.entityManager removeEntity:entity];
                                                }],
                                                nil];

        [renderComponent.node runAction:sequence];
    }
    else
    {
        [renderComponent.node removeFromParentAndCleanup:YES];
        [self.entityManager removeEntity:entity];
    }
}

@end