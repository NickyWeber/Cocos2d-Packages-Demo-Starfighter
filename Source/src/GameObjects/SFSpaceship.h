#import <Foundation/Foundation.h>
#import "SFGameObject.h"

@protocol SFGamePlaySceneDelegate;
@class SFEntity;


@interface SFSpaceship : SFGameObject

@property (nonatomic, weak) id<SFGamePlaySceneDelegate> delegate;

/*
@property (nonatomic) int health;
@property (nonatomic) int healthMax;
*/

@property (nonatomic) int shield;
@property (nonatomic) int shieldMax;

@property (nonatomic, strong) SFEntity *entity;

- (id)initWithDelegate:(id <SFGamePlaySceneDelegate>)delegate;

- (void)addHealth:(int)health;

- (void)addShield:(int)shield;
@end