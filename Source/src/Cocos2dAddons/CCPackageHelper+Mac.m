#import "CCPackageHelper+Mac.h"

@implementation CCPackageHelper (Mac)

+ (NSString *)currentOS
{
#if __CC_PLATFORM_ANDROID
    return @"Android";
#else
    return @"iOS";
#endif
}

@end