#import <Foundation/Foundation.h>
#import "SFComponent.h"

@interface SFCollisionComponent : SFComponent

@property (nonatomic) BOOL despawnAfterCollision;
@property (nonatomic, strong) NSArray *collisionBlackListTags;
@property (nonatomic, strong) NSArray *collisionWhiteListTags;
@property (nonatomic, copy) NSString *canCollideWithTag;
@property (nonatomic, strong) CCAction *hitAnimationAction;

- (instancetype)initWithDespawnAfterCollision:(BOOL)despawnAfterCollision;

@end
