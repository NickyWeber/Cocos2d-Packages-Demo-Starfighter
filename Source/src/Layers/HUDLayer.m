#import "HUDLayer.h"
#import "SneakyJoystickSkinnedDPadExample.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyButton.h"


@implementation HUDLayer

- (id)init
{
    self = [super init];

    if (self)
    {
        [self setupScoreLabel];

        [self setupHealthBar];

        [self setupShieldBar];

        [self initialiseUserControls];
    }

    return self;
}

- (void)setupShieldBar
{
    CGSize displaySize = [CCDirector sharedDirector].view.frame.size;

    self.shieldBar = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.0 green:1.0 blue:1.0]];
    _shieldBar.contentSize = CGSizeMake(160.0, 3.0);
    _shieldBar.position = CGPointMake(0.0, (CGFloat) (displaySize.height - 7.0));
    _shieldBar.anchorPoint = CGPointMake(0.0, 0.0);
    [self addChild:_shieldBar];
}

- (void)setupHealthBar
{
    CGSize displaySize = [CCDirector sharedDirector].view.frame.size;

    self.healthBar = [CCNodeColor nodeWithColor:[CCColor colorWithRed:1.0 green:0.0 blue:0.0]];
    _healthBar.contentSize = CGSizeMake(160.0, 3.0);
    _healthBar.position = CGPointMake(0.0, (CGFloat) (displaySize.height - 3.0));
    _healthBar.anchorPoint = CGPointMake(0.0, 0.0);
    [self addChild:_healthBar];
}

- (void)setupScoreLabel
{
    CGSize displaySize = [CCDirector sharedDirector].view.frame.size;

    self.scoreLabel = [CCLabelTTF labelWithString:@"1000"
                                             fontName:@"Courier-Bold"
                                             fontSize:24.0];

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
	[_joystick setPosition:CGPointMake(_joystick.contentSize.width / 2, _joystick.contentSize.height / 2)];
	[self addChild:_joystick];

	// Fire button
	self.fireButton = [[SneakyButtonSkinnedBase alloc] init];
	_fireButton.position = CGPointMake((CGFloat) (displaySize.width - 42.0), 42.0);
	_fireButton.defaultSprite = [CCSprite spriteWithImageNamed:@"Sprites/Controls/Firebutton_default.png"];
	_fireButton.pressSprite = [CCSprite spriteWithImageNamed:@"Sprites/Controls/Firebutton_pressed.png"];
	_fireButton.button = [[SneakyButton alloc] initWithRect:CGRectMake(0, 0, 64, 64)];
	_fireButton.button.isToggleable = NO;
	_fireButton.button.isHoldable = YES;

	[self addChild:_fireButton];
}

- (void)gameScoreChanged:(int)newGameScore
{
	self.scoreLabel.string = [NSString stringWithFormat:@"%d", newGameScore];
}

- (void)updateHealthBarWithHealthInPercent:(float)healthInPercent
{
	float newHealthInPercent = MAX(0, MIN(healthInPercent, 1.0));

	_healthBar.position = CGPointMake(0.0, 239.0);

	_healthBar.contentSize = CGSizeMake((CGFloat) (160.0 * newHealthInPercent), 1.0);
}

- (void)updateShieldBarWithShieldInPercent:(float)shieldInPercent
{
	float newShieldInPercent = MAX(0, MIN(shieldInPercent, 1.0));

	_shieldBar.position = CGPointMake(0.0, 237.0);

	_shieldBar.contentSize = CGSizeMake((CGFloat) (160.0 * newShieldInPercent), 1.0);
}

@end
