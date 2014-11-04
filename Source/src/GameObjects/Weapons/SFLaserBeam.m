//
//  Created by nickyweber on 08.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SFLaserBeam.h"


@implementation SFLaserBeam

- (id)init
{
	self = [super initWithImageNamed:@"Sprites/Shots/LaserBeam.png"];

	if (self)
	{
		[self addBoundingBoxWithRect:CGRectMake(0.0, 0.0, 4.0, 12.0)];
		self.speedfactor = 3.0;
		self.power = 25;
	}

	return self;
}

#pragma mark - overriden methods

- (void)updateStateWithTimeDelta:(CCTime)aTimeDelta andGameObjects:(NSArray *)gameObjects
{
	CGPoint newPosition = CGPointMake(self.position.x,
                                      (CGFloat) (self.position.y + [CCDirector sharedDirector].view.frame.size.width * self.speedfactor * aTimeDelta));

	[self setPosition:newPosition];

	// NSLog(@"%p - y: %f.2 - %f", self, self.position.y, aTimeDelta);

	if (newPosition.y >= [CCDirector sharedDirector].view.frame.size.height + 10.0)
	{
		[self despawn];
	}
}


#pragma mark - Weapon Protocol methods

- (int)damage
{
	return self.power;
}

- (BOOL)damagesSpaceship
{
	return NO;
}

- (void)weaponHitTarget
{
	[self despawn];
}


@end