
import 'dart:async';

import 'package:flutter/services.dart';

class QTCommonSdk {
  static const MethodChannel _channel = const MethodChannel('qt_common_sdk');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
  ///
  /// 设置上报统计日志的主域名和备用域名。此函数必须在SDK初始化函数调用之前调用。
  ///
  /// @param primaryDomain String 主域名.
  /// @param standbyDomain String 备用域名 上传日志备用域名收数地址,参数可以为null或者空串，若此参数为空，SDK内部会自动将主域名设置为备用域名。
  ///
  ///
  static void setCustomDomain(String primaryDomain, String standbyDomain) {
    List<dynamic> args = [primaryDomain, standbyDomain];
    _channel.invokeMethod('setCustomDomain', args);
  }

  ///
  /// 初始化
  ///
  /// @param androidAppkey String 开发者申请的android appkey.
  /// @param iosAppkey String 开发者申请的ios appkey.
  /// @param channel String 渠道标识，可设置nil表示"App Store".
  ///
  ///
  static Future<dynamic> initCommon(String androidAppkey, String iosAppkey, String channel) async {
    List<dynamic> params = [androidAppkey, iosAppkey ,channel];
    final dynamic result =  await _channel.invokeMethod('initCommon', params);
    return result;
  }

  ///
  /// 自定义app版本号，默认获取version，只可设置一次建议在所有接口之前调用
  ///
  /// @param appVersion String 自定义版本号
  /// @param appVersionCode int 对应Android应用版本号versionCode，仅Android端会使用此参数
  ///
  static void setAppVersion (String appVersion, int appVersionCode) {
    List<dynamic> args = [appVersion, appVersionCode];
    _channel.invokeMethod('setAppVersion', args);
  }

  ///
  /// 设置是否在console输出sdk的log信息.
  ///
  /// @param bFlag bool 默认NO(不输出log); 设置为YES, 输出可供调试参考的log信息. 发布产品时必须设置为NO.
  ///
  ///
  static void setLogEnabled (bool bFlag) {
    List<dynamic> args = [bFlag];
    _channel.invokeMethod('setLogEnabled', args);
  }

  ///
  /// 自定义事件
  ///
  /// @param event String 事件Id.
  /// @param properties Map 自定义参数.
  ///
  static void onEvent(String event, Map<String,dynamic> properties) {
    List<dynamic> args = [event,properties];
    print("current event === $event");
    print("properties === $properties");
    _channel.invokeMethod('onEvent', args);
  }

  ///
  /// 自定义事件
  ///
  /// @param event String 事件Id.
  /// @param pageName String 页面名称.
  /// @param properties Map 自定义参数.
  ///
  static void onEventWithPage(String event,String pageName, Map<String,dynamic> properties) {
    List<dynamic> args = [event,pageName,properties];
    _channel.invokeMethod('onEventWithPage', args);
  }

  ///
  /// 账号统计登录
  ///
  /// @param userID String user's ID
  ///
  ///
  static void onProfileSignIn (String userID) {
    onProfileSignInEx(userID, '_adhoc');
  }

  ///
  /// 账号统计登录
  ///
  /// @param userID String user's ID
  /// @param provider String user's provider
  ///
  static void onProfileSignInEx (String userID, String provider) {
    List<dynamic> args = [userID, provider];
    _channel.invokeMethod('onProfileSignIn', args);
  }

  ///
  /// 账号统计登出
  ///
  ///
  static void onProfileSignOff () {
    _channel.invokeMethod('onProfileSignOff');
  }

  ///
  /// 页面统计
  ///
  /// @param viewName String 页面名称
  ///
  ///
  static void onPageStart(String viewName) {
    List<dynamic> args = [viewName];
    _channel.invokeMethod('onPageStart', args);
  }

  ///
  /// 页面统计
  ///
  /// @param viewName String 页面名称
  ///
  ///
  static void onPageEnd(String viewName) {
    List<dynamic> args = [viewName];
    _channel.invokeMethod('onPageEnd', args);
  }

  ///
  /// 注册全局属性
  ///
  /// @param properties Map 自定义参数
  ///
  ///
  static void registerGlobalProperties(Map<String,dynamic> properties) {
    List<dynamic> args = [properties];
    _channel.invokeMethod('registerGlobalProperties', args);
  }

  ///
  /// 删除一个全局属性
  ///
  /// @param propertyName String 自定义参数key
  ///
  ///
  static void unregisterGlobalProperty(String propertyName) {
    List<dynamic> args = [propertyName];
    _channel.invokeMethod('unregisterGlobalProperty', args);
  }

  ///
  /// 获取全局属性
  ///
  ///
  static Future<String>? get getGlobalProperties async {
    return await _channel.invokeMethod('getGlobalProperties');
  }

  ///
  /// 获取一个全局属性值
  ///
  ///
  static Future<dynamic>? getGlobalProperty(String propertyName) async {
    List<dynamic> args = [propertyName];
    return await _channel.invokeMethod("getGlobalProperty", args);
  }




  ///
  /// 清除全局属性
  ///
  static void clearGlobalProperties() {
    _channel.invokeMethod('clearGlobalProperties');
  }


  ///
  /// 跳过当前页面统计.
  ///
  /// @param pageName String 页面名称
  ///
  ///
  static void skipMe(String pageName) {
    List<dynamic> args = [pageName];
    _channel.invokeMethod('skipMe', args);
  }

  ///
  /// 设置页面属性.
  ///
  /// @param pageName String 页面名称
  /// @param properties Map 自定义参数
  ///
  static void setPageProperty(String pageName, Map<String,dynamic> properties) {
    List<dynamic> args = [pageName,properties];
    _channel.invokeMethod('setPageProperty', args);
  }

  ///
  /// 更新当前的spm
  ///
  /// @param curSPM String 当前页面事件的spm
  ///
  static void updateCurSpm(String curSPM) {
    List<dynamic> args = [curSPM];
    _channel.invokeMethod('updateCurSpm', args);
  }

  ///
  /// 更新下一个页面业务参数
  ///
  /// @param properties Map 传给下一个页面业务参数,kv对
  ///
  static void updateNextPageProperties(Map<String,dynamic> properties) {
    List<dynamic> args = [properties];
    _channel.invokeMethod('updateNextPageProperties', args);
  }

  ///
  /// 自定义设备id
  ///
  /// @param customDeviceId String
  ///
  static void setCustomDeviceId(String customDeviceId) {
    List<dynamic> args = [customDeviceId];
    _channel.invokeMethod('setCustomDeviceId', args);
  }

  ///
  /// 获取设备id
  ///
  ///
  static Future<dynamic>? getDeviceId() async {
    return await _channel.invokeMethod("getDeviceId");
  }


  ///
  ///  ios 专有API
  /// 是否hook系统方法
  ///
  /// @param value bool
  ///
  ///
  static void isHook (bool value) {
    List<dynamic> args = [value];
    _channel.invokeMethod('isHook', args);
  }

  static void isHookUrl (bool value) {
    List<dynamic> args = [value];
    _channel.invokeMethod('isHookUrl', args);
  }

  static void isHookEvent (bool value) {
    List<dynamic> args = [value];
    _channel.invokeMethod('isHookEvent', args);
  }

  static void isHookPage (bool value) {
    List<dynamic> args = [value];
    _channel.invokeMethod('isHookPage', args);
  }

  ///
  /// ios 专有API
  /// 自定义 openudid 设置
  ///
  /// @param customOpenUdid 自定义的 openudid
  ///
  ///
  static void setCustomOpenUdid(String customOpenUdid) {
    List<dynamic> args = [customOpenUdid];
    _channel.invokeMethod('setCustomOpenUdid', args);
  }
  ///
  /// ios 专有API
  /// 自定义 idfa 设置
  ///
  /// @param customIdfa 自定义 idfa
  ///
  ///
  static void setCustomIdfa(String customIdfa) {
    List<dynamic> args = [customIdfa];
    _channel.invokeMethod('setCustomIdfa', args);
  }
  ///
  /// ios 专有API
  /// 自定义 idfv 设置
  ///
  /// @param customIdfv 自定义 idfv
  ///
  ///
  static void setCustomIdfv(String customIdfv) {
    List<dynamic> args = [customIdfv];
    _channel.invokeMethod('setCustomIdfv', args);
  }
  ///
  /// ios 专有API
  /// 自定义 utdid 设置
  ///
  /// @param customUtdid 自定义 utdid
  ///
  ///
  static void setCustomUtdid(String customUtdid) {
    List<dynamic> args = [customUtdid];
    _channel.invokeMethod('setCustomUtdid', args);
  }

  ///
  /// ios 专有API
  /// 自定义 mcc 设置
  ///
  /// @param customMcc 自定义 mcc
  ///
  ///
  static void setCustomMcc(String customMcc) {
    List<dynamic> args = [customMcc];
    _channel.invokeMethod('setCustomMcc', args);
  }
  ///
  /// ios 专有API
  /// 自定义 mnc 设置
  ///
  /// @param customMnc 自定义 mnc
  ///
  ///
  static void setCustomMnc(String customMnc) {
    List<dynamic> args = [customMnc];
    _channel.invokeMethod('setCustomMnc', args);
  }
  ///
  /// ios 专有API
  /// 自定义 localIP 设置
  ///
  /// @param customLocalIP 自定义 localIP
  ///
  ///
  static void setCustomLocalIP(String customLocalIP) {
    List<dynamic> args = [customLocalIP];
    _channel.invokeMethod('setCustomLocalIP', args);
  }


  ///
  /// 应用如果以强杀死自身进程方式暴力退出，
  /// 则需要在自杀前调用此接口，Android特有
  ///
  ///
  static void onKillProcess() {
    _channel.invokeMethod('onKillProcess');
  }

  //
  // QT JS SDK通过flutter_webview_plugin插件将JS层统计数据发送到flutter层JavascriptChannel接口
  // 时需调用此接口，具体示例代码见example/lib/main.dart 第15行~第23行 写法。
  //
  static void onJSCall(String msg) {
    List<dynamic> args = [msg];
    _channel.invokeMethod('onJSCall', args);
  }
}
