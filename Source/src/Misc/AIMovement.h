//
//  Created by nickyweber on 26.01.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "ccTypes.h"
#import "AIMovementProtocol.h"


@interface AIMovement : NSObject <AIMovementProtocol>

@property (nonatomic) NSUInteger level;

- (instancetype)initWithLevel:(NSUInteger)level;


@end