#import "SFConfigLoader.h"
#import "SFEntity.h"
#import "SFRenderComponent.h"
#import "SFCollisionComponent.h"
#import "CCAnimation.h"
#import "SFLootComponent.h"
#import "SFDropTable.h"

@interface SFConfigLoader()

@property (nonatomic, strong) NSMutableDictionary *configCache;

@end


@implementation SFConfigLoader

- (id)init
{
    self = [super init];

    if (self)
    {
        self.configCache = [NSMutableDictionary dictionary];
    }

    return self;
}

- (NSArray *)componentsWithConfigName:(NSString *)name level:(NSUInteger)level
{
    NSAssert(name != nil, @"name must not be nil");

    NSDictionary *jsonDict = _configCache[name];
    if (!jsonDict)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSError *error = nil;
        jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

        if (!jsonDict)
        {
            NSLog(@"Error parsing json file \"%@\" with error: %@", filePath, error);
            return nil;
        }

        _configCache[name] = jsonDict;
    }

    NSMutableArray *components = [NSMutableArray array];

    NSArray *componentsDict = jsonDict[@"components"];
    for (NSDictionary *componentDict in componentsDict)
    {
        Class componentClass = [self classForComponentName:componentDict[@"name"]];
        id component = [[componentClass alloc] init];

        [self setProperties:componentDict forComponent:component];

        [components addObject:component];

        // NSLog(@"%@", componentDict);
    }

    NSDictionary *levelDataDict = jsonDict[@"levelData"];
    [self patchComponents:components forLevel:level withLevelData:levelDataDict];

    return components;
}

- (void)patchComponents:(NSMutableArray *)componentsToPatch forLevel:(NSUInteger)level withLevelData:(NSDictionary *)levelData
{
    if (!levelData
        || level <= 1)
    {
        return;
    }

    NSString *levelIndex = [NSString stringWithFormat:@"%lu", level];
    NSArray *componentsToPatchData = levelData[levelIndex];

    for (NSDictionary *componentDict in componentsToPatchData)
    {
        Class componentClass = [self classForComponentName:componentDict[@"name"]];
        SFComponent *component = [self componentOfClass:componentClass inComponents:componentsToPatch];

        if (!component)
        {
            continue;
        }

        [self setProperties:componentDict forComponent:component];
    }
}

- (SFComponent *)componentOfClass:(Class)class inComponents:(NSArray *)components
{
    for (SFComponent *component in components)
    {
        if ([component isKindOfClass:class])
        {
            return component;
        }
    }
    return nil;
}

- (void)setProperties:(NSDictionary *)dictionary forComponent:(id)component
{
    for (NSString *key in dictionary)
    {
        if ([key isEqualToString:@"name"])
        {
            continue;
        }

/*
        if ([key isEqualToString:@"target"])
        {
            NSLog(@"break");
        }
*/

        id value = dictionary[key];

        [self setComponentPropertyWithComponent:component key:key value:value];
    }
}

- (void)setComponentPropertyWithComponent:(id)component key:(NSString *)key value:(id)value
{
    if ([component isKindOfClass:[SFRenderComponent class]] && [key isEqualToString:@"spriteName"])
    {
        CCSprite *valueToSet = [CCSprite spriteWithImageNamed:value];
        [component setValue:valueToSet forKey:@"node"];
    }
    else if ([component isKindOfClass:[SFLootComponent class]] && [key isEqualToString:@"dropTable"])
    {
        SFDropTable *dropTable = [self createDropTable:value];
        [((SFLootComponent *)component) setDropTable:dropTable];
    }
    else if ([component isKindOfClass:[SFRenderComponent class]] && [key isEqualToString:@"defaultAnimation"])
    {
        CCActionAnimate *action = [self loadAnimation:value repeatForever:YES];
        [((SFRenderComponent *)component) setDefaultActionAnimate:action];
    }
    else if ([component isKindOfClass:[SFCollisionComponent class]] && [key isEqualToString:@"hitAnimation"])
    {
        CCActionAnimate *animate = [self loadAnimation:value repeatForever:NO];
        [component setValue:animate forKey:@"hitAnimationAction"];
    }
    else if ([value isKindOfClass:[NSNumber class]]
             || [value isKindOfClass:[NSArray class]]
             || [value isKindOfClass:[NSString class]])
    {
        [component setValue:value forKey:key];
    }
    else if ([value isKindOfClass:[NSDictionary class]])
    {
        NSString *type = value[@"type"];
        if ([type isEqualToString:@"point"])
        {
            CGPoint point = ccp([value[@"x"] floatValue], [value[@"y"] floatValue]);
            NSValue *valueToSet = [NSValue valueWithCGPoint:point];
            [component setValue:valueToSet forKey:key];
        }
    }
}

- (SFDropTable *)createDropTable:(id)value
{
    SFDropTable *dropTable = [[SFDropTable  alloc] init];
    dropTable.chance = [value[@"chance"] doubleValue];
    dropTable.list = value[@"list"];
    return dropTable;
}

- (CCActionAnimate *)loadAnimation:(id)value repeatForever:(BOOL)repeatForever
{
    CCAnimation *animation = [CCAnimation animation];

    for (NSString *spriteFrameName in value[@"spriteFrames"])
    {
        [animation addSpriteFrameWithFilename:spriteFrameName];
    }

    animation.delayPerUnit = [value[@"delayPerUnit"] floatValue];
    animation.restoreOriginalFrame = [value[@"restoreOriginalFrame"] boolValue];

    CCActionAnimate *actionAnimate = [CCActionAnimate actionWithAnimation:animation];
    actionAnimate.duration = [value[@"duration"] doubleValue];

    if (repeatForever)
    {
        return [CCActionRepeatForever actionWithAction:actionAnimate];
    }

    return actionAnimate;
}

- (Class)classForComponentName:(NSString *)name
{
    NSString *firstChar = [name substringToIndex:1];
    NSString *modString = [[firstChar uppercaseString] stringByAppendingString:[name substringFromIndex:1]];
    NSString *className = [NSString stringWithFormat:@"SF%@Component", modString];

    Class result = NSClassFromString(className);
    NSAssert(result != nil, @"Could not load component with name %@ and reflected classname %@", name, className);

    return result;
}

- (void)invalidateCache
{
    self.configCache = [NSMutableDictionary dictionary];
}

@end
