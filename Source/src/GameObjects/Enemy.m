//
//  Created by nickyweber on 08.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Enemy.h"
#import "CCAnimation.h"
#import "CCActionInterval.h"
#import "SneakyJoystick.h"
#import "LaserBeam.h"
/*
#import "GameConfig.h"
#import "EnemyShot.h"
*/
#import "GamePlayLayer.h"
#import "Spaceship.h"
#import "Constants.h"
#import "CCAnimationCache.h"
#import "MonsterSpawner.h"
#import "GamePlaySceneDelegate.h"
#import "AIMovementDebug.h"
#import "EnemyShot.h"

/*
#import "AIMovementProtocol.h"
#import "AIMovement.h"
#import "AIMovementDebug.h"
#import "HomingMissile.h"
*/


@interface Enemy()

@property (nonatomic) EnemyStates state;
@property (nonatomic) float timeSinceLastShot;
@property (nonatomic) float shotsPerSecond;
@property (nonatomic) int points;
@property (nonatomic) float speedfactor;


@end

@implementation Enemy

- (id)initEnemyWithDelegate:(id<GamePlaySceneDelegate>)aDelegate
{
	self = [super initWithImageNamed:@"Sprites/Enemy/Enemy_1.png"];
	if (self)
	{
		NSAssert(aDelegate != nil, @"Delegate has to be set!");
		NSAssert([aDelegate conformsToProtocol:@protocol(GamePlaySceneDelegate)], @"Delegate has to conform to GamePlaySceneDelegateProtocol!");

		self.delegate = aDelegate;

		self.aiMovement = [[AIMovementDebug alloc] init];

		self.state = EnemyStateNormal;

		[self addBoundingBoxWithRect:CGRectMake(0.0, 0.0, 64.0, 44.0)];

		// self.timeSinceLastShot = 2.0 * CCRANDOM_0_1();
        self.timeSinceLastShot = 100.0;
		self.shotsPerSecond = 0.2;

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

		self.speedfactor = (float) (0.5 * [CCDirector sharedDirector].view.frame.size.width);
		self.points = 75;
		self.health = 50;
	}

	return self;
}

- (void)updateStateWithTimeDelta:(CCTime)aTimeDelta andGameObjects:(NSArray *)gameObjects
{
	// relPosHeight = 1.0 - MIN(1.0, MAX(0, (1.0 / 480.0) * newPosition.y));

	for (GameObject <WeaponProjectileProtocol> *gameObject in gameObjects)
	{
		// if ([gameObject isKindOfClass:[LaserBeam class]])
		if ([gameObject conformsToProtocol:@protocol(WeaponProjectileProtocol)])
		{
//			LaserBeam *laserBeam = (LaserBeam *)gameObject;
//			NSLog(@"1: %f.1 %f.1 %f.1 %f.1", rect1.origin.x, rect1.origin.y, rect1.size.width, rect1.size.height);
//			NSLog(@"2: %f.1 %f.1 %f.1 %f.1", rect2.origin.x, rect2.origin.y, rect2.size.width, rect2.size.height);

			if ([self detectCollisionWithGameObject:gameObject]
				&& gameObject.isActive
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
	if (newPosition.y <= -30.0)
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
	self.isActive = NO;

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
/*
	if (loot)
	{
		loot.position = self.position;
		[delegate addGameEntity:loot];
	}
*/
}

- (void)takeDamage:(int)damageTaken
{
	self.health -= damageTaken;

	if (_health <= 0)
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
        EnemyShot *aShot = [[EnemyShot alloc] initEnemyShotWithStartPosition:self.position
                                                                   andTarget:[_delegate spaceship]];
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
	if (_timeSinceLastShot >= 1.0 / _shotsPerSecond)
	{
		self.timeSinceLastShot = 0.0;
		return YES;
	}
	
	return NO;
}

@end