#import <Foundation/Foundation.h>

@class SneakyJoystickSkinnedDPadExample;
@class SneakyButtonSkinnedBase;


@interface SFHUDLayer : CCNode

@property (nonatomic, strong) CCLabelTTF *scoreLabel;
@property (nonatomic, strong) CCNodeColor *healthBar;
@property (nonatomic, strong) CCNodeColor *shieldBar;

@property (nonatomic, strong) SneakyJoystickSkinnedDPadExample *joystick;
@property (nonatomic, strong) SneakyButtonSkinnedBase *fireButton;

- (void)gameScoreChanged:(int)newGameScore;

- (void)updateHealthBarWithHealthInPercent:(double)healthInPercent;

- (void)updateShieldBarWithShieldInPercent:(double)shieldInPercent;


@end