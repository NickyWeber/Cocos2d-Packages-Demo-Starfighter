//
//  Created by nickyweber on 24.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "ccTypes.h"

@protocol GamePlaySceneDelegate;

@class CCArray;



@interface MonsterSpawner : NSObject

@property (nonatomic, weak) id<GamePlaySceneDelegate> delegate;

- (id)initWithDelegate:(id<GamePlaySceneDelegate>)aDelegate;

- (void)update:(CCTime)deltaTime andGameObjects:(NSArray *)someGameObjects;

@end