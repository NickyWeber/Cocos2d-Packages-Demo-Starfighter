#import <Foundation/Foundation.h>
#import "SFGamePlaySceneDelegate.h"

@protocol SFTouchDelegate

- (void)touchBegan:(CCTouch *)touch event:(CCTouchEvent *)event;

@end


@class SFBackgroundLayer;
@class SFHUDLayer;
@class SFGamePlayLayer;


@interface SFGamePlayScene : CCScene  <SFGamePlaySceneDelegate, SFTouchDelegate>

@property (nonatomic, strong) SFBackgroundLayer *backgroundLayer;
@property (nonatomic, strong) SFHUDLayer *hudLayer;
@property (nonatomic, strong) SFGamePlayLayer *gamePlayLayer;

@end