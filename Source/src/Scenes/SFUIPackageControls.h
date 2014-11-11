#import <Foundation/Foundation.h>
#import "CCPackageManagerDelegate.h"

@class CCPackage;


@interface SFUIPackageControls : CCNode

@property (nonatomic, copy) NSString *packageName;
@property (nonatomic, strong) CCLabelTTF *title;
@property (nonatomic, strong) CCLabelTTF *status;
@property (nonatomic, strong) CCButton *button;
@property (nonatomic, strong) CCNode *buttonContainer;
@property (nonatomic, strong) CCPackage *package;

- (instancetype)initWithPackageName:(NSString *)packageName title:(NSString *)title;

- (void)packageInstallationFailedWithError:(NSError *)error;

- (void)packageDownloadFailedWithError:(NSError *)error;

- (void)packageUnzippingFailedWithError:(NSError *)error;

- (void)packageDownloadProgressDownloadedBytes:(NSUInteger)downloadedBytes totalBytes:(NSUInteger)totalBytes;

- (void)packageUnzippingProgressUnzippedBytes:(NSUInteger)unzippedBytes totalBytes:(NSUInteger)totalBytes;


@end
