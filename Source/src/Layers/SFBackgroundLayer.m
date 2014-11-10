#import "SFBackgroundLayer.h"
#import "SFBackgroundDebris.h"


@interface SFBackgroundLayer ()

@property (nonatomic) float lastDebris;
@property (nonatomic) float nextDebris;

@end


@implementation SFBackgroundLayer

#pragma mark - Initialization

- (id)init
{
    self = [super init];

    if (self)
    {
        self.newDebrisMinTime = 0.8;
        self.newDebrisVariance = 0.2;

        self.lastDebris = 0.0;
        self.nextDebris = 0.5;

        CCSprite *background = [CCSprite spriteWithImageNamed:@"Sprites/Backgrounds/stars.png"];
        [background setAnchorPoint:CGPointMake(0.0, 0.0)];
        background.scale = 1.2;
        [self addChild:background z:0];

        self.debrisBaseSpeed = 200.0;
        self.debrisSpeedVariance = 10.0;
    }

    return self;
}

- (void)update:(CCTime)deltaTime
{
    if (_lastDebris >= _nextDebris)
   	{
   		SFBackgroundDebris *debris = [[SFBackgroundDebris alloc] init];
   		[self addChild:debris];

        debris.speedfactor = (float) (_debrisBaseSpeed + CCRANDOM_0_1() * _debrisSpeedVariance);

        self.nextDebris = (float) (_newDebrisMinTime + CCRANDOM_0_1() * _newDebrisVariance);
        self.lastDebris = 0.0;
   	}

    self.lastDebris += deltaTime;
}

@end