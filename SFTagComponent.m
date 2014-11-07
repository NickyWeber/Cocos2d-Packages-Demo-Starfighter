#import "SFTagComponent.h"

@implementation SFTagComponent


// TODO: Remove me
- (id)init
{
    self = [super init];

    if (self)
    {
        self.tags = [NSMutableArray array];
    }

    return self;
}

- (void)addTag:(id)tag
{
    NSAssert(tag != nil, @"tag must not be nil");

    [_tags addObject:tag];
}

- (void)removeTag:(id)tag
{
    NSAssert(tag != nil, @"tag must not be nil");

    [_tags removeObject:tag];
}

- (BOOL)hasTag:(id)tag
{
    return [_tags containsObject:tag];
}

@end