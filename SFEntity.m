#import "SFEntity.h"

@interface SFEntity()

@property (nonatomic, copy, readwrite) NSString *uuid;

@end

@implementation SFEntity

- (id)initWithUUID:(NSString *)uuid
{
    self = [super init];

    if (self)
    {
        self.uuid = uuid;
    }

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%@)", _name, _uuid];
}

@end