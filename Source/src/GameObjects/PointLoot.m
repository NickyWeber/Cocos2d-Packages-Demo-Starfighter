//
//  Created by nickyweber on 24.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CCAction.h"
#import "CCActionInterval.h"
#import "Spaceship.h"
#import "PointLoot.h"
#import "CCAnimationCache.h"
#import "CCAnimation.h"
#import "Constants.h"
#import "GamePlaySceneDelegate.h"

static int AWARD_POINTS = 100;


@interface PointLoot()

@end

@implementation PointLoot


- (id)initWithDelegate:(id)aDelegate
{
    self = [super initWithDelegate:aDelegate];
    if (self)
    {
        CCAnimation *spaceshipAnimation = [CCAnimation animation];

        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_1.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_2.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_3.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_4.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_5.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_4.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_3.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_2.png"];
        [spaceshipAnimation addSpriteFrameWithFilename:@"Sprites/Loot/CashLoot_1.png"];

        spaceshipAnimation.delayPerUnit = (float) (TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER / 5.0);

        CCActionAnimate *spaceshipAnimationAction = [CCActionAnimate actionWithAnimation:spaceshipAnimation];
        spaceshipAnimationAction.duration = 1.0 * TIME_CONSTANT_ANIMATION_DURATION_MULTIPLIER;
        spaceshipAnimation.restoreOriginalFrame = YES;

        [self runAction:[CCActionRepeatForever actionWithAction:spaceshipAnimationAction]];

        self.fadeoutTime = 2.0;
        self.lifeTime = 5.0;

        [self addBoundingBoxWithRect:CGRectMake(0.0, 0.0, 22.0, 28.0)];
    }

    return self;
}

- (void)applyReward
{
    [self.delegate addPoints:AWARD_POINTS];
}


@end
