//
//  Created by nickyweber on 26.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AIMovement.h"


@implementation AIMovement

- (CGPoint)positionWithTimeDelta:(CCTime)aTimeDelta oldPoisition:(CGPoint)anOldPosition speedfactor:(float)aSpeedfactor
{
	return CGPointMake(anOldPosition.x,
                       (CGFloat) (anOldPosition.y - aSpeedfactor * aTimeDelta));
}

@end