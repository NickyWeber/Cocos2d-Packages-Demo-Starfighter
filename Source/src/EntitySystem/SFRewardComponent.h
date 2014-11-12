#import <Foundation/Foundation.h>
#import "SFComponent.h"


@interface SFRewardComponent : SFComponent

@property (nonatomic) NSUInteger points;

- (instancetype)initWithPoints:(NSUInteger)points;


@end