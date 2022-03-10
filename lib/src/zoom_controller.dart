part of zoom_sdk_plugin;

class ZoomController {
  final int _internalId;

  late Stream<dynamic> _roomEvent;

  StreamSubscription? _roomEventSubscription;

  ZoomController(this._internalId) {
    _roomEvent = ZoomPlatform.instance.getRoomEvent();
  }

  /// Set zoom meeting status event listener
  void setRoomEventListener(Function(dynamic) listener) {
    _roomEventSubscription = _roomEvent.listen(listener);
  }

  /// Leave zoom meeting
  Future<void> leaveMeeting() async {
    return await ZoomPlatform.instance.leaveMeeting();
  }

  /// Switch local user camera front/back
  Future<void> switchCamera() async {
    return await ZoomPlatform.instance.switchCamera();
  }

  /// Switch local user camera on/off
  Future<void> switchCameraState() async {
    return await ZoomPlatform.instance.toggleCamera();
  }

  /// Get local user video widget
  Widget localVideoWidget() {
    return ZoomPlatform.instance.getLocalVideoWidget();
  }

  /// Get remote user video widget
  Widget remoteVideoWidget() {
    return ZoomPlatform.instance.getRemoteVideoWidget();
  }

  /// Disconnect zoom meeting
  Future<void> disconnect() async {
    await _roomEventSubscription?.cancel();
    return await ZoomPlatform.instance.disconnect();
  }
}
