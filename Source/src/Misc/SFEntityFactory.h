#import <Foundation/Foundation.h>

@protocol SFGamePlaySceneDelegate;
@class SFEntityManager;
@class SFEntity;


@interface SFEntityFactory : NSObject

@property (nonatomic, strong) id <SFGamePlaySceneDelegate> delegate;
@property (nonatomic, strong) SFEntityManager *entityManager;

+ (SFEntityFactory *)sharedFactory;

- (SFEntity *)addEnemy;

@end