#import <Foundation/Foundation.h>
#import "SFComponent.h"

@interface SFTagComponent : SFComponent

@property (nonatomic, strong) NSMutableArray *tags;

- (void)addTag:(id)tag;

- (void)removeTag:(id)tag;

- (BOOL)hasTag:(id)tag;

@end
