import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:zoom_sdk_plugin/zoom_sdk_plugin.dart';
import 'package:zoom_sdk_plugin/src/zoom_platform.dart';

class ZoomMethodChannel extends ZoomPlatform {
  ZoomMethodChannel()
      : _methodChannel = const MethodChannel('zoom_sdk_plugin'),
        _roomChannel = const EventChannel('zoom_sdk_plugin/room'),
        super();

  Widget _videoWidget(Map<String, bool> creationParams, Key key) {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: 'zoom_sdk_plugin/views',
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }

    if (Platform.isIOS) {
      return UiKitView(
        viewType: 'zoom_sdk_plugin/views',
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }

    throw Exception(
        'No widget implementation found for platform: ${Platform.operatingSystem}');
  }

  @override
  Widget getLocalVideoWidget({Key? key}) {
    key ??= const ValueKey('Zoom_LocalParticipant');

    final creationParams = {'isLocal': true};

    return _videoWidget(creationParams, key);
  }

  @override
  Widget getRemoteVideoWidget({Key? key}) {
    key ??= const ValueKey('Zoom_RemoteParticipant');

    final creationParams = {'isLocal': false};

    return _videoWidget(creationParams, key);
  }

  final MethodChannel _methodChannel;

  @override
  Future<bool?> connect({
    required ZoomOptions zoomOptions,
    required ZoomMeetingOptions zoomMeetingOptions,
  }) async {
    var optionMap = <String, String>{};
    optionMap.putIfAbsent('zoomKey', () => zoomOptions.zoomKey);
    optionMap.putIfAbsent('zoomSecret', () => zoomOptions.zoomSecret);

    bool? result = await _methodChannel.invokeMethod('init', optionMap);
    if (result != true) return null;
    return result;
  }

  @override
  Future<int?> join(ZoomMeetingOptions zoomMeetingOptions) async {
    var optionMap = <String, String>{};
    optionMap.putIfAbsent('userName', () => zoomMeetingOptions.userName);
    optionMap.putIfAbsent('meetingID', () => zoomMeetingOptions.meetingID);
    optionMap.putIfAbsent('meetingPW', () => zoomMeetingOptions.meetingPW);

    int? result = await _methodChannel.invokeMethod('join', optionMap);
    if (result == null) return null;
    return result;
  }

  @override
  Future<void> leaveMeeting() {
    return _methodChannel.invokeMethod('leave');
  }

  @override
  Future<void> switchCamera() {
    return _methodChannel.invokeMethod('switch_camera');
  }

  @override
  Future<void> toggleCamera() {
    return _methodChannel.invokeMethod('toggle_camera');
  }

  final EventChannel _roomChannel;

  @override
  Stream<dynamic> getRoomEvent() => _roomChannel.receiveBroadcastStream();

  @override
  Future<void> disconnect() async {
    // _streamSubscription?.cancel();
  }
}
