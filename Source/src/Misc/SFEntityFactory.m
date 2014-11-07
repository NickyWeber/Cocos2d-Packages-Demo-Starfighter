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
#import "SFConfigLoader.h"
#import "SFLootComponent.h"
#import "SFWeaponComponent.h"
#import "SFCollisionComponent.h"
#import "SFLootComponent.h"
#import "SFCollisionRewardComponent.h"
#import "SFTimeToLiveSystem.h"
#import "SFTimeToLiveComponent.h"
#import "SFRewardComponent.h"
#import "SFTrigonometryHelper.h"
#import "SFConfigLoader.h"

@interface SFEntityFactory ()
@property (nonatomic, strong) SFConfigLoader *configLoader;
@end

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

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.configLoader = [[SFConfigLoader alloc] init];
        [self setupAnimations];
    }

    return self;
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

    [_delegate addEntityNodeToGame:renderComponent.node];

    return spaceship;
}

- (SFEntity *)addEnemyShotWithWeaponComponent:(SFWeaponComponent *)weaponComponent atPosition:(CGPoint)position
{
    NSArray *array = [_entityManager allEntitiesPosessingComponentOfClass:[SFTagComponent class]];

    for (SFEntity *entity in array)
    {
        SFTagComponent *tagComponent = [self.entityManager componentOfClass:[SFTagComponent  class] forEntity:entity];
        if ([tagComponent hasTag:@"Spaceship"])
        {
            SFEntity *shot = [self addEntityWithName:@"EnemyShot" atPosition:position];
            shot.name = @"@EnemyShot";

            SFRenderComponent *renderComponentSpaceship = [self.entityManager componentOfClass:[SFRenderComponent class] forEntity:entity];

            CGPoint shotVector = [SFTrigonometryHelper calcNormalizedShotVector:position andTargetPosition:renderComponentSpaceship.node.position];

            SFMoveComponent *moveComponent = [[SFMoveComponent alloc] initWithVelocity:ccpMult(shotVector, weaponComponent.speed)];
            [_entityManager addComponent:moveComponent toEntity:shot];

            SFCollisionDamageComponent *collisionDamageComponent = [[SFCollisionDamageComponent alloc] initWithDamage:weaponComponent.power];
            [_entityManager addComponent:collisionDamageComponent toEntity:shot];

            return shot;
        }
    }

    return nil;
}

- (SFEntity *)addLaserBeamWithWeaponComponent:(SFWeaponComponent *)weaponComponent atPosition:(CGPoint)position
{
    SFEntity *result = [self addEntityWithName:@"LaserBeam" atPosition:position];
    result.name = @"LaserBeam";

    SFMoveComponent *moveComponent = [[SFMoveComponent alloc] initWithVelocity:ccp(0.0, weaponComponent.speed)];
    [_entityManager addComponent:moveComponent toEntity:result];

    SFCollisionDamageComponent *collisionDamageComponent = [[SFCollisionDamageComponent alloc] initWithDamage:weaponComponent.power];
    [_entityManager addComponent:collisionDamageComponent toEntity:result];

    return result;
}

- (SFEntity *)addEnemyAtPosition:(CGPoint)position
{
    return [self addEntityWithName:@"Enemy" atPosition:position];
}

- (SFEntity *)addEntityWithName:(NSString *)name atPosition:(CGPoint)position
{
    NSArray *components = [_configLoader componentsWithConfigName:name];

    SFEntity *result = [_entityManager createEntityWithComponents:components];
    result.name = name;

    SFRenderComponent *renderComponent = [self.entityManager componentOfClass:[SFRenderComponent class] forEntity:result];
    renderComponent.node.position = position;

    [_delegate addEntityNodeToGame:renderComponent.node];

    return result;
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
}

- (void)setupAnimations
{
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

    [_delegate addEntityNodeToGame:renderComponent.node];

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
