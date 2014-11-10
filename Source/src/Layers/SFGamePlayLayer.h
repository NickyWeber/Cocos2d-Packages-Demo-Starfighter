#import <Foundation/Foundation.h>

@protocol SFGamePlaySceneDelegate;
@class SFEntityManager;
@class SFLevel;

@interface SFGamePlayLayer : CCNode

@property (nonatomic, weak) id<SFGamePlaySceneDelegate> delegate;
@property (nonatomic, strong) SFEntityManager *entityManager;

- (id)initWithDelegate:(id <SFGamePlaySceneDelegate>)aDelegate entityManager:(SFEntityManager *)entityManager startLevel:(SFLevel *)startLevel;

- (void)startGame;

- (void)addGameEntity:(CCNode *)aGameEntity;

- (void)advanceToLevel:(SFLevel *)level;

- (void)playerDied;

@end