#import <Foundation/Foundation.h>

@protocol SFKeyEventHandlingDelegate;

@interface SFGLView : CCGLView

@property (nonatomic, weak) id <SFKeyEventHandlingDelegate> keyHandler;

@end