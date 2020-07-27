import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:dockchat/Widgets/ProgressWidget.dart';
import 'package:dockchat/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  SharedPreferences preferences;
  String id = '';
  String nickname = '';
  String aboutMe = '';
  String photoUrl = '';
  TextEditingController nickNametextEditingController;
  TextEditingController aboutMetextEditingController;
  File imagefileAvator;
  bool isLoading = false;
  @override
  void initState() {
    readDataFromLocal();
    super.initState();
  }

  void readDataFromLocal() async {
    preferences = await SharedPreferences.getInstance();
//fetching data from local and storing in variables
    id = preferences.getString('id');
    nickname = preferences.getString('nickname');
    aboutMe = preferences.getString('aboutMe');
    photoUrl = preferences.getString('photoUrl');
    nickNametextEditingController = TextEditingController(text: nickname);
    aboutMetextEditingController = TextEditingController(text: aboutMe);
    setState(() {});
  }

Future getImage() async{
var pickedfile =  await ImagePicker().getImage(source: ImageSource.gallery);
if(pickedfile!=null){
  setState(() {
  imagefileAvator = File(pickedfile.path);
  isLoading = true;
});
}
}

void uploadImageToFirebaseStorage(){

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white,
          
        ),
        title: Text('Account Settings',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
        
      ),
      body: 
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Profile Image
              Container(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      (imagefileAvator == null)
                          ? (photoUrl != "")
                              ? Material(
                                  // if photoUrl is not null means pic exists : display the  image file
                                  child: CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                            width: 200,
                                            height: 200,
                                            padding: EdgeInsets.all(20),
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              valueColor: AlwaysStoppedAnimation(
                                                  Theme.of(context).primaryColor),
                                            ),
                                          ),
                                      imageUrl: photoUrl,
                                      width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(125),
                                      clipBehavior: Clip.hardEdge,
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: 90,
                                  color: Colors.grey,
                                )
                          : Material(
                              // displaying the updated new avatar
                              child: Image.file(imagefileAvator,
                               width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,),
                                   borderRadius: BorderRadius.circular(125),
                                  clipBehavior: Clip.hardEdge,
                              
                              ),
                      IconButton(
                        icon: Icon(Icons.camera_alt, size:100,color: Colors.white54.withOpacity(0.3),),
                        onPressed: getImage,
                        padding: EdgeInsets.all(0.0),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.grey,
                        iconSize: 200,

                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(20),
              ),
            ],
          ),
        )
    
    );
  }
}

// class Settings extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return 
//   }
// }
