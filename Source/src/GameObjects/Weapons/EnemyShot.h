//
//  Created by nickyweber on 24.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GameObject.h"
#import "WeaponProjectileProtocol.h"
#import "CCAction.h"

@class Spaceship;
@protocol GamePlaySceneDelegateProtocol;
@class CCLine;


@interface EnemyShot : GameObject <WeaponProjectileProtocol>
{
	GameObject *target;

	CGPoint shotVector;
	float speedFactor;

	int power;

	CCRepeatForever *standardAnimation;
}

@property (nonatomic, assign) GameObject *target;

@property (nonatomic) float speedFactor;
@property (nonatomic) int power;
@property (nonatomic, retain) CCRepeatForever *standardAnimation;
@property (nonatomic) CGPoint shotVector;


- (id)initEnemyShotWithStartPosition:(CGPoint)startPosition andTarget:(GameObject *)aTarget;


@end