#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <QTCommon/MobClick.h>
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

//iOS9以上，走这个方法
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    NSLog(@"UMurl:%@", url);
    if ([QTMobClick handleUrl:url]) {
        return YES;
    }
 
    //其它第三方处理
    return YES;
}

@end
