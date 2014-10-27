#import "LaserCannon.h"
#import "GamePlaySceneDelegate.h"
#import "LaserBeam.h"


@interface LaserCannon ()

@property (nonatomic) NSTimeInterval timestampSinceLastShot;
@property (nonatomic) float shotsPerSecond;

@end


@implementation LaserCannon

- (id)initWithDelegate:(id <GamePlaySceneDelegate>)aDelegate
{
    self = [super init];

    if (self)
    {
        self.delegate = aDelegate;

        self.timestampSinceLastShot = [[NSDate date] timeIntervalSince1970];

        self.shotsPerSecond = 5.0f;
    }

    return self;
}

- (BOOL)canShoot
{
    NSTimeInterval timePassedSinceLastShot = [[NSDate date] timeIntervalSince1970] - _timestampSinceLastShot;

    return timePassedSinceLastShot >= 1.0f / _shotsPerSecond;
}

- (void)shootWithPosition:(CGPoint)aPosition
{
    if ([self canShoot])
    {
        LaserBeam *beamLeft = [[LaserBeam alloc] init];
        beamLeft.position = CGPointMake(aPosition.x - 16, aPosition.y + 30);

        LaserBeam *beamRight = [[LaserBeam alloc] init];
        beamRight.position = CGPointMake(aPosition.x + 16, aPosition.y + 30);

        [_delegate addGameEntity:beamLeft];
        [_delegate addGameEntity:beamRight];

        self.timestampSinceLastShot = [[NSDate date] timeIntervalSince1970];
    }
}

@end
