import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future<Null> logoutUser() async {
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Center(
        child: RaisedButton.icon(
          onPressed: logoutUser,
          icon: Icon(Icons.power_settings_new),
          label: Text('SignOut'),
        ),
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
