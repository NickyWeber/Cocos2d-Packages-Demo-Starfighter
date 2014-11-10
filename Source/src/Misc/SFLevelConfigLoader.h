#import <Foundation/Foundation.h>

@interface SFLevelConfigLoader : NSObject

- (NSArray *)loadLevelsWithFileName:(NSString *)filename;

@end