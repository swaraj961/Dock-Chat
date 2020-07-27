import 'package:dockchat/Pages/boading_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DockChat',
      theme: ThemeData(
        primaryColor: Color(0xff14DAE2),
      ),
      home: BoardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
