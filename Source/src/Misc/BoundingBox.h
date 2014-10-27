//
//  Created by nickyweber on 23.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface BoundingBox : NSObject
{
	CGRect boundingBox;
}

- (void)setRect:(CGRect)newRect;
- (CGRect)rect;

- (id)initWithRect:(CGRect)aRect;
+ (BoundingBox *)boundingBoxWithRect:(CGRect)aRect;

@end