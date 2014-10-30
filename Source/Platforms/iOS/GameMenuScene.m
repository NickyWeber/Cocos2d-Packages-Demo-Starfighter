#import "GameMenuScene.h"
#import "BackgroundLayer.h"
#import "CCLabelTTF+GameFont.h"
#import "GamePlayScene.h"


@implementation GameMenuScene

- (id)init
{
    self = [super init];

    if (self)
    {
        CCButton *button = [CCButton buttonWithTitle:@"Play" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"ccbResources/ccbButtonNormal.png"]];
        button.label.fontName = @"Courier-Bold";
        button.preferredSize = CGSizeMake(40, 40);
        button.label.fontSize = 28.0;
        button.horizontalPadding = 10.0;
        button.contentSize = CGSizeMake(112.0, 48.0);
        button.positionType = CCPositionTypeNormalized;
        button.position = ccp(0.0, 0.0);
        button.anchorPoint = ccp(0.0, 0.0);
        [button setTarget:self selector:@selector(playGame)];

        BackgroundLayer *backgroundLayer = [BackgroundLayer node];
        [self addChild:backgroundLayer z:-1];

        CCLabelTTF *title = [CCLabelTTF gameLabelWithSize:36.0];
        title.string = @"Starfighter";
        title.positionType = CCPositionTypeNormalized;
        title.position = ccp(0.5, 0.8);
        [self addChild:title];

        int highscore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"highscore"] intValue];

        CCLabelTTF *highscoreLabel = [CCLabelTTF gameLabelWithSize:24.0 blockSize:2.0];
        highscoreLabel.string = [NSString stringWithFormat:@"Highscore: %d", highscore];
        highscoreLabel.horizontalAlignment = CCTextAlignmentCenter;
        highscoreLabel.positionType = CCPositionTypeNormalized;
        highscoreLabel.position = ccp(0.5, 0.6);
        [self addChild:highscoreLabel];


        CCEffectPixellate *effectPixellate = [[CCEffectPixellate alloc] initWithBlockSize:3.0];
        CCEffectNode *effectNode = [[CCEffectNode alloc] initWithWidth:(int) button.contentSize.width
                                                                height:(int) button.contentSize.height];
        effectNode.effect = effectPixellate;
        effectNode.positionType = CCPositionTypeNormalized;
        effectNode.position = ccp(0.5, 0.5);
        effectNode.anchorPoint = ccp(0.5, 0.4);
        [effectNode addChild:button];
        [self addChild:effectNode];
    }

    return self;
}

- (void)playGame
{
    [[CCDirector sharedDirector] replaceScene:[[GamePlayScene alloc] init]
                               withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown duration:0.3]];
}

@end