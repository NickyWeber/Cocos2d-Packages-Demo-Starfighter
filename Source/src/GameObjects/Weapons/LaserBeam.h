//
//  Created by nickyweber on 08.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "GameObject.h"
#import "WeaponProjectileProtocol.h"


@interface LaserBeam : GameObject <WeaponProjectileProtocol>

@property (nonatomic) int power;
@property (nonatomic) float speedfactor;

@end