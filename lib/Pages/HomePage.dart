import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dockchat/Models/user.dart';
import 'package:dockchat/Pages/Extra/create_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:dockchat/Pages/ChattingPage.dart';
import 'package:dockchat/main.dart';
import 'package:dockchat/Pages/AccountSettingsPage.dart';
import 'package:dockchat/Widgets/ProgressWidget.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserID;

  HomeScreen({Key key, @required this.currentUserID}) : super(key: key);
  @override
  State createState() => HomeScreenState(currentUserID);
}

class HomeScreenState extends State<HomeScreen> {
  String currentuserId;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  TextEditingController _textEditingController = TextEditingController();
  Future<QuerySnapshot> futureSearchResults;

  HomeScreenState(this.currentuserId);

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
            //  focusedBorder: InputBorder.none,
            prefixIcon: Icon(
              Icons.person_pin,
              color: Colors.white,
              size: 30,
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
            ),
          ),
          onFieldSubmitted: implementSearch,
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
                builder: (context) => SettingScreen(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void implementSearch(String userName) {
    Future<QuerySnapshot> allDockchatusers = Firestore.instance
        .collection('users')
        .where('nickname', isGreaterThanOrEqualTo: userName)
        .getDocuments();
    setState(() {
      futureSearchResults = allDockchatusers;
    });
  }

  displayNOsearchResultScreen() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Icon(
              Icons.group,
              size: 150,
              color: Colors.grey,
            ),
            Text(
              'Search users',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.grey,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  userFoundScreen() {
    return FutureBuilder(
      future: futureSearchResults,
      builder: (context, datasnapshot) {
        if (!datasnapshot.hasData) {
          return circularProgress();
        } else {
          List<UserResult> searchResultList = [];
          datasnapshot.data.documents.forEach((document) {
            User eachuser = User.fromDocument(document);
            UserResult userResult = UserResult(
              eachuser: eachuser,
            );

            if (currentuserId != document['id']) {
//checking for same user can't search for himself
// showing users if  search user is not same as current user
              searchResultList.add(userResult);
            }
          });
          return ListView(
            children: searchResultList,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff251F34),
      appBar: homePageHeader(),
      body: futureSearchResults == null
          ? displayNOsearchResultScreen()
          : userFoundScreen(),
    );
  }
}

class UserResult extends StatelessWidget {
  final User eachuser;

  const UserResult({Key key, this.eachuser}) : super(key: key);

  // sendUsertoChatPage(BuildContext context) {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(receiverId:eachuser.id , receiverImage:eachuser.photoUrl,receiverName:eachuser.nickname)));
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(receiverId:eachuser.id , receiverImage:eachuser.photoUrl,receiverName:eachuser.nickname))),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage:
                      CachedNetworkImageProvider(eachuser.photoUrl),
                ),
                title: Text(
                  eachuser.nickname,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.grey),
                ),
                subtitle: Text(
                  "Joined DockChat at :" +
                      DateFormat("dd MMMM , yyyy - hh:mm:aa").format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(eachuser.createdAt))),
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.grey),
                ),
              ),
            )
          ],
        ));
  }
}
