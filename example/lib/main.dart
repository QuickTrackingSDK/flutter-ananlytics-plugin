import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:qt_common_sdk/qt_common_sdk.dart';

//import 'analytics.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();

    QTCommonSdk.setCustomDomain('https://log-api-daily.aplus.emas-poc.com', '');
    QTCommonSdk.setLogEnabled(true);
    QTCommonSdk.initCommon('您的appkey(Android)', '您的appkey(iOS)', 'QT');
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
                children:<Widget>[
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text("onEvent(testEkv, {name:jack, age:18,id_number:5220891219})"),
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () async {

                        QTCommonSdk.onEvent('testEkv', {'name':'jack', 'age':18, 'id_number':5220891219});
                      }
                  ),
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text("registerGlobalProperties({name:jack, age:18, degree:1.6})"),
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: (){
                        QTCommonSdk.registerGlobalProperties({'name':'jack', 'age':'18', 'degree':'1.6'});
                      }
                  ),
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text("unregisterGlobalProperty('degree')"),
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: (){
                        QTCommonSdk.unregisterGlobalProperty('degree');
                      }
                  ), FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text("clearGlobalProperties"),
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: (){
                        QTCommonSdk.clearGlobalProperties();
                      }
                  ),  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text("getGlobalProperties()"),
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: ()async {



                        var allgp = await QTCommonSdk.getGlobalProperties;
                        print("getGlobalProperties Value===$allgp");
                      }
                  ),
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text("getGlobalPropertie('name')"),
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: ()async {

                        var gp = await QTCommonSdk.getGlobalProperty('name');
                        print("getGlobalPropertie Value===$gp");
                      }
                  ),
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text("onEventWithPage(event1,pageName1, {name:jack, age:18 })"),
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: (){
                        QTCommonSdk.onEventWithPage('event1','pageName1', {'name':'jack', 'age':18});
                      }
                  ),
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text("onProfileSignInEx(mike,QQ)"),
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: (){
                      //  QTCommonSdk.onProfileSignIn('jack');
                        QTCommonSdk.onProfileSignInEx('mike', 'QQ');
                      }
                  ),
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text("onProfileSignOff()"),
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: (){
                        QTCommonSdk.onProfileSignOff();
                      }
                  ),
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text("onPageStart(homeView)"),
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: (){
                        QTCommonSdk.onPageStart('homeView');
                      }
                  ),
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text("onPageEnd(homeView)"),
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: (){
                        QTCommonSdk.onPageEnd('homeView');
                      }
                  ),
                  FlatButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      child: Text("setPageProperty('homeView',{'name':'jack', 'age':'20'}"),
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      onPressed: (){
                        QTCommonSdk.setPageProperty('homeView',{'name':'jack', 'age':'20'});
                      }
                  ),
                ]
            ),
          )
      ),
    );
  }
}


