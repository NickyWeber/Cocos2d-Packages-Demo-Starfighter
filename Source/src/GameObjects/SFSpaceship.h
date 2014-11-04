#import <Foundation/Foundation.h>
#import "SFGameObject.h"

@protocol SFGamePlaySceneDelegate;


@interface SFSpaceship : SFGameObject

@property (nonatomic, weak) id<SFGamePlaySceneDelegate> delegate;

@property (nonatomic) int health;
@property (nonatomic) int healthMax;
@property (nonatomic) int shield;
@property (nonatomic) int shieldMax;

- (id)initWithDelegate:(id <SFGamePlaySceneDelegate>)delegate;

- (void)addHealth:(int)health;

- (void)addShield:(int)shield;
@end