#import "SFComponent.h"
#import "SFCollisionDamageComponent.h"

@implementation SFCollisionDamageComponent

- (instancetype)initWithDamage:(NSUInteger)damage
{
    self = [super init];

    if (self)
    {
        self.damage = damage;
    }

    return self;
}

@end