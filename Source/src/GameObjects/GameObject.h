//
//  Created by nickyweber on 08.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "CCSprite.h"

@class BoundingBox;

@interface GameObject : CCSprite

@property (nonatomic, strong) NSMutableArray *boundingBoxes;
@property (nonatomic) BOOL isActive;
@property (nonatomic) BOOL removeInSeparateLoop;

- (void)updateStateWithTimeDelta:(CCTime)aTimeDelta andGameObjects:(NSArray *)gameObjects;

- (BOOL)detectTextureCollisionWithGameObject:(GameObject *)aGameObject;
- (BOOL)detectCollisionWithGameObject:(GameObject *)aGameObject;
- (BOOL)detectCollisionWithRect:(CGRect)aCollisionRect;

- (CGRect)absoluteCollisionRectWithRect:(CGRect)aRect;
- (CGRect)absoluteCollisionRectWithBoundingBox:(BoundingBox *)aBoundingBox;
- (CGRect)absoluteTextureRect;

- (void)addBoundingBoxWithRect:(CGRect)aRect;
- (void)addBoundingBoxWithBoundingBox:(BoundingBox *)aBoundingBox;

- (void)despawn;

@end