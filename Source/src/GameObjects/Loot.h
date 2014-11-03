#import <Foundation/Foundation.h>
#import "GameObject.h"

@class CCRepeatForever;
@protocol GamePlaySceneDelegate;


@interface Loot : GameObject

@property (nonatomic, weak) id<GamePlaySceneDelegate> delegate;
@property (nonatomic) float lifeTime;
@property (nonatomic) float fadeoutTime;

- (id)initWithBaseFrameName:(NSString *)baseFrameName delegate:(id)aDelegate;

- (void)applyReward;

@end