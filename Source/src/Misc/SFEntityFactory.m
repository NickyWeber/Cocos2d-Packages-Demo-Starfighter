#import "SFEntityFactory.h"
#import "SFGamePlaySceneDelegate.h"
#import "SFRenderComponent.h"
#import "SFHealthComponent.h"
#import "SFEntity.h"
#import "SFEntityManager.h"
#import "CCAnimation.h"
#import "SFConstants.h"
#import "CCAnimationCache.h"
#import "SFMoveComponent.h"
#import "SFLevelComponent.h"
#import "SFTagComponent.h"
#import "SFCollisionDamageComponent.h"
#import "SFLootComponent.h"
#import "SFWeaponComponent.h"
#import "SFCollisionComponent.h"
#import "SFLootComponent.h"
#import "SFPointLoot.h"
#import "SFShieldLoot.h"
#import "SFHealthLoot.h"
#import "SFCollisionRewardComponent.h"
#import "SFTimeToLiveSystem.h"
#import "SFTimeToLiveComponent.h"
#import "SFRewardComponent.h"
#import "SFWeaponComponent.h"
#import "SFGameObject+Trigonometry.h"

@implementation SFEntityFactory

+ (SFEntityFactory *)sharedFactory
{
    static SFEntityFactory *sharedFactory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        sharedFactory = [[self alloc] init];
    });
    return sharedFactory;
}

- (SFEntity *)addSpaceshipAtPosition:(CGPoint)position
{
    SFEntity *spaceship = [[SFEntityManager sharedManager] createEntity];
    spaceship.name = @"Spaceship";
    SFHealthComponent *healthComponent = [[SFHealthComponent alloc] initWithHealth:50 healthMax:100];
    healthComponent.shieldMax = 100;
    [[SFEntityManager sharedManager] addComponent:healthComponent toEntity:spaceship];

    SFMoveComponent *moveComponent = [[SFMoveComponent alloc] init];
    [_entityManager addComponent:moveComponent toEntity:spaceship];
    moveComponent.spaceshipSpeed = 200.0;

    SFTagComponent *tagComponent = [[SFTagComponent alloc] init];
    [tagComponent addTag:@"Spaceship"];
    [[SFEntityManager sharedManager] addComponent:tagComponent toEntity:spaceship];

    SFCollisionComponent *collisionComponent = [[SFCollisionComponent alloc] init];
    [[SFEntityManager sharedManager] addComponent:collisionComponent toEntity:spaceship];

    CCAnimation *hitAnimation = [CCAnimation animation];
    [hitAnimation addSpriteFrameWithFilename:@"Sprites/Spaceship/Spaceship_hit.png"];
    hitAnimation.restoreOriginalFrame = YES;
    hitAnimation.delayPerUnit = 0.5;

    CCActionAnimate *hitAnimationAction = [CCActionAnimate actionWithAnimation:hitAnimation];
    hitAnimationAction.duration = 5.0;

    collisionComponent.hitAnimationAction = hitAnimationAction;

    SFCollisionDamageComponent *collisionDamageComponent = [[SFCollisionDamageComponent alloc] initWithDamage:10000000];
    [[SFEntityManager sharedManager] addComponent:collisionDamageComponent toEntity:spaceship];

    SFRenderComponent *renderComponent = [[SFRenderComponent alloc] initWithSprite:[CCSprite spriteWithImageNamed:@"Sprites/Spaceship/Spaceship_1.png"]];
    [[SFEntityManager sharedManager] addComponent:renderComponent toEntity:spaceship];
    renderComponent.node.position = position;

    CCAnimation *spaceshipAnimation = [CCAnimation animation];

    spaceshipAnimation.restoreOriginalFrame = YES;
    spaceshipAnimation.delayPerUnit = (float) (TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER / 5.0);

    [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Spaceship/Spaceship_1.png"];
    [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Spaceship/Spaceship_2.png"];
    [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Spaceship/Spaceship_3.png"];
    [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Spaceship/Spaceship_2.png"];

    CCActionAnimate *spaceshipAnimationAction = [CCActionAnimate actionWithAnimation:spaceshipAnimation];

    [renderComponent.node runAction:[CCActionRepeatForever actionWithAction:spaceshipAnimationAction]];

    SFWeaponComponent *weaponComponent = [[SFWeaponComponent alloc] init];
    weaponComponent.fireRate = 2.5;
    weaponComponent.weaponType = 2;
    weaponComponent.timeSinceLastShot = 11111;
    weaponComponent.power = 10;
    weaponComponent.speed = 400;
    [[SFEntityManager sharedManager] addComponent:weaponComponent toEntity:spaceship];

    [_delegate addGameNode:renderComponent.node];

    return spaceship;
}

- (SFEntity *)addEnemyShotWithWeaponComponent:(SFWeaponComponent *)weaponComponent atPosition:(CGPoint)position
{
    //SFTagComponent

    NSArray *array = [_entityManager allEntitiesPosessingComponentOfClass:[SFTagComponent class]];

    for (SFEntity *entity in array)
    {
        SFTagComponent *tagComponent = [self.entityManager componentOfClass:[SFTagComponent  class] forEntity:entity];
        if ([tagComponent hasTag:@"Spaceship"])
        {
            SFRenderComponent *renderComponentSpaceship = [self.entityManager componentOfClass:[SFRenderComponent class] forEntity:entity];

            SFEntity *shot = [_entityManager createEntity];
            shot.name = @"Shot";

            CGPoint shotVector = [SFGameObject calcNormalizedShotVector:position andTargetPosition:renderComponentSpaceship.node.position];

            SFMoveComponent *moveComponent = [[SFMoveComponent alloc] initWithVelocity:ccpMult(shotVector, weaponComponent.speed)];
            [_entityManager addComponent:moveComponent toEntity:shot];

            SFRenderComponent *renderComponent = [[SFRenderComponent alloc] initWithSprite:[CCSprite spriteWithImageNamed:@"Sprites/Shots/EnemyShot_2.png"]];
            [_entityManager addComponent:renderComponent toEntity:shot];
            renderComponent.node.position = position;

            SFCollisionComponent *collisionComponent = [[SFCollisionComponent alloc] init];
            [[SFEntityManager sharedManager] addComponent:collisionComponent toEntity:shot];
            collisionComponent.collisionWhiteListTags = @[@"Spaceship"];
            collisionComponent.despawnAfterCollision = YES;

            CCAnimation *spaceshipAnimation = [CCAnimation animation];
            [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Shots/EnemyShot_1.png"];
            [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Shots/EnemyShot_2.png"];
            spaceshipAnimation.delayPerUnit = (float) (TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER / 2.0);

            CCActionAnimate *spaceshipAnimationAction = [CCActionAnimate actionWithAnimation:spaceshipAnimation];
            spaceshipAnimationAction.duration = 1.0 * TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER;
            spaceshipAnimation.restoreOriginalFrame = YES;
            [renderComponent.node runAction:[CCActionRepeatForever actionWithAction:spaceshipAnimationAction]];

            SFCollisionDamageComponent *collisionDamageComponent = [[SFCollisionDamageComponent alloc] initWithDamage:weaponComponent.power];
            [_entityManager addComponent:collisionDamageComponent toEntity:shot];

            [_delegate addGameNode:renderComponent.node];

            return shot;
        }
    }

    return nil;
}

- (SFEntity *)addEnemyAtPosition:(CGPoint)position
{
    SFEntity *entity = [_entityManager createEntity];
    entity.name = @"Enemy";
    [_entityManager addComponent:[[SFHealthComponent alloc] initWithHealth:50 healthMax:50] toEntity:entity];

    SFRenderComponent *renderComponent = [[SFRenderComponent alloc] initWithSprite:[CCSprite spriteWithImageNamed:@"Sprites/Enemy/Enemy_1.png"]];
    [_entityManager addComponent:renderComponent toEntity:entity];
    renderComponent.node.position = position;

    SFWeaponComponent *weaponComponent = [[SFWeaponComponent alloc] init];
    weaponComponent.enemyWeapon = YES;
    weaponComponent.fireRate = 0.75;
    weaponComponent.weaponType = 1;
    weaponComponent.timeSinceLastShot = 11110;
    weaponComponent.power = 10;
    weaponComponent.speed = 200;
    [_entityManager addComponent:weaponComponent toEntity:entity];

    SFMoveComponent *moveComponent = [[SFMoveComponent alloc] initWithVelocity:ccp(0.0, -100.0)];
    [_entityManager addComponent:moveComponent toEntity:entity];

    SFLevelComponent *levelComponent = [[SFLevelComponent alloc] initWithLevel:1];
    [_entityManager addComponent:levelComponent toEntity:entity];

    SFRewardComponent *rewardComponent = [[SFRewardComponent alloc] initWithPoints:100];
    [_entityManager addComponent:rewardComponent toEntity:entity];

    SFTagComponent *tagComponent = [[SFTagComponent alloc] init];
    [tagComponent addTag:@"Enemy"];
    [[SFEntityManager sharedManager] addComponent:tagComponent toEntity:entity];

    NSUInteger lootType = [self randomLootType];
    if (lootType > 0)
    {
        [_entityManager addComponent:[[SFLootComponent alloc] initWithDropType:lootType] toEntity:entity];
    }

    SFCollisionComponent *collisionComponent = [[SFCollisionComponent alloc] init];
    [[SFEntityManager sharedManager] addComponent:collisionComponent toEntity:entity];

    CCAnimation *hitAnimation = [CCAnimation animation];
    [hitAnimation addSpriteFrameWithFilename:@"Sprites/Enemy/Enemy_hit.png"];
    hitAnimation.delayPerUnit = 0.1;

    CCActionAnimate *hitAnimationAction = [CCActionAnimate actionWithAnimation:hitAnimation];
    hitAnimationAction.duration = 0.1 * TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER;
    hitAnimation.restoreOriginalFrame = YES;
    collisionComponent.hitAnimationAction = hitAnimationAction;


    SFCollisionDamageComponent *collisionDamageComponent = [[SFCollisionDamageComponent alloc] initWithDamage:50];
    [_entityManager addComponent:collisionDamageComponent toEntity:entity];

    [self setupEnemyAnimationWithRenderComponent:renderComponent];

    [_delegate addGameNode:renderComponent.node];

    return entity;
}

- (NSUInteger)randomLootType
{
    int rng = arc4random() % 1000 + 1;

    if (rng <= 1000)
    {
        return arc4random() % 3 + 1;
    }
    return 0;
}

- (SFEntity *)addLaserBeamWithWeaponComponent:(SFWeaponComponent *)weaponComponent atPosition:(CGPoint)position
{
    SFEntity *laserBeam = [_entityManager createEntity];
    laserBeam.name = @"Laser";

    SFRenderComponent *renderComponent = [[SFRenderComponent alloc] initWithSprite:[CCSprite spriteWithImageNamed:@"Sprites/Shots/LaserBeam.png"]];
    [_entityManager addComponent:renderComponent toEntity:laserBeam];
    renderComponent.node.position = position;

    SFMoveComponent *moveComponent = [[SFMoveComponent alloc] initWithVelocity:ccp(0.0, weaponComponent.speed)];
    [_entityManager addComponent:moveComponent toEntity:laserBeam];

    SFCollisionComponent *collisionComponent = [[SFCollisionComponent alloc] initWithDespawnAfterCollision:YES];
    [[SFEntityManager sharedManager] addComponent:collisionComponent toEntity:laserBeam];
    collisionComponent.collisionBlackListTags = @[@"Spaceship"];

    SFCollisionDamageComponent *collisionDamageComponent = [[SFCollisionDamageComponent alloc] initWithDamage:weaponComponent.power];
    [_entityManager addComponent:collisionDamageComponent toEntity:laserBeam];

    [_delegate addGameNode:renderComponent.node];

    return laserBeam;
}

- (void)setupEnemyAnimationWithRenderComponent:(SFRenderComponent *)renderComponent
{
    CCAnimation *spaceshipAnimation = [CCAnimation animation];

    [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Enemy/Enemy_1.png"];
    [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Enemy/Enemy_2.png"];
    [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Enemy/Enemy_3.png"];
    [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Enemy/Enemy_2.png"];
    spaceshipAnimation.delayPerUnit = (float) (TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER / 5.0);

    CCActionAnimate *spaceshipAnimationAction = [CCActionAnimate actionWithAnimation:spaceshipAnimation];
    spaceshipAnimationAction.duration = 1.0 * TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER;
    spaceshipAnimation.restoreOriginalFrame = YES;
    id standardAnimation = [CCActionRepeatForever actionWithAction:spaceshipAnimationAction];

    [renderComponent.node runAction:standardAnimation];

    // TODO: move
    CCAnimation *explosionAnimation = [CCAnimation animation];
    [explosionAnimation addSpriteFrameWithFilename:@"Sprites/Explosion/Explosion_1.png"];
    [explosionAnimation addSpriteFrameWithFilename:@"Sprites/Explosion/Explosion_2.png"];
    [explosionAnimation addSpriteFrameWithFilename:@"Sprites/Explosion/Explosion_3.png"];
    [explosionAnimation addSpriteFrameWithFilename:@"Sprites/Explosion/Explosion_4.png"];
    [explosionAnimation addSpriteFrameWithFilename:@"Sprites/Explosion/Explosion_5.png"];
    [explosionAnimation addSpriteFrameWithFilename:@"Sprites/Explosion/Explosion_6.png"];
    [explosionAnimation addSpriteFrameWithFilename:@"Sprites/Explosion/Explosion_7.png"];
    [explosionAnimation addSpriteFrameWithFilename:@"Sprites/Explosion/Explosion_8.png"];
    [explosionAnimation addSpriteFrameWithFilename:@"Sprites/Explosion/Explosion_9.png"];
    [explosionAnimation addSpriteFrameWithFilename:@"Sprites/Explosion/Explosion_10.png"];
    explosionAnimation.delayPerUnit = (float) (TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER / 1.3 / explosionAnimation.frames.count);

    [[CCAnimationCache sharedAnimationCache] addAnimation:explosionAnimation name:@"Explosion"];
}

- (SFEntity *)addLoot:(SFLootComponent *)lootComponent atPosition:(CGPoint)position
{
    if (!lootComponent)
    {
        return nil;
    }


    NSString *lootSpriteName;
    CCActionAnimate *actionAnimate;

    NSUInteger points = 0;
    NSUInteger health = 0;
    NSUInteger shield = 0;

    switch (lootComponent.dropType)
    {
        case 1:
        {
            lootSpriteName = @"Sprites/Loot/HealthLoot_1.png";
            actionAnimate = [self healthLootAnimation];
            health = 20;
            break;
        }
        case 2:
        {
            lootSpriteName = @"Sprites/Loot/ShieldLoot_1.png";
            actionAnimate = [self shieldLootAnimation];
            shield = 20;
            break;
        }
        default:
        {
            lootSpriteName = @"Sprites/Loot/CashLoot_1.png";
            actionAnimate = [self pointLootAnimation];
            points = 50;
            break;
        }
    }

    SFEntity *loot = [_entityManager createEntity];
    loot.name = [NSString stringWithFormat:@"Loot (%@)", lootSpriteName];

    SFRenderComponent *renderComponent = [[SFRenderComponent alloc] initWithSprite:[CCSprite spriteWithImageNamed:lootSpriteName]];
    [_entityManager addComponent:renderComponent toEntity:loot];
    [renderComponent.node runAction:actionAnimate];

    SFCollisionComponent *collisionComponent = [[SFCollisionComponent alloc] initWithDespawnAfterCollision:YES];
    [_entityManager addComponent:collisionComponent  toEntity:loot];
    collisionComponent.collisionWhiteListTags = @[@"Spaceship"];

    SFTimeToLiveComponent *timeToLiveComponent = [[SFTimeToLiveComponent alloc] initWithTimeToLive:5.0 fadeDuration:2.0];
    [[SFEntityManager sharedManager] addComponent:timeToLiveComponent toEntity:loot];

    SFCollisionRewardComponent *collisionRewardComponent = [[SFCollisionRewardComponent alloc] init];
    [_entityManager addComponent:collisionRewardComponent toEntity:loot];
    collisionRewardComponent.points = points;
    collisionRewardComponent.health = health;
    collisionRewardComponent.shield = shield;

    renderComponent.node.position = position;

    [_delegate addGameNode:renderComponent.node];

    return loot;
}

- (CCActionAnimate *)pointLootAnimation
{
    CCAnimation *animation = [CCAnimation animation];

    [animation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_1.png"];
    [animation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_2.png"];
    [animation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_3.png"];
    [animation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_4.png"];
    [animation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_5.png"];
    [animation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_4.png"];
    [animation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_3.png"];
    [animation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_2.png"];
    [animation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_1.png"];

    animation.delayPerUnit = (float) (TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER / 5.0);

    CCActionAnimate *actionAnimate = [CCActionAnimate actionWithAnimation:animation];
    actionAnimate.duration = 1.0 * TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER;
    animation.restoreOriginalFrame = YES;

    return [CCActionRepeatForever actionWithAction:actionAnimate];
}

- (CCActionAnimate *)shieldLootAnimation
{
    CCAnimation *action = [CCAnimation animation];

    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_6.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_5.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_4.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_4.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_3.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_3.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_3.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_2.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_2.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_2.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_1.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_1.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_1.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_1.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_2.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_2.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_2.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_3.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_3.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_3.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_4.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_4.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_5.png"];
    [action addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_6.png"];

    action.delayPerUnit = (float) (TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER / 5.0);

    CCActionAnimate *actionAnimate = [CCActionAnimate actionWithAnimation:action];
    actionAnimate.duration = 1.0 * TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER;
    action.restoreOriginalFrame = YES;

    return [CCActionRepeatForever actionWithAction:actionAnimate];
}

- (CCActionAnimate *)healthLootAnimation
{
    CCAnimation *animation = [CCAnimation animation];

    [animation addSpriteFrameWithFilename:@"Sprites/Loot/HealthLoot_1.png"];
    [animation addSpriteFrameWithFilename:@"Sprites/Loot/HealthLoot_1.png"];
    [animation addSpriteFrameWithFilename:@"Sprites/Loot/HealthLoot_1.png"];
    [animation addSpriteFrameWithFilename:@"Sprites/Loot/HealthLoot_1.png"];
    [animation addSpriteFrameWithFilename:@"Sprites/Loot/HealthLoot_1.png"];
    [animation addSpriteFrameWithFilename:@"Sprites/Loot/HealthLoot_1.png"];
    [animation addSpriteFrameWithFilename:@"Sprites/Loot/HealthLoot_2.png"];

    animation.delayPerUnit = (float) (TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER / 5.0);

    CCActionAnimate *actionAnimate = [CCActionAnimate actionWithAnimation:animation];
    actionAnimate.duration = 1.0 * TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER;
    animation.restoreOriginalFrame = YES;

    return [CCActionRepeatForever actionWithAction:actionAnimate];
}

@end
