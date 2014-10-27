//
//  Created by nickyweber on 24.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EnemyShot.h"
#import "CCAnimation.h"
#import "CCActionInterval.h"
#import "GameConfig.h"
#import "CCActionTween.h"
#import "GamePlaySceneDelegateProtocol.h"
#import "Spaceship.h"
#import "GamePlayLayer.h"
#import "CCLine.h"
#import "GameObject+Trigonemetry.h"


@interface EnemyShot ()

- (BOOL)isBeyondScreen;

@end


@implementation EnemyShot


@synthesize speedFactor;
@synthesize power;
@synthesize standardAnimation;
@synthesize shotVector;
@synthesize target;


#pragma mark -
#pragma mark - memory management

- (void)dealloc
{
	[standardAnimation release];

	[super dealloc];
}


#pragma mark -
#pragma mark - initialization

- (id)initEnemyShotWithStartPosition:(CGPoint)startPosition andTarget:(GameObject *)aTarget
{
	self = [super initWithFile:@"EnemyShot_1.png"];

	if (self)
	{
		self.target = aTarget;
		self.position = startPosition;

		speedFactor = 120;
		power = 25;

		self.shotVector = [self calcNormalizedShotVector:startPosition
									   andTargetPosition:CGPointMake(target.position.x - 100.0, target.position.y)];

		CCAnimation *shotAnimation= [CCAnimation animation];

		[shotAnimation addSpriteFrameWithFilename:@"EnemyShot_1.png"];
		[shotAnimation addSpriteFrameWithFilename:@"EnemyShot_2.png"];
		[shotAnimation addSpriteFrameWithFilename:@"EnemyShot_2.png"];
		id shotAnimationAction = [CCAnimate actionWithDuration:2.0 * TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER
		                                             animation:shotAnimation
									      restoreOriginalFrame:YES];

		self.standardAnimation = [CCRepeatForever actionWithAction:shotAnimationAction];

		[self runAction:self.standardAnimation];


		[self addBoundingBoxWithRect:CGRectMake(0.0, 0.0, 15.0, 15.0)];
	}

	return self;
}

- (void)updateStateWithTimeDelta:(ccTime)aTimeDelta andGameObjects:(CCArray *)gameObjects
{
	CGPoint newPosition = CGPointMake(self.position.x + aTimeDelta * shotVector.x * speedFactor,
									  self.position.y + aTimeDelta * shotVector.y * speedFactor);

	[self setPosition:newPosition];

	if ([self isBeyondScreen])
	{
		// NSLog(@"DESPAWNING SHOT @ %f.2 %f.2", self.position.x, self.position.y);
		[self despawn];
	}
}

- (BOOL)isBeyondScreen
{
	float graceBuffer = 20.0;

	return    self.position.x > 320.0 + graceBuffer
		   || self.position.x < 0.0 - graceBuffer
		   || self.position.y > 480.0 + graceBuffer
		   || self.position.y < 0.0 - graceBuffer;
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
	return YES;
}

- (void)weaponHitTarget
{
	[self despawn];
}


@end