#import <Foundation/Foundation.h>

@class SneakyButton;
@class SneakyJoystick;
@class SFSpaceship;

@protocol SFGamePlaySceneDelegate <NSObject>

@required
- (void)addPoints:(int)pointsToAdd;

- (void)updateHealthBarWithHealthInPercent:(double)healthInPercent;
- (void)updateShieldBarWithShieldInPercent:(double)shieldInPercent;

- (void)addEntityNodeToGame:(CCNode *)aGameEntity;

- (NSArray *)gameObjects;

- (CGPoint)dPadVelocity;
- (BOOL)firing;

- (void)levelCompleted:(NSUInteger)level;
- (void)gameOver;

@end