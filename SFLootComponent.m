#import "SFComponent.h"
#import "SFLootComponent.h"

@implementation SFLootComponent

- (instancetype)initWithDropType:(NSUInteger)dropType
{
    self = [super init];
    if (self)
    {
        self.dropType = dropType;
    }

    return self;
}


@end