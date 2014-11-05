#import "SFCollisionSystem.h"
#import "SFCollisionComponent.h"
#import "SFEntity.h"
#import "SFEntityManager.h"
#import "SFBoundingBoxComponent.h"
#import "SFRenderComponent.h"
#import "SFTagComponent.h"
#import "SFHealthComponent.h"
#import "SFCollisionDamageComponent.h"
#import "SFCollisionRewardComponent.h"
#import "SFGamePlaySceneDelegate.h"


@implementation SFCollisionSystem

- (void)update:(CCTime)delta
{
    NSArray *entities = [self.entityManager allEntitiesPosessingComponentOfClass:[SFCollisionComponent class]];
    NSMutableArray *entities2 = [entities mutableCopy];

    for (SFEntity *entityA in entities)
    {
        SFTagComponent *tagComponent = [self.entityManager componentOfClass:[SFTagComponent class] forEntity:entityA];

        [entities2 removeObject:entityA];

        for (SFEntity *entityB in entities2)
        {
            if ([self detectCollision:entityA entityB:entityB])
            {
                [self applyDamageOfEntity:entityA toEntity:entityB];
                [self applyDamageOfEntity:entityB toEntity:entityA];

                if ([tagComponent hasTag:@"Spaceship"])
                {
                    [self applyRewardEntity:entityB toSpaceship:entityA];
                }

                [self removeCollidedEntityIfApplicable:entityA];
                [self removeCollidedEntityIfApplicable:entityB];
            }
        }
    }
}

- (void)removeCollidedEntityIfApplicable:(SFEntity *)entity
{
    SFCollisionComponent *collisionComponent = [self.entityManager componentOfClass:[SFCollisionComponent class] forEntity:entity];
    if (collisionComponent.despawnAfterCollision)
    {
        SFRenderComponent *renderComponent = [self.entityManager componentOfClass:[SFRenderComponent class] forEntity:entity];
        [renderComponent.node removeFromParentAndCleanup:YES];

        [self.entityManager removeEntity:entity];
    }
}

- (void)applyRewardEntity:(SFEntity *)reward toSpaceship:(SFEntity *)spaceship
{
    SFCollisionRewardComponent *rewardComponent = [self.entityManager componentOfClass:[SFCollisionRewardComponent class] forEntity:reward];
    if (!rewardComponent)
    {
        return;
    }

    SFHealthComponent *healthComponent = [self.entityManager componentOfClass:[SFHealthComponent class] forEntity:spaceship];
    healthComponent.health += rewardComponent.health;

/*
    SFShieldComponent *shieldComponent = [self.entityManager componentOfClass:[SFShieldComponent class] forEntity:spaceship];
    shieldComponent.shield += rewardComponent.shield;
*/

    [self.delegate addPoints:rewardComponent.points];

    SFRenderComponent *renderComponent = [self.entityManager componentOfClass:[SFRenderComponent class] forEntity:reward];
    [renderComponent.node removeFromParentAndCleanup:YES];

    [self.entityManager removeEntity:reward];
}

- (void)applyDamageOfEntity:(SFEntity *)entityA toEntity:(SFEntity *)entityB
{
    SFCollisionDamageComponent *damageComponentA = [self.entityManager componentOfClass:[SFCollisionDamageComponent class] forEntity:entityA];
    SFHealthComponent *healthComponentA = [self.entityManager componentOfClass:[SFHealthComponent class] forEntity:entityA];
    SFHealthComponent *healthComponentB = [self.entityManager componentOfClass:[SFHealthComponent class] forEntity:entityB];

    if (healthComponentA
        && healthComponentA.isAlive
        && damageComponentA
        && healthComponentB)
    {
        healthComponentB.health -= damageComponentA.damage;
        return;
    }

    if (!healthComponentA
        && damageComponentA)
    {
        healthComponentB.health -= damageComponentA.damage;
        return;
    }
}

- (BOOL)detectCollision:(SFEntity *)entityA entityB:(SFEntity *)entityB
{
    if ([self entity:entityA cannotCollideWithEntity:entityB])
    {
        return NO;
    }
/*
    SFBoundingBoxComponent *boundingBoxComponentA = [self.entityManager componentOfClass:[SFBoundingBoxComponent class] forEntity:entityA];
    SFBoundingBoxComponent *boundingBoxComponentB = [self.entityManager componentOfClass:[SFBoundingBoxComponent class] forEntity:entityB];
*/

    SFRenderComponent *renderComponentA = [self.entityManager componentOfClass:[SFRenderComponent class] forEntity:entityA];
    SFRenderComponent *renderComponentB = [self.entityManager componentOfClass:[SFRenderComponent class] forEntity:entityB];

	// simple collision test, before we start looking through all the boundingboxes
    // Ther will be finder collision detection soon
    return [self detectTextureCollisionsOfRenderComponentA:renderComponentA andComponentB:renderComponentB];

}

- (BOOL)entity:(SFEntity *)entityA cannotCollideWithEntity:(SFEntity *)entityB
{
    SFCollisionComponent *collisionComponentA = [self.entityManager componentOfClass:[SFCollisionComponent class] forEntity:entityA];
    SFCollisionComponent *collisionComponentB = [self.entityManager componentOfClass:[SFCollisionComponent class] forEntity:entityB];

    SFTagComponent *tagComponentA = [self.entityManager componentOfClass:[SFTagComponent class] forEntity:entityA];
    SFTagComponent *tagComponentB = [self.entityManager componentOfClass:[SFTagComponent class] forEntity:entityB];

    for (NSString *tag in collisionComponentA.collisionExceptionTags)
    {
        if ([tagComponentB hasTag:tag])
        {
            return YES;
        }
    }

    for (NSString *tag in collisionComponentB.collisionExceptionTags)
    {
        if ([tagComponentA hasTag:tag])
        {
            return YES;
        }
    }

    return NO;
}

- (BOOL)detectTextureCollisionsOfRenderComponentA:(SFRenderComponent *)componentA andComponentB:(SFRenderComponent *)componentB
{
    if (!componentA
        || !componentB)
    {
        return NO;
    }

    return CGRectIntersectsRect([self absoluteTextureRect:componentA],
                                [self absoluteTextureRect:componentB]);
}

- (CGRect)absoluteTextureRect:(SFRenderComponent *)component
{
    return [self absoluteCollisionRectWithRenderComponent:component andBoundingRect:[(CCSprite *) component.node textureRect]];
}

- (CGRect)absoluteCollisionRectWithRenderComponent:(SFRenderComponent *)component andBoundingRect:(CGRect)rect
{
    CCSprite *sprite = (CCSprite *) component.node;

	CGRect tmp = CGRectMake(sprite.position.x + rect.origin.x - sprite.contentSize.width / 2.0,
                            sprite.position.y + rect.origin.y - sprite.contentSize.height / 2.0,
							rect.size.width,
							rect.size.height);

	return tmp;
}

@end
