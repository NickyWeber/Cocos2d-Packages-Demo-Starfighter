#import <Foundation/Foundation.h>

@class SFEntityManager;


@interface SFEntitySystem : NSObject

@property (nonatomic, strong) SFEntityManager *entityManager;

- (id)initWithEntityManager:(SFEntityManager *)entityManager;

- (instancetype)initWithEntityManager:(SFEntityManager *)entityManager;


- (void)update:(CCTime)delta;

@end