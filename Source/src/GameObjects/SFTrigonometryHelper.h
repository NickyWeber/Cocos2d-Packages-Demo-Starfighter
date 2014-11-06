//
//  Created by nickyweber on 27.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface SFTrigonometryHelper : NSObject

+ (CGPoint)calcNormalizedShotVector:(CGPoint)startPosition andTargetPosition:(CGPoint)targetPosition;
+ (CGPoint)rotateVector:(CGPoint)vector byDegrees:(float)degrees;
+ (CGPoint)normalizeVector:(CGPoint)aVector;
+ (float)angleBetweenTwoVectors:(CGPoint)aVectorA vectorB:(CGPoint)aVectorB;

+ (float)lengthOfVector:(CGPoint)aVector;
+ (float)distanceBetweenTwoPoints:(CGPoint)aPointA pointB:(CGPoint)aPointB;

@end