package com.qt.qt_common_sdk;

import android.content.Context;

import androidx.annotation.NonNull;

import com.quick.qt.analytics.QtTrackAgent;
import com.quick.qt.commonsdk.QtConfigure;
import com.quick.qt.spm.SpmAgent;

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
            Class<?> agent = Class.forName("com.quick.qt.analytics.QtTrackAgent");
            Method[] methods = agent.getDeclaredMethods();
            for (Method m : methods) {
//                Log.e("QTFlutterLog", "Reflect:" + m);
                if (m.getName().equals("onEventObject")) {
                    versionMatch = true;
                    break;
                }
            }
            if (!versionMatch) {
                Log.e("QTFlutterLog", "安卓SDK版本过低，建议升级至8以上");
                //return;
            } else {
                Log.e("QTFlutterLog", "安卓依赖版本检查成功");
            }
        } catch (Throwable e) {
            Log.e("QTFlutterLog", "SDK版本过低，请升级至8以上" + e.toString());
            return;
        }

        Method method = null;
        try {
            Class<?> config = Class.forName("com.quick.qt.commonsdk.QtConfigure");
            method = config.getDeclaredMethod("setWraperType", String.class, String.class);
            method.setAccessible(true);
            method.invoke(null, "flutter", "1.0");
            android.util.Log.i("QTFlutterLog", "setWraperType:flutter1.0 success");
        } catch (Throwable e) {
            Log.e("QTFlutterLog", "setWraperType:flutter1.0" + e.toString());
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
            Log.e("QTFlutterLog", "onMethodCall:" + call.method + ":安卓SDK版本过低，请升级至8以上");
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
                case "onJSCall":
                    onJSCall(args);
                    result.success(null);
                    break;
                case "setCustomDeviceId":
                    setCustomDeviceId(args);
                    break;
                case "getDeviceId":
                    Object res = getDeviceId();
                    result.success(res);
                    break;
                case "updateNextPageProperties":
                    updateNextPageProperties(args);
                    break;
                default:
                    result.notImplemented();
                    break;
            }
        } catch (Throwable e) {
            Log.e("QTFlutterLog", "Exception:" + e.getMessage());
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
            QtConfigure.init(getContext(), appkey, channel, QtConfigure.DEVICE_TYPE_PHONE, null);
            Log.i("QTFlutterLog", "initCommon:" + appkey + "@" + channel);
        } catch (Throwable e) {
            Log.e("QTFlutterLog", "initCommon invoke error: " + e.getMessage());
        }
    }

    private void setAppVersion(List args) {
        try {
            String version = (String) args.get(0);
            int versionCode = (int) args.get(1);
            QtConfigure.setAppVersion(version, versionCode);
        } catch (Throwable e) {
            Log.e("QTFlutterLog", "setAppVersion invoke error: " + e.getMessage());
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
                QtTrackAgent.onEventObject(getContext(), event, map);
            } else {
                QtTrackAgent.onEvent(getContext(), event);
            }

            if (map != null) {
                Log.i("QTFlutterLog", "onEvent:" + event + "(" + map.toString() + ")");
            } else {
                Log.i("QTFlutterLog", "onEvent:" + event);
            }
        } catch (Throwable e) {
            Log.e("QTFlutterLog", "onEventObject invoke error: " + e.getMessage());
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
                QtTrackAgent.onEventObject(getContext(), event, map, pageName);
            } else {
                QtTrackAgent.onEvent(getContext(), event, pageName);
            }
            if (map != null) {
                Log.i("QTFlutterLog", "onEventWithPage:" + event + "(" + map.toString() + ")");
            } else {
                Log.i("QTFlutterLog", "onEvent:" + event);
            }
        } catch (Throwable e) {
            Log.e("QTFlutterLog", "onEventObjectWithPage invoke error: " + e.getMessage());
        }
    }

    private void onProfileSignIn(List args) {
        try {
            String userID = (String) args.get(0);
            String provider = (String) args.get(1);
            QtTrackAgent.onProfileSignIn(provider, userID);
            Log.i("QTFlutterLog", "onProfileSignIn:" + userID);
        } catch (Throwable e) {
            Log.e("QTFlutterLog", "onProfileSignInEx invoke error: " + e.getMessage());
        }
    }

    private void onProfileSignOff() {
        QtTrackAgent.onProfileSignOff();
        Log.i("QTFlutterLog", "onProfileSignOff");
    }


    private void onPageStart(List args) {
        try {
            String event = (String) args.get(0);
            QtTrackAgent.onPageStart(event);
            Log.i("QTFlutterLog", "onPageStart:" + event);
        } catch (Throwable e) {
            Log.e("QTFlutterLog", "onPageStart invoke error: " + e.getMessage());
        }
    }

    private void onPageEnd(List args) {
        try {
            String event = (String) args.get(0);
            QtTrackAgent.onPageEnd(event);
            Log.i("QTFlutterLog", "onPageEnd:" + event);
        } catch (Throwable e) {
            Log.e("QTFlutterLog", "onPageEnd invoke error: " + e.getMessage());
        }
    }

    private void registerGlobalProperties(List args) {
        Map map = null;
        try {
            if (args.size() > 0) {
                map = (Map) args.get(0);
            }
            QtTrackAgent.registerGlobalProperties(getContext(), map);
        } catch (Throwable e) {
            Log.e("QTFlutterLog", "registerGlobalProperties invoke error: " + e.getMessage());
        }
    }

    private void unregisterGlobalProperty(List args) {
        try {
            String propertyName = (String)args.get(0);
            QtTrackAgent.unregisterGlobalProperty(getContext(), propertyName);
        } catch (Throwable e) {
            Log.e("QTFlutterLog", "unregisterGlobalProperty invoke error: " + e.getMessage());
        }
    }

    private void clearGlobalProperties(List args) {
        QtTrackAgent.clearGlobalProperties(getContext());
    }

    private Object getGlobalProperty(List args) {
        Object result = null;
        try {
            String propertyName = (String)args.get(0);
            result = QtTrackAgent.getGlobalProperty(getContext(), propertyName);
            return result;
        } catch (Throwable e) {
            Log.e("QTFlutterLog", "getGlobalProperty invoke error: " + e.getMessage());
        }
        return result;
    }

    private Object getGlobalProperties(List args) {
        Object result = null;
        try {
            result = QtTrackAgent.getGlobalProperties(getContext());
            return result;
        } catch (Throwable e) {
            Log.e("QTFlutterLog", "getGlobalProperties invoke error: " + e.getMessage());
        }
        return result;
    }

    private void skipMe(List args) {
        try {
            String pageName = (String) args.get(0);
            QtTrackAgent.skipMe(getContext(), pageName);
            Log.i("QTFlutterLog", "skipMe: pageName = " + pageName);
        } catch (Throwable e) {
            Log.e("QTFlutterLog", "skipMe invoke error: " + e.getMessage());
        }
    }

    private void updateCurSpm(List args) {
        try {
            String curSpm = (String) args.get(0);
            SpmAgent.updateCurSpm(getContext(), curSpm);
            Log.i("QTFlutterLog", "updateCurSpm: curSpm = " + curSpm);
        } catch (Throwable e) {
            Log.e("QTFlutterLog", "updateCurSpm invoke error: " + e.getMessage());
        }
    }

    private void setPageProperty(List args) {
        try {
            String pageName = (String) args.get(0);
            Map map = null;
            if (args.size() > 0) {
                map = (Map) args.get(1);
            }
            QtTrackAgent.setPageProperty(getContext(), pageName, map);

        } catch (Throwable e) {

        }
    }

    private void onKillProcess(List args) {
        QtTrackAgent.onKillProcess(getContext());
    }

    private void onJSCall(List args) {
        try {
            String msg = (String) args.get(0);
            SpmAgent.CALL(msg);
            Log.i("QTFlutterLog", "onJSCall: msg = " + msg);
        } catch (Throwable e) {
            Log.e("QTFlutterLog", "onJSCall invoke error: " + e.getMessage());
        }
    }

    private void setCustomDeviceId(List args) {
        try {
            String deviceId = (String) args.get(0);
            QtConfigure.setCustomDeviceId(getContext(), deviceId);
        } catch (Throwable e) {
            Log.e("QTFlutterLog", "setCustomDeviceId invoke error: " + e.getMessage());
        }
    }

    private Object getDeviceId() {
        Object deviceId = null;
        try {
            deviceId = QtConfigure.getUMIDString();
        } catch (Throwable e) {
            Log.e("QTFlutterLog", "getDeviceId invoke error: " + e.getMessage());
        }
        return deviceId;
    }

    private void updateNextPageProperties(List args) {
        try {
            Map params = (Map) args.get(0);
            SpmAgent.updateNextPageProperties(getContext(), map);
        } catch (Throwable e) {
            Log.e("QTFlutterLog", "updateNextPageProperties invoke error: " + e.getMessage());
        }
    }
}
