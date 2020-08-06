import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:dockchat/Widgets/FullImageWidget.dart';
import 'package:dockchat/Widgets/ProgressWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatelessWidget {
  final String receiverId;
  final String receiverName;
  final String receiverImage;

  const Chat({Key key, this.receiverId, this.receiverName, this.receiverImage}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              backgroundImage: CachedNetworkImageProvider(receiverImage),
            ),
            ),
           
        ],
         // to change the theme of backbutton 
        iconTheme: IconThemeData(
          color: Colors.white,

        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(receiverName ,style: TextStyle(fontWeight: FontWeight.w700,
        color: Colors.white
        ),
        ),
        centerTitle: true,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
