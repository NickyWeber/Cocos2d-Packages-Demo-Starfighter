#import "SFGamePlaySceneDelegate.h"
#import "SFConstants.h"
#import "SFPointLoot.h"
#import "SFGamePlayLayer.h"
#import "SFSpaceship.h"
#import "CCAnimation.h"
#import "SFLoot.h"


@interface SFLoot ()
{
    BOOL fadingOut;
    float timeSinceSpawning;
}

@end


@implementation SFLoot


- (id)initWithBaseFrameName:(NSString *)baseFrameName delegate:(id)aDelegate
{
	self = [super initWithImageNamed:baseFrameName];

	if (self)
	{
		NSAssert(aDelegate != nil, @"Delegate has to be set!");
		NSAssert([aDelegate conformsToProtocol:@protocol(SFGamePlaySceneDelegate)], @"Delegate has to conform to SFGamePlaySceneDelegate");

		self.delegate = aDelegate;

		timeSinceSpawning = 0.0;
		fadingOut = NO;
	}

	return self;
}

- (void)updateStateWithTimeDelta:(CCTime)aTimeDelta andGameObjects:(NSArray *)gameObjects
{
	SFSpaceship *spaceship = [_delegate spaceship];

	if ([self detectCollisionWithGameObject:spaceship])
	{
		[self collectedByPlayer];
	}
	else if (timeSinceSpawning >= _lifeTime - _fadeoutTime)
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

    CCActionFadeOut *actionFadeOut = [[CCActionFadeOut alloc] initWithDuration:_fadeoutTime];

	id sequence = [CCActionSequence actions:actionFadeOut,
                                            [CCActionCallFunc actionWithTarget:self selector:@selector(despawn)],
									        nil];

	[self runAction:sequence];
}

- (void)collectedByPlayer
{
    [self applyReward];

	self.isActive = NO;

    [self removeFromParentAndCleanup:YES];
}

- (void)applyReward
{
    NSAssert(NO, @"Override me!");
}

@end