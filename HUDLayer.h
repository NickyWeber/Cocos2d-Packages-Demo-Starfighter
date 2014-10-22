#import <Foundation/Foundation.h>


@interface HUDLayer : CCNode

@property (nonatomic, strong) CCLabelTTF *scoreLabel;
@property (nonatomic, strong) CCNodeColor *healthBar;
@property (nonatomic, strong) CCNodeColor *shieldBar;

/*
@property (nonatomic, retain) SneakyJoystickSkinnedBase *joystick;
@property (nonatomic, retain) SneakyButtonSkinnedBase *fireButton;
*/

@end