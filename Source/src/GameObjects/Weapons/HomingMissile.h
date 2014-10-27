//
//  Created by nickyweber on 27.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GameObject.h"
#import "WeaponProjectileProtocol.h"
#import "CCAction.h"

@class Spaceship;
@protocol GamePlaySceneDelegateProtocol;
@class CCLine;


@interface HomingMissile : GameObject <WeaponProjectileProtocol>
{
	id <GamePlaySceneDelegateProtocol> delegate;

	GameObject *target;
	CGPoint shotVector;

	CCRepeatForever *standardAnimation;

	int power;
	float speedFactor;
	float degreesPerSecond;
	BOOL damagesPlayer;
	BOOL canAcquireNewTarget;
	float fuelLastingInSeconds;

	BOOL lostTarget;

	CCLine *debugShotVectorLine;
	CCLine *debugMissileTargetVector;
}

@property (nonatomic, assign) id delegate;

@property (nonatomic, assign) GameObject *target;
@property (nonatomic) CGPoint shotVector;

@property (nonatomic, retain) CCRepeatForever *standardAnimation;

@property (nonatomic) int power;
@property (nonatomic) float speedFactor;
@property (nonatomic) BOOL damagesPlayer;
@property (nonatomic) float degreesPerSecond;
@property (nonatomic) float fuelLastingInSeconds;
@property (nonatomic) BOOL canAcquireNewTarget;

@property (nonatomic, retain) CCLine *debugShotVectorLine;
@property (nonatomic, retain) CCLine *debugMissileTargetVector;


- (id)initWithFile:(NSString *)aFile animationFrames:(NSArray *)someAnimationFrames delegate:(id <GamePlaySceneDelegateProtocol>)aDelegate;

+ (HomingMissile *)enemyHomingMissileWithStartPosition:(CGPoint)aStartPosition
									   andTargetObject:(GameObject *)aGameObject
											  delegate:(id <GamePlaySceneDelegateProtocol>)aDelegate;

+ (HomingMissile *)playerHomingMissileWithStartPosition:(CGPoint)aStartPosition
										andTargetObject:(GameObject *)aGameObject
											   delegate:(id <GamePlaySceneDelegateProtocol>)aDelegate;

- (void)setStartPosition:(CGPoint)aStartPosition andTarget:(GameObject *)aGameObject;



@end
