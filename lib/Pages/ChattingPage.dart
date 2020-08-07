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
  File imagefile;
  String imageUrl;
  String chatID;
  SharedPreferences sharedPreferences;
  String id;
  var listMessages;


  ChatScreenState({this.receiverId, this.receiverImage});
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final ScrollController listscrollController= ScrollController();
  bool isDisplaySticker;
  bool isLoading;
 

  @override
  void initState() {
    isDisplaySticker = false;
    isLoading = false;
    focusNode.addListener(onFocusChange);
    chatID="";
    readFromLocal();
    super.initState();
  }

  readFromLocal() async{
    // best way to use sharedpreferces 
sharedPreferences = await SharedPreferences.getInstance();
id = sharedPreferences.getString("id") ?? "";

if(id.hashCode <= receiverId.hashCode){

  chatID = '$id-$receiverId';
} else {
   chatID = '$receiverId-$id';
}
Firestore.instance.collection("users").document(id).updateData({
  "chattingWith": receiverId
  
});
setState(() {
  
});
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
              child: IconButton(icon: Icon(Icons.image), onPressed:getImageFromGallery),
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
                    onPressed:onSendMessage(textEditingController.text,0)),
          ),
          ),
        ],
      ),
    );
  }

  createListofChat() {
    return Flexible(
        child: chatID == "" ?  Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
      ),
    ) : StreamBuilder(
      stream: Firestore.instance.collection('messages').document(chatID).collection(chatID).orderBy("timestamp", descending: true).limit(20).snapshots(),

      builder: (context , snapshot){
        if(!snapshot.hasData ){
          return  Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
      ),
    );
        } else {

          listMessages  = snapshot.data.documents;
          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: snapshot.data.documents.length,
            reverse: true,
            controller: listscrollController,
          //   itemBuilder: (BuildContext context, int index) {
          //   return  createItem(index, snapshot.data.documents[index]);
          //  },
          );

        }
      }),
    );
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
                  onPressed: onSendMessage("mimi1",2),
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/mimi2.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                 onPressed: onSendMessage("mimi2",2),
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/mimi3.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                 onPressed: onSendMessage("mimi3",2),
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
                 onPressed: onSendMessage("mimi4",2),
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/mimi5.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                onPressed: onSendMessage("mimi5",2),),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/mimi6.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                onPressed: onSendMessage("mimi6",2),
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
                onPressed: onSendMessage("mimi17",2),
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/mimi8.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: onSendMessage("mimi8",2),
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/mimi9.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                 onPressed: onSendMessage("mimi9",2),
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
                  onPressed: onSendMessage("cute4",2),
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute5.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: onSendMessage("cute5",2),
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute6.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                   onPressed: onSendMessage("cute6",2),
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
                 onPressed: onSendMessage("cute1",2),
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute2.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                 onPressed: onSendMessage("cute2",2),
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute3.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                 onPressed: onSendMessage("cute3",2),
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
                 onPressed: onSendMessage("cute7",2),
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute8.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: onSendMessage("cute8",2),
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute9.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
             onPressed: onSendMessage("cute9",2),
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
                onPressed: onSendMessage("cute10",2),
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute11.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                 onPressed: onSendMessage("cute11",2),
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute12.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                onPressed: onSendMessage("cute12",2),
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
                  onPressed: onSendMessage("cute13",2),
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute14.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                onPressed: onSendMessage("cute14",2),
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute15.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                 onPressed: onSendMessage("cute15",2),
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
                 onPressed: onSendMessage("cute16",2),
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/cute17.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                 onPressed: onSendMessage("cute17",2),
                ),
                FlatButton(
                  child: Image.asset(
                    "images/stickers/mimi10.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onPressed: onSendMessage("mimi10",2),
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
Future getImageFromGallery() async {
    var pickedfile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedfile != null) {
      setState(() {
      imagefile = File(pickedfile.path);
        isLoading = true;
      });
    }
    uploadImageToFirebaseStorage();
  }
 Future uploadImageToFirebaseStorage() async {
  //  bestway to code
  String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  StorageReference storageReference = FirebaseStorage.instance.ref().child("Chat Images").child(fileName);
  StorageUploadTask storageUploadTask =  storageReference.putFile(imagefile);
 StorageTaskSnapshot storageTaskSnapshot = await storageUploadTask.onComplete;
 storageTaskSnapshot.ref.getDownloadURL().then((value) {
setState(() {
  imageUrl = value;
  isLoading = false;
  onSendMessage(imageUrl,1);
});

 }, onError: (error){
   setState(() {
     isLoading = false;
   });
   Fluttertoast.showToast(msg: "Error :"+error.toString());
 });

}

 onSendMessage(String contextMsg, int type){

//  type =0: its a text message
//  type =1: its a imageFile
//  type =2:its a StickerEmojies

if(contextMsg!=""){
  textEditingController.clear();
  var docMsgRef = Firestore.instance.collection("messages").document(chatID).collection(chatID).document(DateTime.now().millisecondsSinceEpoch.toString());
 Firestore.instance.runTransaction((transaction) async{
   await transaction.set( docMsgRef, {
     "idFrom": id,
     "idTo": receiverId,
     "timestamp":DateTime.now().millisecondsSinceEpoch.toString(),
     "contextMsg":contextMsg,
     "type":type
   });
 });
listscrollController.animateTo(0.0, duration: Duration(microseconds: 300), curve: Curves.easeOut);

}else {
  Fluttertoast.showToast(msg: "Empty message can't be send !");
}


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
