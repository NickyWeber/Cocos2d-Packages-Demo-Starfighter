#import <Foundation/Foundation.h>

@protocol GamePlaySceneDelegate;
@class Spaceship;


@interface GamePlayLayer : CCNode

@property (nonatomic, weak) id<GamePlaySceneDelegate> delegate;
@property (nonatomic, strong) Spaceship *spaceship;

- (id)initWithDelegate:(id<GamePlaySceneDelegate>)aDelegate;

- (void)addGameEntity:(CCNode *)aGameEntity;
- (void)addGameEntity:(CCNode *)aGameEntity z:(int)zOrder;

@end