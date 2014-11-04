#import "Spaceship.h"
#import "GamePlaySceneDelegate.h"
#import "CCAnimation.h"
#import "Constants.h"
#import "Enemy.h"
#import "WeaponProjectileProtocol.h"
#import "CCAnimationCache.h"
#import "SneakyJoystick.h"
#import "SneakyButton.h"
#import "WeaponSystemProtocol.h"
#import "LaserCannon.h"
#import "CCEffectInvert.h"


static float EXPLOSION_ANIMATION_DURATION = 1.3f;
static float HIT_ANIMATION_DURATION = 0.1f;

@interface Spaceship ()

@property (nonatomic, strong) NSMutableArray *weaponSystems;
@property (nonatomic) double speedfactor;
@property (nonatomic) double shotsPerSecond;
@property (nonatomic) double missilesPerSecond;
@property (nonatomic) double timeSinceLastShotFired;
@property (nonatomic) double timeSinceLastMissileLaunched;
@property (nonatomic, strong) id spaceshipAnimationAction;
@property (nonatomic, strong) id repeatedSpaceshipAnimation;
@end

@implementation Spaceship

- (id)initWithDelegate:(id <GamePlaySceneDelegate>)delegate
{
    self = [super init];

    if (self)
    {
        self.delegate = delegate;
        [self setIsActive:YES];

        self.health = 100;
        self.healthMax = 100;

        self.shield = 100;
        self.shieldMax = 100;

        self.weaponSystems = [NSMutableArray array];

        LaserCannon *laserCannon = [[LaserCannon alloc] initWithDelegate:self.delegate];
        [_weaponSystems addObject:laserCannon];
/*

        MissileLauncher *missileLauncher = [[[MissileLauncher alloc] initWithDelegate:self.delegate
                                                                        andDatasource:self] autorelease];
        // TODO: missile launcher still not working as expected :)
        // [weaponSystems addObject:missileLauncher];
*/

        [self addBoundingBoxWithRect:CGRectMake(0.0, 26.0, 52.0, 56.0)];

        CCAnimation *spaceshipAnimation = [CCAnimation animation];

        spaceshipAnimation.restoreOriginalFrame = YES;
        spaceshipAnimation.delayPerUnit = (float) (TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER / 5.0);

        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Spaceship/Spaceship_1.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Spaceship/Spaceship_2.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Spaceship/Spaceship_3.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Spaceship/Spaceship_2.png"];
        
        self.spaceshipAnimationAction = [CCActionAnimate actionWithAnimation:spaceshipAnimation];
        self.repeatedSpaceshipAnimation = [CCActionRepeatForever actionWithAction:_spaceshipAnimationAction];

        self.speedfactor = 0.75;
        self.shotsPerSecond = 5.0;
        self.missilesPerSecond = 0.5;
        self.timeSinceLastShotFired = 0.0;
        self.timeSinceLastMissileLaunched = 0.0;

        [self runAction:_repeatedSpaceshipAnimation];

        [_delegate updateHealthBarWithHealthInPercent:[self healthInPercent]];
        [_delegate updateShieldBarWithShieldInPercent:[self shieldInPercent]];
    }

    return self;
}

- (void)updateStateWithTimeDelta:(CCTime)aTimeDelta andGameObjects:(NSArray *)gameObjects
{
    if (![self isPlayerDead])
    {
        [self applyJoystickWithTimeDelta:aTimeDelta andGameObjects:gameObjects];

        for (GameObject *gameObject in gameObjects)
        {
            if ([gameObject isKindOfClass:[Enemy class]])
            {
                [self testOnEnemyShipCollisionAndApplyDamageWithEnemy:((Enemy *) gameObject)];
            }

            GameObject <WeaponProjectileProtocol> *weapon = (GameObject <WeaponProjectileProtocol>*) gameObject;
            if ([weapon conformsToProtocol:@protocol(WeaponProjectileProtocol)]
                && [weapon damagesSpaceship]
                && weapon.isActive)
            {
                [self testOnEnemyShotCollisionAndApplyDamageWithShot:weapon];
            }
        }
    }
}

#pragma mark -
#pragma mark - action

- (void)testOnEnemyShotCollisionAndApplyDamageWithShot:(GameObject <WeaponProjectileProtocol> *)aShot
{
	if ([self detectCollisionWithGameObject:aShot])
	{
		// NSLog(@"Taking damage: %d from (%@)", [aShot damage], aShot);
		[self playerTakesDamage:[aShot damage]];
		[aShot weaponHitTarget];
	}
}

- (void)testOnEnemyShipCollisionAndApplyDamageWithEnemy:(Enemy *)anEnemy
{
	if ([self detectCollisionWithGameObject:anEnemy]
		&& anEnemy.isActive)
	{
		[self playerTakesDamage:anEnemy.health];
		[anEnemy takeDamage:100];
	}
}

- (void)addHealth:(int)health
{
    if (health + _health > _healthMax)
    {
        self.health = _healthMax;
    }
    else
    {
        self.health += health;
    }

    [_delegate updateHealthBarWithHealthInPercent:[self healthInPercent]];
}

- (void)addShield:(int)shield
{
    if (shield + _shield > _shieldMax)
    {
        self.shield = _shieldMax;
    }
    else
    {
        self.shield += shield;
    }

    [_delegate updateShieldBarWithShieldInPercent:[self shieldInPercent]];
}

- (void)playerTakesDamage:(int)damageTaken
{
	if (PLAYER_IS_INVULNERABLE)
	{
		return;
	}

	int newShield = _shield - damageTaken;
	self.shield = MAX(newShield, 0);

	if (newShield < 0)
	{
		self.health = _health - newShield * -1;
	}

	if ([self isPlayerDead])
	{
		[self playerDies];
	}
	else
	{
		CCAnimation *hitAnimation = [CCAnimation animation];
		[hitAnimation addSpriteFrameWithFilename:@"Sprites/Spaceship/Spaceship_hit.png"];
        hitAnimation.restoreOriginalFrame = YES;
        hitAnimation.delayPerUnit = HIT_ANIMATION_DURATION;

        CCActionAnimate *hitAnimationAction = [CCActionAnimate actionWithAnimation:hitAnimation];
        hitAnimationAction.duration = HIT_ANIMATION_DURATION * TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER;

		[self runAction:hitAnimationAction];
	}

	[_delegate updateHealthBarWithHealthInPercent:[self healthInPercent]];
	[_delegate updateShieldBarWithShieldInPercent:[self shieldInPercent]];
}

- (void)playerDies
{
	self.isActive = NO;

    CCActionAnimate *explosionAnimationAction = [CCActionAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:@"Explosion"]];
    explosionAnimationAction.animation.restoreOriginalFrame = NO;

    [self stopAction:_repeatedSpaceshipAnimation];

    id sequence = [CCActionSequence actions:explosionAnimationAction,
                                    [CCActionCallBlock actionWithBlock:^{
                                        self.visible = NO;
                                    }],
                                    [CCActionCallFunc actionWithTarget:_delegate selector:@selector(gameOver)],
                                    nil];

	[self runAction:sequence];
}

- (void)applyJoystickWithTimeDelta:(CCTime)aTimeDelta andGameObjects:(NSArray *)someGameObjects
{
    CGSize displaySize = [CCDirector sharedDirector].view.frame.size;
	CGPoint scaledVelocity = ccpMult(_delegate.dPadVelocity, (CGFloat const) (displaySize.width * _speedfactor));
//    NSLog(@"*** %@", [NSValue valueWithCGPoint:scaledVelocity]);

	CGPoint newPosition = CGPointMake(MAX(0, MIN(self.position.x + scaledVelocity.x * aTimeDelta, displaySize.width)),
			                          MAX(0, MIN(self.position.y + scaledVelocity.y * aTimeDelta, displaySize.height)));


    if ([_delegate dPadVelocity].x != 0 || [_delegate dPadVelocity].y != 0)
    {
        // NSLog(@"%.2f", _delegate.degrees);
/*
        NSLog(@"xv: %f, xs: %.4f, x:%f, dt:%f, new x:%f", [_delegate dPadVelocity].x, scaledVelocity.x, self.position.x, aTimeDelta,self.position.x + scaledVelocity.x * aTimeDelta);
        NSLog(@"yv: %f, ys: %.4f, y:%f, dt:%f, new y:%f", [_delegate dPadVelocity].y, scaledVelocity.y, self.position.y, aTimeDelta,self.position.y + scaledVelocity.y * aTimeDelta);
*/
    }

	if (self.isActive)
	{
		[self setPosition:newPosition];
	}

	self.timeSinceLastShotFired += aTimeDelta;
	self.timeSinceLastMissileLaunched += aTimeDelta;

	[self addLaserShotsIfButtonPressedToDelegateWithPosition:newPosition andGameObjects:someGameObjects];
}

- (void)addLaserShotsIfButtonPressedToDelegateWithPosition:(CGPoint)aPosition andGameObjects:(NSArray *)someGameObjects
{
	if (_delegate.firing && self.isActive)
	{
		for (id <WeaponSystemProtocol> weaponSystem in _weaponSystems)
		{
			[weaponSystem shootWithPosition:self.position];
		}
	}

	// TODO move this to missile launcher code
/*	if (fireButton.active
		&& [self missileLauncherReady])
	{
		GameObject *nearestTarget = [self findNearestEnemyWithGameObjects:someGameObjects];

		if (nearestTarget &&
			[self missileLauncherReady])
		{
			HomingMissile *homingMissile = [HomingMissile playerHomingMissileWithStartPosition:self.position
																			   andTargetObject:nearestTarget
																					  delegate:self.delegate];

			[delegate addGameEntity:homingMissile];

			timeSinceLastMissileLaunched = 0.0;
		}
	}*/
}

/*
- (GameObject *)findNearestEnemyWithGameObjects:(NSArray *)someGameObjects
{
	for (GameObject *gameObject in someGameObjects)
	{
		if ([gameObject isKindOfClass:[Enemy class]])
		{
			return gameObject;
		}
	}

	return nil;
}
*/

- (float)healthInPercent
{
	return (float) (1.0 / (float) _healthMax * (float) _health);
}

- (float)shieldInPercent
{
	return (float) (1.0 / (float) _shieldMax * (float) _shield);
}

- (BOOL)isPlayerDead
{
	return (_health <= 0);
}

- (BOOL)canShoot
{
	return (_timeSinceLastShotFired >= 1.0 / _shotsPerSecond);
}

- (BOOL)missileLauncherReady
{
	return (_timeSinceLastMissileLaunched >= 1.0 / _missilesPerSecond);
}

- (CGPoint)currentPosition
{
	return self.position;
}

@end