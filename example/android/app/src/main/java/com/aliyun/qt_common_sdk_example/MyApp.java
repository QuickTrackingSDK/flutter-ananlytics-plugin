package com.aliyun.qt_common_sdk_example;

import io.flutter.app.FlutterApplication;
import com.quick.qt.commonsdk.QtConfigure;

public class MyApp extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        //为了采集热启动的应用启动和应用退出事件，需要自定义 application 并调用 preInit 和 setCustomDomain
        QtConfigure.setCustomDomain("设置主收数域名", "设置副收数域名"); //调用 preInit 之前，必须操作
        QtConfigure.preInit(this, "设置 appkey", "设置渠道信息");
    }
}
