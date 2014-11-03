#import "HealthLoot.h"
#import "Spaceship.h"
#import "GamePlayLayer.h"
#import "CCAnimation.h"
#import "Constants.h"


@implementation HealthLoot

- (id)initWithDelegate:(id)aDelegate
{
    self = [super initWithBaseFrameName:@"Sprites/Loot/HealthLoot_1.png" delegate:aDelegate];

    if (self)
    {
        CCAnimation *spaceshipAnimation = [CCAnimation animation];

        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/HealthLoot_1.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/HealthLoot_1.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/HealthLoot_1.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/HealthLoot_1.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/HealthLoot_1.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/HealthLoot_1.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/HealthLoot_2.png"];

        spaceshipAnimation.delayPerUnit = (float) (TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER / 5.0);

        CCActionAnimate *spaceshipAnimationAction = [CCActionAnimate actionWithAnimation:spaceshipAnimation];
        spaceshipAnimationAction.duration = 1.0 * TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER;
        spaceshipAnimation.restoreOriginalFrame = YES;

        [self runAction:[CCActionRepeatForever actionWithAction:spaceshipAnimationAction]];

        self.fadeoutTime = 2.0;
        self.lifeTime = 7.0;

        [self addBoundingBoxWithRect:CGRectMake(0.0, 0.0, 26.0, 26.0)];
    }

    return self;
}

- (void)applyReward
{
    GamePlayLayer *gamePlayLayer = (id) self.delegate;

    Spaceship *spaceship = [gamePlayLayer spaceship];

    [spaceship addHealth:25];
}

@end