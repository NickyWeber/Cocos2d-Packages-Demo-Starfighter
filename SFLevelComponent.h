#import <Foundation/Foundation.h>

#import "SFComponent.h"

@interface SFLevelComponent : SFComponent

@property (nonatomic) NSUInteger level;

- (instancetype)initWithLevel:(NSUInteger)level;

@end
