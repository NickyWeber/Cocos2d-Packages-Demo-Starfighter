#import "GamePlayScene.h"
#import "BackgroundLayer.h"
#import "HUDLayer.h"


@implementation GamePlayScene

- (id)init
{
    self = [super init];

    if (self)
    {
        self.hudLayer = [HUDLayer node];
        [self addChild:_hudLayer z:2];




        self.backgroundLayer = [BackgroundLayer node];
        [self addChild:_backgroundLayer z:0];
    }

    return self;
}

@end