#import "SFSpaceship.h"
#import "SFGamePlaySceneDelegate.h"
#import "CCAnimation.h"
#import "SFConstants.h"
#import "SFEnemy.h"
#import "SFWeaponProjectileProtocol.h"
#import "CCAnimationCache.h"
#import "SneakyJoystick.h"
#import "SneakyButton.h"
#import "SFWeaponSystemProtocol.h"
#import "SFLaserCannon.h"
#import "CCEffectInvert.h"
#import "SFHealthComponent.h"
#import "SFEntityManager.h"
#import "SFEntity.h"
#import "SFTagComponent.h"
#import "SFCollisionDamageComponent.h"
#import "SFCollisionComponent.h"
#import "SFRenderComponent.h"
#import "SFWeaponComponent.h"


static float EXPLOSION_ANIMATION_DURATION = 1.3f;
static float HIT_ANIMATION_DURATION = 0.1f;

@interface SFSpaceship ()

@property (nonatomic, strong) NSMutableArray *weaponSystems;
@property (nonatomic) double speedfactor;
@property (nonatomic) double shotsPerSecond;
@property (nonatomic) double missilesPerSecond;
@property (nonatomic) double timeSinceLastShotFired;
@property (nonatomic) double timeSinceLastMissileLaunched;
@property (nonatomic, strong) id spaceshipAnimationAction;
@property (nonatomic, strong) id repeatedSpaceshipAnimation;
@end

@implementation SFSpaceship

- (id)initWithDelegate:(id <SFGamePlaySceneDelegate>)delegate
{
    self = [super init];

    if (self)
    {
        self.delegate = delegate;
        [self setIsActive:YES];
        
        self.entity = [[SFEntityManager sharedManager] createEntity];
        _entity.name = @"Spaceship";
        SFHealthComponent *healthComponent = [[SFHealthComponent alloc] initWithHealth:70 healthMax:100];
        healthComponent.shieldMax = 100;
        [[SFEntityManager sharedManager] addComponent:healthComponent toEntity:_entity];

        SFTagComponent *tagComponent = [[SFTagComponent alloc] init];
        [tagComponent addTag:@"Spaceship"];
        [[SFEntityManager sharedManager] addComponent:tagComponent toEntity:_entity];

        SFCollisionComponent *collisionComponent = [[SFCollisionComponent alloc] init];
        [[SFEntityManager sharedManager] addComponent:collisionComponent toEntity:_entity];

        CCAnimation *hitAnimation = [CCAnimation animation];
        [hitAnimation addSpriteFrameWithFilename:@"Sprites/Spaceship/Spaceship_hit.png"];
        hitAnimation.restoreOriginalFrame = YES;
        hitAnimation.delayPerUnit = 0.5;

        CCActionAnimate *hitAnimationAction = [CCActionAnimate actionWithAnimation:hitAnimation];
        hitAnimationAction.duration = 5.0;

        collisionComponent.hitAnimationAction = hitAnimationAction;

        SFCollisionDamageComponent *collisionDamageComponent = [[SFCollisionDamageComponent alloc] initWithDamage:10000000];
        [[SFEntityManager sharedManager] addComponent:collisionDamageComponent toEntity:_entity];

        SFRenderComponent *renderComponent = [[SFRenderComponent alloc] initWithSprite:[CCSprite spriteWithImageNamed:@"Sprites/Spaceship/Spaceship_1.png"]];
        [[SFEntityManager sharedManager] addComponent:renderComponent toEntity:_entity];
        renderComponent.node = self;

        SFWeaponComponent *weaponComponent = [[SFWeaponComponent alloc] init];
        weaponComponent.fireRate = 2.0;
        weaponComponent.weaponType = 2;
        weaponComponent.timeSinceLastShot = 11111;
        weaponComponent.power = 10;
        weaponComponent.speed = 400;
        [[SFEntityManager sharedManager] addComponent:weaponComponent toEntity:self.entity];

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
    SFHealthComponent *healthComponent = [[SFEntityManager sharedManager] componentOfClass:[SFHealthComponent class] forEntity:_entity];

    if (healthComponent.isAlive)
    {
        [self applyJoystickWithTimeDelta:aTimeDelta andGameObjects:gameObjects];

        for (SFGameObject *gameObject in gameObjects)
        {
            if ([gameObject isKindOfClass:[SFEnemy class]])
            {
                [self testOnEnemyShipCollisionAndApplyDamageWithEnemy:((SFEnemy *) gameObject)];
            }

            SFGameObject <SFWeaponProjectileProtocol> *weapon = (SFGameObject <SFWeaponProjectileProtocol>*) gameObject;
            if ([weapon conformsToProtocol:@protocol(SFWeaponProjectileProtocol)]
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

- (void)testOnEnemyShotCollisionAndApplyDamageWithShot:(SFGameObject <SFWeaponProjectileProtocol> *)aShot
{
	if ([self detectCollisionWithGameObject:aShot])
	{
		// NSLog(@"Taking damage: %d from (%@)", [aShot damage], aShot);
		[self playerTakesDamage:[aShot damage]];
		[aShot weaponHitTarget];
	}
}

- (void)testOnEnemyShipCollisionAndApplyDamageWithEnemy:(SFEnemy *)anEnemy
{
    SFHealthComponent *healthComponent = [[SFEntityManager sharedManager] componentOfClass:[SFHealthComponent class] forEntity:anEnemy.entity];

	if ([self detectCollisionWithGameObject:anEnemy]
		&& healthComponent.isAlive)
	{
		[self playerTakesDamage:healthComponent.health];
		[anEnemy takeDamage:100];
	}
}

- (void)addHealth:(int)health
{
    SFHealthComponent *healthComponent = [[SFEntityManager sharedManager] componentOfClass:[SFHealthComponent class] forEntity:_entity];
    healthComponent.health += health;

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

    SFHealthComponent *healthComponent = [[SFEntityManager sharedManager] componentOfClass:[SFHealthComponent class] forEntity:_entity];

	if (newShield < 0)
	{
        healthComponent.health = healthComponent.health - newShield * -1;
	}

	if (![healthComponent isAlive])
	{
		[self playerDies];
	}
	else
	{
/*
		CCAnimation *hitAnimation = [CCAnimation animation];
		[hitAnimation addSpriteFrameWithFilename:@"Sprites/Spaceship/Spaceship_hit.png"];
        hitAnimation.restoreOriginalFrame = YES;
        hitAnimation.delayPerUnit = HIT_ANIMATION_DURATION;

        CCActionAnimate *hitAnimationAction = [CCActionAnimate actionWithAnimation:hitAnimation];
        hitAnimationAction.duration = HIT_ANIMATION_DURATION * TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER;

		[self runAction:hitAnimationAction];
*/
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
        SFRenderComponent *renderComponent = [[SFEntityManager sharedManager] componentOfClass:[SFRenderComponent class] forEntity:_entity];
        renderComponent.node.position = newPosition;

		[self setPosition:newPosition];
	}

	self.timeSinceLastShotFired += aTimeDelta;
	self.timeSinceLastMissileLaunched += aTimeDelta;

	// [self addLaserShotsIfButtonPressedToDelegateWithPosition:newPosition andGameObjects:someGameObjects];
}

- (void)addLaserShotsIfButtonPressedToDelegateWithPosition:(CGPoint)aPosition andGameObjects:(NSArray *)someGameObjects
{
	if (_delegate.firing && self.isActive)
	{
		for (id <SFWeaponSystemProtocol> weaponSystem in _weaponSystems)
		{
			[weaponSystem shootWithPosition:self.position];
		}
	}

	// TODO move this to missile launcher code
/*	if (fireButton.active
		&& [self missileLauncherReady])
	{
		SFGameObject *nearestTarget = [self findNearestEnemyWithGameObjects:someGameObjects];

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
- (SFGameObject *)findNearestEnemyWithGameObjects:(NSArray *)someGameObjects
{
	for (SFGameObject *gameObject in someGameObjects)
	{
		if ([gameObject isKindOfClass:[SFEnemy class]])
		{
			return gameObject;
		}
	}

	return nil;
}
*/

- (float)healthInPercent
{
    SFHealthComponent *healthComponent = [[SFEntityManager sharedManager] componentOfClass:[SFHealthComponent class] forEntity:_entity];

	return (float) (1.0 / (float) healthComponent.healthMax * (float) healthComponent.health);
}

- (float)shieldInPercent
{
	return (float) (1.0 / (float) _shieldMax * (float) _shield);
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