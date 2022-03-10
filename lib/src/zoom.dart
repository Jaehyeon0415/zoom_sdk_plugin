part of zoom_sdk_plugin;

class Zoom {
  /// Connect zoom meeting
  static Future<ZoomController> connect({
    required ZoomOptions zoomOptions,
    required ZoomMeetingOptions zoomMeetingOptions,
  }) async {
    final bool? result = await ZoomPlatform.instance.connect(
      zoomOptions: zoomOptions,
      zoomMeetingOptions: zoomMeetingOptions,
    );

    if (result == null) throw Exception('Zoom connect failed');

    return await _join(zoomMeetingOptions);
  }

  /// Join zoom meeting
  static Future<ZoomController> _join(
      ZoomMeetingOptions zoomMeetingOptions) async {
    final int? id = await ZoomPlatform.instance.join(zoomMeetingOptions);
    if (id == null) throw Exception('ZoomId is null');

    return ZoomController(id);
  }
}
