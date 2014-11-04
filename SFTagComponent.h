#import <Foundation/Foundation.h>
#import "SFComponent.h"

@interface SFTagComponent : SFComponent

@property (nonatomic, strong) NSMutableSet *tags;

- (void)addTag:(id)tag;

- (void)removeTag:(id)tag;

- (BOOL)hasTag:(id)tag;

@end
