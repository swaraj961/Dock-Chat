import 'package:dockchat/Pages/HomePage.dart';
import 'package:dockchat/Pages/boading_page.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';



Future<void> main() async {
      WidgetsFlutterBinding.ensureInitialized();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var id = prefs.getString('id');
      print(id);
      runApp(MyApp(userid: id,));
    }

// void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
 final String userid;

  const MyApp({Key key, @required this.userid}) : super(key: key);
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
      home: userid == null ? BoardingScreen() : HomeScreen(currentUserID: userid),
      debugShowCheckedModeBanner: false,
    ),);
  }
}
