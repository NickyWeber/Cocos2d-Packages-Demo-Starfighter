//
//  Created by nickyweber on 26.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SSZipArchive/unzip.h>
#import "AIMovement.h"


@implementation AIMovement

- (instancetype)initWithLevel:(NSUInteger)level
{
    self = [super init];
    if (self)
    {
        self.level = level;
    }

    return self;
}

- (CGPoint)positionWithTimeDelta:(CCTime)aTimeDelta oldPoisition:(CGPoint)anOldPosition speedfactor:(float)aSpeedfactor
{
	return CGPointMake([self xPosition:anOldPosition],
                       (CGFloat) (anOldPosition.y - aSpeedfactor * aTimeDelta));
}

- (CGFloat)xPosition:(CGPoint)oldPosition
{
    if (_level > 1 && _level <= 3)
    {
        return (CGFloat) (oldPosition.x + ((1.0 + _level * 0.33) *sin(CACurrentMediaTime())));
    }
    else if (_level > 3)
    {
        return (CGFloat) ((oldPosition.x + ((1.0 + _level * 0.20) *sin(CACurrentMediaTime())) * cos(CACurrentMediaTime() * 0.50)));
    }

    return oldPosition.x;
}

@end