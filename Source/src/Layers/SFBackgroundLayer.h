#import <Foundation/Foundation.h>


@interface SFBackgroundLayer : CCNode

@property (nonatomic) double newDebrisMinTime;
@property (nonatomic) double newDebrisVariance;
@property (nonatomic) double debrisBaseSpeed;
@property (nonatomic) double debrisSpeedVariance;

@end