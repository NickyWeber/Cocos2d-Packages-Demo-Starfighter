#import <Foundation/Foundation.h>

@protocol WeaponSystemProtocol <NSObject>

@required
- (void)shootWithPosition:(CGPoint)aPosition;

@end