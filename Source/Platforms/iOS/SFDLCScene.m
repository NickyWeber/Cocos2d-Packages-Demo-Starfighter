#import "SFDLCScene.h"
#import "SFBackgroundLayer.h"
#import "SFUIHelper.h"
#import "SFGameMenuScene.h"
#import "CCPackageManager.h"
#import "CCPackage.h"

static NSString *PACKAGE_NAME_PATCH_1_1 = @"patch_1_1";
static NSString *PACKAGE_NAME_LEVELS = @"levels";


@interface SFDLCScene()

@property (nonatomic, strong) CCPackage *patchPackage;
@property (nonatomic, strong) CCPackage *levelsPackage;

@property (nonatomic, strong) CCButton *patchPackageButton;
@property (nonatomic, strong) CCButton *levelsPackageButton;

@property (nonatomic, strong) NSMutableDictionary *buttonForPackageName;
@property (nonatomic, strong) NSMutableDictionary *packageForButton;

@end


@implementation SFDLCScene

- (id)init
{
    self = [super init];

    if (self)
    {
        self.buttonForPackageName = [NSMutableDictionary dictionary];

        [CCPackageManager sharedManager].delegate = self;
        [CCPackageManager sharedManager].baseURL = [NSURL URLWithString:@"http://siner.de"];
        self.patchPackage = [[CCPackageManager sharedManager] packageWithName:PACKAGE_NAME_PATCH_1_1];
        self.levelsPackage = [[CCPackageManager sharedManager] packageWithName:PACKAGE_NAME_LEVELS];

        SFBackgroundLayer *backgroundLayer = [SFBackgroundLayer node];
        [self addChild:backgroundLayer z:-1];
        backgroundLayer.newDebrisMinTime = 0.1;
        backgroundLayer.newDebrisVariance = 0.15;
        backgroundLayer.debrisBaseSpeed = 500.0;
        backgroundLayer.debrisSpeedVariance = 500.0;

        CCLabelTTF *titlePatch = [SFUIHelper gameLabelWithSize:20.0 blockSize:2.0];
        titlePatch.string = @"Patch 1.1";
        titlePatch.positionType = CCPositionTypeNormalized;
        titlePatch.position = ccp(0.5, 0.7);
        [self addChild:titlePatch];

        NSDictionary *buttonDownloadPatch = [SFUIHelper createMenuButtonWithTitle:@"Download" target:self selector:@selector(downloadPatchPackage) atRelPosition:ccp(0.5, 0.65)];
        [self addChild:buttonDownloadPatch[@"effectNode"]];
        self.patchPackageButton = buttonDownloadPatch[@"button"];

        CCLabelTTF *titleLevels = [SFUIHelper gameLabelWithSize:20.0 blockSize:2.0];
        titleLevels.string = @"More Levels";
        titleLevels.positionType = CCPositionTypeNormalized;
        titleLevels.position = ccp(0.5, 0.55);
        [self addChild:titleLevels];

        NSDictionary *buttonDownloadLevels = [SFUIHelper createMenuButtonWithTitle:@"Download" target:self selector:@selector(downloadLevelsPackage) atRelPosition:ccp(0.5, 0.5)];
        [self addChild:buttonDownloadLevels[@"effectNode"]];
        self.levelsPackageButton = buttonDownloadLevels[@"button"];


        NSDictionary *buttonBack = [SFUIHelper createMenuButtonWithTitle:@"back" target:self selector:@selector(back) atRelPosition:ccp(0.5, 0.2)];
        [self addChild:buttonBack[@"effectNode"]];

        CCLabelTTF *title = [SFUIHelper gameLabelWithSize:36.0];
        title.string = @"Downloads";
        title.positionType = CCPositionTypeNormalized;
        title.position = ccp(0.5, 0.9);
        [self addChild:title];

        [self configureButtons];
    }

    return self;
}

- (void)dealloc
{
    @try
    {
        [self.levelsPackage removeObserver:self forKeyPath:@"status"];
        [self.patchPackage removeObserver:self forKeyPath:@"status"];
    }
    @catch (NSException *e)
    {

    }
}


- (void)configureButton:(CCButton *)button packageName:(NSString *)packageName package:(CCPackage *)package
{
    _buttonForPackageName[packageName] = button;
    if (package)
    {
        [self updateButton:button withPackage:package];
        button.userObject = package;

        [package addObserver:self
                  forKeyPath:@"status"
                     options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                     context:NULL];
    }
}

- (void)configureButtons
{
    [self configureButton:_patchPackageButton packageName:PACKAGE_NAME_PATCH_1_1 package:_patchPackage];
    [self configureButton:_levelsPackageButton packageName:PACKAGE_NAME_LEVELS package:_levelsPackage];
}

- (void)back
{
    [[CCDirector sharedDirector] replaceScene:[[SFGameMenuScene alloc] init]
                               withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown duration:0.3]];
}

- (void)downloadLevelsPackage
{
    self.levelsPackage = [[CCPackageManager sharedManager] downloadPackageWithName:@"levels" enableAfterDownload:YES];
    [self configureButton:_levelsPackageButton packageName:PACKAGE_NAME_LEVELS package:_levelsPackage];
}

- (void)downloadPatchPackage
{
    self.patchPackage = [[CCPackageManager sharedManager] downloadPackageWithName:PACKAGE_NAME_PATCH_1_1 enableAfterDownload:YES];
    [self configureButton:_patchPackageButton packageName:PACKAGE_NAME_PATCH_1_1 package:_patchPackage];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"])
    {
        CCPackage *package = object;
        CCButton *button = _buttonForPackageName[package.name];
        [self updateButton:button withPackage:package];
    }
}

- (void)updateButton:(CCButton *)button withPackage:(CCPackage *)package
{
    switch (package.status)
    {
        case CCPackageStatusDownloading:
            [self setButtons:button title:@"Pause" selector:@selector(pauseDownload:) enabled:YES];
            break;

        case CCPackageStatusDownloadPaused:
            [self setButtons:button title:@"Resume" selector:@selector(resumeDownload:) enabled:YES];
            break;

        case CCPackageStatusDownloadFailed:
            [self setButtons:button title:@"Retry" selector:@selector(retryDownload:) enabled:YES];
            break;

        case CCPackageStatusDownloaded:
            [self setButtons:button title:@"Download" selector:nil enabled:NO];
            break;

        case CCPackageStatusUnzipping:
            [self setButtons:button title:@"Download" selector:nil enabled:NO];
            break;

        case CCPackageStatusUnzipped:
            [self setButtons:button title:@"Download" selector:nil enabled:NO];
            break;

        case CCPackageStatusUnzipFailed:
            [self setButtons:button title:@"Retry" selector:@selector(retryDownload:) enabled:YES];
            break;

        case CCPackageStatusInstallationFailed:
            [self setButtons:button title:@"Retry" selector:@selector(retryDownload:) enabled:YES];
            break;

        case CCPackageStatusInstalledEnabled:
            [self setButtons:button title:@"Disable" selector:@selector(disablePackage:) enabled:YES];
            break;

        case CCPackageStatusInstalledDisabled:
            [self setButtons:button title:@"Enable" selector:@selector(enablePackage:) enabled:YES];
            break;

        default: break;
    }
}

- (void)enablePackage:(id)sender
{
    CCPackage *package = [sender userObject];
    NSError *error;
    if (![[CCPackageManager sharedManager] enablePackage:package error:&error])
    {
        NSLog(@"Error enabling package: %@", error);
    }
}

- (void)disablePackage:(id)sender
{
    CCPackage *package = [sender userObject];
    [[CCPackageManager sharedManager] disablePackage:package error:nil];

    NSError *error;
    if (![[CCPackageManager sharedManager] disablePackage:package error:&error])
    {
        NSLog(@"Error disabling package: %@", error);
    }
}

- (void)retryDownload:(id)sender
{
    CCPackage *package = [sender userObject];
    [[CCPackageManager sharedManager] downloadPackage:package enableAfterDownload:YES];
}

- (void)resumeDownload:(id)sender
{
    CCPackage *package = [sender userObject];
    [[CCPackageManager sharedManager] resumeDownloadOfPackage:package];
}

- (void)pauseDownload:(id)sender
{
    CCPackage *package = [sender userObject];
    [[CCPackageManager sharedManager] pauseDownloadOfPackage:package];
}

- (void)setButtons:(CCButton *)button title:(NSString *)title selector:(SEL)selector enabled:(BOOL)enabled
{
    [button setTitle:title];
    [button setTarget:self selector:selector];
    button.enabled = enabled;
}


#pragma mark - CCPackageManagerDelegate

- (void)packageInstallationFinished:(CCPackage *)package
{
    NSLog(@"%@ - %@", NSStringFromSelector(_cmd), package);
}

- (void)packageInstallationFailed:(CCPackage *)package error:(NSError *)error
{
    NSLog(@"%@ - %@ - %@", NSStringFromSelector(_cmd), package, error);
}

- (void)packageDownloadFinished:(CCPackage *)package
{
    NSLog(@"%@ - %@", NSStringFromSelector(_cmd), package);
}

- (void)packageDownloadFailed:(CCPackage *)package error:(NSError *)error
{
    NSLog(@"%@ - %@ - %@", NSStringFromSelector(_cmd), package, error);
}

- (void)packageUnzippingFinished:(CCPackage *)package
{
    NSLog(@"%@ - %@", NSStringFromSelector(_cmd), package);
}

- (void)packageUnzippingFailed:(CCPackage *)package error:(NSError *)error
{
    NSLog(@"%@ - %@ - %@", NSStringFromSelector(_cmd), package, error);
}

- (void)packageDownloadProgress:(CCPackage *)package downloadedBytes:(NSUInteger)downloadedBytes totalBytes:(NSUInteger)totalBytes
{
    NSLog(@"%@ - %@ - %u / %u", NSStringFromSelector(_cmd), package, downloadedBytes, totalBytes);
}

- (void)packageUnzippingProgress:(CCPackage *)package unzippedBytes:(NSUInteger)unzippedBytes totalBytes:(NSUInteger)totalBytes
{
    NSLog(@"%@ - %@ - %u / %u", NSStringFromSelector(_cmd), package, unzippedBytes, totalBytes);
}

@end
