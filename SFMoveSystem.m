#import "SFMoveSystem.h"
#import "SFMoveComponent.h"
#import "SFEntity.h"
#import "SFEntityManager.h"
#import "SFRenderComponent.h"


@implementation SFMoveSystem

- (void)update:(CCTime)delta
{
    NSArray * entities = [self.entityManager allEntitiesPosessingComponentOfClass:[SFMoveComponent class]];
    for (SFEntity *entity in entities)
    {
        SFMoveComponent *moveComponent = [self.entityManager componentOfClass:[SFMoveComponent class] forEntity:entity];
        SFRenderComponent *renderComponent = [self.entityManager componentOfClass:[SFRenderComponent class] forEntity:entity];

        CGPoint newPosition = ccpAdd(renderComponent.node.position, ccpMult(moveComponent.velocity, delta));
        renderComponent.node.position = newPosition;
    }
}

@end