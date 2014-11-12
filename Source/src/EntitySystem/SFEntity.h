#import <Foundation/Foundation.h>


@interface SFEntity : NSObject

@property (nonatomic, copy, readonly) NSString *uuid;
@property (nonatomic, copy) NSString *name;

- (id)initWithUUID:(NSString *)uuid;

@end