import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:qt_common_sdk/qt_common_sdk.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

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
      QTCommonSdk.setCustomDomain(
          'https://log-api-daily.aplus.emas-poc.com', '');
      QTCommonSdk.setLogEnabled(true);
      QTCommonSdk.initCommon('64632267', '12323232', 'QT');
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
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text(
                          "onEvent(testEkv, {name:jack, age:18,id_number:5220891219})"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () async {
                        QTCommonSdk.onEvent('testEkv', {
                          'name': 'jack',
                          'age': 18,
                          'id_number': 5220891219
                        });
                      }),
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text(
                          "registerGlobalProperties({name:jack, age:18, degree:1.6})"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () {
                        QTCommonSdk.registerGlobalProperties(
                            {'name': 'jack', 'age': '18', 'degree': '1.6'});
                      }),
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text("unregisterGlobalProperty('degree')"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () {
                        QTCommonSdk.unregisterGlobalProperty('degree');
                      }),
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text("clearGlobalProperties"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () {
                        QTCommonSdk.clearGlobalProperties();
                      }),
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text("getGlobalProperties()"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () async {
                        var allgp = await QTCommonSdk.getGlobalProperties;
                        print("getGlobalProperties Value===$allgp");
                      }),
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text("getGlobalPropertie('name')"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () async {
                        var gp = await QTCommonSdk.getGlobalProperty('name');
                        print("getGlobalPropertie Value===$gp");
                      }),
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text(
                          "onEventWithPage(event1,pageName1, {name:jack, age:18 })"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () {
                        QTCommonSdk.onEventWithPage(
                            'event1', 'pageName1', {'name': 'jack', 'age': 18});
                      }),
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text("onProfileSignInEx(mike,QQ)"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () {
                        //  QTCommonSdk.onProfileSignIn('jack');
                        QTCommonSdk.onProfileSignInEx('mike', 'QQ');
                      }),
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text("onProfileSignOff()"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () {
                        QTCommonSdk.onProfileSignOff();
                      }),
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text("onPageStart(homeView)"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () {
                        QTCommonSdk.onPageStart('homeView');
                      }),
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text("onPageEnd(homeView)"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () {
                        QTCommonSdk.onPageEnd('homeView');
                      }),
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text(
                          "setPageProperty('homeView',{'name':'jack', 'age':'20'}"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () {
                        QTCommonSdk.setPageProperty(
                            'homeView', {'name': 'jack', 'age': '20'});
                      }),
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text("跳转到webview plugin示例页"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
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
