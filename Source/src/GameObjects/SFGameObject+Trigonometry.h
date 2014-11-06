//
//  Created by nickyweber on 27.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SFGameObject.h"

@interface SFGameObject (Trigonometry)

+ (CGPoint)calcNormalizedShotVector:(CGPoint)startPosition andTargetPosition:(CGPoint)targetPosition;
- (CGPoint)rotateVector:(CGPoint)vector byDegrees:(float)degrees;
+ (CGPoint)normalizeVector:(CGPoint)aVector;
- (float)angleBetweenTwoVectors:(CGPoint)aVectorA vectorB:(CGPoint)aVectorB;
- (float)distanceToPoint:(CGPoint)aPoint;

+ (float)lengthOfVector:(CGPoint)aVector;
+ (float)distanceBetweenTwoPoints:(CGPoint)aPointA pointB:(CGPoint)aPointB;

@end