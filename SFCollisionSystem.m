#import "SFCollisionSystem.h"
#import "SFCollisionComponent.h"
#import "SFEntity.h"
#import "SFEntityManager.h"
#import "SFBoundingBoxComponent.h"
#import "SFRenderComponent.h"
#import "SFTagComponent.h"
#import "SFHealthComponent.h"
#import "SFCollisionDamageComponent.h"


@implementation SFCollisionSystem

- (void)update:(CCTime)delta
{
    NSArray *entities = [self.entityManager allEntitiesPosessingComponentOfClass:[SFCollisionComponent class]];
    NSMutableArray *entities2 = [entities mutableCopy];

    for (SFEntity *entityA in entities)
    {
        [entities2 removeObject:entityA];

        for (SFEntity *entityB in entities2)
        {
            if ([self detectCollision:entityA entityB:entityB])
            {
                [self applyDamageToEachOtherWithEntityA:entityA entityB:entityB];
            }
        }
    }
}

- (void)applyDamageToEachOtherWithEntityA:(SFEntity *)entityA entityB:(SFEntity *)entityB
{
    SFCollisionDamageComponent *damageComponentA = [self.entityManager componentOfClass:[SFCollisionDamageComponent class] forEntity:entityA];
    SFCollisionDamageComponent *damageComponentB = [self.entityManager componentOfClass:[SFCollisionDamageComponent class] forEntity:entityB];

    SFHealthComponent *healthComponentA = [self.entityManager componentOfClass:[SFHealthComponent class] forEntity:entityA];
    SFHealthComponent *healthComponentB = [self.entityManager componentOfClass:[SFHealthComponent class] forEntity:entityB];

    if (healthComponentA.isAlive
        && healthComponentB.isAlive
        && damageComponentA
        && healthComponentB)
    {
        healthComponentB.health -= damageComponentA.damage;
    }

    if (healthComponentA.isAlive
        && healthComponentB.isAlive
        && damageComponentB
        && healthComponentA)
    {
        healthComponentA.health -= damageComponentB.damage;
    }
}

- (BOOL)detectCollision:(SFEntity *)entityA entityB:(SFEntity *)entityB
{
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
