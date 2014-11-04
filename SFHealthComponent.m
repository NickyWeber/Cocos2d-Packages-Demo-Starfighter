#import "SFHealthComponent.h"

@implementation SFHealthComponent

- (instancetype)initWithHealth:(NSUInteger)health healthMax:(NSUInteger)healthMax
{
    self = [super init];
    if (self)
    {
        self.isAlive = YES;
        self.healthMax = healthMax;
        self.health = health;
    }

    return self;
}

- (void)setHealth:(NSInteger)health
{
    _health = (NSInteger) MIN(MAX(0, health), _healthMax);
}

@end