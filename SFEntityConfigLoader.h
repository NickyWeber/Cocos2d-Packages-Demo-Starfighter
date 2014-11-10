#import <Foundation/Foundation.h>

@class SFEntity;

@interface SFEntityConfigLoader : NSObject

- (NSArray *)componentsWithConfigName:(NSString *)name levelId:(NSString *)levelId;

- (void)invalidateCache;

@end
