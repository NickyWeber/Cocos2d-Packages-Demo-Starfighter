#import "SFControlSystem.h"


@implementation SFControlSystem

- (void)update:(CCTime)delta
{



/*
    CGSize displaySize = [CCDirector sharedDirector].view.frame.size;
	CGPoint scaledVelocity = ccpMult(_delegate.dPadVelocity, (CGFloat const) (displaySize.width * _speedfactor));
//    NSLog(@"*** %@", [NSValue valueWithCGPoint:scaledVelocity]);

	CGPoint newPosition = CGPointMake(MAX(0, MIN(self.position.x + scaledVelocity.x * aTimeDelta, displaySize.width)),
			                          MAX(0, MIN(self.position.y + scaledVelocity.y * aTimeDelta, displaySize.height)));


    if ([_delegate dPadVelocity].x != 0 || [_delegate dPadVelocity].y != 0)
    {
        // NSLog(@"%.2f", _delegate.degrees);
*/
/*
        NSLog(@"xv: %f, xs: %.4f, x:%f, dt:%f, new x:%f", [_delegate dPadVelocity].x, scaledVelocity.x, self.position.x, aTimeDelta,self.position.x + scaledVelocity.x * aTimeDelta);
        NSLog(@"yv: %f, ys: %.4f, y:%f, dt:%f, new y:%f", [_delegate dPadVelocity].y, scaledVelocity.y, self.position.y, aTimeDelta,self.position.y + scaledVelocity.y * aTimeDelta);
*//*

    }

//	if (self.isActive)
//	{
		[self setPosition:newPosition];
//	}

	self.timeSinceLastShotFired += aTimeDelta;
	self.timeSinceLastMissileLaunched += aTimeDelta;

	[self addLaserShotsIfButtonPressedToDelegateWithPosition:newPosition andGameObjects:someGameObjects];
*/
}

@end