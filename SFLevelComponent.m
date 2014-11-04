#import "SFLevelComponent.h"

@implementation SFLevelComponent

- (instancetype)initWithLevel:(NSUInteger)level
{
    self = [super init];
    if (self)
    {
        self.level = level;
    }

    return self;
}

@end