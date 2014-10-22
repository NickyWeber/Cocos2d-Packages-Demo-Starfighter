#import "GamePlaySceneDelegate.h"
#import "GamePlayLayer.h"
#import "GamePlaySceneDelegate.h"


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

/*
		self.gameObjectRemovalPool = [CCArray array];

		self.monserSpawner = [[[MonsterSpawner alloc] initWithDelegate:delegate] autorelease];

		[self initializeSpaceship];

		enemyCount = 0;
		points = 0;
*/
	}
	return self;
}

@end