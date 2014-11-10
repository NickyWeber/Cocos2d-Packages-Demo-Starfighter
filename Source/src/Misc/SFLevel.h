#import <Foundation/Foundation.h>


@interface SFLevel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *id;
@property (nonatomic) NSUInteger enemyCount;
@property (nonatomic, copy) NSString *spawnType;

@end