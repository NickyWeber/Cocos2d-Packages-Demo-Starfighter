#import "GamePlayScene.h"
#import "BackgroundLayer.h"
#import "HUDLayer.h"
#import "GamePlayLayer.h"
#import "SneakyButton.h"
#import "SneakyJoystick.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyJoystickSkinnedDPadExample.h"

@interface GamePlayScene ()
@property (nonatomic) int gameScore;
@end

@implementation GamePlayScene

- (id)init
{
    self = [super init];

    if (self)
    {
        self.hudLayer = [HUDLayer node];
        [self addChild:_hudLayer z:2];

        self.gamePlayLayer = [[GamePlayLayer alloc] initWithDelegate:self];
        [self addChild:_gamePlayLayer z:1];

        self.backgroundLayer = [BackgroundLayer node];
        [self addChild:_backgroundLayer z:0];
    }

    return self;
}

#pragma mark -
#pragma mark - GamePlaySceneDelegateProtocolMethods

- (void)addPoints:(int)pointsToAdd
{
	self.gameScore += pointsToAdd;

	[_hudLayer gameScoreChanged:_gameScore];
}

- (void)updateHealthBarWithHealthInPercent:(float)healthInPercent
{
	[_hudLayer updateHealthBarWithHealthInPercent:healthInPercent];
}

- (void)updateShieldBarWithShieldInPercent:(float)shieldInPercent
{
	[_hudLayer updateShieldBarWithShieldInPercent:shieldInPercent];
}

- (void)addGameEntity:(CCNode *)aGameEntity
{
	[_gamePlayLayer addGameEntity:aGameEntity];
}

- (Spaceship *)spaceship
{
	return [_gamePlayLayer spaceship];
}

- (NSArray *)gameObjects
{
	return [_gamePlayLayer children];
}

- (SneakyButton *)fireButton
{
    return _hudLayer.fireButton.button;
}

- (SneakyJoystick *)joystick
{
    return _hudLayer.joystick.joystick;
}

@end
