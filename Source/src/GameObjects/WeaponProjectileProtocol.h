#import <Foundation/Foundation.h>

@protocol WeaponProjectileProtocol <NSObject>

@required
- (int)damage;
- (BOOL)damagesSpaceship;
- (void)weaponHitTarget;

@end