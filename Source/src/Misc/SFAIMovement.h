//
//  Created by nickyweber on 26.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "ccTypes.h"
#import "SFAIMovementProtocol.h"


@interface SFAIMovement : NSObject <SFAIMovementProtocol>

@property (nonatomic) NSUInteger level;

- (instancetype)initWithLevel:(NSUInteger)level;


@end