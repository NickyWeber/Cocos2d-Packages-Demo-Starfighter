//
//  Created by nickyweber on 24.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "ccTypes.h"

@protocol GamePlaySceneDelegate;


@interface LevelController : NSObject

@property (nonatomic, weak) id<GamePlaySceneDelegate> delegate;
@property (nonatomic) NSUInteger level;
@property (nonatomic) NSUInteger totalEnemies;
@property (nonatomic) BOOL enabled;

- (id)initWithDelegate:(id<GamePlaySceneDelegate>)aDelegate;

- (void)update:(CCTime)deltaTime andGameObjects:(NSArray *)someGameObjects;

@end