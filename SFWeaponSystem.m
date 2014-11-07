#import "SFWeaponSystem.h"
#import "SFEntity.h"
#import "SFWeaponComponent.h"
#import "SFEntityManager.h"
#import "SFGamePlaySceneDelegate.h"
#import "SFEntityFactory.h"
#import "SFRenderComponent.h"
#import "SFHealthComponent.h"

@implementation SFWeaponSystem

- (void)update:(CCTime)delta
{
    NSArray *entities = [self.entityManager allEntitiesPosessingComponentOfClass:[SFWeaponComponent class]];
    for (SFEntity *entity in entities)
    {
        SFHealthComponent *healthComponent = [self.entityManager componentOfClass:[SFHealthComponent class] forEntity:entity];
        SFWeaponComponent *weaponComponent = [self.entityManager componentOfClass:[SFWeaponComponent class] forEntity:entity];

        if (!healthComponent.isAlive)
        {
            continue;
        }

        if (weaponComponent.enemyWeapon)
        {
            [self fireWeaponsOfEntity:entity delta:delta];
        }
        else
        {
            [self fireSpaceshipWeapon:entity delta:delta];
        }
    }
}

- (void)fireSpaceshipWeapon:(SFEntity *)spaceship delta:(CCTime)delta
{
    SFWeaponComponent *weaponComponent = [self.entityManager componentOfClass:[SFWeaponComponent class] forEntity:spaceship];

    if (weaponComponent
        && [self.delegate firing]
        && weaponComponent.timeSinceLastShot >= (1.0 / weaponComponent.fireRate))
    {
        weaponComponent.timeSinceLastShot = 0.0;

        SFRenderComponent *renderComponent = [self.entityManager componentOfClass:[SFRenderComponent class] forEntity:spaceship];
        CGPoint position = renderComponent.node.position;

        [[SFEntityFactory sharedFactory] addLaserBeamWithWeaponComponent:weaponComponent atPosition:ccp(position.x - 16, position.y + 30)];
        [[SFEntityFactory sharedFactory] addLaserBeamWithWeaponComponent:weaponComponent atPosition:ccp(position.x + 16, position.y + 30)];
    }

    weaponComponent.timeSinceLastShot += delta;
}

- (void)fireWeaponsOfEntity:(SFEntity *)entity delta:(CCTime)delta
{
    SFWeaponComponent *weaponComponent = [self.entityManager componentOfClass:[SFWeaponComponent class] forEntity:entity];

	if (weaponComponent.timeSinceLastShot >= (1.0 / weaponComponent.fireRate))
	{
        weaponComponent.timeSinceLastShot = 0.0;

        SFRenderComponent *renderComponent = [self.entityManager componentOfClass:[SFRenderComponent class] forEntity:entity];
        [[SFEntityFactory sharedFactory] addEnemyShotWithWeaponComponent:weaponComponent atPosition:renderComponent.node.position];
	}

    // [self fireAtPlayer];
    weaponComponent.timeSinceLastShot += delta;
}

@end
