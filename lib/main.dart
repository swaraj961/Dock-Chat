import 'package:dockchat/Pages/boading_page.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
       data: (brightness) => ThemeData(
     
       fontFamily: 'Poppins',
          primaryColor: Color(0xff14DAE2),
          brightness: brightness ==  Brightness.light
                ? Brightness.light
                : Brightness.dark,
                 scaffoldBackgroundColor:brightness ==Brightness.dark ? Color(0xff292D38) : Colors.white

    ),
    themedWidgetBuilder: (context,themdata)=> 
MaterialApp(
      title: 'DockChat',
      theme : themdata,
      home: BoardingScreen(),
      debugShowCheckedModeBanner: false,
    ),);
  }
}
