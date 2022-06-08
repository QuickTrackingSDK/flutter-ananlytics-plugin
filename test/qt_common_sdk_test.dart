import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qt_common_sdk/qt_common_sdk.dart';

void main() {
  const MethodChannel channel = MethodChannel('qtcommon_sdk');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await QTCommonSdk.platformVersion, '42');
  });
}
