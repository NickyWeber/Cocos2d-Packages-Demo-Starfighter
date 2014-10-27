//
//  button.m
//  Classroom Demo
//
//  Created by Nick Pannuto on 2/10/10.
//  Copyright 2010 Sneakyness, llc.. All rights reserved.
//

#import "SneakyButton.h"
#import "SneakyJoystick.h"

@interface SneakyButton()

@property (nonatomic, readwrite) BOOL value;
@property (nonatomic, readwrite) BOOL active;

@property (nonatomic) CGRect bounds;
@property (nonatomic) CGPoint center;


@property (nonatomic) float radiusSq;

@end


@implementation SneakyButton

- (id)initWithRect:(CGRect)rect
{
    self = [super init];
    if (self)
    {

        self.bounds = CGRectMake(0, 0, rect.size.width, rect.size.height);
        self.center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
        self.status = 1; //defaults to enabled
        self.active = NO;
        self.value = NO;
        self.isHoldable = YES;
        self.isToggleable = 0;
        self.radius = 32.0f;
        self.rateLimit = 1.0f / 120.0f;

        self.userInteractionEnabled = YES;

        self.position = rect.origin;
    }
    return self;
}

- (void)limiter:(float)delta
{
    self.value = NO;
    [self unschedule:@selector(limiter:)];
    self.active = NO;
}

- (void)setRadius:(float)r
{
    _radius = r;
    self.radiusSq = r * r;
}


#pragma mark Touch Delegate

- (BOOL)hitTestWithWorldPos:(CGPoint)pos
{
    // CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    CGPoint location = [self convertToNodeSpace:pos];
    //Do a fast rect check before doing a circle hit check:
    if (location.x < -_radius || location.x > _radius || location.y < -_radius || location.y > _radius)
    {
        return NO;
    }
    else
    {
        float dSq = location.x * location.x + location.y * location.y;
        if (_radiusSq > dSq)
        {
            return YES;
        }
    }
    return NO;
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    NSLog(@"FIRE!");

    if (_active)
    {
        return;
    }

    self.active = YES;
    if (!_isHoldable && !_isToggleable)
    {
        self.value = YES;
        [self schedule:@selector(limiter:) interval:_rateLimit];
    }
    if (_isHoldable)
    {
        self.value = NO;
    }
    if (_isToggleable)
    {
        self.value = !_value;
    }
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if (!_active)
    {
        return;
    }

    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    location = [self convertToNodeSpace:location];
    //Do a fast rect check before doing a circle hit check:
    if (location.x < -_radius || location.x > _radius || location.y < -_radius || location.y > _radius)
    {
        return;
    }
    else
    {
        float dSq = location.x * location.x + location.y * location.y;
        if (_radiusSq > dSq)
        {
            if (_isHoldable)
            {
                self.value = YES;
            }
        }
        else
        {
            if (_isHoldable)
            {
                self.value = NO;
            }
            self.active = NO;
        }
    }
}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if (!_active)
    {
        return;
    }
    if (_isHoldable)
    {
        self.value = NO;
    }
    if (_isHoldable || _isToggleable)
    {
        self.active = NO;
    }
}

- (void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    [self touchEnded:touch withEvent:event];
}

@end
