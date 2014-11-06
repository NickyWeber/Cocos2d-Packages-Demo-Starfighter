#import <Foundation/Foundation.h>
#import "SFGamePlaySceneDelegate.h"

@protocol SFEventDelegate

#if __CC_PLATFORM_IOS || __CC_PLATFORM_ANDROID
- (void)touchBegan:(CCTouch *)touch event:(CCTouchEvent *)event;
#elif __CC_PLATFORM_MAC
- (void) mouseDown:(NSEvent *)event;
#endif
@end


@class SFBackgroundLayer;
@class SFHUDLayer;
@class SFGamePlayLayer;


@interface SFGamePlayScene : CCScene  <SFGamePlaySceneDelegate, SFEventDelegate>

@property (nonatomic, strong) SFBackgroundLayer *backgroundLayer;
@property (nonatomic, strong) SFHUDLayer *hudLayer;
@property (nonatomic, strong) SFGamePlayLayer *gamePlayLayer;

@end