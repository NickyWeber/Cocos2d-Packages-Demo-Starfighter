//
//  Created by nickyweber on 24.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GameObject.h"
#import "WeaponProjectileProtocol.h"
#import "CCAction.h"

@class Spaceship;
@protocol GamePlaySceneDelegate;
// @class CCLine;


@interface EnemyShot : GameObject <WeaponProjectileProtocol>

@property (nonatomic, assign) GameObject *target;

@property (nonatomic) float speedFactor;
@property (nonatomic) int power;
@property (nonatomic) NSUInteger level;
@property (nonatomic, strong) CCActionRepeatForever *standardAnimation;
@property (nonatomic) CGPoint shotVector;

- (id)initEnemyShotWithStartPosition:(CGPoint)startPosition andTarget:(GameObject *)aTarget level:(NSUInteger)level;

@end