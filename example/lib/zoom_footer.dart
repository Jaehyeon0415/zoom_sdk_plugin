import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoom_sdk_plugin/zoom_sdk_plugin.dart';

class ZoomFooter extends StatelessWidget {
  final ZoomController? zoomController;
  const ZoomFooter({
    Key? key,
    required this.zoomController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      child: Container(
        height: 55,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CupertinoButton(
              onPressed: () async {
                await zoomController?.toggleCamera();
              },
              child: const Icon(Icons.videocam, color: Colors.green),
            ),
            const SizedBox(width: 8),
            CupertinoButton(
              onPressed: () async {
                await zoomController?.switchCamera();
              },
              child: const Icon(Icons.switch_camera),
            ),
            const SizedBox(width: 8),
            CupertinoButton(
              color: Colors.red,
              onPressed: () => _exit(context),
              child: const Text(
                'leave',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _exit(context) async {
    bool result = await showCupertinoDialog(
      context: context,
      builder: (alertContext) {
        return CupertinoAlertDialog(
          content: const Text('Leaving zoom meeting?'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(alertContext).pop(false),
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              onPressed: () => Navigator.of(alertContext).pop(true),
              child: const Text('Leave'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await zoomController?.leaveMeeting();
      if (await Navigator.of(context).maybePop()) {
        Navigator.of(context).pop();
      }
    }
  }
}
