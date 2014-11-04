#import <Foundation/Foundation.h>
#import "SFGameObject.h"

@class CCRepeatForever;
@protocol SFGamePlaySceneDelegate;


@interface SFLoot : SFGameObject

@property (nonatomic, weak) id<SFGamePlaySceneDelegate> delegate;
@property (nonatomic) float lifeTime;
@property (nonatomic) float fadeoutTime;

- (id)initWithBaseFrameName:(NSString *)baseFrameName delegate:(id)aDelegate;

- (void)applyReward;

@end