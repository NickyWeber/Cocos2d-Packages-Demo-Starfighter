#import <Foundation/Foundation.h>
#import "SFComponent.h"


@interface SFRenderComponent : SFComponent

@property (nonatomic, strong) CCNode *node;

- (instancetype)initWithSprite:(CCNode *)node;

@end
