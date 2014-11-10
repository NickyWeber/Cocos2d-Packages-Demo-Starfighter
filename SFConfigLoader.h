#import <Foundation/Foundation.h>

@class SFEntity;

@interface SFConfigLoader : NSObject

- (NSArray *)componentsWithConfigName:(NSString *)name level:(NSUInteger)level;

- (void)invalidateCache;

@end
