#import "SFUIHelper.h"
#import "CCEffectInvert.h"


@implementation SFUIHelper

+ (NSDictionary *)createMenuButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector atRelPosition:(CGPoint)atPosition
{
    CCButton *button = [CCButton buttonWithTitle:title spriteFrame:[CCSpriteFrame frameWithImageNamed:@"ccbResources/ccbButtonNormal.png"]];
    button.label.fontName = @"Courier-Bold";
    button.label.fontSize = 28.0;
    button.horizontalPadding = 10.0;
    button.positionType = CCPositionTypeNormalized;
    button.position = ccp(0.0, 0.0);
    button.anchorPoint = ccp(0.0, 0.0);

    [button setTarget:target selector:selector];

    CCEffectNode *effectNode = [[CCEffectNode alloc] initWithWidth:(int) button.contentSize.width
                                                            height:(int) button.contentSize.height];

    CCEffectPixellate *effectPixellate = [[CCEffectPixellate alloc] initWithBlockSize:3.0];
    effectNode.effect = effectPixellate;
    effectNode.positionType = CCPositionTypeNormalized;
    effectNode.position = atPosition;
    effectNode.anchorPoint = ccp(0.5, 0.5);
    [effectNode addChild:button];

    return @{@"button":button, @"effectNode" : effectNode};
}

+ (CCLabelTTF *)gameLabelWithSize:(CGFloat)size blockSize:(float)blockSize
{
    CCLabelTTF *label = [[CCLabelTTF alloc] initWithString:@"" fontName:@"Courier-Bold" fontSize:size];
    label.color = [CCColor blackColor];

    CCEffectPixellate *effectPixellate = [[CCEffectPixellate alloc] initWithBlockSize:blockSize];
    CCEffectInvert *effectInvert = [[CCEffectInvert alloc] init];
    CCEffectStack *effectStack = [[CCEffectStack alloc] initWithEffects:effectInvert, effectPixellate, nil];

    label.effect = effectStack;

    return label;
}

+ (CCLabelTTF *)gameLabelWithSize:(CGFloat)size
{
    return [SFUIHelper gameLabelWithSize:size blockSize:3.0];
}

@end