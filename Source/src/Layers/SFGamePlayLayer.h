#import <Foundation/Foundation.h>

@protocol SFGamePlaySceneDelegate;
@class SFEntityManager;

@interface SFGamePlayLayer : CCNode

@property (nonatomic, weak) id<SFGamePlaySceneDelegate> delegate;
@property (nonatomic, strong) SFEntityManager *entityManager;

- (id)initWithDelegate:(id <SFGamePlaySceneDelegate>)aDelegate entityManager:(SFEntityManager *)entityManager;

- (void)startGame;

- (void)addGameEntity:(CCNode *)aGameEntity;

- (void)advanceToLevel:(NSUInteger)level;

- (void)playerDied;

@end