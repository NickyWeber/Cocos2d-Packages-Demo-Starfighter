#import <Foundation/Foundation.h>

@protocol GamePlaySceneDelegate;


@interface GamePlayLayer : CCNode

@property (nonatomic, weak) id<GamePlaySceneDelegate> delegate;

- (id)initWithDelegate:(id<GamePlaySceneDelegate>)aDelegate;

@end