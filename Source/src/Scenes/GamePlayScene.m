#import "GamePlayScene.h"
#import "BackgroundLayer.h"
#import "HUDLayer.h"
#import "GamePlayLayer.h"
#import "SneakyButton.h"
#import "SneakyJoystick.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyJoystickSkinnedDPadExample.h"
#import "CCEffectInvert.h"
#import "CCLabelTTF+GameFont.h"
#import "Helper.h"
#import "GameMenuScene.h"
#import "CCAnimation.h"


@interface SFTouchNode : CCNode

@property (nonatomic, weak) id <SFTouchDelegate> delegate;

@end


@implementation SFTouchNode

- (id)init
{
    self = [super init];
    if (self)
    {
        self.userInteractionEnabled = YES;
    }

    return self;
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    [_delegate touchBegan:touch event:event];
}

@end


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
#pragma mark - GamePlaySceneDelegateMethods

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

- (void)gameOver
{
    CCLabelTTF *label = [CCLabelTTF gameLabelWithSize:48.0];
    label.string = @"Game Over";
    label.opacity = 0.0;

    CGSize screenSize = [CCDirector sharedDirector].view.frame.size;

    [_hudLayer addChild:label];
    label.position = ccp((CGFloat) (screenSize.width / 2.0),
                         (CGFloat) (screenSize.height * 0.6666));

    SFTouchNode *touchNode = [[SFTouchNode alloc] init];
    touchNode.delegate = self;

    touchNode.contentSize = screenSize;
    touchNode.anchorPoint = ccp(0.0, 0.0);
    touchNode.position = ccp(0.0, 0.0);

    [self addChild:touchNode z:100];

    CCActionFadeIn *actionFadeIn = [CCActionFadeIn actionWithDuration:0.5];
    [label runAction:actionFadeIn];
}

- (void)touchBegan:(CCTouch *)touch event:(CCTouchEvent *)event
{
    [[CCDirector sharedDirector] replaceScene:[[GameMenuScene alloc] init] withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown
                                                                                                                             duration:0.3]];
}


@end
