#import <Foundation/Foundation.h>

@class BackgroundLayer;
@class HUDLayer;


@interface GamePlayScene : CCScene

@property (nonatomic, strong) BackgroundLayer *backgroundLayer;
@property (nonatomic, strong) HUDLayer *hudLayer;

@end