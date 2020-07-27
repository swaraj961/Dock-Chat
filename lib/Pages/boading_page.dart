import 'package:dockchat/Pages/LoginPage.dart';
import 'package:fancy_on_boarding/fancy_on_boarding.dart';
import 'package:flutter/material.dart';

final pagelist = [
  PageModel(
    color: Color(0xff251F34),
    heroAssetPath: "images/board1.png",
    iconAssetPath: "images/phone.png",
    title: Text(
      "Holla !",
      style: TextStyle(
        fontWeight: FontWeight.w800,
        color: Colors.white,
        fontSize: 34.0,
      ),
    ),
    body: Text("Welcome to DockChat \n \n Swipe next ➡",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        )),
  ),
  PageModel(
    color: Color(0xff14DAE2),
    heroAssetPath: "images/boad2.png",
    iconAssetPath: "images/like-filled.png",
    title: Text(
      "Easy to Use!",
      style: TextStyle(
        fontWeight: FontWeight.w800,
        color: Colors.white,
        fontSize: 34.0,
      ),
    ),
    body: Text(
      "MaterialDesign with lots of Features\n \n Swipe next ➡",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
    ),
  ),
  PageModel(
    color: Color(0xff251F34),
    heroAssetPath: "images/Group_chat.png",
    iconAssetPath: "images/connect.png",
    title: Text(
      "Connect Now",
      style: TextStyle(
        fontWeight: FontWeight.w800,
        color: Colors.white,
        fontSize: 34.0,
      ),
    ),
    body: Text(
      "over 2 million users around world\n \n lets start ➡",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
    ),
  ),
];

class BoardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FancyOnBoarding(
        doneButtonText: "Start",
        skipButtonText: "Skip",
        pageList: pagelist,
        onDoneButtonPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        ),
        onSkipButtonPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        ),
      ),
    );
  }
}
