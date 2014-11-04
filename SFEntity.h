#import <Foundation/Foundation.h>


@interface SFEntity : NSObject

@property (nonatomic, copy, readonly) NSString *uuid;

- (id)initWithUUID:(NSString *)uuid;

@end