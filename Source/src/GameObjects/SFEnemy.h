//
//  Created by nickyweber on 08.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SFGameObject.h"
#import "CCAction.h"

@class CCAnimation;
@class CCActionAnimate;
@class CCActionInterval;
@class SFGamePlayLayer;
@protocol SFAIMovementProtocol;
@protocol SFGamePlaySceneDelegate;
@class SFLoot;


typedef enum {
	EnemyStateNormal = 1,
	InputStateExploding = 2
} EnemyStates;


@interface SFEnemy : SFGameObject

@property (nonatomic, weak) id<SFGamePlaySceneDelegate> delegate;

@property (nonatomic, strong) CCActionAnimate *hitAnimationAction;
@property (nonatomic, strong) CCActionRepeatForever *standardAnimation;
@property (nonatomic, strong) CCAnimation *hitAnimation;
@property (nonatomic, strong) CCAnimation *explosionAnimation;
@property (nonatomic, strong) CCActionAnimate *explosionAnimationAction;

@property (nonatomic) int health;
@property (nonatomic, strong) id <SFAIMovementProtocol> aiMovement;

- (id)initEnemyWithDelegate:(id <SFGamePlaySceneDelegate>)aDelegate level:(NSUInteger)level;

- (void)takeDamage:(int)damageTaken;

@property (nonatomic) BOOL isActive;

@end