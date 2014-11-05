#import <Foundation/Foundation.h>
#import "SFComponent.h"

@interface SFCollisionRewardComponent : SFComponent

@property (nonatomic) NSUInteger points;
@property (nonatomic) NSUInteger health;
@property (nonatomic) NSUInteger shield;

@end