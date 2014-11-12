#import "SFBackgroundDebris.h"


@interface SFBackgroundDebris ()

@end


@implementation SFBackgroundDebris


- (id)init
{
    self = [super init];

    if (self)
    {
        float rnd = CCRANDOM_0_1();
        
        CGSize screenSize = [[CCDirector sharedDirector] designSize];

        self.position = ccp((CGFloat) (screenSize.width * CCRANDOM_0_1()),
                            screenSize.height);

        self.speedfactor = 200.0;
        float size = (float) (2.0 * rnd + 0.5);
        GLubyte color = (GLubyte) (80.0 * rnd + 130.0);

        CCNodeColor *square = [[CCNodeColor alloc] initWithColor:[CCColor colorWithRed:color green:color blue:color]
                                                           width:size
                                                          height:size];
        [self addChild:square];
    }

    return self;
}

- (void)update:(CCTime)aTimeDelta
{
	if (self.position.y <= 0.0)
	{
		[self removeFromParentAndCleanup:YES];

	}
	else
	{
		CGPoint newPosition = CGPointMake(self.position.x,
                                          (CGFloat) (self.position.y - _speedfactor * aTimeDelta));
		self.position = newPosition;
	}
}

@end