#import <Foundation/Foundation.h>

@class SneakyButton;
@class SneakyJoystick;
@class SFSpaceship;

@protocol SFGamePlaySceneDelegate <NSObject>

@required
- (void)addPoints:(int)pointsToAdd;

- (void)updateHealthBarWithHealthInPercent:(double)healthInPercent;
- (void)updateShieldBarWithShieldInPercent:(float)shieldInPercent;

- (void)addGameEntity:(CCNode *)aGameEntity;

- (NSArray *)gameObjects;

- (SFSpaceship *)spaceship;

- (CGPoint)dPadVelocity;
- (BOOL)firing;

- (void)levelCompleted:(NSUInteger)level;

@end