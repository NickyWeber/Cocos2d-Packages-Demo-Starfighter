#import <Foundation/Foundation.h>
#import "GameObject.h"

@protocol GamePlaySceneDelegate;


@interface Spaceship : GameObject

@property (nonatomic, weak) id<GamePlaySceneDelegate> delegate;

@property (nonatomic) int health;
@property (nonatomic) int healthMax;
@property (nonatomic) int shield;
@property (nonatomic) int shieldMax;

- (id)initWithDelegate:(id <GamePlaySceneDelegate>)delegate;

- (void)addHealth:(int)health;

- (void)addShield:(int)shield;
@end