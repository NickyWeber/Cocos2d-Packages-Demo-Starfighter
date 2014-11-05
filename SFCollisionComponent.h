#import <Foundation/Foundation.h>
#import "SFComponent.h"

@interface SFCollisionComponent : SFComponent

@property (nonatomic) BOOL despawnAfterCollision;
@property (nonatomic, strong) NSMutableSet *collisionExceptionTags;

- (instancetype)initWithDespawnAfterCollision:(BOOL)despawnAfterCollision;


@end