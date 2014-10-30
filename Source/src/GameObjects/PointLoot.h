//
//  Created by nickyweber on 24.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "GameObject.h"

@class CCRepeatForever;


@interface PointLoot : GameObject
{
	id delegate;
	BOOL fadingOut;

	CCRepeatForever  *standardAnimation;

	float timeSinceSpawning;
}

@property (nonatomic, weak) id delegate;

- (id)initWithDelegate:(id)aDelegate;

@end