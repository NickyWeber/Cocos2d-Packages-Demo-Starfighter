//
//  Created by nickyweber on 24.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SFLevelController.h"
#import "SFEnemy.h"
#import "SFGamePlaySceneDelegate.h"
#import "SFRenderComponent.h"
#import "SFEntityManager.h"
#import "SFEntityFactory.h"


@interface SFLevelController ()

@property (nonatomic) NSUInteger totalSpawned;
@property (nonatomic) BOOL complete;
@property (nonatomic) NSTimeInterval lastSpawnTime;
@property (nonatomic) double spawTime;

@end


@implementation SFLevelController

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
		NSAssert([aDelegate conformsToProtocol:@protocol(SFGamePlaySceneDelegate)],
		         @"Delegate has to conform to GamePlaySceneDelegateProtocol!");

        self.totalSpawned = 0;
		self.delegate = aDelegate;
        self.level = 1;
        self.enabled = YES;
        self.lastSpawnTime = [[NSDate date] timeIntervalSince1970] - 10000000;
        self.spawTime = 3.0;
	}

	return self;
}

- (NSUInteger)totalEnemiesForLevel:(NSUInteger)level
{
    return (NSUInteger) (3+ 3 * (level - 1));
}

- (void)setLevel:(NSUInteger)level
{
    self.complete = NO;
    self.totalSpawned = 0;

    _level = level;
    self.totalEnemies = [self totalEnemiesForLevel:_level];

    // NSLog(@"*** New Level: %u - total enemies %u", level, _totalEnemies);
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

    int enemyCount = [self countEnemies:someGameObjects];

    enemyCount = [self spawnEnemy:enemyCount];

    [self completeLevel:enemyCount];
}

- (int)spawnEnemy:(int)enemyCount
{
    NSTimeInterval timePassedSinceLastShot = [[NSDate date] timeIntervalSince1970] - _lastSpawnTime;

    if (timePassedSinceLastShot >= _spawTime
        && (_totalSpawned < _totalEnemies))
	{
        self.totalSpawned += 1;

		CGPoint position = CGPointMake((CGFloat) (([CCDirector sharedDirector].view.frame.size.width - 20.0) * CCRANDOM_0_1() + 20),
                                     (CGFloat) ([CCDirector sharedDirector].view.frame.size.height + 50.0));

        [[SFEntityFactory sharedFactory] addEnemyAtPosition:position];

        self.lastSpawnTime = [[NSDate date] timeIntervalSince1970];

        enemyCount++;
	}
    return enemyCount;
}

- (void)completeLevel:(int)enemyCount
{
    if (_totalEnemies == _totalSpawned
        && enemyCount == 0)
    {
        self.complete = YES;
        [_delegate levelCompleted:_level];
    }
}

- (int)countEnemies:(NSArray *)someGameObjects
{
    int enemyCount = 0;

    for (id gameObject in someGameObjects)
	{
		if ([gameObject isKindOfClass:[SFEnemy class]]
			&& [gameObject isActive])
		{
			enemyCount++;
		}
	}
    return enemyCount;
}

@end