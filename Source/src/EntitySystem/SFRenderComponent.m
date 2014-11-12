#import "SFRenderComponent.h"

@implementation SFRenderComponent

- (instancetype)initWithSprite:(CCNode *)node
{
    self = [super init];
    if (self)
    {
        self.node = node;
    }

    return self;
}

@end