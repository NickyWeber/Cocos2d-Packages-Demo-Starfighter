#import <Foundation/Foundation.h>
#import "GamePlaySceneDelegate.h"

@class BackgroundLayer;
@class HUDLayer;
@class GamePlayLayer;


@interface GamePlayScene : CCScene  <GamePlaySceneDelegate>

@property (nonatomic, strong) BackgroundLayer *backgroundLayer;
@property (nonatomic, strong) HUDLayer *hudLayer;
@property (nonatomic, strong) GamePlayLayer *gamePlayLayer;

@end