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

  Chat({Key key, this.receiverId, this.receiverName, this.receiverImage})
      : super(key: key);

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
        title: Text(
          receiverName,
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ChatScreen(receiverId: receiverId, receiverImage: receiverImage),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverImage;

  const ChatScreen({Key key, this.receiverId, this.receiverImage})
      : super(key: key);

  @override
  State createState() =>
      ChatScreenState(receiverId: receiverId, receiverImage: receiverImage);
}

class ChatScreenState extends State<ChatScreen> {
  final String receiverId;
  final String receiverImage;

  ChatScreenState({this.receiverId, this.receiverImage});
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  createInput() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Row(
        children: <Widget>[
          //  leading Image icon
          Material(
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(icon: Icon(Icons.image), onPressed: null),
            ),
          ),
// suffix emoji iconbutton
          Material(
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(icon: Icon(Icons.face), onPressed: null),
            ),
          ),

          //  usermsg text feild
          Flexible(
            child: Container(
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: "Write a text here ...",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                focusNode: focusNode,
              ),
            ),
          ),
          // send msg button
          Material(
            child: Container(
                color: Colors.white,
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: null)),
          )
        ],
      ),
    );
  }

  createListofChat() {
    return Flexible(
        child: Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // list of message section
              createListofChat(),

              // user send section
              createInput()
            ],
          )
        ],
      ),
    );
  }
}
