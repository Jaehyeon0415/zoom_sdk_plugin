import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock/wakelock.dart';
import 'package:zoom_sdk_plugin/zoom_sdk_plugin.dart';
import 'package:zoom_sdk_plugin_example/zoom_footer.dart';

class ZoomPage extends StatefulWidget {
  const ZoomPage({Key? key}) : super(key: key);

  @override
  State<ZoomPage> createState() => _ZoomPageState();
}

class _ZoomPageState extends State<ZoomPage> {
  late ZoomOptions zoomOptions;
  late ZoomMeetingOptions zoomMeetingOptions;
  ZoomController? zoomController;

  @override
  void initState() {
    _zoomConnect();
    AutoOrientation.landscapeAutoMode();
    Wakelock.enable();
    super.initState();
  }

  @override
  void dispose() {
    zoomController?.disconnect();
    AutoOrientation.portraitUpMode();
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: ZoomFooter(zoomController: zoomController),
        body: SizedBox.expand(
          child: Row(
            children: [
              Expanded(flex: 2, child: _buildRemoteVideoWidget()),
              Expanded(child: _buildLocalVideoWidget()),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPermissions() async {
    PermissionStatus camera = await Permission.camera.request();
    PermissionStatus mic = await Permission.microphone.request();

    if (!camera.isGranted || !mic.isGranted) {
      if (!await openAppSettings()) {
        return false;
      } else {
        return await _requestPermissions();
      }
    }
    return true;
  }

  void _roomStateEventListener(dynamic statusEvent) async {
    print('zoom status: $statusEvent');
    var status = statusEvent[0];

    switch (status) {
      case 'MEETING_STATUS_CONNECTING':
        break;

      case 'MEETING_STATUS_DISCONNECTING':
        break;

      case 'MEETING_STATUS_FAILED':
        break;

      case 'MEETING_STATUS_IDLE':
      case 'MEETING_STATUS_ENDED':
        await zoomController?.leaveMeeting();
        if (await Navigator.of(context).maybePop()) {
          Navigator.of(context).pop();
        }
        break;

      case 'MEETING_STATUS_INMEETING':
        break;
    }
  }

  void _zoomConnect() async {
    try {
      if (await _requestPermissions() == false) throw 'Permission denied';

      var controller = await Zoom.connect(
        zoomOptions: zoomOptions,
        zoomMeetingOptions: zoomMeetingOptions,
      );

      controller.setRoomEventListener(_roomStateEventListener);

      setState(() => zoomController = controller);
    } catch (err) {
      print('_zoom() err: $err');
      Navigator.of(context).pop();
    }
  }

  Widget _buildLocalVideoWidget() {
    if (zoomController == null) {
      return const Center(
        child: SizedBox(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(
              color: Color(0xff00d695), strokeWidth: 3),
        ),
      );
    }

    return zoomController!.localVideoWidget();
  }

  Widget _buildRemoteVideoWidget() {
    if (zoomController == null) {
      return const Center(
        child: Text(
          'Entering zoom...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      );
    }

    return zoomController!.remoteVideoWidget();
  }
}
