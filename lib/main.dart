import 'package:flutter/material.dart';

import 'screens/home/home_view_impl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch:
            MaterialColor(const Color.fromRGBO(171, 144, 255, 1).value, const {}),
      ),
      home: const Home(),
    );
  }
}