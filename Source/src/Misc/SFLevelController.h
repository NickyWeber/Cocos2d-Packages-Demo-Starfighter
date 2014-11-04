//
//  Created by nickyweber on 24.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "ccTypes.h"

@protocol SFGamePlaySceneDelegate;


@interface SFLevelController : NSObject

@property (nonatomic, weak) id<SFGamePlaySceneDelegate> delegate;
@property (nonatomic) NSUInteger level;
@property (nonatomic) NSUInteger totalEnemies;
@property (nonatomic) BOOL enabled;

- (id)initWithDelegate:(id<SFGamePlaySceneDelegate>)aDelegate;

- (void)update:(CCTime)deltaTime andGameObjects:(NSArray *)someGameObjects;

@end