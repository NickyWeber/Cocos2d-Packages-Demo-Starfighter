#import "SFEntityManager.h"
#import "SFEntity.h"
#import "SFComponent.h"
#import "SFTagComponent.h"


@interface  SFEntityManager()

@property (nonatomic, strong) NSMutableDictionary *entities;
@property (nonatomic, strong) NSMutableDictionary *componentsByClass;


@end


@implementation SFEntityManager

- (id)init
{
    self = [super init];

    if (self)
    {
        self.entities = [NSMutableDictionary dictionary];
        self.componentsByClass = [NSMutableDictionary dictionary];
    }

    return self;
}

+ (SFEntityManager *)sharedManager
{
    static SFEntityManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (SFEntity *)createEntity
{
    NSString *uuid = [[NSUUID UUID] UUIDString];

    SFEntity *entity = [[SFEntity alloc] initWithUUID:uuid];

    _entities[uuid] = entity;

    return entity;
}

- (void)addComponent:(SFComponent *)component toEntity:(SFEntity *)entity
{
    NSMutableDictionary *components = _componentsByClass[NSStringFromClass([component class])];
    if (!components)
    {
        components = [NSMutableDictionary dictionary];
        _componentsByClass[NSStringFromClass([component class])] = components;
    }
    components[entity.uuid] = component;
}

- (void)removeComponent:(Class)class fromEntity:(SFEntity *)entity
{
    NSMutableDictionary *components = _componentsByClass[NSStringFromClass(class)];
    [components removeObjectForKey:entity.uuid];
}

- (NSArray *)allComponentsOfEntity:(SFEntity *)entity
{
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *componentName in _componentsByClass)
    {
        SFComponent *component = _componentsByClass[componentName][entity.uuid];
        if (component)
        {
            [result addObject:component];
        }
    }

    return result;
}

- (id)componentOfClass:(Class)class forEntity:(SFEntity *)entity
{
    return _componentsByClass[NSStringFromClass(class)][entity.uuid];
}

- (void)removeEntity:(SFEntity *)entity
{
    for (NSMutableDictionary *components in _componentsByClass.allValues)
    {
        if (components[entity.uuid])
        {
            [components removeObjectForKey:entity.uuid];
        }
    }
    [_entities removeObjectForKey:entity.uuid];
}

- (NSArray *)allEntitiesPosessingComponentOfClass:(Class)class
{
    NSMutableDictionary *components = _componentsByClass[NSStringFromClass(class)];
    if (components)
    {
        NSMutableArray *retval = [NSMutableArray arrayWithCapacity:components.allKeys.count];
        for (NSString *uuid in components.allKeys)
        {
            [retval addObject:_entities[uuid]];
        }
        return retval;
    }
    else
    {
        return [NSArray array];
    }
}

- (NSArray *)entitiesWithTag:(NSString *)tag
{
    NSMutableArray *result = [NSMutableArray array];
    NSArray *entities = [self allEntitiesPosessingComponentOfClass:[SFTagComponent class]];
    for (SFEntity *entity in entities)
    {
        SFTagComponent *tagComponent = [self componentOfClass:[SFTagComponent class] forEntity:entity];
        if ([tagComponent hasTag:tag])
        {
            [result addObject:entity];
        }
    }

    return result;
}

- (SFEntity *)createEntityWithComponents:(NSArray *)components
{
    SFEntity *newEntity = [self createEntity];

    for (SFComponent *component in components)
    {
        [self addComponent:component toEntity:newEntity];
    }

    return newEntity;
}

@end
