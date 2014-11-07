#import <Foundation/Foundation.h>

@class SFEntity;

@interface SFConfigLoader : NSObject

- (NSArray *)componentsWithConfigName:(NSString *)name;

- (void)invalidateCache;

@end
