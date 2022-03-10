import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:zoom_sdk_plugin/src/zoom_method_channel.dart';
import 'package:zoom_sdk_plugin/zoom_sdk_plugin.dart';

abstract class ZoomPlatform extends PlatformInterface {
  ZoomPlatform() : super(token: _token);

  static final Object _token = Object();
  static ZoomPlatform _instance = ZoomMethodChannel();

  static ZoomPlatform get instance => _instance;

  static set instance(ZoomPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Zoom init & join meeting
  Future<bool?> connect({
    required ZoomOptions zoomOptions,
    required ZoomMeetingOptions zoomMeetingOptions,
  }) {
    throw UnimplementedError('connect() has not been implemented');
  }

  /// Join Zoom meeting
  Future<int?> join(ZoomMeetingOptions zoomMeetingOptions) {
    throw UnimplementedError('_join() has not been implemented');
  }

  /// Leave Zoom meeting
  Future<void> leaveMeeting() {
    throw UnimplementedError('leaveMeeting() has not been implemented');
  }

  /// Switch camera front/back
  Future<void> switchCamera() {
    throw UnimplementedError('switchCamera() has not been implemented');
  }

  /// Camera on/off
  Future<void> toggleCamera() {
    throw UnimplementedError('switchCameraState() has not been implemented');
  }

  /// Create local user video widget
  Widget getLocalVideoWidget({Key? key}) {
    throw UnimplementedError('getLocalVideoWidget() has not been implemented');
  }

  /// Create Remote user video widget
  Widget getRemoteVideoWidget({Key? key}) {
    throw UnimplementedError('getRemoteVideoWidget() has not been implemented');
  }

  Stream<dynamic> getRoomEvent() {
    throw UnimplementedError('getRoomEvent() has not benn implemented');
  }

  /// Zoom meeting disconnect
  Future<void> disconnect() {
    throw UnimplementedError('disconnect() has not been implemented');
  }
}
