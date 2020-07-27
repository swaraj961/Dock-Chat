import 'dart:async';
import 'package:dockchat/Models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dockchat/Pages/HomePage.dart';
import 'package:dockchat/Widgets/ProgressWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // SharedPreferences preferences;
 
  
  bool isLoggedIn = false;
  bool isLoading = false;
  FirebaseUser currentUser;

  Future<void> controlSignIn() async {
    setState(() {
      isLoading = true;
    });
 var preferences = await SharedPreferences.getInstance();
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuthentication =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuthentication.idToken,
        accessToken: googleAuthentication.accessToken);

    FirebaseUser myFirebaseUser =
        (await _firebaseAuth.signInWithCredential(credential)).user;

    // SignIn Success

    if (myFirebaseUser != null) {
//      Checking if already SignIn Up

      final QuerySnapshot resultQuery = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: myFirebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documentSnapshot = resultQuery.documents;

//      Retrive the list of snapshotQuery from firestone

      // SAVE DATA: User is new and need to store the information in fireStore
      if (documentSnapshot.length == 0) {
        Firestore.instance.collection('users').document().setData({
          "nickname": myFirebaseUser.displayName,
          "photoUrl": myFirebaseUser.photoUrl,
          "id": myFirebaseUser.uid,
          "aboutMe": "Hey there ! I am Using DockChat",
          "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
          "chattingWith": null,
        });

//        Writing data to Local
        currentUser = myFirebaseUser;
        await preferences.setString('id', currentUser.uid);
        await preferences.setString('nickname', currentUser.displayName);
        await preferences.setString('photoUrl', currentUser.photoUrl);
      }
//      User Already Exist
      else {
        //        Writing data to Local
        currentUser = myFirebaseUser;
        await preferences.setString('id', documentSnapshot[0]['id']);
        await preferences.setString(
            'nickname', documentSnapshot[0]['nickname']);
        await preferences.setString(
            'photoUrl', documentSnapshot[0]['photoUrl']);
        await preferences.setString('aboutMe', documentSnapshot[0]['aboutMe']);
      }
      Fluttertoast.showToast(msg: 'Welcome, SignIn Success');
      setState(() {
        isLoading = false;
         Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    currentUserID: myFirebaseUser.uid,
                  ),),);
      });
     
    }
    //    SignIn Failed
    else {
      Fluttertoast.showToast(msg: 'Try Again, SignIn Failed');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
     Scaffold(
        backgroundColor: Color(0xff251F34),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          //Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'DockChat',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        resizeToAvoidBottomPadding: true,
        body: Stack(
          children: <Widget>[
            
             Column(
          children: <Widget>[
            
            SizedBox(
              height:60,
            ),
            Center(
              child: Hero(
                tag: "login",
                child: SizedBox(
                  width: 250,
                  height: 250,
                  child: Image.asset('images/welcome.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Color(0xfff3B324E),
                child: Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 30),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Please sign in to continue.',
                style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                    fontSize: 13),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: controlSignIn,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'images/google_signin_button.png')))),
            ),
            Padding(
              padding: EdgeInsets.all(2),
              child: isLoading ? circularProgress() : Container(),
            ),
            
    //         SizedBox(
    //   height:60,
    // ),
    // Text(
    //   'Version 1.0',
    //   style: TextStyle(color: Colors.grey, letterSpacing: 1.2),
    //   textAlign: TextAlign.center,
    // ),
    // Text(
    //   'Developed by © Swaraj',
    //   style: TextStyle(color: Colors.grey, letterSpacing: 1.2),
    //   textAlign: TextAlign.center,
    // ),
    
          ],
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 60,
            child:DevloperInfo(),)
      
          ],
          
        ),
     );
        
    
  }
}

class DevloperInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
            Text(
      'Version 1.0',
      style: TextStyle(color: Colors.grey, letterSpacing: 1.2),
      textAlign: TextAlign.center,
    ),
    Text(
      'Developed by © Swaraj',
      style: TextStyle(color: Colors.grey, letterSpacing: 1.2),
      textAlign: TextAlign.center,
    ),
        ],
      ),
    );
  }
}