#import <Foundation/Foundation.h>
#import "CCFileUtils.h"

@interface CCFileUtils (Packages)

- (NSString *)filePathForFilename:(NSString *)filename;

- (NSString *)filePathForFilename:(NSString *)filename inDirectory:(NSString *)inDirectory;

@end