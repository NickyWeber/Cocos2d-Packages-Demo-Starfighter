//
//  SneakyButtonSkinnedBase.h
//  SneakyInput
//
//  Created by Nick Pannuto on 2/19/10.
//  Copyright 2010 Sneakyness, llc.. All rights reserved.
//

#import "cocos2d.h"

@class SneakyButton;

@interface SneakyButtonSkinnedBase : CCSprite

@property (nonatomic, strong) CCSprite *defaultSprite;
@property (nonatomic, strong) CCSprite *activatedSprite;
@property (nonatomic, strong) CCSprite *disabledSprite;
@property (nonatomic, strong) CCSprite *pressSprite;
@property (nonatomic, strong) SneakyButton *button;

@end
