#import "SFGameMenuScene.h"
#import "SFBackgroundLayer.h"
#import "SFGamePlayScene.h"
#import "SFEntityConfigLoader.h"
#import "SFDLCScene.h"
#import "SFUIHelper.h"

@implementation SFGameMenuScene

- (id)init
{
    self = [super init];

    if (self)
    {
        CCNode *playButton = [SFUIHelper createMenuButtonWithTitle:@"Play" target:self selector:@selector(playGame) atRelPosition:ccp(0.5, 0.5)];
        [self addChild:playButton];

        CCNode *dlcButton = [SFUIHelper createMenuButtonWithTitle:@"DLC" target:self selector:@selector(downloads) atRelPosition:ccp(0.5, 0.4)];
        [self addChild:dlcButton];

        SFBackgroundLayer *backgroundLayer = [SFBackgroundLayer node];
        [self addChild:backgroundLayer z:-1];

        CCLabelTTF *title = [SFUIHelper gameLabelWithSize:36.0];
        title.string = @"Starfighter";
        title.positionType = CCPositionTypeNormalized;
        title.position = ccp(0.5, 0.8);
        [self addChild:title];

        int highscore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"highscore"] intValue];

        CCLabelTTF *highscoreLabel = [SFUIHelper gameLabelWithSize:24.0 blockSize:2.0];
        highscoreLabel.string = [NSString stringWithFormat:@"Highscore: %d", highscore];
        highscoreLabel.horizontalAlignment = CCTextAlignmentCenter;
        highscoreLabel.positionType = CCPositionTypeNormalized;
        highscoreLabel.position = ccp(0.5, 0.6);
        [self addChild:highscoreLabel];
    }

    return self;
}

- (void)playGame
{
    [[CCDirector sharedDirector] replaceScene:[[SFGamePlayScene alloc] init]
                               withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown duration:0.3]];
}

- (void)downloads
{
    [[CCDirector sharedDirector] replaceScene:[[SFDLCScene alloc] init]
                               withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionUp duration:0.3]];
}

@end