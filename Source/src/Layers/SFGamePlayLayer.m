#import "SFGamePlaySceneDelegate.h"
#import "SFGamePlayLayer.h"
#import "SFGamePlaySceneDelegate.h"
#import "SFSpaceship.h"
#import "SFHUDLayer.h"
#import "SFLevelController.h"
#import "SFLaserBeam.h"
#import "SFEnemy.h"
#import "SneakyButton.h"
#import "SneakyJoystick.h"
#import "SFPointLoot.h"
#import "SFMoveSystem.h"
#import "SFHealthLoot.h"
#import "SFShieldLoot.h"
#import "SFEntityManager.h"
#import "SFHealthSystem.h"
#import "SFRenderComponent.h"
#import "SFHealthComponent.h"
#import "SFEntityFactory.h"
#import "SFMoveSystem.h"
#import "SFCollisionSystem.h"
#import "SFLootComponent.h"
#import "SFCollisionRewardComponent.h"
#import "SFTimeToLiveSystem.h"
#import "SFWeaponSystem.h"


@interface SFGamePlayLayer ()

@property (nonatomic, strong) SFLevelController *levelController;
@property (nonatomic) NSUInteger level;
@property (nonatomic, strong) SFEntityManager *entityManager;
@property (nonatomic, strong) NSMutableArray *systems;
@property (nonatomic, strong) id healthComponent;

@end


@implementation SFGamePlayLayer

- (id)initWithDelegate:(id<SFGamePlaySceneDelegate>)aDelegate
{
	self = [super init];

	if ((self))
	{
		NSAssert(aDelegate != nil, @"Delegate has to be set!");
		NSAssert([aDelegate conformsToProtocol:@protocol(SFGamePlaySceneDelegate)],
		         @"Delegate has to conform to SFGamePlaySceneDelegate!");

        self.entityManager = [SFEntityManager sharedManager];
		self.delegate = aDelegate;
		self.levelController = [[SFLevelController alloc] initWithDelegate:_delegate];

        [SFEntityFactory sharedFactory].delegate = aDelegate;
        [SFEntityFactory sharedFactory].entityManager = _entityManager;

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

- (void)disableGameObjectsAndControls
{
    for (SFGameObject *gameObject in [self children])
   	{
        gameObject.isActive = NO;
    }
    
    _levelController.enabled = NO;

    [_delegate spaceship].isActive = NO;
}

- (void)update:(CCTime)delta
{
    for (SFEntitySystem *entitySystem in _systems)
    {
        [entitySystem update:delta];
    }

    [_levelController update:delta andGameObjects:[self children]];

}

- (void)initializeSpaceship
{
/*
	self.spaceship = [[SFSpaceship alloc] initWithDelegate:_delegate];
    _spaceship.position = CGPointMake(160, 160);
    SFRenderComponent *renderComponentA = [[SFEntityManager sharedManager] componentOfClass:[SFRenderComponent class] forEntity:_spaceship.entity];
    renderComponentA.node.position = _spaceship.position;
	[self addChild:_spaceship];
    self.healthComponent = [[SFEntityManager sharedManager] componentOfClass:[SFHealthComponent class] forEntity:_spaceship.entity];
*/
    CGSize screenSize = [CCDirector sharedDirector].view.frame.size;

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

/*   Only for debugging and dev

    [[SFEntityFactory sharedFactory] addEnemyAtPosition:ccp(160.0, 600.0)];
    SFEntity *entity = [[SFEntityFactory sharedFactory] addLoot:[[SFLootComponent alloc] initWithDropType:1] atPosition:ccp(160.0, 290.0)];
    SFCollisionRewardComponent *rewardComponent = [_entityManager componentOfClass:[SFCollisionRewardComponent class] forEntity:entity];
    rewardComponent.health = 20;
    rewardComponent.points = 100;
*/
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
	// NSLog(@"Adding a game entity %@", [aGameEntity class]);
	[self addChild:aGameEntity];
}

- (void)advanceToLevel:(NSUInteger)level
{
    _levelController.level = level;
    self.level = level;
}

- (void)playerDied
{
    _levelController.enabled = NO;

    [_healthComponent removeObserver:self forKeyPath:@"shield"];
    [_healthComponent removeObserver:self forKeyPath:@"health"];
}

@end
