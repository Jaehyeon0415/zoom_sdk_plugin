import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoom_sdk_plugin/zoom_sdk_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('zoom_sdk_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  // test('getPlatformVersion', () async {
  //   expect(await ZoomSdkPlugin.platformVersion, '42');
  // });
}
