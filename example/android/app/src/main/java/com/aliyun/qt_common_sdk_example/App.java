package com.aliyun.qt_common_sdk_example;


import android.util.Log;

import com.quick.qt.commonsdk.QtConfigure;


public class App extends io.flutter.app.FlutterApplication {
    public static final String DEFAULT_APPKEY = "您的appkey(Android端)";
    public static final String DEFAULT_CHANNEL = "QT";
    public static final String DEFAULT_HOST = "https://您的收数域名";
    @Override
    public void onCreate() {
        super.onCreate();

        QtConfigure.setCustomDomain(DEFAULT_HOST, null);
        QtConfigure.setLogEnabled(true);
        Log.i("UMLog", "call UMConfigure.preInit();");
        QtConfigure.preInit(this, DEFAULT_APPKEY, DEFAULT_CHANNEL);
    }
}
