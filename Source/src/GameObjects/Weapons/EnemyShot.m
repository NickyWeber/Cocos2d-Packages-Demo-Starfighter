//
//  Created by nickyweber on 24.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EnemyShot.h"
#import "CCAnimation.h"
#import "GameObject+Trigonometry.h"
#import "Constants.h"


@implementation EnemyShot

- (id)initEnemyShotWithStartPosition:(CGPoint)startPosition andTarget:(GameObject *)aTarget
{
	self = [super initWithImageNamed:@"Sprites/Shots/EnemyShot_2.png"];

	if (self)
	{
		self.target = aTarget;
		self.position = startPosition;

		self.speedFactor = 120;
		self.power = 25;

		self.shotVector = [self calcNormalizedShotVector:startPosition
									   andTargetPosition:_target.position];

        CCAnimation *spaceshipAnimation = [CCAnimation animation];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Shots/EnemyShot_1.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Shots/EnemyShot_2.png"];
        spaceshipAnimation.delayPerUnit = (float) (TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER / 2.0);

        CCActionAnimate *spaceshipAnimationAction = [CCActionAnimate actionWithAnimation:spaceshipAnimation];
        spaceshipAnimationAction.duration = 1.0 * TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER;
        spaceshipAnimation.restoreOriginalFrame = YES;
        self.standardAnimation = [CCActionRepeatForever actionWithAction:spaceshipAnimationAction];

        [self runAction:self.standardAnimation];
		[self addBoundingBoxWithRect:CGRectMake(0.0, 0.0, 15.0, 15.0)];
	}

	return self;
}

- (void)updateStateWithTimeDelta:(CCTime)aTimeDelta andGameObjects:(NSArray *)gameObjects
{
	CGPoint newPosition = ccp((CGFloat) (self.position.x + aTimeDelta * _shotVector.x * _speedFactor),
                              (CGFloat) (self.position.y + aTimeDelta * _shotVector.y * _speedFactor));

	[self setPosition:newPosition];

	if ([self isBeyondScreen])
	{
		// NSLog(@"DESPAWNING SHOT @ %f.2 %f.2", self.position.x, self.position.y);
		[self despawn];
	}
}

- (BOOL)isBeyondScreen
{
	float margin = 100.0;

	return    self.position.x > [CCDirector sharedDirector].view.frame.size.width + margin
		   || self.position.x < 0.0 - margin
		   || self.position.y > [CCDirector sharedDirector].view.frame.size.height + margin
		   || self.position.y < 0.0 - margin;
}


#pragma mark -
#pragma mark - Weapon Protocol methods

- (int)damage
{
	return self.isActive
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