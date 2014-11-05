#import <Foundation/Foundation.h>
#import "SFComponent.h"

@interface SFTimeToLiveComponent : SFComponent

@property (nonatomic) double timeToLive;
@property (nonatomic) double fadeDuration;
@property (nonatomic) NSTimeInterval timeSinceSpawning;
@property (nonatomic) BOOL fadingOut;

- (instancetype)initWithTimeToLive:(double)timeToLive fadeDuration:(double)fadeDuration;

@end