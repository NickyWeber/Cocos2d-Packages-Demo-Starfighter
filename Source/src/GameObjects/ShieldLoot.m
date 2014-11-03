#import "HealthLoot.h"
#import "Spaceship.h"
#import "GamePlayLayer.h"
#import "CCAnimation.h"
#import "Constants.h"
#import "ShieldLoot.h"


@implementation ShieldLoot

- (id)initWithDelegate:(id)aDelegate
{
    self = [super initWithBaseFrameName:@"Sprites/Loot/ShieldLoot_1.png" delegate:aDelegate];

    if (self)
    {
        CCAnimation *spaceshipAnimation = [CCAnimation animation];

        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_6.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_5.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_4.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_4.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_3.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_3.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_3.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_2.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_2.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_2.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_1.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_1.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_1.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_1.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_2.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_2.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_2.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_3.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_3.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_3.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_4.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_4.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_5.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/ShieldLoot_6.png"];

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

    [spaceship addShield:25];
}

@end