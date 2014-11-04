//
//  Created by nickyweber on 26.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ccTypes.h"

@protocol SFAIMovementProtocol

- (CGPoint)positionWithTimeDelta:(CCTime)aTimeDelta oldPoisition:(CGPoint)anOldPosition speedfactor:(float)aSpeedfactor;

@end