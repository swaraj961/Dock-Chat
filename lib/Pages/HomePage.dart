import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dockchat/Pages/Extra/create_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:dockchat/Pages/ChattingPage.dart';
import 'package:dockchat/main.dart';
import 'package:dockchat/Pages/AccountSettingsPage.dart';
import 'package:dockchat/models/user.dart';
import 'package:dockchat/Widgets/ProgressWidget.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserID;

  HomeScreen({Key key, @required this.currentUserID}) : super(key: key);
  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  TextEditingController _textEditingController = TextEditingController();

  Future<Null> logoutUser() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
        (Route<dynamic> route) => false);
  }

  homePageHeader() {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: Container(
      
      margin: EdgeInsets.only(bottom: 4),
        child: TextFormField(
          //  textAlign: TextAlign.center, 
          controller: _textEditingController,
          style: TextStyle(fontSize: 18.0, color: Colors.white),
          decoration: InputDecoration(
             contentPadding: const EdgeInsets.only(bottom: 8),
              hintText: 'Search for users',
              hintStyle: TextStyle(
              
                color: Colors.white,
              ),
              
            
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              prefixIcon: Icon(
                Icons.person_pin,
                color: Colors.white,
                size:30,
              ),
              suffix: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    _textEditingController.clear();
                  });
                },
              )),
        ),
      ),
      automaticallyImplyLeading: false,
      //  remove the back button in app bar
      actions: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: IconButton(
            icon: Icon(
              Icons.settings,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateAccount(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff251F34),
      appBar: homePageHeader(),
      body: Center(
        child: RaisedButton(
          child: Text('Logout'),
          onPressed:logoutUser),
      ),
    );
  }
}

class UserResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
