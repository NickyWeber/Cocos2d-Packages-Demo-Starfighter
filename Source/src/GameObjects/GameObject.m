//
//  Created by nickyweber on 08.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GameObject.h"
#import "BoundingBox.h"


@implementation GameObject

- (id)initWithImageNamed:(NSString *)imageName
{
	self = [super initWithImageNamed:imageName];

	if (self)
	{
		self.isActive = YES;
		self.boundingBoxes = [NSMutableArray array];
		self.removeInSeparateLoop = NO;
	}
	return self;
}


#pragma mark - public methods

- (void)updateStateWithTimeDelta:(CCTime)aTimeDelta andGameObjects:(NSArray *)gameObjects
{
	NSLog(@"*** Override me! Called by %@(%@) ***", self, [self class]);
}

- (BOOL)detectCollisionWithGameObject:(GameObject *)aGameObject
{
	// simple collision test, before we start looking through all the boundingboxes
	if ([self detectTextureCollisionWithGameObject:aGameObject])
	{
		for (BoundingBox *aBoundingBox in aGameObject.boundingBoxes)
		{
			if ([self detectCollisionWithRect:[aGameObject absoluteCollisionRectWithBoundingBox:aBoundingBox]])
			{
				return YES;
			}
		}
	}
	return NO;
}

- (BOOL)detectTextureCollisionWithGameObject:(GameObject *)aGameObject
{
    return CGRectIntersectsRect([self absoluteTextureRect], [aGameObject absoluteTextureRect]);
}

- (BOOL)detectCollisionWithRect:(CGRect)aCollisionRect
{
	for (BoundingBox *aBoundingBox in _boundingBoxes)
	{
		if (CGRectIntersectsRect([self absoluteCollisionRectWithRect:[aBoundingBox rect]], aCollisionRect))
		{
			return YES;
		}
	}

	return NO;
}

- (CGRect)absoluteTextureRect
{
	return [self absoluteCollisionRectWithRect:[self textureRect]];
}

- (CGRect)absoluteCollisionRectWithRect:(CGRect)aRect
{
	CGRect tmp = CGRectMake(self.position.x + aRect.origin.x - self.contentSize.width / 2,
							self.position.y + aRect.origin.y - self.contentSize.height / 2,
							aRect.size.width,
							aRect.size.height);

	return tmp;
}

- (CGRect)absoluteCollisionRectWithBoundingBox:(BoundingBox *)aBoundingBox;
{
	return [self absoluteCollisionRectWithRect:[aBoundingBox rect]];
}


- (void)addBoundingBoxWithRect:(CGRect)aRect
{
	[self addBoundingBoxWithBoundingBox:[BoundingBox boundingBoxWithRect:aRect]];
}

- (void)addBoundingBoxWithBoundingBox:(BoundingBox *)aBoundingBox;
{
	[self.boundingBoxes addObject:aBoundingBox];
}


- (void)despawn
{
	self.removeInSeparateLoop = YES;
	self.isActive = NO;
	// This didn't work: removing objects from the main loop caused big problems.
	// [self removeFromParentAndCleanup:YES];
}


@end