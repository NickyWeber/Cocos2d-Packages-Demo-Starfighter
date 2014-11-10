//
//  Created by nickyweber on 24.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SFLevelController.h"
#import "SFGamePlaySceneDelegate.h"
#import "SFEntityManager.h"
#import "SFEntityFactory.h"
#import "SFLevel.h"


@interface SFLevelController ()

@property (nonatomic) NSUInteger totalSpawned;
@property (nonatomic) BOOL complete;
@property (nonatomic) NSTimeInterval lastSpawnTime;
@property (nonatomic) double spawnTime;

@end


@implementation SFLevelController

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
        self.enabled = YES;
        self.lastSpawnTime = [[NSDate date] timeIntervalSince1970] - 10000000;
        self.spawnTime = 3.0;
	}

	return self;
}

- (void)setLevel:(SFLevel *)level
{
    self.complete = NO;
    self.totalSpawned = 0;

    _level = level;

    [SFEntityFactory sharedFactory].currentLevelId = level.id;

    self.totalEnemies = _level.enemyCount;

    // NSLog(@"*** New Level: %u - total enemies %u", level, _totalEnemies);
    // NSLog(@"%@", [NSThread callStackSymbols]);
}

- (void)update:(CCTime)deltaTime
{
    if (_complete || !_enabled)
    {
        return;
    }

    [self spawnEnemy];

    [self completeLevel];
}

- (void)spawnEnemy
{
    NSTimeInterval timePassedSinceLastShot = [[NSDate date] timeIntervalSince1970] - _lastSpawnTime;

    if (timePassedSinceLastShot >= _spawnTime
        && (_totalSpawned < _totalEnemies))
	{
        self.totalSpawned += 1;

		CGPoint position = CGPointMake((CGFloat) (([CCDirector sharedDirector].view.frame.size.width - 20.0) * CCRANDOM_0_1() + 20),
                                     (CGFloat) ([CCDirector sharedDirector].view.frame.size.height + 50.0));

        [[SFEntityFactory sharedFactory] addEnemyAtPosition:position];

        self.lastSpawnTime = [[NSDate date] timeIntervalSince1970];
	}
}

- (void)completeLevel
{
    NSArray *enemies = [[SFEntityManager sharedManager] entitiesWithTag:@"Enemy"];

    if (_totalEnemies == _totalSpawned
        && enemies.count == 0)
    {
        self.complete = YES;
        [_delegate levelCompleted:_level];
    }
}

@end
