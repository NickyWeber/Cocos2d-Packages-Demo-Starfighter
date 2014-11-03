#import <Foundation/Foundation.h>

@protocol SFKeyEventHandlingDelegate <NSObject>

- (void)keyUp:(NSEvent *)event;
- (void)keyDown:(NSEvent *)event;

@optional
- (void)flagsChanged:(NSEvent *)event;

@end