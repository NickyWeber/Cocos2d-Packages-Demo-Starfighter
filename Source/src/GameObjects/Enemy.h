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
@class Loot;


typedef enum {
	EnemyStateNormal = 1,
	InputStateExploding = 2
} EnemyStates;


@interface Enemy : GameObject

@property (nonatomic, weak) id<GamePlaySceneDelegate> delegate;

@property (nonatomic, strong) CCActionAnimate *hitAnimationAction;
@property (nonatomic, strong) CCActionRepeatForever *standardAnimation;
@property (nonatomic, strong) CCAnimation *hitAnimation;
@property (nonatomic, strong) CCAnimation *explosionAnimation;
@property (nonatomic, strong) CCActionAnimate *explosionAnimationAction;

@property (nonatomic) int health;
@property (nonatomic, strong) id <AIMovementProtocol> aiMovement;

- (id)initEnemyWithDelegate:(id <GamePlaySceneDelegate>)aDelegate level:(NSUInteger)level;

- (void)takeDamage:(int)damageTaken;

@property (nonatomic) BOOL isActive;

@end