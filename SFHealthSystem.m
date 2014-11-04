#import "SFHealthSystem.h"
#import "SFHealthComponent.h"
#import "SFEntityManager.h"

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
        }
    }
}

@end