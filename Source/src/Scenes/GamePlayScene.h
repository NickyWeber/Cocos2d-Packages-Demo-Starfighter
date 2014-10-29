#import <Foundation/Foundation.h>
#import "GamePlaySceneDelegate.h"

@protocol SFTouchDelegate

- (void)touchBegan:(CCTouch *)touch event:(CCTouchEvent *)event;

@end


@class BackgroundLayer;
@class HUDLayer;
@class GamePlayLayer;


@interface GamePlayScene : CCScene  <GamePlaySceneDelegate, SFTouchDelegate>

@property (nonatomic, strong) BackgroundLayer *backgroundLayer;
@property (nonatomic, strong) HUDLayer *hudLayer;
@property (nonatomic, strong) GamePlayLayer *gamePlayLayer;

@end