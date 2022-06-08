package com.qt.qt_common_sdk;

import android.content.Context;

import androidx.annotation.NonNull;

import com.umeng.analytics.MobclickAgent;
import com.umeng.commonsdk.UMConfigure;
import com.umeng.spm.SpmAgent;

import java.lang.reflect.Method;
import java.util.List;
import java.util.Map;

import android.util.Log;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class QtCommonSdkPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private static Context mContext = null;

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "qt_common_sdk");
        QtCommonSdkPlugin plugin = new QtCommonSdkPlugin();
        plugin.mContext = registrar.context();
        channel.setMethodCallHandler(plugin);
        onAttachedEngineAdd();
    }

    private static void onAttachedEngineAdd() {
        try {
            Class<?> agent = Class.forName("com.umeng.analytics.MobclickAgent");
            Method[] methods = agent.getDeclaredMethods();
            for (Method m : methods) {
//                Log.e("UMLog", "Reflect:" + m);
                if (m.getName().equals("onEventObject")) {
                    versionMatch = true;
                    break;
                }
            }
            if (!versionMatch) {
                Log.e("UMLog", "安卓SDK版本过低，建议升级至8以上");
                //return;
            } else {
                Log.e("UMLog", "安卓依赖版本检查成功");
            }
        } catch (Throwable e) {
            Log.e("UMLog", "SDK版本过低，请升级至8以上" + e.toString());
            return;
        }

        Method method = null;
        try {
            Class<?> config = Class.forName("com.umeng.commonsdk.UMConfigure");
            method = config.getDeclaredMethod("setWraperType", String.class, String.class);
            method.setAccessible(true);
            method.invoke(null, "flutter", "1.0");
            android.util.Log.i("UMLog", "setWraperType:flutter1.0 success");
        } catch (Throwable e) {
            Log.e("UMLog", "setWraperType:flutter1.0" + e.toString());
        }
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        mContext = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "qt_common_sdk");
        channel.setMethodCallHandler(this);
        onAttachedEngineAdd();
    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (!versionMatch) {
            Log.e("UMLog", "onMethodCall:" + call.method + ":安卓SDK版本过低，请升级至8以上");
        }
        try {
            List args = (List) call.arguments;
            switch (call.method) {
                case "getPlatformVersion":
                    result.success("Android " + android.os.Build.VERSION.RELEASE);
                    break;
                case "initCommon":
                    initCommon(args);
                    result.success(null);
                    break;
                case "setAppVersion":
                    setAppVersion(args);
                    result.success(null);
                    break;
                case "onEvent":
                    onEventObject(args);
                    result.success(null);
                    break;
                case "onEventWithPage":
                    onEventObjectWithPage(args);
                    result.success(null);
                    break;
                case "onProfileSignIn":
                    onProfileSignIn(args);
                    result.success(null);
                    break;
                case "onProfileSignOff":
                    onProfileSignOff();
                    result.success(null);
                    break;
                case "onPageStart":
                    onPageStart(args);
                    result.success(null);
                    break;
                case "onPageEnd":
                    onPageEnd(args);
                    result.success(null);
                    break;
                case "registerGlobalProperties":
                    registerGlobalProperties(args);
                    result.success(null);
                    break;
                case "unregisterGlobalProperty":
                    unregisterGlobalProperty(args);
                    result.success(null);
                    break;
                case "getGlobalProperty": {
                    Object res = getGlobalProperty(args);
                    result.success(res);
                }break;
                case "getGlobalProperties": {
                    Object res = getGlobalProperties(args);
                    result.success(res);
                }break;
                case "clearGlobalProperties":
                    clearGlobalProperties(args);
                    result.success(null);
                    break;
                case "skipMe":
                    skipMe(args);
                    result.success(null);
                    break;
                case "updateCurSpm":
                    updateCurSpm(args);
                    result.success(null);
                    break;
                case "setPageProperty":
                    setPageProperty(args);
                    result.success(null);
                    break;
                case "onKillProcess":
                    onKillProcess(args);
                    result.success(null);
                    break;
                default:
                    result.notImplemented();
                    break;
            }
        } catch (Throwable e) {
            Log.e("UMLog", "Exception:" + e.getMessage());
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private static Boolean versionMatch = false;

//    public static void setContext(Context ctx) {
//        mContext = ctx;
//    }

    public static Context getContext() {
        return mContext;
    }

    private void initCommon(List args) {
        try {
            String appkey = (String) args.get(0);
            String channel = (String) args.get(2);
            UMConfigure.init(getContext(), appkey, channel, UMConfigure.DEVICE_TYPE_PHONE, null);
            Log.i("UMLog", "initCommon:" + appkey + "@" + channel);
        } catch (Throwable e) {
            Log.e("UMLog", "initCommon invoke error: " + e.getMessage());
        }
    }

    private void setAppVersion(List args) {
        try {
            String version = (String) args.get(0);
            int versionCode = (int) args.get(1);
            UMConfigure.setAppVersion(version, versionCode);
        } catch (Throwable e) {
            Log.e("UMLog", "setAppVersion invoke error: " + e.getMessage());
        }
    }

    private void onEventObject(List args) {
        try {
            String event = (String) args.get(0);
            Map map = null;
            if (args.size() > 1) {
                map = (Map) args.get(1);
            }
            if ((map != null) && (map.size() > 0)) {
                MobclickAgent.onEventObject(getContext(), event, map);
            } else {
                MobclickAgent.onEvent(getContext(), event);
            }

            if (map != null) {
                Log.i("UMLog", "onEvent:" + event + "(" + map.toString() + ")");
            } else {
                Log.i("UMLog", "onEvent:" + event);
            }
        } catch (Throwable e) {
            Log.e("UMLog", "onEventObject invoke error: " + e.getMessage());
        }
    }

    private void onEventObjectWithPage(List args) {
        try {
            String event = (String) args.get(0);
            String pageName = (String) args.get(1);
            Map map = null;
            if (args.size() > 2) {
                map = (Map) args.get(2);
            }
            if ((map != null) && (map.size() > 0)) {
                MobclickAgent.onEventObject(getContext(), event, map, pageName);
            } else {
                MobclickAgent.onEvent(getContext(), event, pageName);
            }
            if (map != null) {
                Log.i("UMLog", "onEventWithPage:" + event + "(" + map.toString() + ")");
            } else {
                Log.i("UMLog", "onEvent:" + event);
            }
        } catch (Throwable e) {
            Log.e("UMLog", "onEventObjectWithPage invoke error: " + e.getMessage());
        }
    }

    private void onProfileSignIn(List args) {
        try {
            String userID = (String) args.get(0);
            String provider = (String) args.get(1);
            MobclickAgent.onProfileSignIn(userID, provider);
            Log.i("UMLog", "onProfileSignIn:" + userID);
        } catch (Throwable e) {
            Log.e("UMLog", "onProfileSignInEx invoke error: " + e.getMessage());
        }
    }

    private void onProfileSignOff() {
        MobclickAgent.onProfileSignOff();
        Log.i("UMLog", "onProfileSignOff");
    }


    private void onPageStart(List args) {
        try {
            String event = (String) args.get(0);
            MobclickAgent.onPageStart(event);
            Log.i("UMLog", "onPageStart:" + event);
        } catch (Throwable e) {
            Log.e("UMLog", "onPageStart invoke error: " + e.getMessage());
        }
    }

    private void onPageEnd(List args) {
        try {
            String event = (String) args.get(0);
            MobclickAgent.onPageEnd(event);
            Log.i("UMLog", "onPageEnd:" + event);
        } catch (Throwable e) {
            Log.e("UMLog", "onPageEnd invoke error: " + e.getMessage());
        }
    }

    private void registerGlobalProperties(List args) {
        Map map = null;
        try {
            if (args.size() > 0) {
                map = (Map) args.get(0);
            }
            MobclickAgent.registerGlobalProperties(getContext(), map);
        } catch (Throwable e) {
            Log.e("UMLog", "registerGlobalProperties invoke error: " + e.getMessage());
        }
    }

    private void unregisterGlobalProperty(List args) {
        try {
            String propertyName = (String)args.get(0);
            MobclickAgent.unregisterGlobalProperty(getContext(), propertyName);
        } catch (Throwable e) {
            Log.e("UMLog", "unregisterGlobalProperty invoke error: " + e.getMessage());
        }
    }

    private void clearGlobalProperties(List args) {
        MobclickAgent.clearGlobalProperties(getContext());
    }

    private Object getGlobalProperty(List args) {
        Object result = null;
        try {
            String propertyName = (String)args.get(0);
            result = MobclickAgent.getGlobalProperty(getContext(), propertyName);
            return result;
        } catch (Throwable e) {
            Log.e("UMLog", "getGlobalProperty invoke error: " + e.getMessage());
        }
        return result;
    }

    private Object getGlobalProperties(List args) {
        Object result = null;
        try {
            result = MobclickAgent.getGlobalProperties(getContext());
            return result;
        } catch (Throwable e) {
            Log.e("UMLog", "getGlobalProperties invoke error: " + e.getMessage());
        }
        return result;
    }

    private void skipMe(List args) {
        try {
            String pageName = (String) args.get(0);
            MobclickAgent.skipMe(getContext(), pageName);
            Log.i("UMLog", "skipMe: pageName = " + pageName);
        } catch (Throwable e) {
            Log.e("UMLog", "skipMe invoke error: " + e.getMessage());
        }
    }

    private void updateCurSpm(List args) {
        try {
            String curSpm = (String) args.get(0);
            SpmAgent.updateCurSpm(getContext(), curSpm);
            Log.i("UMLog", "updateCurSpm: curSpm = " + curSpm);
        } catch (Throwable e) {
            Log.e("UMLog", "updateCurSpm invoke error: " + e.getMessage());
        }
    }

    private void setPageProperty(List args) {
        try {
            String pageName = (String) args.get(0);
            Map map = null;
            if (args.size() > 0) {
                map = (Map) args.get(1);
            }
            MobclickAgent.setPageProperty(getContext(), pageName, map);

        } catch (Throwable e) {

        }
    }

    private void onKillProcess(List args) {
        MobclickAgent.onKillProcess(getContext());
    }
}
