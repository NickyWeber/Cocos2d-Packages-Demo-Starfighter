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
#import "SFHealthLoot.h"
#import "SFShieldLoot.h"
#import "SFEntityManager.h"
#import "SFHealthSystem.h"


@interface SFGamePlayLayer ()

@property (nonatomic, strong) SFLevelController *levelController;
@property (nonatomic, strong) NSMutableArray *gameObjectRemovalPool;
@property (nonatomic) double timeSinceLastStatusUpdate;
@property (nonatomic) NSUInteger level;

@property (nonatomic, strong) SFEntityManager *entityManager;
@property (nonatomic, strong) SFHealthSystem *healthSystem;

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
        self.healthSystem = [[SFHealthSystem alloc] initWithEntityManager:_entityManager];

		self.delegate = aDelegate;
		self.gameObjectRemovalPool = [NSMutableArray array];
        
		self.levelController = [[SFLevelController alloc] initWithDelegate:_delegate];

		[self initializeSpaceship];
	}
	return self;
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
    [_healthSystem update:delta];

    [_levelController update:delta andGameObjects:[self children]];

   	for (SFGameObject *gameObject in [[self children] copy])
   	{
   		if ([gameObject isKindOfClass:[SFGameObject class]]
   			&& gameObject.isActive)
   		{
   			[gameObject updateStateWithTimeDelta:delta andGameObjects:[self children]];
   		}

   		[self addGameObjectToRemovalPoolIfMarkedWithGameObject:gameObject];
   	}

   	[self removeGameObjectsMarkedForRemoval];

//   	[self debugStatusWithDeltaTime:deltaTime];

}

- (void)initializeSpaceship
{
	self.spaceship = [[SFSpaceship alloc] initWithDelegate:_delegate];
    _spaceship.position = CGPointMake(160, 160);
	[self addChild:_spaceship];
}

- (void)addGameObjectToRemovalPoolIfMarkedWithGameObject:(SFGameObject *)aGameObject
{
	if (aGameObject.removeInSeparateLoop)
	{
		[_gameObjectRemovalPool addObject:aGameObject];
	}
}

- (void)removeGameObjectsMarkedForRemoval
{
	for (SFGameObject *aGameObjectToBeRemoved in [_gameObjectRemovalPool copy])
	{
		[aGameObjectToBeRemoved removeFromParentAndCleanup:YES];
        [_gameObjectRemovalPool removeObject:aGameObjectToBeRemoved];
	}
}

- (void)addGameEntity:(CCNode *)aGameEntity
{
	// NSLog(@"Adding a game entity %@", [aGameEntity class]);
	[self addChild:aGameEntity];
}

- (void)addGameEntity:(CCNode *)aGameEntity z:(int)zOrder
{
	[self addChild:aGameEntity z:zOrder];
}

- (void)debugStatusWithDeltaTime:(CCTime)aTimeDelta
{
	if (_timeSinceLastStatusUpdate >= 1.0)
	{
		int shots = 0;
		int enemies = 0;

		for (SFGameObject *gameObject in [self children]) {
			if ([gameObject isKindOfClass:[SFLaserBeam class]]) {
				shots++;
			}
			if ([gameObject isKindOfClass:[SFEnemy class]]) {
				enemies++;
			}
		}


		// NSLog(@"Status update - Enemies: %d, Shots: %d", enemies, shots);
		NSLog(@"Status update - game objects: %d", [[self children] count]);

		self.timeSinceLastStatusUpdate = 0.0;
	}

	self.timeSinceLastStatusUpdate += aTimeDelta;
}

- (void)advanceToLevel:(NSUInteger)level
{
    _levelController.level = level;
    self.level = level;
}

@end
