package com.aliyun.qt_common_sdk_example;

import com.umeng.commonsdk.UMConfigure;

public class App extends io.flutter.app.FlutterApplication {
    public static final String DEFAULT_APPKEY = "您的appkey(Android端)";
    public static final String DEFAULT_CHANNEL = "QT";
    public static final String DEFAULT_HOST = "https://您的收数域名";
    @Override
    public void onCreate() {
        super.onCreate();

        UMConfigure.setCustomDomain(DEFAULT_HOST, null);
        UMConfigure.setLogEnabled(true);
        UMConfigure.preInit(this, DEFAULT_APPKEY, DEFAULT_CHANNEL);
    }
}
