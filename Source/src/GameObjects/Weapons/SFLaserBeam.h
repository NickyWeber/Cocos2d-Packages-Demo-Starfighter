//
//  Created by nickyweber on 08.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SFGameObject.h"
#import "SFWeaponProjectileProtocol.h"


@interface SFLaserBeam : SFGameObject <SFWeaponProjectileProtocol>

@property (nonatomic) int power;
@property (nonatomic) float speedfactor;

@end