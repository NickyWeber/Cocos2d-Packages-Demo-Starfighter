#import <Foundation/Foundation.h>
#import "CCPackageManagerDelegate.h"

@class CCPackage;


@interface SFUIPackageControls : CCNode

@property (nonatomic, copy) NSURL *packageURL;
@property (nonatomic, copy) NSString *packageName;
@property (nonatomic, copy) NSString *resolution;
@property (nonatomic, strong) CCLabelTTF *title;
@property (nonatomic, strong) CCLabelTTF *status;
@property (nonatomic, strong) CCButton *button;
@property (nonatomic, strong) CCNode *buttonContainer;
@property (nonatomic, strong) CCPackage *package;

- (instancetype)initWithPackageURL:(NSURL *)packageURL title:(NSString *)title name:(NSString *)name resolution:(NSString *)resolution;

- (void)packageDownloadProgressDownloadedBytes:(NSUInteger)downloadedBytes totalBytes:(NSUInteger)totalBytes;

- (void)packageUnzippingProgressUnzippedBytes:(NSUInteger)unzippedBytes totalBytes:(NSUInteger)totalBytes;

@end
