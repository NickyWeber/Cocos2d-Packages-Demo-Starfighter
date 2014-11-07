#import <Foundation/Foundation.h>
#import "SFComponent.h"


@interface SFRenderComponent : SFComponent

@property (nonatomic, strong) CCNode *node;
@property (nonatomic, strong) id defaultActionAnimate;

- (instancetype)initWithSprite:(CCNode *)node;

@end
