//
//  SneakyJoystickSkinnedBase.m
//  SneakyJoystick
//
//  Created by CJ Hanson on 2/18/10.
//  Copyright 2010 Hanson Interactive. All rights reserved.
//

#import "SneakyJoystickSkinnedBase.h"
#import "SneakyJoystick.h"

@implementation SneakyJoystickSkinnedBase

- (id)init
{
    self = [super init];

    if (self)
    {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)update:(CCTime)delta
{
	if (_joystick && _thumbSprite) {
		[_thumbSprite setPosition:_joystick.stickPosition];
	}
}

- (void)setContentSize:(CGSize)s
{
	_contentSize = s;
	_backgroundSprite.contentSize = s;
	_joystick.joystickRadius = s.width / 2;
}

- (void)setBackgroundSprite:(CCSprite *)aSprite
{
	if (_backgroundSprite) {
		if (_backgroundSprite.parent) {
			[_backgroundSprite.parent removeChild:_backgroundSprite cleanup:YES];
		}
	}
	_backgroundSprite = aSprite;
	if (aSprite) {
		[self addChild:_backgroundSprite z:0];

		[self setContentSize:_backgroundSprite.contentSize];
	}
}

- (void)setThumbSprite:(CCSprite *)aSprite
{
	if (_thumbSprite) {
		if (_thumbSprite.parent) {
			[_thumbSprite.parent removeChild:_thumbSprite cleanup:YES];
		}
	}
	_thumbSprite = aSprite;
	if (aSprite) {
		[self addChild:_thumbSprite z:1];

		[_joystick setThumbRadius:_thumbSprite.contentSize.width / 2];
	}
}

- (void)setJoystick:(SneakyJoystick *)aJoystick
{
	if (_joystick) {
		if (_joystick.parent) {
			[_joystick.parent removeChild:_joystick cleanup:YES];
		}
	}
	_joystick = aJoystick;
	if (aJoystick) {
		[self addChild:_joystick z:2];
		if (_thumbSprite) {
			[_joystick setThumbRadius:_thumbSprite.contentSize.width / 2];
		} else {
			[_joystick setThumbRadius:0];
		}

		if (_backgroundSprite) {
			[_joystick setJoystickRadius:_backgroundSprite.contentSize.width / 2];
		}
	}
}

@end
