#import "SFUIPackageControls.h"
#import "SFUIHelper.h"
#import "CCPackageManager.h"
#import "CCPackage.h"
#import "SFEntityFactory.h"

@implementation SFUIPackageControls

- (instancetype)initWithPackageURL:(NSURL *)packageURL title:(NSString *)title name:(NSString *)name resolution:(NSString *)resolution
{
    self = [super init];

    if (self)
    {
        self.packageURL = packageURL;
        self.packageName = name;
        self.resolution = resolution;

        self.title = [SFUIHelper gameLabelWithSize:24.0 blockSize:2.0];
        _title.string = title;
        _title.position = ccp(0.0, 0.0);
        [self addChild:_title];

        self.status = [SFUIHelper gameLabelWithSize:20.0 blockSize:2.0];
        _status.string = @"Not Installed";
        _status.position = ccpSub(_title.position, ccp(0.0, _title.contentSize.height + 5.0f));
        [self addChild:_status];

        NSDictionary *buttonDownloadPatch = [SFUIHelper createMenuButtonWithTitle:@"Download"
                                                                           target:self
                                                                         selector:nil
                                                                    atRelPosition:ccp(0.0, 0.0)];
        self.buttonContainer = buttonDownloadPatch[@"effectNode"];

        _buttonContainer.positionType = _title.positionType;
        _buttonContainer.position = ccpSub(_status.position, ccp(0.0, _status.contentSize.height + 5.0f));

        [self addChild:_buttonContainer];

        self.button = buttonDownloadPatch[@"button"];

        self.package = [self findPackage];
    }

    return self;
}

- (CCPackage *)findPackage
{
    for (CCPackage *aPackage in [[CCPackageManager sharedManager] allPackages])
    {
        if ([aPackage.name isEqualToString:_packageName ] && [aPackage.resolution isEqualToString:_resolution])
        {
            return aPackage;
        }
    }
    return nil;
}

- (void)downloadPackage
{
    self.package = [[CCPackageManager sharedManager] downloadPackageWithName:_packageName
                                                                  resolution:_resolution
                                                                   remoteURL:_packageURL
                                                         enableAfterDownload:YES];
}

- (void)packageDownloadProgressDownloadedBytes:(NSUInteger)downloadedBytes totalBytes:(NSUInteger)totalBytes
{
    NSString *progressString = [NSString stringWithFormat:@"DL: %lu, / %lu", downloadedBytes, totalBytes];
    [_status setString:progressString];
}

- (void)packageUnzippingProgressUnzippedBytes:(NSUInteger)unzippedBytes totalBytes:(NSUInteger)totalBytes
{
    NSString *progressString = [NSString stringWithFormat:@"unzip: %lu, / %lu", unzippedBytes, totalBytes];
    [_status setString:progressString];
}

- (void)dealloc
{
    [self removeObserver];
}

- (void)setPackage:(CCPackage *)package
{
    [self removeObserver];

    _package = package;

    // Package is not created yet by manager, downloadPackage will trigger that
    if (!package)
    {
        [self setButtonsTitle:@"Download" selector:nil enabled:YES];
        _status.string = @"Not Installed";
        [_button setTarget:self selector:@selector(downloadPackage)];
        return;
    }

    [self updateButton];

    [_package addObserver:self
               forKeyPath:@"status"
                  options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                  context:NULL];

}

- (void)removeObserver
{
    @try
    {
        [_package removeObserver:self forKeyPath:@"status"];
    }
    @catch (NSException *e)
    {

    }
}

- (void)updateButton
{
    switch (_package.status)
    {
        case CCPackageStatusInitial:
            _status.string = @"Not Installed";
            break;

        case CCPackageStatusDownloading:
            [self setButtonsTitle:@"Pause" selector:@selector(pauseDownload:) enabled:YES];
            break;

        case CCPackageStatusDownloadPaused:
            [self setButtonsTitle:@"Resume" selector:@selector(resumeDownload:) enabled:YES];
            _status.string = @"Paused";
            break;

        case CCPackageStatusDownloadFailed:
            [self setButtonsTitle:@"Retry" selector:@selector(retryDownload:) enabled:YES];
            break;

        case CCPackageStatusDownloaded:
            [self setButtonsTitle:@"Download" selector:nil enabled:NO];
            break;

        case CCPackageStatusUnzipping:
            [self setButtonsTitle:@"Download" selector:nil enabled:NO];
            break;

        case CCPackageStatusUnzipped:
            [self setButtonsTitle:@"Download" selector:nil enabled:NO];
            break;

        case CCPackageStatusUnzipFailed:
            [self setButtonsTitle:@"Retry" selector:@selector(retryDownload:) enabled:YES];
            break;

        case CCPackageStatusInstallationFailed:
            [self setButtonsTitle:@"Retry" selector:@selector(retryDownload:) enabled:YES];
            break;

        case CCPackageStatusInstalledEnabled:
            [self setButtonsTitle:@"Disable" selector:@selector(disablePackage:) enabled:YES];
            _status.string = @"Installed";
            break;

        case CCPackageStatusInstalledDisabled:
            [self setButtonsTitle:@"Enable" selector:@selector(enablePackage:) enabled:YES];
            _status.string = @"Deactivated";
            break;

        default:
            [self setButtonsTitle:@"Download" selector:nil enabled:NO];
            _status.string = @"Not Installed";
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self updateButton];

    if (_package.status == CCPackageStatusInstalledEnabled || _package.status == CCPackageStatusInstalledDisabled)
    {
        [[SFEntityFactory sharedFactory] invalidateCache];
    }
}

- (void)enablePackage:(id)sender
{
    NSError *error;
    if (![[CCPackageManager sharedManager] enablePackage:_package error:&error])
    {
        NSLog(@"Error enabling package: %@", error);
    }
}

- (void)disablePackage:(id)sender
{
    [[CCPackageManager sharedManager] disablePackage:_package error:nil];

    NSError *error;
    if (![[CCPackageManager sharedManager] disablePackage:_package error:&error])
    {
        NSLog(@"Error disabling package: %@", error);
    }
}

- (void)retryDownload:(id)sender
{
    [[CCPackageManager sharedManager] downloadPackage:_package enableAfterDownload:YES];
}

- (void)resumeDownload:(id)sender
{
    [[CCPackageManager sharedManager] resumeDownloadOfPackage:_package];
}

- (void)pauseDownload:(id)sender
{
    [[CCPackageManager sharedManager] pauseDownloadOfPackage:_package];
}

- (void)setButtonsTitle:(NSString *)title selector:(SEL)selector enabled:(BOOL)enabled
{
    [_button setTitle:title];
    [_button setTarget:self selector:selector];
    _button.enabled = enabled;
}

 @end
