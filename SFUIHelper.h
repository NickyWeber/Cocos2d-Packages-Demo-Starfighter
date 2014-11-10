#import <Foundation/Foundation.h>


@interface SFUIHelper : NSObject

+ (CCNode *)createMenuButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector atRelPosition:(CGPoint)atPosition;

+ (CCLabelTTF *)gameLabelWithSize:(CGFloat)size blockSize:(float)blockSize;

+ (CCLabelTTF *)gameLabelWithSize:(CGFloat)size;

@end