#import <Foundation/Foundation.h>
#import "SFComponent.h"


@interface SFLootComponent : SFComponent

@property (nonatomic) NSUInteger dropType;

- (instancetype)initWithDropType:(NSUInteger)dropType;


@end