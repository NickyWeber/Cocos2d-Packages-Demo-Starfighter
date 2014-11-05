#import <Foundation/Foundation.h>

@protocol SFGamePlaySceneDelegate;
@class SFEntityManager;
@class SFEntity;
@class SFLootComponent;


@interface SFEntityFactory : NSObject

@property (nonatomic, strong) id <SFGamePlaySceneDelegate> delegate;
@property (nonatomic, strong) SFEntityManager *entityManager;

+ (SFEntityFactory *)sharedFactory;

- (SFEntity *)addEnemyAtPosition:(CGPoint)position;

- (SFEntity *)addLoot:(SFLootComponent *)lootComponent atPosition:(CGPoint)position;

- (SFEntity *)addLaserBeamAtPosition:(CGPoint)position;

@end