#import <Foundation/Foundation.h>

@class SFEntity;
@class SFComponent;

@interface SFEntityManager : NSObject

+ (SFEntityManager *)sharedManager;

- (SFEntity *)createEntity;
- (SFEntity *)createEntityWithComponents:(NSArray *)components;

- (void)addComponent:(SFComponent *)component toEntity:(SFEntity *)entity;
- (void)removeComponent:(Class)class fromEntity:(SFEntity *)entity;

- (NSArray *)allComponentsOfEntity:(SFEntity *)entity;

- (id)componentOfClass:(Class)class forEntity:(SFEntity *)entity;

- (void)removeEntity:(SFEntity *)entity;

- (NSArray *)allEntitiesPosessingComponentOfClass:(Class)class;

- (NSArray *)entitiesWithTag:(NSString *)tag;


@end