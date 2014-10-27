#import <Foundation/Foundation.h>
#import "GameObject.h"


@interface Enemy : GameObject

@property (nonatomic) int health;

- (void)takeDamage:(int)damageTaken;

@end