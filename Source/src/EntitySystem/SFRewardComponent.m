#import "SFRewardComponent.h"


@implementation SFRewardComponent

- (instancetype)initWithPoints:(NSUInteger)points
{
    self = [super init];
    if (self)
    {
        self.points = points;
    }

    return self;
}

@end
