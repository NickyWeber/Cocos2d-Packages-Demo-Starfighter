#import "SFConfigLoader.h"
#import "SFEntity.h"
#import "SFRenderComponent.h"
#import "SFCollisionComponent.h"
#import "CCAnimation.h"

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

- (NSArray *)componentsWithConfigName:(NSString *)name
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

    return components;
}

- (void)setProperties:(NSDictionary *)dictionary forComponent:(id)component
{
    for (NSString *key in dictionary)
    {
        if ([key isEqualToString:@"name"])
        {
            continue;
        }

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
    else if ([component isKindOfClass:[SFRenderComponent class]] && [key isEqualToString:@"defaultAnimation"])
    {
        CCActionAnimate *action = [self loadAnimation:value repeatForever:YES];
        [[((SFRenderComponent *)component) node] runAction:action];
    }
    else if ([component isKindOfClass:[SFCollisionComponent class]] && [key isEqualToString:@"hitAnimation"])
    {
        CCActionAnimate *animate = [self loadAnimation:value repeatForever:NO];
        [component setValue:animate forKey:@"hitAnimationAction"];
    }
    else if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSArray class]])
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
    actionAnimate.duration = [value[@"duration"] floatValue];

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
