//
//  SneakyButtonSkinnedBase.m
//  SneakyInput
//
//  Created by Nick Pannuto on 2/19/10.
//  Copyright 2010 Sneakyness, llc.. All rights reserved.
//

#import "SneakyButtonSkinnedBase.h"
#import "SneakyButton.h"

@implementation SneakyButtonSkinnedBase

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)update:(CCTime)delta
{
    [self watchSelf];
}

- (void)watchSelf
{
    if (!_button.status)
    {
        _disabledSprite.visible = _disabledSprite != nil;
    }
    else
    {
        if (!_button.active)
        {
            _pressSprite.visible = NO;
            if (_button.value == 0)
            {
                _activatedSprite.visible = NO;
                if (_defaultSprite)
                {
                    _defaultSprite.visible = YES;
                }
            }
            else
            {
                _activatedSprite.visible = YES;
            }
        }
        else
        {
            _defaultSprite.visible = NO;
            if (_pressSprite)
            {
                _pressSprite.visible = YES;
            }
        }
    }
}

- (void)setContentSize:(CGSize)s
{
    _contentSize = s;
    _defaultSprite.contentSize = s;
    _button.radius = s.width / 2;
}

- (void)setDefaultSprite:(CCSprite *)aSprite
{
    if (_defaultSprite)
    {
        if (_defaultSprite.parent)
        {
            [_defaultSprite.parent removeChild:_defaultSprite cleanup:YES];
        }
    }
    _defaultSprite = aSprite;
    if (aSprite)
    {
        [self addChild:_defaultSprite z:0];

        [self setContentSize:_defaultSprite.contentSize];
    }
}

- (void)setActivatedSprite:(CCSprite *)aSprite
{
    if (_activatedSprite)
    {
        if (_activatedSprite.parent)
        {
            [_activatedSprite.parent removeChild:_activatedSprite cleanup:YES];
        }
    }
    _activatedSprite = aSprite;
    if (aSprite)
    {
        [self addChild:_activatedSprite z:1];

        [self setContentSize:_activatedSprite.contentSize];
    }
}

- (void)setDisabledSprite:(CCSprite *)aSprite
{
    if (_disabledSprite)
    {
        if (_disabledSprite.parent)
        {
            [_disabledSprite.parent removeChild:_disabledSprite cleanup:YES];
        }
    }
    _disabledSprite = aSprite;
    if (aSprite)
    {
        [self addChild:_disabledSprite z:2];

        [self setContentSize:_disabledSprite.contentSize];
    }
}

- (void)setPressSprite:(CCSprite *)aSprite
{
    if (_pressSprite)
    {
        if (_pressSprite.parent)
        {
            [_pressSprite.parent removeChild:_pressSprite cleanup:YES];
        }
    }
    _pressSprite = aSprite;
    if (aSprite)
    {
        [self addChild:_pressSprite z:3];

        [self setContentSize:_pressSprite.contentSize];
    }
}

- (void)setButton:(SneakyButton *)aButton
{
    if (_button)
    {
        if (_button.parent)
        {
            [_button.parent removeChild:_button cleanup:YES];
        }
    }
    _button = aButton;
    if (_button)
    {
        [self addChild:_button z:4];
        if (_defaultSprite)
        {
            [_button setRadius:_defaultSprite.contentSize.width / 2];
        }
    }
}

@end
