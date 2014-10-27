#import <Foundation/Foundation.h>
#import "WeaponSystemProtocol.h"

@protocol GamePlaySceneDelegate;

@interface LaserCannon : NSObject <WeaponSystemProtocol>

@property (nonatomic, weak) id<GamePlaySceneDelegate> delegate;

- (id)initWithDelegate:(id<GamePlaySceneDelegate>)aDelegate;

@end
