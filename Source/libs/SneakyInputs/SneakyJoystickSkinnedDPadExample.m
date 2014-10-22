//
//  SneakyJoystickSkinnedDPadExample.m
//  SneakyJoystick
//
//  Created by CJ Hanson on 2/18/10.
//  Copyright 2010 Hanson Interactive. All rights reserved.
//

#import "SneakyJoystickSkinnedDPadExample.h"
#import "cocos2d.h"
#import "SneakyJoystick.h"

@implementation SneakyJoystickSkinnedDPadExample

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.userInteractionEnabled = YES;

        self.backgroundSprite = [CCSprite spriteWithImageNamed:@"Sprites/Controls/DPad_BG.png"];

        self.joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0.0f, 0.0f, _contentSize.width, _contentSize.height)];
        self.joystick.thumbRadius = 0.0f;
        self.joystick.deadRadius = 0.0f;
        self.joystick.isDPad = YES;
        self.joystick.numberOfDirections = 8;
    }

    return self;
}

@end
