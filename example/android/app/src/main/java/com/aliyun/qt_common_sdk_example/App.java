package com.aliyun.qt_common_sdk_example;

import com.quick.qt.commonsdk.QtConfigure;

public class App extends io.flutter.app.FlutterApplication {
    public static final String DEFAULT_APPKEY = "64632267";
    public static final String DEFAULT_CHANNEL = "QT";
    public static final String DEFAULT_HOST = "https://log-api.aplus.emas-poc.com";
    @Override
    public void onCreate() {
        super.onCreate();

        QtConfigure.setCustomDomain(DEFAULT_HOST, null);
        QtConfigure.setLogEnabled(true);
        QtConfigure.preInit(this, DEFAULT_APPKEY, DEFAULT_CHANNEL);
    }
}
