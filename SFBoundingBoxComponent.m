#import "SFBoundingBoxComponent.h"


@implementation SFBoundingBoxComponent

- (id)initWithRect:(CGRect)aRect
{
	self = [super init];
	if (self)
	{
        self.rect = aRect;
	}
	return self;
}

@end