#import "CCFileUtils+Packages.h"

@implementation CCFileUtils (Packages)

- (NSString *)filePathForFilename:(NSString *)filename
{
    return [self filePathForFilename:filename inDirectory:nil];
}

- (NSString *)filePathForFilename:(NSString *)filename inDirectory:(NSString *)inDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSArray *searchPath = [CCFileUtils sharedFileUtils].searchPath;
    for (NSString *path in searchPath)
    {
        NSString *pathToSearch = inDirectory != nil
            ? [path stringByAppendingPathComponent:inDirectory]
            : path;

        NSURL *url = [NSURL fileURLWithPath:pathToSearch];

        NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:url
                                              includingPropertiesForKeys:@[NSURLNameKey, NSURLIsDirectoryKey]
                                                                 options:NSDirectoryEnumerationSkipsHiddenFiles
                                                            errorHandler:^BOOL(NSURL *aUrl, NSError *error)
        {
            if (error && error.code != NSFileReadNoSuchFileError)
            {
                NSLog(@"[Error] %@ (%@)", error, url);
                return NO;
            }

            return YES;
        }];

        for (NSURL *fileURL in enumerator)
        {
            if ([[fileURL lastPathComponent] isEqualToString:filename])
            {
                return fileURL.path;
            }

            // NSLog(@"%@ - %@", [fileURL lastPathComponent], fileURL);
        }
    }
    return nil;
}


@end