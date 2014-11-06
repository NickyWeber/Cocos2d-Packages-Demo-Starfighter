//
//  Created by nickyweber on 27.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SFTrigonometryHelper.h"


@implementation SFTrigonometryHelper

+ (CGPoint)calcNormalizedShotVector:(CGPoint)startPosition andTargetPosition:(CGPoint)targetPosition
{
	CGPoint notNormalizedVector = CGPointMake(targetPosition.x - startPosition.x,
											  targetPosition.y - startPosition.y);


/*	NSLog(@"NNV %f.2 %f.2", notNormalizedVector.x, notNormalizedVector.y);
  */
	return [SFTrigonometryHelper normalizeVector:notNormalizedVector];
}

+ (CGPoint)normalizeVector:(CGPoint)aVector
{
	float lengthOfVector = [SFTrigonometryHelper lengthOfVector:aVector];
/*
	NSLog(@"NV %f.2 %f.2", aVector.x / lengthOfVector, aVector.y / lengthOfVector);
*/

	return CGPointMake(aVector.x / lengthOfVector, aVector.y / lengthOfVector);
}

+ (float)lengthOfVector:(CGPoint)aVector
{
	return sqrtf(powf((float) aVector.x, 2.0) + powf((float) aVector.y, 2.0));
}

+ (CGPoint)rotateVector:(CGPoint)vector byDegrees:(float)degrees
{
    double x_, y_;
    double rad = (float) (degrees * M_PI / 180.0);

	x_ = vector.x * cosf(rad) - vector.y * sinf(rad);
	y_ = vector.y * cosf(rad) + vector.x * sinf(rad);

//	NSLog(@"%f.2 %f.2 -> %f.2 %f.2", vector.x, vector.y, x_, y_);

	return CGPointMake(x_, y_);
}


+ (float)angleBetweenTwoVectors:(CGPoint)aVectorA vectorB:(CGPoint)aVectorB
{
	double tmp = aVectorA.x * aVectorB.x + aVectorA.y * aVectorB.y;
    double tmp2 = [SFTrigonometryHelper lengthOfVector:aVectorA] * [SFTrigonometryHelper lengthOfVector:aVectorB];

    double angleRad = (float) acos(tmp / tmp2);
    double angleDeg = (float) (angleRad * 180.0 / M_PI);

    double crossProduct = aVectorA.x * aVectorB.y - aVectorA.y * aVectorB.x;

	return (float) ((crossProduct > 0.0)
        ? angleDeg
        : angleDeg * -1.0);
}

+ (float)distanceBetweenTwoPoints:(CGPoint)aPointA pointB:(CGPoint)aPointB
{
	CGPoint vector = CGPointMake(aPointA.x - aPointB.x, aPointA.y - aPointB.y);

	return [SFTrigonometryHelper lengthOfVector:vector];
}

@end
