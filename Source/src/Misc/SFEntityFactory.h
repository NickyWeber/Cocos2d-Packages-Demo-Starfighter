#import <Foundation/Foundation.h>

@protocol SFGamePlaySceneDelegate;
@class SFEntityManager;
@class SFEntity;
@class SFLootComponent;
@class SFWeaponComponent;
@class SFEntityConfigLoader;


@interface SFEntityFactory : NSObject

@property (nonatomic, strong) id <SFGamePlaySceneDelegate> delegate;
@property (nonatomic, strong) SFEntityManager *entityManager;
@property (nonatomic, copy) NSString *currentLevelId;

+ (SFEntityFactory *)sharedFactory;

- (SFEntity *)addSpaceshipAtPosition:(CGPoint)position;

- (SFEntity *)addEntityWithName:(NSString *)name atPosition:(CGPoint)position;

- (SFEntity *)addLoot:(SFLootComponent *)lootComponent atPosition:(CGPoint)position;

- (SFEntity *)addProjectileForWeaponComponent:(SFWeaponComponent *)weaponComponent atPosition:(CGPoint)position;

@end