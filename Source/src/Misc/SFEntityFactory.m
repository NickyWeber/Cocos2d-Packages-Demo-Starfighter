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
#import "SFDropTable.h"

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
    SFEntity *spaceship = [self addEntityWithName:@"Spaceship" atPosition:position];
    spaceship.name = @"Spaceship";

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

    if (renderComponent.defaultActionAnimate)
    {
        [renderComponent.node runAction:renderComponent.defaultActionAnimate];
    }

    [_delegate addEntityNodeToGame:renderComponent.node];

    return result;
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
    explosionAnimation.delayPerUnit = (float) (1.0 / 1.3 / explosionAnimation.frames.count);

    [[CCAnimationCache sharedAnimationCache] addAnimation:explosionAnimation name:@"Explosion"];
}

- (SFEntity *)addLoot:(SFLootComponent *)lootComponent atPosition:(CGPoint)position
{
    if (!lootComponent)
    {
        return nil;
    }

    double rng = arc4random() % 1000 / 1000.0;
    NSString *lootName;
    if (rng <= lootComponent.dropTable.chance)
    {
        NSUInteger index = arc4random() % [lootComponent.dropTable.list count];
        lootName = lootComponent.dropTable.list[index];
    }

    if (lootName)
    {
        SFEntity *loot = [self addEntityWithName:lootName atPosition:position];
        loot.name = lootName;
        return loot;
    }
    return nil;
}

@end
