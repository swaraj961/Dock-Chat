import 'dart:async';
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
  bool isDisplaySticker;
  bool isLoading;

  @override
  void initState() {
    isDisplaySticker = false;
    isLoading = false;
    focusNode.addListener(onFocusChange);
    super.initState();
  }

  onFocusChange() {
    if (focusNode.hasFocus) {
      // hide the stickers when keyboard appears
      setState(() {
        isDisplaySticker = false;
      });
    }
  }

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
              child: IconButton(icon: Icon(Icons.face), onPressed: getSticker),
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

  createStickers() {
    return Container(
      height: 200,
      padding: EdgeInsets.only(top: 20, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
          )),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // row1
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Image.asset(
                    "images/stickers/mimi1.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/mimi2.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/mimi3.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),

// row2
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Image.asset(
                    "images/stickers/mimi4.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/mimi5.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/mimi6.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),

// row3
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Image.asset(
                    "images/stickers/mimi7.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/mimi8.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/mimi9.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),

            // row4
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute4.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute5.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute6.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),

            // row5
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute1.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute2.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute3.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),

            // row6
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute7.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute8.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute9.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            // row7
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute10.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute11.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute12.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),

            // row8
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute13.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute14.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute15.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),

            // row9
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute16.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute17.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/mimi10.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void getSticker() {
    focusNode.unfocus();
    setState(() {
      isDisplaySticker = !isDisplaySticker;
    });
  }

  Future<bool> onBackPress() {
    if (isDisplaySticker == true) {
      setState(() {
        isDisplaySticker = false;
      });
    } else {
      Navigator.pop(context);
    }
    return Future.value(false);
  }

  createLoading() {
    return Container(
      child: isLoading ? circularProgress() : Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // list of message section
              createListofChat(),

              // show the stickers
              isDisplaySticker ? createStickers() : Container(),

              // user send section
              createInput(),

              createLoading(),
            ],
          )
        ],
      ),
    );
  }
}
