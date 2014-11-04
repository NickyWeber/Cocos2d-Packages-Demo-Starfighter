#import <Foundation/Foundation.h>
#import "SFWeaponSystemProtocol.h"

@protocol SFGamePlaySceneDelegate;

@interface SFLaserCannon : NSObject <SFWeaponSystemProtocol>

@property (nonatomic, weak) id<SFGamePlaySceneDelegate> delegate;

- (id)initWithDelegate:(id<SFGamePlaySceneDelegate>)aDelegate;

@end
