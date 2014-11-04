#import <Foundation/Foundation.h>
#import "SFHUDLayer.h"
#import "SneakyJoystickSkinnedDPadExample.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyButton.h"
#import "CCBSequence.h"
#import "CCEffectInvert.h"


@interface SFHUDLayer ()
@property (nonatomic, strong) CCActionRepeatForever *healthFlickerAction;
@end

@implementation SFHUDLayer

- (id)init
{
    self = [super init];

    if (self)
    {
        [self setupScoreLabel];

        [self setupHealthBar];

        [self setupShieldBar];

        #if !__CC_PLATFORM_MAC
        [self initialiseUserControls];
        #endif
    }

    return self;
}

- (void)setupShieldBar
{
    CGSize displaySize = [CCDirector sharedDirector].view.frame.size;

    self.shieldBar = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.0 green:1.0 blue:1.0]];
    _shieldBar.contentSize = CGSizeMake(displaySize.width, 3.0);
    _shieldBar.position = CGPointMake(0.0, (CGFloat) (displaySize.height - 7.0));
    _shieldBar.anchorPoint = CGPointMake(0.0, 0.0);
    [self addChild:_shieldBar];
}

- (void)setupHealthBar
{
    CGSize displaySize = [CCDirector sharedDirector].view.frame.size;

    self.healthBar = [CCNodeColor nodeWithColor:[CCColor colorWithRed:1.0 green:0.0 blue:0.0]];
    _healthBar.contentSize = CGSizeMake(displaySize.width, 3.0);
    _healthBar.position = CGPointMake(0.0, (CGFloat) (displaySize.height - 3.0));
    _healthBar.anchorPoint = CGPointMake(0.0, 0.0);
    [self addChild:_healthBar];

    self.healthFlickerAction = [CCActionRepeatForever actionWithAction:[CCActionBlink actionWithDuration:0.2 blinks:1]];
    _healthFlickerAction.tag = 1000;
}

- (void)setupScoreLabel
{
    CGSize displaySize = [CCDirector sharedDirector].view.frame.size;

    self.scoreLabel = [CCLabelTTF labelWithString:@"1234"
                                         fontName:@"Courier-Bold"
                                         fontSize:24.0];


    CCEffectStack *effectStack = [[CCEffectStack alloc] initWithEffects:[[CCEffectInvert alloc] init], [CCEffectPixellate effectWithBlockSize:2.0], nil];
    _scoreLabel.effect = effectStack;

    _scoreLabel.horizontalAlignment = CCTextAlignmentRight;
    _scoreLabel.anchorPoint = CGPointMake(0.0, 0.0);
    _scoreLabel.position = CGPointMake(0.0, (CGFloat) (displaySize.height - _scoreLabel.contentSize.height - 2.0));

    [self addChild:self.scoreLabel];
}

- (void)initialiseUserControls
{
    CGSize displaySize = [CCDirector sharedDirector].view.frame.size;

	// DPad
	self.joystick = [[SneakyJoystickSkinnedDPadExample alloc] init];
    _joystick.anchorPoint = ccp(0.0, 0.0);
    _joystick.position = ccp(62.0, 62.0);
	[self addChild:_joystick];

	// Fire button
	self.fireButton = [[SneakyButtonSkinnedBase alloc] init];
	_fireButton.defaultSprite = [CCSprite spriteWithImageNamed:@"Sprites/Controls/Firebutton_default.png"];
	_fireButton.pressSprite = [CCSprite spriteWithImageNamed:@"Sprites/Controls/Firebutton_pressed.png"];
	_fireButton.button = [[SneakyButton alloc] initWithRect:CGRectMake(0, 0, 64, 64)];
	_fireButton.button.isToggleable = NO;
	_fireButton.button.isHoldable = YES;
	_fireButton.position = ccp((CGFloat) (displaySize.width - 56.0), 56.0);
    _fireButton.anchorPoint = ccp(0.0, 0.0);

	[self addChild:_fireButton];
}

- (void)gameScoreChanged:(int)newGameScore
{
	self.scoreLabel.string = [NSString stringWithFormat:@"%d", newGameScore];
}

- (void)updateHealthBarWithHealthInPercent:(float)healthInPercent
{
    id action = [_healthBar getActionByTag:1000];

    if (healthInPercent <= 0.2 && !action)
    {
        [_healthBar runAction:_healthFlickerAction];
    }
    else if (healthInPercent > 0.2 && action)
    {
        [_healthBar stopAction:_healthFlickerAction];
    }

    CGSize displaySize = [CCDirector sharedDirector].view.frame.size;

	float newHealthInPercent = MAX(0, MIN(healthInPercent, 1.0));

	// _healthBar.position = CGPointMake(0.0, 239.0);
	_healthBar.contentSize = CGSizeMake((CGFloat) (displaySize.width * newHealthInPercent), _shieldBar.contentSize.height);
}

- (void)updateShieldBarWithShieldInPercent:(float)shieldInPercent
{
    CGSize displaySize = [CCDirector sharedDirector].view.frame.size;

	float newShieldInPercent = MAX(0, MIN(shieldInPercent, 1.0));

	// _shieldBar.position = CGPointMake(0.0, 237.0);
	_shieldBar.contentSize = CGSizeMake((CGFloat) (displaySize.width * newShieldInPercent), _shieldBar.contentSize.height);
}

@end
