//
//  Created by nickyweber on 24.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CCAction.h"
#import "CCAnimation.h"
#import "CCActionInterval.h"
#import "Spaceship.h"
#import "GamePlayLayer.h"
#import "PointLoot.h"
#import "Constants.h"
#import "GamePlaySceneDelegate.h"
#import "CCAnimationCache.h"


static float LIFETIME_OF_LOOT = 5.0;
static float FADEOUT_TIME = 2.0;
static int AWARD_POINTS = 100;


@interface PointLoot()

@property (nonatomic, strong) CCActionRepeatForever *standardAnimation;

@end

@implementation PointLoot

- (id)initWithDelegate:(id)aDelegate
{
	self = [super initWithImageNamed:@"Sprites/Loot/CashLoot_1.png"];

	if (self)
	{
		NSAssert(aDelegate != nil, @"Delegate has to be set!");
		NSAssert([aDelegate conformsToProtocol:@protocol(GamePlaySceneDelegate)], @"Delegate has to conform to GamePlaySceneDelegateProtocol!");

		self.delegate = aDelegate;

		timeSinceSpawning = 0.0;
		fadingOut = NO;

        CCAnimation *spaceshipAnimation = [CCAnimation animation];

        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_1.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_2.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_3.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_4.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_5.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_4.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_3.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_2.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_1.png"];

        spaceshipAnimation.delayPerUnit = (float) (TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER / 5.0);

        CCActionAnimate *spaceshipAnimationAction = [CCActionAnimate actionWithAnimation:spaceshipAnimation];
        spaceshipAnimationAction.duration = 1.0 * TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER;
        spaceshipAnimation.restoreOriginalFrame = YES;
        self.standardAnimation = [CCActionRepeatForever actionWithAction:spaceshipAnimationAction];

        [self runAction:self.standardAnimation];

		[self addBoundingBoxWithRect:CGRectMake(0.0, 0.0, 22.0, 28.0)];
	}

	return self;
}

- (void)updateStateWithTimeDelta:(CCTime)aTimeDelta andGameObjects:(NSArray *)gameObjects
{
	Spaceship *spaceship = [_delegate spaceship];
	
	if ([self detectCollisionWithGameObject:spaceship])
	{
		[_delegate addPoints:AWARD_POINTS];
		[self collectedByPlayer];
	}
	else if (timeSinceSpawning >= LIFETIME_OF_LOOT - FADEOUT_TIME)
	{
		if ( ! fadingOut)
		{
			[self fadeOut];
		}
	}

	timeSinceSpawning += aTimeDelta;
}

- (void)fadeOut
{
	fadingOut = YES;

    CCActionFadeOut *actionFadeOut = [[CCActionFadeOut alloc] initWithDuration:FADEOUT_TIME];

	id sequence = [CCActionSequence actions:actionFadeOut,
									  [CCActionCallFunc actionWithTarget:self selector:@selector(despawn)],
									  nil];

	[self runAction:sequence];
}

- (void)collectedByPlayer
{
	self.isActive = NO;

    [self removeFromParentAndCleanup:YES];
}

@end
