#import <Foundation/Foundation.h>
#import "SFComponent.h"

@interface SFCollisionDamageComponent : SFComponent

@property (nonatomic) NSUInteger damage;

- (instancetype)initWithDamage:(NSUInteger)damage;


@end