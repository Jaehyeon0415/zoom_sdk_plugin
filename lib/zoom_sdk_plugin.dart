import 'dart:async';

import 'package:flutter/services.dart';

class ZoomSdkPlugin {
  static const MethodChannel _channel = MethodChannel('zoom_sdk_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
