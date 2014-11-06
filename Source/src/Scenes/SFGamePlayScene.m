#import "SFGamePlayScene.h"
#import "SFBackgroundLayer.h"
#import "SFHUDLayer.h"
#import "SFGamePlayLayer.h"
#import "SneakyButton.h"
#import "SneakyJoystick.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyJoystickSkinnedDPadExample.h"
#import "CCEffectInvert.h"
#import "CCLabelTTF+GameFont.h"
#import "SFHelper.h"
#import "SFGameMenuScene.h"
#import "CCAnimation.h"
#import "CCBSequence.h"
#import "SFConstants.h"
#import "SFEntityFactory.h"
#import "SFEntityManager.h"

#if __CC_PLATFORM_MAC
#import "SFKeyEventHandlingDelegate.h"
#import "SFKeyEventHandler.h"
#import "SFGLView.h"
#endif


@interface SFTouchNode : CCNode

@property (nonatomic, weak) id <SFEventDelegate> delegate;

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

#if __CC_PLATFORM_IOS || __CC_PLATFORM_ANDROID
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    [_delegate touchBegan:touch event:event];
}
#elif __CC_PLATFORM_MAC
- (void) mouseDown:(NSEvent *)event
{
    [_delegate mouseDown:event];
}
#endif

@end


@interface SFGamePlayScene ()

@property (nonatomic) int gameScore;


#if __CC_PLATFORM_MAC
@property (nonatomic, strong) SFKeyEventHandler <SFKeyEventHandlingDelegate>* keyEventHandler;
#endif


@end

@implementation SFGamePlayScene

- (id)init
{
    self = [super init];

    if (self)
    {
        self.hudLayer = [SFHUDLayer node];
        [self addChild:_hudLayer z:2];

        self.gamePlayLayer = [[SFGamePlayLayer alloc] initWithDelegate:self entityManager:[SFEntityManager sharedManager]];
        [self addChild:_gamePlayLayer z:1];

        self.backgroundLayer = [SFBackgroundLayer node];
        [self addChild:_backgroundLayer z:0];

        [SFEntityFactory sharedFactory].delegate = self;
        [SFEntityFactory sharedFactory].entityManager = [SFEntityManager sharedManager];

#if __CC_PLATFORM_MAC
        self.keyEventHandler = [[SFKeyEventHandler alloc] init];
        SFGLView *glview = (id) [CCDirector sharedDirector].view;
        glview.keyHandler = _keyEventHandler;
#endif

        [_gamePlayLayer startGame];
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

- (void)updateHealthBarWithHealthInPercent:(double)healthInPercent
{
	[_hudLayer updateHealthBarWithHealthInPercent:healthInPercent];
}

- (void)updateShieldBarWithShieldInPercent:(double)shieldInPercent
{
	[_hudLayer updateShieldBarWithShieldInPercent:shieldInPercent];
}

- (void)addGameNode:(CCNode *)aGameEntity
{
	[_gamePlayLayer addGameEntity:aGameEntity];
}

- (NSArray *)gameObjects
{
	return [_gamePlayLayer children];
}

- (CGPoint)dPadVelocity;
{
    #if __CC_PLATFORM_MAC
    return [_keyEventHandler velocity];
    #else
    return _hudLayer.joystick.joystick.velocity;
    #endif
}

- (BOOL)firing
{
    #if __CC_PLATFORM_MAC
    return [_keyEventHandler firing];
    #else
    return _hudLayer.fireButton.button.active;
    #endif
}

- (void)gameOver
{
    [_gamePlayLayer playerDied];

    CGSize screenSize = [CCDirector sharedDirector].view.frame.size;

    CCLabelTTF *label = [CCLabelTTF gameLabelWithSize:48.0];
    label.string = @"Game Over";
    label.opacity = 0.0;

    [self saveHighscore];

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

- (void)saveHighscore
{
    int highscore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"highscore"] intValue];

    if (_gameScore > highscore)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(_gameScore) forKey:@"highscore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
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
        [self saveHighscore];

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

        label.string = [NSString stringWithFormat:@"Level %lu", level + 1];

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
    [[CCDirector sharedDirector] replaceScene:[[SFGameMenuScene alloc] init] withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown
                                                                                                                             duration:0.3]];
}

- (void)mouseDown:(NSEvent *)event
{
    [[CCDirector sharedDirector] replaceScene:[[SFGameMenuScene alloc] init] withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown                                                                                                                            duration:0.3]];
}

@end
