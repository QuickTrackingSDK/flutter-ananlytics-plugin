#import "QTCommonSdkPlugin.h"
#import <QTCommon/UMConfigure.h>
#import <QTCommon/MobClick.h>
#import <QTCommon/UMSpm.h>
#import <QTCommon/UMSpmHybrid.h>

@interface QTflutterpluginForQTCommon : NSObject
@end
@implementation QTflutterpluginForQTCommon

+ (BOOL)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
    BOOL resultCode = YES;
    NSArray* arguments = (NSArray *)call.arguments;

    if ([@"initCommon" isEqualToString:call.method]){
        NSString* appkey = arguments[1];
        NSString* channel = arguments[2];
        [QTConfigure initWithAppkey:appkey channel:channel];
        //result(@"success");
    }
    else if ([@"setCustomDomain" isEqualToString:call.method]){
        NSString* primaryDomain = arguments[0];
        NSString* standbyDomain = arguments[1];

        [QTConfigure setCustomDomain:primaryDomain standbyDomain:standbyDomain];
    }
    else if ([@"isHook" isEqualToString:call.method]){
        BOOL isHook = [arguments[0] boolValue];

        [QTConfigure isHook:isHook];
    }
    else if ([@"isHookUrl" isEqualToString:call.method]){
        BOOL isHookUrl = [arguments[0] boolValue];

        [QTConfigure isHookUrl:isHookUrl];
    }
    else if ([@"isHookEvent" isEqualToString:call.method]){
        BOOL isHookEvent = [arguments[0] boolValue];

        [QTConfigure isHookEvent:isHookEvent];
    }
    else if ([@"isHookPage" isEqualToString:call.method]){
        BOOL isHookPage = [arguments[0] boolValue];

        [QTConfigure isHookPage:isHookPage];
    }
    else if ([@"setAppVersion" isEqualToString:call.method]){
        NSString* appVersion = arguments[0];

        [QTConfigure setAppVersion:appVersion];
    }
    else if ([@"setLogEnabled" isEqualToString:call.method]){
        BOOL enabled = [arguments[0] boolValue];

        [QTConfigure setLogEnabled:enabled];
    }
    else{
        resultCode = NO;
    }
    return resultCode;
}
@end

@interface QTflutterpluginForAnalytics : NSObject
@end
@implementation QTflutterpluginForAnalytics


+ (BOOL)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
    BOOL resultCode = YES;
    NSArray* arguments = (NSArray *)call.arguments;
    if ([@"onEvent" isEqualToString:call.method]){
        NSString* eventName = arguments[0];
        NSDictionary* properties = arguments[1];
        [QTMobClick event:eventName attributes:properties];
        //result(@"success");
    }
    if ([@"onEventWithPage" isEqualToString:call.method]){
        NSString* eventName = arguments[0];
        NSString* pageName = arguments[1];
        NSDictionary* properties = arguments[2];
        [QTMobClick event:eventName pageName:pageName attributes:properties];
        //result(@"success");
    }
    else if ([@"onProfileSignIn" isEqualToString:call.method]){
        NSString* userID = arguments[0];
        NSString* provider = arguments[1];
        [QTMobClick profileSignInWithPUID:userID provider:provider];

        //result(@"success");
    }
    else if ([@"onProfileSignOff" isEqualToString:call.method]){
        [QTMobClick profileSignOff];
        //result(@"success");
    }
//    else if ([@"setAutoPageEnabled" isEqualToString:call.method]){
//        BOOL enabled=[arguments[0] boolValue];
//        [QTMobClick setAutoPageEnabled:enabled];
//        //result(@"success");
//    }
//    else if ([@"setAutoEventEnabled" isEqualToString:call.method]){
//        BOOL enabled=[arguments[0] boolValue];
//
//        [QTMobClick setAutoEventEnabled:enabled];
//        //result(@"success");
//    }
    else if ([@"onPageStart" isEqualToString:call.method]){
        NSString* pageName = arguments[0];
        [QTMobClick beginLogPageView:pageName];
        //result(@"success");
    }
    else if ([@"onPageEnd" isEqualToString:call.method]){
        NSString* pageName = arguments[0];
        [QTMobClick endLogPageView:pageName];
        //result(@"success");
    }
    else if ([@"registerGlobalProperties" isEqualToString:call.method]){
        NSDictionary* dic = arguments[0];
        [QTMobClick registerGlobalProperty:dic];
        //result(@"success");
    }
    else if ([@"unregisterGlobalProperty" isEqualToString:call.method]){
        NSString* propertyName = arguments[0];
        [QTMobClick unregisterGlobalProperty:propertyName];
        //result(@"success");
    }
    else if ([@"getGlobalProperties" isEqualToString:call.method]){
        NSString *jsonStr=[self JSONFragment:[QTMobClick getGlobalProperties]];
        result(jsonStr);
    }
    else if ([@"getGlobalProperty" isEqualToString:call.method]){
        NSString* propertyName = arguments[0];
        result([QTMobClick getSuperProperty:propertyName]);
    }
    else if ([@"clearGlobalProperties" isEqualToString:call.method]){
        [QTMobClick clearGlobalProperties];
        //result(@"success");
    }
    else if ([@"reportError" isEqualToString:call.method]){
        NSLog(@"reportError API not existed ");
        //result(@"success");
     }
    else{
        resultCode = NO;
    }
    return resultCode;
}

+ (NSString *)JSONFragment:(id)object
{
    //判断是否空值
    if (!object) {
        return nil;
    }
    
    //判断是否能转换json
    if (![NSJSONSerialization isValidJSONObject:object]) {
        return nil;
    }
    
    //此处 用@try @catch影响效率
    NSString *jsonString = nil;
    NSError *error = nil;
    NSData *jsonData = nil;
    jsonData = [NSJSONSerialization dataWithJSONObject:object
                                               options:kNilOptions //TODO: NSJSONWritingPrettyPrinted  // kNilOptions
                                                 error:&error];
    if ([jsonData length] && (error == nil))
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end

@interface QTflutterpluginForSPM : NSObject
@end
@implementation QTflutterpluginForSPM

+ (BOOL)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
    BOOL resultCode = YES;
    NSArray* arguments = (NSArray *)call.arguments;

    if ([@"skipMe" isEqualToString:call.method]){
        NSString* pageName = arguments[0];
        [UMSpmHybrid skipMe:nil pageName:pageName];
        //result(@"success");
    }
    else if ([@"setPageProperty" isEqualToString:call.method]){
        NSString* pageName = arguments[0];
        NSDictionary* dic = arguments[1];
        [UMSpm updatePageProperties:pageName properties:dic];
    }
    else if ([@"updateCurSpm" isEqualToString:call.method]){
        NSString* curSPM = arguments[0];
        [UMSpm updateCurSPM:curSPM];
    }
    else if ([@"onJSCall" isEqualToString:call.method]){
        NSString* jsMsg = arguments[0];
        NSDictionary *params = [self JSONValue:jsMsg];
        Class _UMSpmPageModelManager = NSClassFromString(@"UMSpmPageModelManager");
        if (_UMSpmPageModelManager){
            id manager = [self reflectObject:_UMSpmPageModelManager selector:@"shareInstance"];
            if(manager){
                [self reflectObject:manager selector:@"callDicFromJS:webView:" object:params object:nil];
            }
        }
    }
    else{
        resultCode = NO;
    }
    return resultCode;
}

+ (BOOL)notEmptyString:(NSString *)string
{
    BOOL bRet = YES;
    if ((string == nil) ||
        (string == NULL) ||
        ([string isKindOfClass:[NSNull class]]) ||
        (![string isKindOfClass:[NSString class]]) ||
        (([string isKindOfClass:[NSString class]])&&([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)))
    {
        bRet = NO;
    }
    return bRet;
}

+ (BOOL)isEmptyString:(NSString *)string
{
    return ![self notEmptyString:string];
}

+ (id)reflectObject:(id)obj selector:(NSString *)method
{
    if (![obj isKindOfClass:[NSObject class]] || [self isEmptyString:method]) {
        return nil;
    }
    
    SEL sel = NSSelectorFromString(method);
    if (sel && [obj respondsToSelector:sel] ) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return  [obj performSelector:sel];
#pragma clang diagnostic pop
    }
    else{
        return nil;
    }
}


+ (id)reflectObject:(id)obj selector:(NSString *)method object:(id)object1 object:(id)object2
{
    if (![obj isKindOfClass:[NSObject class]] ||
        [self isEmptyString:method] ||
        ![object1 isKindOfClass:[NSObject class]]) {
        return nil;
    }
    
    SEL sel = NSSelectorFromString(method);
    if (sel && [obj respondsToSelector:sel] ) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [obj performSelector:sel withObject:object1 withObject:object2];
#pragma clang diagnostic pop
    }
    else{
        return nil;
    }
}

+ (id)JSONValue:(NSString *)string
{
    id result = nil;
    if (string&&string.length > 0)
    {
        NSError* error = nil;
        result = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error]; //NSJSONReadingAllowFragments  kNilOptions
    }
    return result;
}

@end


@implementation QTCommonSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"qt_common_sdk"
            binaryMessenger:[registrar messenger]];
  QTCommonSdkPlugin* instance = [[QTCommonSdkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    //result(FlutterMethodNotImplemented);
  }

    BOOL resultCode = [QTflutterpluginForQTCommon handleMethodCall:call result:result];
    if (resultCode) return;

    resultCode = [QTflutterpluginForAnalytics handleMethodCall:call result:result];
    if (resultCode) return;

    resultCode = [QTflutterpluginForSPM handleMethodCall:call result:result];
    if (resultCode) return;
    
    result(FlutterMethodNotImplemented);
}

@end
