import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_webview_plugin_ios_android/flutter_webview_plugin_ios_android.dart';
import 'package:qt_common_sdk/qt_common_sdk.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

// String selectedUrl = 'https://flutter.io';
String selectedUrl = 'file:///android_asset/index.html';

// ignore: prefer_collection_literals
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Umeng4AplusFlutter',
      onMessageReceived: (JavascriptMessage message) {
        // print(message.message);
        QTCommonSdk.onJSCall(message.message);
      }),
].toSet();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebView Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (_) => const MainPage(title: 'Flutter Demo'),
        '/webviewdemo': (context) =>
            const WebViewDemoPage(title: 'Flutter WebView Demo'),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  final String title;
  const MainPage({Key? key, required this.title}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _platformVersion = 'Unknown';
  static bool sdkHasInit = false;
  @override
  void initState() {
    super.initState();
    initPlatformState();
    if (!sdkHasInit) {
      sdkHasInit = true;
      QTCommonSdk.setCustomDomain('配置收数域名', '');
      QTCommonSdk.setLogEnabled(true);
      QTCommonSdk.initCommon('配置Android应用appkey', '配置iOS应用appkey', 'QT');
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = (await QTCommonSdk.platformVersion)!;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Running on: $_platformVersion'),
          ),
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                    ),
                      child: Text(
                          "onEvent(testEkv, {name:jack, age:18,id_number:5220891219})"),
                      onPressed: () async {
                        QTCommonSdk.onEvent('testEkv', {
                          'name': 'jack',
                          'age': 18,
                          'id_number': 5220891219
                        });
                      }),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                    ),
                      child: Text(
                          "registerGlobalProperties({name:jack, age:18, degree:1.6})"),
                      onPressed: () {
                        QTCommonSdk.registerGlobalProperties(
                            {'name': 'jack', 'age': '18', 'degree': '1.6'});
                      }),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                      ),
                      child: Text("unregisterGlobalProperty('degree')"),
                      onPressed: () {
                        QTCommonSdk.unregisterGlobalProperty('degree');
                      }),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                      ),
                      child: Text("clearGlobalProperties"),
                      onPressed: () {
                        QTCommonSdk.clearGlobalProperties();
                      }),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                      ),
                      child: Text("getGlobalProperties()"),
                      onPressed: () async {
                        var allgp = await QTCommonSdk.getGlobalProperties;
                        print("getGlobalProperties Value===$allgp");
                      }),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                      ),
                      child: Text("getGlobalPropertie('name')"),
                      onPressed: () async {
                        var gp = await QTCommonSdk.getGlobalProperty('name');
                        print("getGlobalPropertie Value===$gp");
                      }),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                      ),
                      child: Text(
                          "onEventWithPage(event1,pageName1, {name:jack, age:18 })"),
                      onPressed: () {
                        QTCommonSdk.onEventWithPage(
                            'event1', 'pageName1', {'name': 'jack', 'age': 18});
                      }),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                      ),
                      child: Text("onProfileSignInEx(mike,QQ)"),
                      onPressed: () {
                        //  QTCommonSdk.onProfileSignIn('jack');
                        QTCommonSdk.onProfileSignInEx('mike', 'QQ');
                      }),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                      ),
                      child: Text("onProfileSignOff()"),
                      onPressed: () {
                        QTCommonSdk.onProfileSignOff();
                      }),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                      ),
                      child: Text("onPageStart(homeView)"),
                      onPressed: () {
                        QTCommonSdk.onPageStart('homeView');
                      }),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                      ),
                      child: Text("onPageEnd(homeView)"),
                      onPressed: () {
                        QTCommonSdk.onPageEnd('homeView');
                      }),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                      ),
                      child: Text(
                          "setPageProperty('homeView',{'name':'jack', 'age':'20'}"),
                      onPressed: () {
                        QTCommonSdk.setPageProperty(
                            'homeView', {'name': 'jack', 'age': '20'});
                      }),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                      ),
                      child: Text("跳转到webview plugin示例页"),
                      onPressed: () {
                        Navigator.pushNamed(context, '/webviewdemo');
                      }),
                ]),
          )),
    );
  }
}

class WebViewDemoPage extends StatefulWidget {
  const WebViewDemoPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _WebViewDemoPageState createState() => _WebViewDemoPageState();
}

class _WebViewDemoPageState extends State<WebViewDemoPage> {
  // Instance of WebView plugin
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  // On destroy stream
  late StreamSubscription _onDestroy;

  // On urlChanged stream
  late StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  late StreamSubscription<WebViewStateChanged> _onStateChanged;

  late StreamSubscription<WebViewHttpError> _onHttpError;

  late StreamSubscription<double> _onProgressChanged;

  late StreamSubscription<double> _onScrollYChanged;

  late StreamSubscription<double> _onScrollXChanged;

  final _urlCtrl = TextEditingController(text: selectedUrl);

  final _codeCtrl = TextEditingController(text: 'window.navigator.userAgent');

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _history = [];

  // static bool sdkHasInit = false;

  @override
  void initState() {
    super.initState();
    // if (!sdkHasInit) {
    //   sdkHasInit = true;
    //   QTCommonSdk.setCustomDomain(
    //       'https://log-api-daily.aplus.emas-poc.com', '');
    //   QTCommonSdk.setLogEnabled(true);
    //   QTCommonSdk.initCommon('64632267', '12342267', 'QT');
    // }
    flutterWebViewPlugin.close();

    _urlCtrl.addListener(() {
      selectedUrl = _urlCtrl.text;
    });

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Webview Destroyed')));
      }
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          _history.add('onUrlChanged: $url');
        });
      }
    });

    _onProgressChanged =
        flutterWebViewPlugin.onProgressChanged.listen((double progress) {
      if (mounted) {
        setState(() {
          _history.add('onProgressChanged: $progress');
        });
      }
    });

    _onScrollYChanged =
        flutterWebViewPlugin.onScrollYChanged.listen((double y) {
      if (mounted) {
        setState(() {
          _history.add('Scroll in Y Direction: $y');
        });
      }
    });

    _onScrollXChanged =
        flutterWebViewPlugin.onScrollXChanged.listen((double x) {
      if (mounted) {
        setState(() {
          _history.add('Scroll in X Direction: $x');
        });
      }
    });

    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        setState(() {
          _history.add('onStateChanged: ${state.type} ${state.url}');
        });
      }
    });

    _onHttpError =
        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
      if (mounted) {
        setState(() {
          _history.add('onHttpError: ${error.code} ${error.url}');
        });
      }
    });
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onProgressChanged.cancel();
    _onScrollXChanged.cancel();
    _onScrollYChanged.cancel();

    flutterWebViewPlugin.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              child: TextField(controller: _urlCtrl),
            ),
            ElevatedButton(
              onPressed: () {
                flutterWebViewPlugin.launch(
                  selectedUrl,
                  javascriptChannels: jsChannels,
                  rect: Rect.fromLTWH(
                      0.0, 0.0, MediaQuery.of(context).size.width, 300.0),
                  userAgent: kAndroidUserAgent,
                  invalidUrlRegex:
                      r'^(https).+(twitter)', // prevent redirecting to twitter when user click on its icon in flutter website
                );
              },
              child: const Text('Open Webview Window'),
            ),
            Container(
              height: 240,
              padding: const EdgeInsets.all(24.0),
              // child: TextField(controller: _codeCtrl),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _history.clear();
                });
                flutterWebViewPlugin.close();
                Navigator.pop(context);
              },
              child: const Text('返回首页'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _history.clear();
                });
                flutterWebViewPlugin.close();
              },
              child: const Text('Close Webview Window'),
            ),
            Text(_history.join('\n'))
          ],
        ),
      ),
    );
  }
}
