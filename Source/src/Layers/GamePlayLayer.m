#import "GamePlaySceneDelegate.h"
#import "GamePlayLayer.h"
#import "GamePlaySceneDelegate.h"
#import "Spaceship.h"
#import "HUDLayer.h"
#import "LevelController.h"
#import "LaserBeam.h"
#import "Enemy.h"
#import "SneakyButton.h"
#import "SneakyJoystick.h"
#import "PointLoot.h"
#import "HealthLoot.h"


@interface GamePlayLayer ()

@property (nonatomic, strong) LevelController *levelController;
@property (nonatomic, strong) NSMutableArray *gameObjectRemovalPool;

@property (nonatomic) double timeSinceLastStatusUpdate;
@property (nonatomic) NSUInteger level;
@end


@implementation GamePlayLayer

- (id)initWithDelegate:(id<GamePlaySceneDelegate>)aDelegate
{
	self = [super init];

	if ((self))
	{
		NSAssert(aDelegate != nil, @"Delegate has to be set!");
		NSAssert([aDelegate conformsToProtocol:@protocol(GamePlaySceneDelegate)],
		         @"Delegate has to conform to GamePlaySceneDelegate!");

		self.delegate = aDelegate;
		self.gameObjectRemovalPool = [NSMutableArray array];
        
		self.levelController = [[LevelController alloc] initWithDelegate:_delegate];

		[self initializeSpaceship];
	}
	return self;
}

- (void)disableGameObjectsAndControls
{
    for (GameObject *gameObject in [self children])
   	{
        gameObject.isActive = NO;
    }
    
    _levelController.enabled = NO;

    [[_delegate fireButton] setEnabled:NO];
    [[_delegate joystick] setEnabled:NO];
}

- (void)update:(CCTime)delta
{
    [_levelController update:delta andGameObjects:[self children]];

   	for (GameObject *gameObject in [[self children] copy])
   	{
   		if ([gameObject isKindOfClass:[GameObject class]]
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
    HealthLoot *loot = [[HealthLoot alloc] initWithDelegate:_delegate];
    loot.position = ccp(160.0, 240.0);
    [self addChild:loot];

	self.spaceship = [[Spaceship alloc] initWithDelegate:_delegate];
    _spaceship.position = CGPointMake(160, 160);
	[self addChild:_spaceship];
}

- (void)addGameObjectToRemovalPoolIfMarkedWithGameObject:(GameObject *)aGameObject
{
	if (aGameObject.removeInSeparateLoop)
	{
		[_gameObjectRemovalPool addObject:aGameObject];
	}
}

- (void)removeGameObjectsMarkedForRemoval
{
	for (GameObject *aGameObjectToBeRemoved in [_gameObjectRemovalPool copy])
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

		for (GameObject *gameObject in [self children]) {
			if ([gameObject isKindOfClass:[LaserBeam class]]) {
				shots++;
			}
			if ([gameObject isKindOfClass:[Enemy class]]) {
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
