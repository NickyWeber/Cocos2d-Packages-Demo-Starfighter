#import "SFTimeToLiveComponent.h"

@implementation SFTimeToLiveComponent

- (instancetype)initWithTimeToLive:(double)timeToLive fadeDuration:(double)fadeDuration
{
    self = [super init];
    if (self)
    {
        self.timeToLive = timeToLive;
        self.fadeDuration = fadeDuration;
        self.timeSinceSpawning = 0.0;
        self.fadingOut = NO;
    }

    return self;
}

@end
