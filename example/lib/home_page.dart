import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AutoOrientation.portraitUpMode();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Zoom sdk plugin example app'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () => Navigator.of(context).pushNamed('/zoom'),
          child: const Text('Join zoom meeting'),
        ),
      ),
    );
  }
}
