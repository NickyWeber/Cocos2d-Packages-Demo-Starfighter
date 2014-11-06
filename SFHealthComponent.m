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
        self.shield = 0;
        self.shieldMax = 0;
    }

    return self;
}

- (void)setHealth:(NSInteger)health
{
    _health = (NSInteger) MIN(MAX(0, health), _healthMax);
}

- (void)setShield:(NSInteger)shield
{
    _shield = (NSInteger) MIN(MAX(0, shield), _shieldMax);
}

- (double)healthInPercent
{
    return 1.0 / _healthMax * _health;
}

- (double)shieldInPercent
{
    return  _shieldMax == 0
        ? 0.0
        : 1.0 / _shieldMax * _shield;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"health: %lu / %lu, shield: %lu / %lu", _health, _healthMax, _shield, _shieldMax];
}

@end
