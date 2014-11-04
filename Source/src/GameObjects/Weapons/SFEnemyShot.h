//
//  Created by nickyweber on 24.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SFGameObject.h"
#import "SFWeaponProjectileProtocol.h"
#import "CCAction.h"

@class SFSpaceship;
@protocol SFGamePlaySceneDelegate;
// @class CCLine;


@interface SFEnemyShot : SFGameObject <SFWeaponProjectileProtocol>

@property (nonatomic, assign) SFGameObject *target;

@property (nonatomic) float speedFactor;
@property (nonatomic) int power;
@property (nonatomic) NSUInteger level;
@property (nonatomic, strong) CCActionRepeatForever *standardAnimation;
@property (nonatomic) CGPoint shotVector;

- (id)initEnemyShotWithStartPosition:(CGPoint)startPosition andTarget:(SFGameObject *)aTarget level:(NSUInteger)level;

@end