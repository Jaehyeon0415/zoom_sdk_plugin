part of zoom_sdk_plugin;

/// Options when authenticate Zoom SDK
class ZoomOptions {
  /// Set your Zoom App Key
  final String zoomKey;

  /// Set your Zoom App Secret
  final String zoomSecret;

  ZoomOptions({
    required this.zoomKey,
    required this.zoomSecret,
  })  : assert(zoomKey.isNotEmpty),
        assert(zoomSecret.isNotEmpty);

  @override
  String toString() {
    return 'ZoomOptions: { '
        'zoomKey: $zoomKey, '
        'zoomSecret: $zoomSecret'
        ' }';
  }
}
