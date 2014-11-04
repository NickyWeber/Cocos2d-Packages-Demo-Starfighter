#import <Foundation/Foundation.h>

@protocol SFWeaponProjectileProtocol <NSObject>

@required
- (int)damage;
- (BOOL)damagesSpaceship;
- (void)weaponHitTarget;

@end