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
#import "SFCollisionComponent.h"
#import "SFLootComponent.h"
#import "SFPointLoot.h"
#import "SFShieldLoot.h"
#import "SFHealthLoot.h"
#import "SFCollisionRewardComponent.h"
#import "SFTimeToLiveSystem.h"
#import "SFTimeToLiveComponent.h"

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

- (SFEntity *)addEnemyAtPosition:(CGPoint)position
{
    SFEntity *entity = [_entityManager createEntity];
    entity.name = @"Enemy";
    [_entityManager addComponent:[[SFHealthComponent alloc] initWithHealth:50 healthMax:50] toEntity:entity];

    SFRenderComponent *renderComponent = [[SFRenderComponent alloc] initWithSprite:[CCSprite spriteWithImageNamed:@"Sprites/Enemy/Enemy_1.png"]];
    [_entityManager addComponent:renderComponent toEntity:entity];
    renderComponent.node.position = position;

    SFMoveComponent *moveComponent = [[SFMoveComponent alloc] initWithVelocity:ccp(0.0, -100.0)];
    [_entityManager addComponent:moveComponent toEntity:entity];

    SFLevelComponent *levelComponent = [[SFLevelComponent alloc] initWithLevel:1];
    [_entityManager addComponent:levelComponent toEntity:entity];

/*
    SFTagComponent *tagComponent = [[SFTagComponent alloc] init];
    [tagComponent addTag:@"Enemy"];
    [[SFEntityManager sharedManager] addComponent:tagComponent toEntity:entity];
*/

    SFCollisionComponent *collisionComponent = [[SFCollisionComponent alloc] init];
    [[SFEntityManager sharedManager] addComponent:collisionComponent toEntity:entity];

    SFCollisionDamageComponent *collisionDamageComponent = [[SFCollisionDamageComponent alloc] initWithDamage:50];
    [_entityManager addComponent:collisionDamageComponent toEntity:entity];

    [self setupEnemyAnimationWithRenderComponent:renderComponent];

    [_delegate addGameNode:renderComponent.node];

    return entity;
}

- (SFEntity *)addLaserBeamAtPosition:(CGPoint)position
{
    SFEntity *laserBeam = [_entityManager createEntity];
    laserBeam.name = @"Laser";

    SFRenderComponent *renderComponent = [[SFRenderComponent alloc] initWithSprite:[CCSprite spriteWithImageNamed:@"Sprites/Shots/LaserBeam.png"]];
    [_entityManager addComponent:renderComponent toEntity:laserBeam];
    renderComponent.node.position = position;

    SFMoveComponent *moveComponent = [[SFMoveComponent alloc] initWithVelocity:ccp(0.0, 300.0)];
    [_entityManager addComponent:moveComponent toEntity:laserBeam];

    SFCollisionComponent *collisionComponent = [[SFCollisionComponent alloc] initWithDespawnAfterCollision:YES];
    [[SFEntityManager sharedManager] addComponent:collisionComponent toEntity:laserBeam];
    [collisionComponent.collisionExceptionTags addObject:@"Spaceship"];

    SFCollisionDamageComponent *collisionDamageComponent = [[SFCollisionDamageComponent alloc] initWithDamage:10];
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
    switch (lootComponent.dropType)
    {
        case 1:
            lootSpriteName = @"Sprites/Loot/HealthLoot_1.png";
            break;
        case 2:
            lootSpriteName = @"Sprites/Loot/ShieldLoot_1.png";
            break;
        default:
            lootSpriteName = @"Sprites/Loot/CashLoot_1.png";
            break;
    }

    SFEntity *loot = [_entityManager createEntity];
    loot.name = [NSString stringWithFormat:@"Loot (%@)", lootSpriteName];

    SFRenderComponent *renderComponent = [[SFRenderComponent alloc] initWithSprite:[CCSprite spriteWithImageNamed:lootSpriteName]];
    [_entityManager addComponent:renderComponent toEntity:loot];

    SFCollisionComponent *collisionComponent = [[SFCollisionComponent alloc] initWithDespawnAfterCollision:YES];
    [_entityManager addComponent:collisionComponent  toEntity:loot];

    SFTimeToLiveComponent *timeToLiveComponent = [[SFTimeToLiveComponent alloc] initWithTimeToLive:5.0 fadeDuration:2.0];
    [[SFEntityManager sharedManager] addComponent:timeToLiveComponent toEntity:loot];

    SFCollisionRewardComponent *collisionRewardComponent = [[SFCollisionRewardComponent alloc] init];
    [_entityManager addComponent:collisionRewardComponent toEntity:loot];

    renderComponent.node.position = position;

    [_delegate addGameNode:renderComponent.node];

    return loot;
}

@end

