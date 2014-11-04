#import "SFLaserCannon.h"
#import "SFGamePlaySceneDelegate.h"
#import "SFLaserBeam.h"


@interface SFLaserCannon ()

@property (nonatomic) NSTimeInterval timestampSinceLastShot;
@property (nonatomic) float shotsPerSecond;

@end


@implementation SFLaserCannon

- (id)initWithDelegate:(id <SFGamePlaySceneDelegate>)aDelegate
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
        SFLaserBeam *beamLeft = [[SFLaserBeam alloc] init];
        beamLeft.position = CGPointMake(aPosition.x - 16, aPosition.y + 30);

        SFLaserBeam *beamRight = [[SFLaserBeam alloc] init];
        beamRight.position = CGPointMake(aPosition.x + 16, aPosition.y + 30);

        [_delegate addGameEntity:beamLeft];
        [_delegate addGameEntity:beamRight];

        self.timestampSinceLastShot = [[NSDate date] timeIntervalSince1970];
    }
}

@end
