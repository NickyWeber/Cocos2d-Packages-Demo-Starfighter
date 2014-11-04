#import <Foundation/Foundation.h>

@class SFEntity;
@class SFComponent;

@interface SFEntityManager : NSObject

+ (SFEntityManager *)sharedManager;


- (SFEntity *)createEntity;

- (void)addComponent:(SFComponent *)component toEntity:(SFEntity *)entity;

- (id)componentOfClass:(Class)class forEntity:(SFEntity *)entity;

- (void)removeEntity:(SFEntity *)entity;

- (NSArray *)allEntitiesPosessingComponentOfClass:(Class)class;
@end