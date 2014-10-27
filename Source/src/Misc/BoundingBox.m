//
//  Created by nickyweber on 23.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BoundingBox.h"


@implementation BoundingBox

- (id)initWithRect:(CGRect)aRect
{
	self = [super init];
	if (self)
	{
		boundingBox = aRect;
	}
	return self;
}

+ (BoundingBox *)boundingBoxWithRect:(CGRect)aRect
{
	return [[BoundingBox alloc] initWithRect:aRect];
}

- (void)setRect:(CGRect)newRect;
{
	boundingBox = newRect;
}

- (CGRect)rect
{
	return boundingBox;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%f.2, %f.2  %f.2 x %f.2",
									  boundingBox.origin.x,
									  boundingBox.origin.y,
									  boundingBox.size.width,
									  boundingBox.size.height];
}

@end
