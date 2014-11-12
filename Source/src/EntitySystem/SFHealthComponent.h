#import <Foundation/Foundation.h>
#import "SFComponent.h"


@interface SFHealthComponent : SFComponent

@property (nonatomic) NSInteger health;
@property (nonatomic) NSUInteger healthMax;
@property (nonatomic) NSInteger shield;
@property (nonatomic) NSUInteger shieldMax;

@property (nonatomic) BOOL isAlive;

- (instancetype)initWithHealth:(NSUInteger)health healthMax:(NSUInteger)healthMax;

- (double)healthInPercent;

- (double)shieldInPercent;

@end