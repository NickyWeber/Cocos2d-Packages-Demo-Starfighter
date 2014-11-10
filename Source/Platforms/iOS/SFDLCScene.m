#import "SFDLCScene.h"
#import "SFBackgroundLayer.h"
#import "SFUIHelper.h"
#import "SFGameMenuScene.h"
#import "CCPackageManager.h"
#import "CCPackage.h"


@interface SFDLCScene()

@property (nonatomic, strong) CCPackage *skinPackage;
@property (nonatomic, strong) CCPackage *levelsPackage;

@end


@implementation SFDLCScene

- (id)init
{
    self = [super init];

    if (self)
    {
        self.skinPackage = [[CCPackageManager sharedManager] packageWithName:@"patch_1_1"];
        self.levelsPackage = [[CCPackageManager sharedManager] packageWithName:@"levels"];

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

        CCNode *buttonDownloadSkinPack = [SFUIHelper createMenuButtonWithTitle:@"Download" target:self selector:@selector(downloadSkinPack) atRelPosition:ccp(0.5, 0.65)];
        [self addChild:buttonDownloadSkinPack];


        CCLabelTTF *titleLevels = [SFUIHelper gameLabelWithSize:20.0 blockSize:2.0];
        titleLevels.string = @"More Levels";
        titleLevels.positionType = CCPositionTypeNormalized;
        titleLevels.position = ccp(0.5, 0.55);
        [self addChild:titleLevels];

        CCNode *buttonDownloadLevels = [SFUIHelper createMenuButtonWithTitle:@"Download" target:self selector:@selector(downloadMoreLevels) atRelPosition:ccp(0.5, 0.5)];
        [self addChild:buttonDownloadLevels];


        CCNode *buttonBack = [SFUIHelper createMenuButtonWithTitle:@"back" target:self selector:@selector(back) atRelPosition:ccp(0.5, 0.2)];
        [self addChild:buttonBack];

        CCLabelTTF *title = [SFUIHelper gameLabelWithSize:36.0];
        title.string = @"Downloads";
        title.positionType = CCPositionTypeNormalized;
        title.position = ccp(0.5, 0.9);
        [self addChild:title];
    }

    return self;
}

- (void)back
{
    [[CCDirector sharedDirector] replaceScene:[[SFGameMenuScene alloc] init]
                               withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown duration:0.3]];
}

- (void)downloadMoreLevels
{
    self.skinPackage = [[CCPackageManager sharedManager] downloadPackageWithName:@"patch_1_1"
                                                                       remoteURL:[NSURL URLWithString:@""]
                                                             enableAfterDownload:YES];
}

- (void)downloadSkinPack
{
    self.skinPackage = [[CCPackageManager sharedManager] downloadPackageWithName:@"levels"
                                                                       remoteURL:[NSURL URLWithString:@""]
                                                             enableAfterDownload:YES];
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
    NSLog(@"%@ - %@ - %luf / %lu", NSStringFromSelector(_cmd), package, downloadedBytes, totalBytes);
}

- (void)packageUnzippingProgress:(CCPackage *)package unzippedBytes:(NSUInteger)unzippedBytes totalBytes:(NSUInteger)totalBytes
{
    NSLog(@"%@ - %@ - %luf / %lu", NSStringFromSelector(_cmd), package, unzippedBytes, totalBytes);
}

@end
