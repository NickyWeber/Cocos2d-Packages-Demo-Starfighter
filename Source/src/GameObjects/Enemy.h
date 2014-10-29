//
//  Created by nickyweber on 08.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "GameObject.h"
#import "CCAction.h"

@class CCAnimation;
@class CCActionAnimate;
@class CCActionInterval;
@class GamePlayLayer;
@protocol AIMovementProtocol;
@protocol GamePlaySceneDelegate;


typedef enum {
	EnemyStateNormal = 1,
	InputStateExploding = 2
} EnemyStates;


@interface Enemy : GameObject
{
/*	id delegate;
	id aiMovement;

	CCAnimation *hitAnimation;
	CCAnimate  *hitAnimationAction;
	CCRepeatForever *standardAnimation;

	GameObject *loot;

	int health;
	int points;
	float speedfactor;

	EnemyStates state;

	float timeSinceLastShot;
	float shotsPerSecond;*/
}

@property (nonatomic, weak) id<GamePlaySceneDelegate> delegate;

@property (nonatomic, strong) CCActionAnimate *hitAnimationAction;
@property (nonatomic, strong) CCActionRepeatForever *standardAnimation;
@property (nonatomic, strong) CCAnimation *hitAnimation;
@property (nonatomic, strong) CCAnimation *explosionAnimation;
@property (nonatomic, strong) CCActionAnimate *explosionAnimationAction;

@property (nonatomic) int health;
@property (nonatomic, strong) GameObject *loot;
@property (nonatomic, strong) id <AIMovementProtocol> aiMovement;

- (id)initEnemyWithDelegate:(id<GamePlaySceneDelegate>)aDelegate;

- (void)takeDamage:(int)damageTaken;

@property (nonatomic) BOOL isActive;

@end