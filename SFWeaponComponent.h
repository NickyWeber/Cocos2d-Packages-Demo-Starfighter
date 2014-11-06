#import <Foundation/Foundation.h>
#import "SFComponent.h"

@interface SFWeaponComponent : SFComponent

@property (nonatomic) BOOL enemyWeapon;
@property (nonatomic) double fireRate;
@property (nonatomic) NSUInteger power;
@property (nonatomic) double speed;
@property (nonatomic) NSUInteger weaponType;
@property (nonatomic) CCTime timeSinceLastShot;

@end