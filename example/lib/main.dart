import 'package:flutter/material.dart';

import 'package:zoom_sdk_plugin_example/home_page.dart';
import 'package:zoom_sdk_plugin_example/zoom_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        'zoom': (context) => const ZoomPage(),
      },
    );
  }
}
