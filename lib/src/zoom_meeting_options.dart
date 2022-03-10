part of zoom_sdk_plugin;

/// Options when connecting to a Zoom Meeting
class ZoomMeetingOptions {
  /// Display user name
  final String userName;

  /// Zoom meeting id
  final String meetingID;

  /// Zoom meeting password
  final String meetingPW;

  ZoomMeetingOptions({
    required this.userName,
    required this.meetingID,
    required this.meetingPW,
  })  : assert(userName.isNotEmpty),
        assert(meetingID.isNotEmpty),
        assert(meetingPW.isNotEmpty);

  @override
  String toString() {
    return 'ZoomMeetingOptions: { '
        'userName: $userName, '
        'meetingID: $meetingID, '
        'meetingPW: $meetingPW'
        ' }';
  }
}
