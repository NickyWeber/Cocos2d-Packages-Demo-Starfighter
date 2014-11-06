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
        self.lastDebris = 0.0;
        self.nextDebris = 0.5;

        CCSprite *background = [CCSprite spriteWithImageNamed:@"Sprites/Backgrounds/stars.png"];
        [background setAnchorPoint:CGPointMake(0.0, 0.0)];
        background.scale = 1.2;
        [self addChild:background z:0];
    }

    return self;
}

- (void)update:(CCTime)deltaTime
{
    if (_lastDebris >= _nextDebris)
   	{
   		SFBackgroundDebris *debris = [[SFBackgroundDebris alloc] init];
   		[self addChild:debris];
   		self.nextDebris = (float) (0.8 * CCRANDOM_0_1() + 0.2);
           self.lastDebris = 0.0;
   	}

    self.lastDebris += deltaTime;
}

@end