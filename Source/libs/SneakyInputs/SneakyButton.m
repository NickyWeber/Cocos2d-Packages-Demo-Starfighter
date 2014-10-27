//
//  button.m
//  Classroom Demo
//
//  Created by Nick Pannuto on 2/10/10.
//  Copyright 2010 Sneakyness, llc.. All rights reserved.
//

#import "SneakyButton.h"
#import "SneakyJoystick.h"

@implementation SneakyButton

- (id)initWithRect:(CGRect)rect
{
    self = [super init];
    if (self)
    {

        bounds = CGRectMake(0, 0, rect.size.width, rect.size.height);
        center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
        status = 1; //defaults to enabled
        active = NO;
        value = 0;
        isHoldable = 0;
        isToggleable = 0;
        radius = 32.0f;
        rateLimit = 1.0f / 120.0f;

        self.userInteractionEnabled = YES;

        self.position = rect.origin;
    }
    return self;
}

- (void)limiter:(float)delta
{
    value = 0;
    [self unschedule:@selector(limiter:)];
    active = NO;
}

- (void)setRadius:(float)r
{
    radius = r;
    radiusSq = r * r;
}


#pragma mark Touch Delegate

- (BOOL)hitTestWithWorldPos:(CGPoint)pos
{
    // CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    CGPoint location = [self convertToNodeSpace:pos];
    //Do a fast rect check before doing a circle hit check:
    if (location.x < -radius || location.x > radius || location.y < -radius || location.y > radius)
    {
        return NO;
    }
    else
    {
        float dSq = location.x * location.x + location.y * location.y;
        if (radiusSq > dSq)
        {
            return YES;
        }
    }
    return NO;
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    NSLog(@"FIRE!");

    if (active)
    {
        return;
    }

    active = YES;
    if (!isHoldable && !isToggleable)
    {
        value = 1;
        [self schedule:@selector(limiter:) interval:rateLimit];
    }
    if (isHoldable)
    {
        value = 1;
    }
    if (isToggleable)
    {
        value = !value;
    }
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if (!active)
    {
        return;
    }

    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    location = [self convertToNodeSpace:location];
    //Do a fast rect check before doing a circle hit check:
    if (location.x < -radius || location.x > radius || location.y < -radius || location.y > radius)
    {
        return;
    }
    else
    {
        float dSq = location.x * location.x + location.y * location.y;
        if (radiusSq > dSq)
        {
            if (isHoldable)
            {
                value = 1;
            }
        }
        else
        {
            if (isHoldable)
            {
                value = 0;
            }
            active = NO;
        }
    }
}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if (!active)
    {
        return;
    }
    if (isHoldable)
    {
        value = 0;
    }
    if (isHoldable || isToggleable)
    {
        active = NO;
    }
}

- (void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    [self touchEnded:touch withEvent:event];
}

@end
