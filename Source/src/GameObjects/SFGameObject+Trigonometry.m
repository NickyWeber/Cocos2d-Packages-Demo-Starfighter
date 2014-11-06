//
//  Created by nickyweber on 27.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SFGameObject+Trigonometry.h"


@implementation SFGameObject (Trigonometry)

+ (CGPoint)calcNormalizedShotVector:(CGPoint)startPosition andTargetPosition:(CGPoint)targetPosition
{
	CGPoint notNormalizedVector = CGPointMake(targetPosition.x - startPosition.x,
											  targetPosition.y - startPosition.y);


/*	NSLog(@"NNV %f.2 %f.2", notNormalizedVector.x, notNormalizedVector.y);
  */
	return [SFGameObject normalizeVector:notNormalizedVector];
}

+ (CGPoint)normalizeVector:(CGPoint)aVector
{
	float lengthOfVector = [SFGameObject lengthOfVector:aVector];
/*
	NSLog(@"NV %f.2 %f.2", aVector.x / lengthOfVector, aVector.y / lengthOfVector);
*/

	return CGPointMake(aVector.x / lengthOfVector, aVector.y / lengthOfVector);
}

+ (float)lengthOfVector:(CGPoint)aVector
{
	return sqrtf(powf((float) aVector.x, 2.0) + powf((float) aVector.y, 2.0));
}

- (CGPoint)rotateVector:(CGPoint)vector byDegrees:(float)degrees
{
	float x_, y_;
	float rad = (float) (degrees * M_PI / 180.0);

	x_ = vector.x * cosf(rad) - vector.y * sinf(rad);
	y_ = vector.y * cosf(rad) + vector.x * sinf(rad);

//	NSLog(@"%f.2 %f.2 -> %f.2 %f.2", vector.x, vector.y, x_, y_);

	return CGPointMake(x_, y_);
}


- (float)angleBetweenTwoVectors:(CGPoint)aVectorA vectorB:(CGPoint)aVectorB
{
	float tmp = aVectorA.x * aVectorB.x + aVectorA.y * aVectorB.y;
	float tmp2 = [SFGameObject lengthOfVector:aVectorA] * [SFGameObject lengthOfVector:aVectorB];

	float angleRad = (float) acos(tmp / tmp2);
	float angleDeg = (float) (angleRad * 180.0 / M_PI);

	float crossProduct = aVectorA.x * aVectorB.y - aVectorA.y * aVectorB.x;

	return (float) ((crossProduct > 0.0)
        ? angleDeg
        : angleDeg * -1.0);
}

- (float)distanceToPoint:(CGPoint)aPoint
{
	CGPoint vector = CGPointMake(self.position.x - aPoint.x, self.position.y - aPoint.y);

	return [SFGameObject lengthOfVector:vector];
}

+ (float)distanceBetweenTwoPoints:(CGPoint)aPointA pointB:(CGPoint)aPointB
{
	CGPoint vector = CGPointMake(aPointA.x - aPointB.x, aPointA.y - aPointB.y);

	return [SFGameObject lengthOfVector:vector];
}


@end