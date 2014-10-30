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
#import "CCBSequence.h"
#import "Constants.h"


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
    [_gamePlayLayer disableGameObjectsAndControls];

    CGSize screenSize = [CCDirector sharedDirector].view.frame.size;

    CCLabelTTF *label = [CCLabelTTF gameLabelWithSize:48.0];
    label.string = @"Game Over";
    label.opacity = 0.0;


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

    [self showTapToContinueLabel];
}

- (void)showTapToContinueLabel
{
    CCLabelTTF *label2 = [self tapToContinueLabel];

    [_hudLayer addChild:label2];

    [label2 runAction:[self actionShowAfterDelayAndPulse:label2]];
}

- (CCLabelTTF *)tapToContinueLabel
{
    CGSize screenSize = [CCDirector sharedDirector].view.frame.size;

    CCLabelTTF *label2 = [CCLabelTTF gameLabelWithSize:20.0 blockSize:2.0];
    label2.string = @"(tap to continue)";
    label2.opacity = 0.0;
    label2.position = ccp((CGFloat) (screenSize.width / 2.0),
                         (CGFloat) (screenSize.height * 0.6666 - 40.0));

    return label2;
}

- (id)actionShowAfterDelayAndPulse:(id)label
{
    CCActionFadeIn *actionFadeIn2 = [[CCActionFadeIn alloc] initWithDuration:0.3];

    CCActionFadeTo *actionFadeTo = [[CCActionFadeTo alloc] initWithDuration:1.0 opacity:0.2];
    CCActionEaseBackIn *actionEaseBackIn = [[CCActionEaseBackIn alloc] initWithAction:actionFadeTo];

    CCActionFadeTo *actionFadeTo2 = [[CCActionFadeTo alloc] initWithDuration:1.0 opacity:0.60];
    CCActionEaseBackOut *actionEaseBackOut2 = [[CCActionEaseBackOut alloc] initWithAction:actionFadeTo2];

    CCActionSequence *sequence = [CCActionSequence actions:actionEaseBackIn, actionEaseBackOut2, nil];
    CCActionRepeatForever *actionRepeatForever = [[CCActionRepeatForever alloc] initWithAction:sequence];


    CCActionSequence *sequence2 = [CCActionSequence actions:actionFadeIn2, [CCActionCallBlock actionWithBlock:^{
        [label runAction:actionRepeatForever];
    }], nil];

    return sequence2;
}

- (void)levelCompleted:(NSUInteger)level
{
    CGSize screenSize = [CCDirector sharedDirector].view.frame.size;

    CCLabelTTF *label;

    CCActionFadeIn *actionFadeIn = [CCActionFadeIn actionWithDuration:0.5];
    CCActionSequence *sequence;

    if (level == GAME_LEVEL_MAX)
    {
        [_gamePlayLayer disableGameObjectsAndControls];

        label = [CCLabelTTF gameLabelWithSize:24.0 blockSize:2.0];
        label.string = @"Congratulations!!!\nYou won!";
        label.position = ccp((CGFloat) (screenSize.width / 2.0),
                             (CGFloat) (screenSize.height * 0.75));

        sequence = [CCActionSequence actions:actionFadeIn,
                                             [CCActionCallBlock actionWithBlock:^{
                                                 SFTouchNode *touchNode = [[SFTouchNode alloc] init];
                                                 touchNode.delegate = self;
                                                 touchNode.contentSize = screenSize;
                                                 touchNode.anchorPoint = ccp(0.0, 0.0);
                                                 touchNode.position = ccp(0.0, 0.0);
                                                 [self addChild:touchNode z:100];
                                             }], nil];

        [self showTapToContinueLabel];
    }
    else
    {
        label = [CCLabelTTF gameLabelWithSize:36.0];
        label.position = ccp((CGFloat) (screenSize.width / 2.0),
                             (CGFloat) (screenSize.height * 0.6666));

        label.string = [NSString stringWithFormat:@"Level %u", level + 1];

        sequence = [CCActionSequence actions:actionFadeIn,
                                             [CCActionDelay actionWithDuration:5.0],
                                             [label runAction:[CCActionFadeOut actionWithDuration:0.3]],
                                             [CCActionCallBlock actionWithBlock:^{
                                                 [label removeFromParentAndCleanup:YES];
                                             }],
                                             [CCActionCallBlock actionWithBlock:^{
                                                 [_gamePlayLayer advanceToLevel:level + 1];
                                             }], nil];
    }

    label.opacity = 0.0;
    label.anchorPoint = ccp(0.5, 0.5);
    label.horizontalAlignment = CCTextAlignmentCenter;

    [_hudLayer addChild:label];
    [label runAction:sequence];
}

- (void)touchBegan:(CCTouch *)touch event:(CCTouchEvent *)event
{
    [[CCDirector sharedDirector] replaceScene:[[GameMenuScene alloc] init] withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown
                                                                                                                             duration:0.3]];
}


@end
