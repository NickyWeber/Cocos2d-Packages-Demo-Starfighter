#import "SFKeyEventHandler.h"

@interface SFKeyEventHandler ()

@property (nonatomic) BOOL arrowUp;
@property (nonatomic) BOOL arrowDown;
@property (nonatomic) BOOL arrowLeft;
@property (nonatomic) BOOL arrowRight;

@end

unichar static const KEY_SPACEBAR = 0x0020;

@implementation SFKeyEventHandler

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetControls) name:NSApplicationWillResignActiveNotification object:nil];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)resetControls
{
    self.firing = NO;
    self.velocity = ccp(0.0, 0.0);

    self.arrowUp = NO;
    self.arrowLeft = NO;
    self.arrowRight = NO;
    self.arrowDown = NO;

    [self updateVelocity];
}

- (CGPoint)updateVelocity
{
    if (_arrowUp && _arrowDown)
    {
         return ccp(0.0, 0.0);
    }

    if (_arrowLeft && _arrowRight)
    {
        return ccp(0.0, 0.0);
    }

    if (_arrowUp && _arrowLeft)
    {
         return ccp(-sqrt(0.5), sqrt(0.5));
    }

    if (_arrowUp && _arrowRight)
    {
         return ccp(sqrt(0.5), sqrt(0.5));
    }

    if (_arrowDown && _arrowLeft)
    {
         return ccp(-sqrt(0.5), -sqrt(0.5));
    }

    if (_arrowDown && _arrowRight)
    {
         return ccp(sqrt(0.5), -sqrt(0.5));
    }

    if (_arrowUp)
    {
         return ccp(0.0, 1.0);
    }

    if (_arrowDown)
    {
         return ccp(0.0, -1.0);
    }

    if (_arrowRight)
    {
         return ccp(1.0, 0.0);
    }

    if (_arrowLeft)
    {
         return ccp(-1.0, 0.0);
    }

    return ccp(0.0, 0.0);
}

- (void)keyUp:(NSEvent *)event
{
    unichar key = [[event charactersIgnoringModifiers] characterAtIndex:0];
    if (key == KEY_SPACEBAR && _firing)
    {
        self.firing = NO;
    }
    else if (key == NSUpArrowFunctionKey)
    {
        self.arrowUp = NO;
    }
    else if (key == NSDownArrowFunctionKey)
    {
        self.arrowDown = NO;
    }
    else if (key == NSLeftArrowFunctionKey)
    {
        self.arrowLeft = NO;
    }
    else if (key == NSRightArrowFunctionKey)
    {
        self.arrowRight = NO;
    }
    self.velocity = [self updateVelocity];
}

- (void)keyDown:(NSEvent *)event
{
    unichar key = [[event charactersIgnoringModifiers] characterAtIndex:0];
    if (key == KEY_SPACEBAR && !_firing)
    {
        self.firing = YES;
    }
    else if (key == NSUpArrowFunctionKey)
    {
        self.arrowUp = YES;
    }
    else if (key == NSDownArrowFunctionKey)
    {
        self.arrowDown = YES;
    }
    else if (key == NSLeftArrowFunctionKey)
    {
        self.arrowLeft = YES;
    }
    else if (key == NSRightArrowFunctionKey)
    {
        self.arrowRight = YES;
    }
    self.velocity = [self updateVelocity];
}

@end