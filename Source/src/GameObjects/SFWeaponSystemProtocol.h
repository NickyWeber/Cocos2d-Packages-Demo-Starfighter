#import <Foundation/Foundation.h>

@protocol SFWeaponSystemProtocol <NSObject>

@required
- (void)shootWithPosition:(CGPoint)aPosition;

@end