#import <Foundation/Foundation.h>
#import "SFComponent.h"

@interface SFWeaponComponent : SFComponent

@property (nonatomic) BOOL enemyWeapon;
@property (nonatomic) double fireRate;
@property (nonatomic) NSUInteger power;
@property (nonatomic) NSString *weaponType;
@property (nonatomic) CCTime timeSinceLastShot;
@property (nonatomic) NSString *target;
@property (nonatomic) CGPoint targetVector;

@end