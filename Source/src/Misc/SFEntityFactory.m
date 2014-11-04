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
#import "SFCollisionComponent.h"

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

- (SFEntity *)addEnemy
{
    SFEntity *entity = [_entityManager createEntity];
    [_entityManager addComponent:[[SFHealthComponent alloc] initWithHealth:50 healthMax:50] toEntity:entity];

    SFRenderComponent *renderComponent = [[SFRenderComponent alloc] initWithSprite:[CCSprite spriteWithImageNamed:@"Sprites/Enemy/Enemy_1.png"]];
    [_entityManager addComponent:renderComponent toEntity:entity];

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

    [_delegate addGameEntity:renderComponent.node];

    return entity;
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


@end