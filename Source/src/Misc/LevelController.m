//
//  Created by nickyweber on 24.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "LevelController.h"
#import "ccTypes.h"
#import "Enemy.h"
#import "ccMacros.h"
#import "GamePlaySceneDelegate.h"
#import "GamePlayLayer.h"
// #import "CashLoot.h"

@interface LevelController()

@property (nonatomic) NSUInteger totalSpawned;

@property (nonatomic) BOOL complete;
@end


@implementation LevelController

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

        self.totalSpawned = 0;
		self.delegate = aDelegate;
        self.level = 1;
        self.enabled = YES;
	}

	return self;
}

- (NSUInteger)totalEnemiesForLevel:(NSUInteger)level
{
    return (NSUInteger) (300 + 3 * (level - 1));
}

- (void)setLevel:(NSUInteger)level
{
    self.complete = NO;
    self.totalSpawned = 0;

    _level = level;
    self.totalEnemies = [self totalEnemiesForLevel:_level];

    NSLog(@"*** New Level: %u - total enemies %u", level, _totalEnemies);
    // NSLog(@"%@", [NSThread callStackSymbols]);
}


#pragma mark -
#pragma mark - public methods

- (void)update:(CCTime)deltaTime andGameObjects:(NSArray *)someGameObjects
{
    if (_complete || !_enabled)
    {
        return;
    }

	int enemyCount = 0;

	for (id gameObject in someGameObjects)
	{
		if ([gameObject isKindOfClass:[Enemy class]]
			&& [gameObject isActive])
		{
			enemyCount++;
		}
	}

	if (enemyCount == 0
        && (_totalSpawned < _totalEnemies))
	{
        self.totalSpawned += 1;
        // NSLog(@"Enemies left for next level: %u", _totalEnemies - _totalSpawned);

		Enemy *enemy = [[Enemy alloc] initEnemyWithDelegate:_delegate level:_level];
		enemy.position = CGPointMake((CGFloat) (([CCDirector sharedDirector].view.frame.size.width - 20.0) * CCRANDOM_0_1() + 20),
                                     (CGFloat) (([CCDirector sharedDirector].view.frame.size.height - 50.0) + enemy.contentSize.height / 2));

		[_delegate addGameEntity:enemy];

        enemyCount++;
	}

    if (_totalEnemies == _totalSpawned
        && enemyCount == 0)
    {
        self.complete = YES;
        [_delegate levelCompleted:_level];
    }
}

@end