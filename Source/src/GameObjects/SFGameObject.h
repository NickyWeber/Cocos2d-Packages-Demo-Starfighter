//
//  Created by nickyweber on 08.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "CCSprite.h"

@class SFBoundingBox;

@interface SFGameObject : CCSprite

@property (nonatomic, strong) NSMutableArray *boundingBoxes;
@property (nonatomic) BOOL isActive;
@property (nonatomic) BOOL removeInSeparateLoop;

- (void)updateStateWithTimeDelta:(CCTime)aTimeDelta andGameObjects:(NSArray *)gameObjects;

- (BOOL)detectTextureCollisionWithGameObject:(SFGameObject *)aGameObject;
- (BOOL)detectCollisionWithGameObject:(SFGameObject *)aGameObject;
- (BOOL)detectCollisionWithRect:(CGRect)aCollisionRect;

- (CGRect)absoluteCollisionRectWithRect:(CGRect)aRect;
- (CGRect)absoluteCollisionRectWithBoundingBox:(SFBoundingBox *)aBoundingBox;
- (CGRect)absoluteTextureRect;

- (void)addBoundingBoxWithRect:(CGRect)aRect;
- (void)addBoundingBoxWithBoundingBox:(SFBoundingBox *)aBoundingBox;

- (void)despawn;

@end