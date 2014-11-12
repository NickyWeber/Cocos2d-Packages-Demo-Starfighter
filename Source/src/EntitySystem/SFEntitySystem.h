#import <Foundation/Foundation.h>

@class SFEntityManager;
@protocol SFGamePlaySceneDelegate;


@interface SFEntitySystem : NSObject

@property (nonatomic, strong) SFEntityManager *entityManager;
@property (nonatomic, strong) id <SFGamePlaySceneDelegate> delegate;

- (instancetype)initWithEntityManager:(SFEntityManager *)entityManager delegate:(id <SFGamePlaySceneDelegate>)delegate;

- (void)update:(CCTime)delta;

@end