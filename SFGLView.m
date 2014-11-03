#import "SFGLView.h"
#import "SFKeyEventHandlingDelegate.h"

@implementation SFGLView

- (void)keyUp:(NSEvent *)theEvent
{
    if ([_keyHandler respondsToSelector:@selector(keyUp:)])
    {
        [_keyHandler keyUp:theEvent];
    }
}

- (void)keyDown:(NSEvent *)theEvent
{
    if ([_keyHandler respondsToSelector:@selector(keyDown:)])
    {
        [_keyHandler keyDown:theEvent];
    }
}

- (void)flagsChanged:(NSEvent *)theEvent
{
    if ([_keyHandler respondsToSelector:@selector(flagsChanged:)])
    {
        [_keyHandler flagsChanged:theEvent];
    }
}

@end
