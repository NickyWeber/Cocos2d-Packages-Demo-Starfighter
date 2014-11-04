//
//  Created by nickyweber on 23.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface SFBoundingBox : NSObject
{
	CGRect boundingBox;
}

- (void)setRect:(CGRect)newRect;
- (CGRect)rect;

- (id)initWithRect:(CGRect)aRect;
+ (SFBoundingBox *)boundingBoxWithRect:(CGRect)aRect;

@end