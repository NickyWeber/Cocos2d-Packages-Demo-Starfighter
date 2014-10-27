//
//  Created by nickyweber on 27.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "HomingMissile.h"

#import "CCActionInterval.h"
#import "GameConfig.h"
#import "CCActionTween.h"
#import "Spaceship.h"
#import "GamePlayLayer.h"
#import "CCLine.h"
#import "GameObject+Trigonemetry.h"
#import "Enemy.h"

@interface HomingMissile ()

- (BOOL)isBeyondScreen;
- (void)alignSelfRotationToShotVector;
- (void)turnShotTowardsSpaceshipWithTimeDelta:(ccTime)aTimeDelta;
- (void)testIfBeyondScreenOrRanOutOfFuelThenDespawn;
- (void)explode;

// Targeting stuff
- (void)acquireNewTargetIfPossible;
- (void)addListenerToNotificationCenterForTargetDestroyed;
- (void)targetDestroyed:(NSNotification *)notification;
- (GameObject *)nearestTargetWithGameObjects:(CCArray *)someGameObjects;

@end


@implementation HomingMissile


@synthesize speedFactor;
@synthesize power;
@synthesize standardAnimation;
@synthesize shotVector;
@synthesize debugShotVectorLine;
@synthesize debugMissileTargetVector;
@synthesize target;
@synthesize damagesPlayer;
@synthesize degreesPerSecond;
@synthesize fuelLastingInSeconds;
@synthesize canAcquireNewTarget;
@synthesize delegate;




#pragma mark -
#pragma mark - Memory Management

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[standardAnimation release];
	[debugShotVectorLine release];
	[debugMissileTargetVector release];
	[target release];

	[super dealloc];
}


#pragma mark -
#pragma mark - Initialization

- (id)initWithFile:(NSString *)aFile animationFrames:(NSArray *)someAnimationFrames delegate:(id <GamePlaySceneDelegateProtocol>)aDelegate
{
	self = [super initWithFile:aFile];

	if (self)
	{
		NSAssert(aDelegate != nil, @"Delegate has to be set!");
		NSAssert([aDelegate conformsToProtocol:@protocol(GamePlaySceneDelegateProtocol)], @"Delegate has to conform to GamePlaySceneDelegateProtocol!");

		self.delegate = delegate;

		CCAnimation *shotAnimation= [CCAnimation animation];

		for (NSString *animationFrame in someAnimationFrames)
		{
			[shotAnimation addSpriteFrameWithFilename:animationFrame];
		}
		
		lostTarget = NO;
		[self addListenerToNotificationCenterForTargetDestroyed];

		id shotAnimationAction = [CCAnimate actionWithDuration:2.0 * TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER
													 animation:shotAnimation
										  restoreOriginalFrame:YES];

		self.standardAnimation = [CCRepeatForever actionWithAction:shotAnimationAction];

		[self runAction:self.standardAnimation];
	}

	return self;
}

- (void)addListenerToNotificationCenterForTargetDestroyed
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(targetDestroyed:)
												 name:@"TargetDestroyed"
											   object:nil];
}


#pragma mark -
#pragma mark - Factory Methods

+ (HomingMissile *)enemyHomingMissileWithStartPosition:(CGPoint)aStartPosition
									   andTargetObject:(GameObject *)aGameObject
											  delegate:(id <GamePlaySceneDelegateProtocol>)aDelegate
{
	NSArray *animationFrames = [NSArray arrayWithObjects:@"EnemyMissile_1.png",
										                 @"EnemyMissile_2.png",
										                 @"EnemyMissile_3.png",
														 nil];

	HomingMissile *missile = [[HomingMissile alloc] initWithFile:@"EnemyMissile_1.png" animationFrames:animationFrames delegate:aDelegate];

	missile.power = 25;
	missile.fuelLastingInSeconds = 5.5;
	missile.speedFactor = 170;
	missile.degreesPerSecond = 120.0;
	missile.damagesPlayer = YES;

	[missile addBoundingBoxWithRect:CGRectMake(0.0, 15.0, 15.0, 27.0)];

	[missile setStartPosition:aStartPosition andTarget:aGameObject];

	return [missile autorelease];
}

+ (HomingMissile *)playerHomingMissileWithStartPosition:(CGPoint)aStartPosition
										andTargetObject:(GameObject *)aGameObject
											   delegate:(id <GamePlaySceneDelegateProtocol>)aDelegate
{
	NSArray *animationFrames = [NSArray arrayWithObjects:@"Missile_1.png",
										                 @"Missile_2.png",
										                 @"Missile_3.png",
														 nil];

	HomingMissile *missile = [[HomingMissile alloc] initWithFile:@"Missile_1.png"
												 animationFrames:animationFrames
														delegate:aDelegate];

	missile.power = 100;
	missile.fuelLastingInSeconds = 5.5;
	missile.speedFactor = 250;
	missile.degreesPerSecond = 180.0;
	missile.damagesPlayer = NO;

	[missile addBoundingBoxWithRect:CGRectMake(0.0, 10.0, 10.0, 18.0)];

	[missile setStartPosition:aStartPosition andTarget:aGameObject];

	return [missile autorelease];
}


#pragma mark -
#pragma mark - Setter

- (void)setStartPosition:(CGPoint)aStartPosition andTarget:(GameObject *)aGameObject
{
	self.position = aStartPosition;
	self.target = aGameObject;

	self.shotVector = [self calcNormalizedShotVector:aStartPosition
								   andTargetPosition:CGPointMake(target.position.x, target.position.y)];
}


#pragma mark -
#pragma mark - Behaviour

- (void)turnShotTowardsSpaceshipWithTimeDelta:(ccTime)aTimeDelta
{
	if (lostTarget)
	{
		return;
	}

	float turnDegrees = aTimeDelta * degreesPerSecond;

	// NSLog(@"roration %.2f", rotation_);

	CGPoint foo = target.position;

/*
	// DEBUG
	CGPoint correctVectorForRotation = [self rotateVector:shotVector byDegrees:self.rotation];
	shotVectorLine.p1 = ccp(self.textureRect.size.width  / 2, self.textureRect.size.height  / 2);
	shotVectorLine.p2 = ccp(shotVectorLine.p1.x + 50 * correctVectorForRotation.x, shotVectorLine.p1.y + 50 * correctVectorForRotation.y);
	// END OF DEBUG
*/


	CGPoint missileToTargetVector = CGPointMake(foo.x - self.position.x, foo.y - self.position.y);

	float angle = [self angleBetweenTwoVectors:shotVector vectorB:missileToTargetVector];

	// adjust turn direction depending on whether the angle is negative or positive
	if (angle < 0) {
		turnDegrees *= -1.0;
	}

	// rotate only if angle is above threshold, else the missile will get jiggy
	if (angle > 0.5 || angle < -0.5)
	{
		self.shotVector = [self rotateVector:shotVector byDegrees:turnDegrees];
	}

	[self alignSelfRotationToShotVector];
}

- (void)alignSelfRotationToShotVector
{
	self.rotation = [self angleBetweenTwoVectors:shotVector vectorB:CGPointMake(0.0, 1.0)];
}

- (void)updatePositionWithTimeDelta:(ccTime)aTimeDelta
{
	CGPoint newPosition = CGPointMake(self.position.x + aTimeDelta * shotVector.x * speedFactor,
									  self.position.y + aTimeDelta * shotVector.y * speedFactor);

	// NSLog(@"new pos: %.2f %.2f", self.position.x, self.position.y);

	[self setPosition:newPosition];
}

- (void)updateStateWithTimeDelta:(ccTime)aTimeDelta andGameObjects:(CCArray *)gameObjects
{
	[self turnShotTowardsSpaceshipWithTimeDelta:aTimeDelta];

	[self updatePositionWithTimeDelta:aTimeDelta];

	fuelLastingInSeconds -= aTimeDelta;

	[self testIfBeyondScreenOrRanOutOfFuelThenDespawn];

	// NSLog(@"%p - x:%f.2 y:%f.2 - %f", self, self.position.x, self.position.y, aTimeDelta);
}

- (void)testIfBeyondScreenOrRanOutOfFuelThenDespawn
{
	if ([self isBeyondScreen])
	{
		// NSLog(@"DESPAWNING SHOT @ %f.2 %f.2", self.position.x, self.position.y);
		[self despawn];
	}
	else if (fuelLastingInSeconds <= 0.0)
	{
		// NSLog(@"Missile ran out of fuel! Awwwww.");
		[self explode];
	}
}

- (BOOL)isBeyondScreen
{
	float graceBuffer = 100.0;

	return    self.position.x > 320.0 + graceBuffer
		   || self.position.x < 0.0 - graceBuffer
		   || self.position.y > 480.0 + graceBuffer
		   || self.position.y < 0.0 - graceBuffer;
}


#pragma mark -
#pragma mark - Actions

- (void)explode
{
	self.isActive = NO;

	CCAnimate *explosionAnimationAction_ = [CCAnimate actionWithDuration:1.3 * TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER
										  					   animation:[[CCAnimationCache sharedAnimationCache] animationByName:@"Explosion"]
												    restoreOriginalFrame:YES];

	id sequence = [CCSequence actions:explosionAnimationAction_,
									  [CCCallFunc actionWithTarget:self selector:@selector(despawn)],
									  nil];

	[self runAction:sequence];
}

- (void)targetDestroyed:(NSNotification *)notification
{
	if (self.isActive && [notification object] == self.target)
	{
		NSLog(@"Homing Missile lost target!");

		self.target = nil;

		lostTarget = YES;

		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:@"TargetDestroyed"
													  object:nil];
		
		[self acquireNewTargetIfPossible];
	}
}

- (void)acquireNewTargetIfPossible
{
	if (self.canAcquireNewTarget)
	{
		GameObject *newTarget = [self nearestTargetWithGameObjects:[delegate gameObjects]];

		if (newTarget && newTarget.isActive)
		{
			NSLog(@"Acquired new target! %@", newTarget);

			self.target = newTarget;
			lostTarget = NO;
			[self addListenerToNotificationCenterForTargetDestroyed];
		}
	}
}

- (GameObject *)nearestTargetWithGameObjects:(CCArray *)someGameObjects
{
	float closestDistance = 100000000.0f;
	GameObject *result = nil;
	
	for (GameObject *gameObject in someGameObjects)
	{
		if (damagesPlayer && [gameObject isKindOfClass:[Spaceship class]]
			|| ( ! damagesPlayer && [gameObject isKindOfClass:[Enemy class]]))
		{
			float distanceToGameObject = [self distanceToPoint:gameObject.position];
			if (distanceToGameObject < closestDistance)
			{
				closestDistance = distanceToGameObject;
				result = gameObject;
			}
		}

	}
	return result;
}




#pragma mark -
#pragma mark - Weapon Protocol methods

- (int)damage
{
	return isActive
		? self.power
		: 0;
}

- (BOOL)damagesSpaceship
{
	return damagesPlayer;
}

- (void)weaponHitTarget
{
	[self explode];
}





@end