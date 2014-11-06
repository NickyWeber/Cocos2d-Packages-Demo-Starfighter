#import <Foundation/Foundation.h>

@protocol SFGamePlaySceneDelegate;
@class SFSpaceship;
@class SFMoveSystem;


@interface SFGamePlayLayer : CCNode

@property (nonatomic, weak) id<SFGamePlaySceneDelegate> delegate;
@property (nonatomic, strong) SFSpaceship *spaceship;

- (id)initWithDelegate:(id<SFGamePlaySceneDelegate>)aDelegate;

- (void)startGame;

- (void)disableGameObjectsAndControls;

- (void)addGameEntity:(CCNode *)aGameEntity;

- (void)advanceToLevel:(NSUInteger)level;

- (void)playerDied;
@end