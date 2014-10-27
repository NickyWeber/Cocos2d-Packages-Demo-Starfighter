//
//  Created by nickyweber on 24.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MonsterSpawner.h"
#import "ccTypes.h"
#import "Enemy.h"
#import "ccMacros.h"
#import "GamePlaySceneDelegate.h"
#import "GamePlayLayer.h"
// #import "CashLoot.h"


@implementation MonsterSpawner

#pragma mark -
#pragma mark - initialization

- (id)init
{
	return [self init];
}

- (id)initWithDelegate:(id)aDelegate
{
	self = [super init];
	if (self)
	{
		NSAssert(aDelegate != nil, @"Delegate has to be set!");
		NSAssert([aDelegate conformsToProtocol:@protocol(GamePlaySceneDelegate)],
		         @"Delegate has to conform to GamePlaySceneDelegateProtocol!");

		self.delegate = aDelegate;
	}

	return self;
}


#pragma mark -
#pragma mark - public methods

- (void)update:(CCTime)deltaTime andGameObjects:(NSArray *)someGameObjects
{
	int enemyCount = 0;

	for (id gameObject in someGameObjects)
	{
		if ([gameObject isKindOfClass:[Enemy class]]
			&& [gameObject isActive])
		{
			enemyCount++;
		}
	}

	if (enemyCount <= 0)
	{
		Enemy *enemy = [[Enemy alloc] initEnemyWithDelegate:_delegate];
		enemy.position = CGPointMake((CGFloat) (([CCDirector sharedDirector].view.frame.size.width - 20.0) * CCRANDOM_0_1() + 20),
                                     // (CGFloat) (([CCDirector sharedDirector].view.frame.size.height) + enemy.contentSize.height / 2));
                                     (CGFloat) (([CCDirector sharedDirector].view.frame.size.height - 50.0) + enemy.contentSize.height / 2));


/*
		enemy.position = CGPointMake(20.0,
                                     (CGFloat) ([CCDirector sharedDirector].view.frame.size.height - 20.0 + enemy.contentSize.height / 2));

*/

/*
		CashLoot *loot = [[CashLoot alloc] initWithDelegate:delegate];
		enemy.loot = loot;
*/

		[_delegate addGameEntity:enemy];
	}
	// END OF TODO create monster spawner class, which can read XML and so on... :)
}

@end