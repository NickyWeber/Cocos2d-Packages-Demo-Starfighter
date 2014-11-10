#import "SFLevelConfigLoader.h"
#import "SFLevel.h"


@implementation SFLevelConfigLoader

- (NSArray *)loadLevelsWithFileName:(NSString *)filename
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;

    NSArray *jsonArray;
    jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

    if (!jsonArray)
    {
        NSLog(@"Error parsing json file \"%@\" with error: %@", filePath, error);
        return nil;
    }

    NSMutableArray *levels = [NSMutableArray array];
    for (NSDictionary *levelDict in jsonArray)
    {
        SFLevel *level = [self createLevelWithDictionary:levelDict];
        [levels addObject:level];
    }

    return levels;
}

- (SFLevel *)createLevelWithDictionary:(NSDictionary *)levelDict
{
    SFLevel *level = [[SFLevel alloc] init];
    level.enemyCount = [levelDict[@"enemyCount"] unsignedIntegerValue];
    level.id = levelDict[@"id"];
    level.name = levelDict[@"name"];
    level.spawnType = levelDict[@"spawnType"];
    
    return level;
}

@end