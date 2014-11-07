#import <Foundation/Foundation.h>

@protocol SFGamePlaySceneDelegate;
@class SFEntityManager;
@class SFEntity;
@class SFLootComponent;
@class SFWeaponComponent;
@class SFConfigLoader;


@interface SFEntityFactory : NSObject

@property (nonatomic, strong) id <SFGamePlaySceneDelegate> delegate;
@property (nonatomic, strong) SFEntityManager *entityManager;

+ (SFEntityFactory *)sharedFactory;

- (SFEntity *)addSpaceshipAtPosition:(CGPoint)position;

- (SFEntity *)addEnemyShotWithWeaponComponent:(SFWeaponComponent *)weaponComponent atPosition:(CGPoint)position;

- (SFEntity *)addEnemyAtPosition:(CGPoint)position;

- (SFEntity *)addLoot:(SFLootComponent *)lootComponent atPosition:(CGPoint)position;

- (SFEntity *)addLaserBeamWithWeaponComponent:(SFWeaponComponent *)weaponComponent atPosition:(CGPoint)position;

@end