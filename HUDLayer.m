#import "HUDLayer.h"


@implementation HUDLayer
// ${MEMBERS}


#pragma mark - Initialization

- (id)init
{
    self = [super init];

    if (self)
    {
        CGSize displaySize = [CCDirector sharedDirector].view.frame.size;

        self.scoreLabel = [CCLabelTTF labelWithString:@"1000"
                                             fontName:@"Courier-Bold"
                                             fontSize:24.0];

        _scoreLabel.horizontalAlignment = CCTextAlignmentRight;

        _scoreLabel.anchorPoint = CGPointMake(0.0, 0.0);
      	_scoreLabel.position = CGPointMake(0.0, (CGFloat) (displaySize.height - _scoreLabel.contentSize.height - 2.0));
      	[self addChild:self.scoreLabel];

        self.healthBar = [CCNodeColor nodeWithColor:[CCColor colorWithRed:1.0 green:0.0 blue:0.0]];
        _healthBar.contentSize = CGSizeMake(160.0, 3.0);
        _healthBar.position = CGPointMake(0.0, (CGFloat) (displaySize.height - 3.0));
        _healthBar.anchorPoint = CGPointMake(0.0, 0.0);
        [self addChild:_healthBar];

        self.shieldBar = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.0 green:1.0 blue:1.0]];
        _shieldBar.contentSize = CGSizeMake(160.0, 3.0);
        _shieldBar.position = CGPointMake(0.0, (CGFloat) (displaySize.height - 7.0));
        _shieldBar.anchorPoint = CGPointMake(0.0, 0.0);
        [self addChild:_shieldBar];
    }

    return self;
}

@end