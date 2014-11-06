#import "SFMoveSystem.h"
#import "SFMoveComponent.h"
#import "SFEntity.h"
#import "SFEntityManager.h"
#import "SFRenderComponent.h"
#import "SFTagComponent.h"
#import "SFGamePlaySceneDelegate.h"

@implementation SFMoveSystem

- (void)update:(CCTime)delta
{
    CGSize displaySize = [CCDirector sharedDirector].view.frame.size;

    NSArray * entities = [self.entityManager allEntitiesPosessingComponentOfClass:[SFMoveComponent class]];
    for (SFEntity *entity in entities)
    {
        SFMoveComponent *moveComponent = [self.entityManager componentOfClass:[SFMoveComponent class] forEntity:entity];
        SFRenderComponent *renderComponent = [self.entityManager componentOfClass:[SFRenderComponent class] forEntity:entity];
        SFTagComponent *tagComponent = [self.entityManager componentOfClass:[SFTagComponent class] forEntity:entity];

        if ([tagComponent hasTag:@"Spaceship"])
        {
        	CGPoint scaledVelocity = ccpMult(self.delegate.dPadVelocity, moveComponent.spaceshipSpeed);

        	CGPoint newPosition = CGPointMake(MAX(0, MIN(renderComponent.node.position.x + scaledVelocity.x * delta, displaySize.width)),
        			                          MAX(0, MIN(renderComponent.node.position.y + scaledVelocity.y * delta, displaySize.height)));

            renderComponent.node.position = newPosition;
        }
        else
        {
            CGPoint newPosition = ccpAdd(renderComponent.node.position, ccpMult(moveComponent.velocity, delta));
            renderComponent.node.position = newPosition;

            [self despawnEntityIfOutOfBounds:entity];
        }
    }
}

- (void)despawnEntityIfOutOfBounds:(SFEntity *)entity
{
    SFRenderComponent *renderComponent = [self.entityManager componentOfClass:[SFRenderComponent class] forEntity:entity];

    CGSize screenSize = [CCDirector sharedDirector].view.frame.size;

    if (renderComponent.node.position.x <= -100
        || renderComponent.node.position.x >= screenSize.width + 100
        || renderComponent.node.position.y <= -100
        || renderComponent.node.position.y >= screenSize.height + 100)
    {
        [self.entityManager removeEntity:entity];
        [renderComponent.node removeFromParentAndCleanup:YES];
    }
}

@end