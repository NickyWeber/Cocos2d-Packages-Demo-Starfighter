#import "SFGamePlaySceneDelegate.h"
#import "SFGamePlayLayer.h"
#import "SFGamePlaySceneDelegate.h"
#import "SFHUDLayer.h"
#import "SFLevelController.h"
#import "SneakyButton.h"
#import "SneakyJoystick.h"
#import "SFEntityManager.h"
#import "SFMoveSystem.h"
#import "SFEntityManager.h"
#import "SFHealthSystem.h"
#import "SFRenderComponent.h"
#import "SFHealthComponent.h"
#import "SFEntityFactory.h"
#import "SFLevel.h"
#import "SFMoveSystem.h"
#import "SFCollisionSystem.h"
#import "SFLootComponent.h"
#import "SFCollisionRewardComponent.h"
#import "SFTimeToLiveSystem.h"
#import "SFWeaponSystem.h"


@interface SFGamePlayLayer ()

@property (nonatomic, strong) SFLevelController *levelController;
@property (nonatomic) NSUInteger level;
@property (nonatomic, strong) NSMutableArray *systems;
@property (nonatomic, strong) id healthComponent;

@end


@implementation SFGamePlayLayer

- (id)initWithDelegate:(id <SFGamePlaySceneDelegate>)aDelegate entityManager:(SFEntityManager *)entityManager startLevel:(SFLevel *)startLevel
{
	self = [super init];

	if ((self))
	{
		NSAssert(aDelegate != nil, @"Delegate has to be set!");
        NSAssert(entityManager != nil, @"entityManager has to be set!");
        NSAssert(startLevel != nil, @"startLevel has to be set!");
		NSAssert([aDelegate conformsToProtocol:@protocol(SFGamePlaySceneDelegate)],
		         @"Delegate has to conform to SFGamePlaySceneDelegate!");

		self.delegate = aDelegate;
        self.entityManager = entityManager;
		self.levelController = [[SFLevelController alloc] initWithDelegate:_delegate];
        _levelController.level = startLevel;

        self.systems = [NSMutableArray array];
        [_systems addObject:[[SFMoveSystem alloc] initWithEntityManager:_entityManager delegate:aDelegate]];
        [_systems addObject:[[SFCollisionSystem alloc] initWithEntityManager:_entityManager delegate:aDelegate]];
        [_systems addObject:[[SFHealthSystem alloc] initWithEntityManager:_entityManager delegate:aDelegate]];
        [_systems addObject:[[SFTimeToLiveSystem alloc] initWithEntityManager:_entityManager delegate:aDelegate]];
        [_systems addObject:[[SFWeaponSystem alloc] initWithEntityManager:_entityManager delegate:aDelegate]];
	}
	return self;
}

- (void)startGame
{
    [self initializeSpaceship];
}

- (void)update:(CCTime)delta
{
    for (SFEntitySystem *entitySystem in _systems)
    {
        [entitySystem update:delta];
    }

    [_levelController update:delta];
}

- (void)initializeSpaceship
{
    CGSize screenSize = [[CCDirector sharedDirector] designSize];

    SFEntity *spaceship = [[SFEntityFactory sharedFactory] addSpaceshipAtPosition:ccp(screenSize.width / 2.0, screenSize.height * 0.333)];
    self.healthComponent = [[SFEntityManager sharedManager] componentOfClass:[SFHealthComponent class] forEntity:spaceship];

    [_healthComponent addObserver:self
                      forKeyPath:@"health"
                         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld
                         context:NULL];

    [_healthComponent addObserver:self
                      forKeyPath:@"shield"
                         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld
                         context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"health"])
    {
        [_delegate updateHealthBarWithHealthInPercent:[_healthComponent healthInPercent]];
    }

    if ([keyPath isEqualToString:@"shield"])
    {
        [_delegate updateShieldBarWithShieldInPercent:[_healthComponent shieldInPercent]];
    }
}

- (void)addGameEntity:(CCNode *)aGameEntity
{
	[self addChild:aGameEntity];
}

- (void)advanceToLevel:(SFLevel *)level
{
    _levelController.level = level;
}

- (void)playerDied
{
    _levelController.enabled = NO;

    [_healthComponent removeObserver:self forKeyPath:@"shield"];
    [_healthComponent removeObserver:self forKeyPath:@"health"];
}

@end
