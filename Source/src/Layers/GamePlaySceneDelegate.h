#import <Foundation/Foundation.h>

@class SneakyButton;
@class SneakyJoystick;
@class Spaceship;

@protocol GamePlaySceneDelegate <NSObject>

@required
- (void)addPoints:(int)pointsToAdd;

- (void)updateHealthBarWithHealthInPercent:(float)healthInPercent;
- (void)updateShieldBarWithShieldInPercent:(float)shieldInPercent;

- (void)addGameEntity:(CCNode *)aGameEntity;

- (NSArray *)gameObjects;

- (Spaceship *)spaceship;

- (SneakyButton *)fireButton;
- (SneakyJoystick *)joystick;

- (void)levelCompleted:(NSUInteger)level;

@end