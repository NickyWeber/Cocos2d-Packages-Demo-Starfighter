//
//  Created by nickyweber on 08.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SFEnemy.h"
#import "CCAnimation.h"
#import "SFLaserBeam.h"
#import "SFSpaceship.h"
#import "SFConstants.h"
#import "CCAnimationCache.h"
#import "SFGamePlaySceneDelegate.h"
#import "SFAIMovementDebug.h"
#import "SFEnemyShot.h"
#import "SFAIMovement.h"
#import "SFPointLoot.h"
#import "SFHealthLoot.h"
#import "SFShieldLoot.h"
#import "SFLoot.h"
#import "SFEntityManager.h"
#import "SFEntity.h"
#import "SFHealthComponent.h"

@interface SFEnemy ()

@property (nonatomic) EnemyStates state;
@property (nonatomic) float timeSinceLastShot;
@property (nonatomic) float shotsPerSecond;
@property (nonatomic) int points;
@property (nonatomic) float speedfactor;
@property (nonatomic) NSUInteger level;

@end

@implementation SFEnemy

- (id)initEnemyWithDelegate:(id <SFGamePlaySceneDelegate>)aDelegate level:(NSUInteger)level
{
	self = [super initWithImageNamed:@"Sprites/Enemy/Enemy_1.png"];
	if (self)
	{
		NSAssert(aDelegate != nil, @"Delegate has to be set!");
		NSAssert([aDelegate conformsToProtocol:@protocol(SFGamePlaySceneDelegate)], @"Delegate has to conform to GamePlaySceneDelegateProtocol!");

		self.delegate = aDelegate;
		self.state = EnemyStateNormal;
        self.level = level;
        
        self.entity = [[SFEntityManager sharedManager] createEntity];
        [[SFEntityManager sharedManager] addComponent:[[SFHealthComponent alloc] initWithHealth:55 healthMax:55]toEntity:_entity];

		[self addBoundingBoxWithRect:CGRectMake(0.0, 0.0, 64.0, 44.0)];

        [self setupStats];

        [self setupAnimations];
	}

	return self;
}

- (void)setupStats
{
    double factor = 1.0 / GAME_LEVEL_MAX * _level;

    self.aiMovement = [[SFAIMovement alloc] initWithLevel:_level];

    self.timeSinceLastShot = 100.0; //(float) (3.0 * CCRANDOM_0_1());
    self.shotsPerSecond = [self shotsPerSecondForLevel];

    self.speedfactor = (float) (50.0 + 50.0 * factor);
    self.points = (int) (75 + 200 * factor);

    // self.health = (int) (50 + 15 * factor);

    // NSLog(@"Level: %d, p: %d, h: %d, s: %.2f, sps: %.2f, f: %.2f", _level, _points, _health, _speedfactor, _shotsPerSecond, factor);
}

- (float)shotsPerSecondForLevel
{
    switch (_level)
    {
        case 1 :
            return 0.333;
        case 2 :
            return 0.5;
        case 3 :
            return 0.75;
        case 4 :
            return 1.0;
        case 5 :
            return 1.5;
        case 6 :
            return 2.0;
        case 7 :
            return 3.0;
        default: return 0.5;
    }
}

- (void)setupAnimations
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
    self.standardAnimation = [CCActionRepeatForever actionWithAction:spaceshipAnimationAction];

    [self runAction:self.standardAnimation];

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

    self.explosionAnimationAction = [CCActionAnimate actionWithAnimation:explosionAnimation];
}

- (void)updateStateWithTimeDelta:(CCTime)aTimeDelta andGameObjects:(NSArray *)gameObjects
{
    SFHealthComponent *healthComponent = [[SFEntityManager sharedManager] componentOfClass:[SFHealthComponent class] forEntity:_entity];

	for (SFGameObject <SFWeaponProjectileProtocol> *gameObject in gameObjects)
	{
		if ([gameObject conformsToProtocol:@protocol(SFWeaponProjectileProtocol)])
		{
//			NSLog(@"1: %f.1 %f.1 %f.1 %f.1", rect1.origin.x, rect1.origin.y, rect1.size.width, rect1.size.height);
//			NSLog(@"2: %f.1 %f.1 %f.1 %f.1", rect2.origin.x, rect2.origin.y, rect2.size.width, rect2.size.height);

			if ([self detectCollisionWithGameObject:gameObject]
				&& healthComponent.isAlive
				&& ! [gameObject damagesSpaceship])
			{
				[self takeDamage:[gameObject damage]];

				[gameObject weaponHitTarget];
			}
		}
	}

	[self fireAtPlayer];
	self.timeSinceLastShot += aTimeDelta;

    CGPoint newPosition = [_aiMovement positionWithTimeDelta:aTimeDelta
                                                oldPoisition:self.position
                                                 speedfactor:_speedfactor];
	if (newPosition.y <= -50.0)
	{
		[self despawn];
	}
	else
	{
		self.position = newPosition;
	}
}

- (void)explode
{


	[[NSNotificationCenter defaultCenter] postNotificationName:@"TargetDestroyed"
														object:self];


    id sequence = [CCActionSequence actions:[CCActionCallFunc actionWithTarget:self selector:@selector(dropLoot)],
                                            _explosionAnimationAction,
                                            [CCActionCallFunc actionWithTarget:self selector:@selector(despawn)],
                                            nil];
    [self stopAction:_standardAnimation];
	[self runAction:sequence];
}

- (void)dropLoot
{
    SFLoot *loot = [self randomLoot];

    if (loot)
    {
        loot.position = self.position;
        [_delegate addGameEntity:loot];
    }
}

- (SFLoot *)randomLoot
{
    int rng = arc4random() % 1000 + 1;

    if (rng <= 200)
    {
        int lootType = arc4random() % 3 + 1;
        switch (lootType)
        {
            case 1:
                return [[SFHealthLoot alloc] initWithDelegate:_delegate];
            case 2:
                return [[SFShieldLoot alloc] initWithDelegate:_delegate];
            default:
                return [[SFPointLoot alloc] initWithDelegate:_delegate];
        }
    }
    return nil;
}

- (void)takeDamage:(int)damageTaken
{
    SFHealthComponent *healthComponent = [[SFEntityManager sharedManager] componentOfClass:[SFHealthComponent class] forEntity:_entity];
    healthComponent.health -= damageTaken;

	// self.health -= damageTaken;

	if (healthComponent.health <= 0)
	{
		[self explode];

		[_delegate addPoints:_points];
	}
	else
	{
		self.hitAnimation = [CCAnimation animation];

		[_hitAnimation addSpriteFrameWithFilename:@"Sprites/Enemy/Enemy_hit.png"];
        _hitAnimation.delayPerUnit = 0.1;

        self.hitAnimationAction = [CCActionAnimate actionWithAnimation:_hitAnimation];
        _hitAnimationAction.duration = 0.1 * TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER;
        _hitAnimation.restoreOriginalFrame = YES;

		[self runAction:_hitAnimationAction];
	}
}

- (void)fireAtPlayer
{
	if ([self areCannonsReady])
	{
        SFEnemyShot *aShot = [[SFEnemyShot alloc] initEnemyShotWithStartPosition:self.position andTarget:[_delegate spaceship] level:_level];



		// NSLog(@"*********** FIRING FROM %f.2 %f.2 !!! ***************", aShot.position.x, aShot.position.y);
		[_delegate addGameEntity:aShot];
	}

/*
    if ([self areCannonsReady])
	{
		HomingMissile *homingMissile = [HomingMissile enemyHomingMissileWithStartPosition:self.position
																		  andTargetObject:[delegate spaceship]
																				 delegate:self.delegate];

		// NSLog(@"*********** FIRING FROM %f.2 %f.2 !!! ***************", aShot.position.x, aShot.position.y);

		[delegate addGameEntity:homingMissile];
	}
*/
}

- (BOOL)areCannonsReady
{
    // NSLog(@"-> %.2f / %.2f", _timeSinceLastShot, (1.0 / _shotsPerSecond) );

	if (_timeSinceLastShot >= (1.0 / _shotsPerSecond))
	{
		self.timeSinceLastShot = 0.0;
		return YES;
	}
	
	return NO;
}

@end