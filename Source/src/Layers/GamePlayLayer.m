#import "GamePlaySceneDelegate.h"
#import "GamePlayLayer.h"
#import "GamePlaySceneDelegate.h"
#import "Spaceship.h"
#import "HUDLayer.h"


@interface GamePlayLayer ()

@property (nonatomic, strong) NSMutableArray *gameObjectRemovalPool;
@property (nonatomic) int enemyCount;
@property (nonatomic) int points;

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
        
/*
		self.monserSpawner = [[[MonsterSpawner alloc] initWithDelegate:delegate] autorelease];

*/
		[self initializeSpaceship];

		self.enemyCount = 0;
		self.points = 0;
	}
	return self;
}

- (void)update:(CCTime)delta
{
    // [monserSpawner update:deltaTime andGameObjects:[self children]];

   	for (GameObject *gameObject in [self children])
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

/*
- (void)debugStatusWithDeltaTime:(ccTime)aTimeDelta
{
	if (timeSinceLastStatusUpdate >= 1.0)
	{
		*/
/*
		int shots = 0;
		int enemies = 0;

		for (GameObject *gameObject in [self children]) {
			if ([gameObject isKindOfClass:[LaserBeam class]]) {
				shots++;
			}
			if ([gameObject isKindOfClass:[Enemy class]]) {
				enemies++;
			}
		}*//*


		// NSLog(@"Status update - Enemies: %d, Shots: %d", enemies, shots);
		NSLog(@"Status update - game objects: %d", [[self children] count]);

		timeSinceLastStatusUpdate = 0.0;
	}

	timeSinceLastStatusUpdate += aTimeDelta;
}
*/

@end
