import 'package:dockchat/Widgets/rounded_btn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dockchat/Pages/LoginPage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dockchat/Pages/HomePage.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController userNameTextcontroller = TextEditingController();
  TextEditingController emailNameTextcontroller = TextEditingController();
  TextEditingController passwordTextcontroller = TextEditingController();

  final formkey = GlobalKey<FormState>();
  bool isLoading = false;
  final _auth = FirebaseAuth.instance;
  final _firestone = Firestore.instance;

  String email;
  String password;
  String username;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          elevation: 0,
          leading: _goBackButton(context),
          backgroundColor: Color(0xff251F34),
        ),
        backgroundColor: Color(0xff251F34),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Hero(
                tag: "Register",
                child: SizedBox(
                  height: 160,
                  width: 160,
                  child: SvgPicture.asset('images/loginpage.svg'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Color(0xfff3B324E),
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 25),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Please fill the input below.',
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
              ),
              Form(
                key: formkey,
                child: Column(
                  //wtapped to wrap all the textform feild inside a container
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Username',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 13,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: userNameTextcontroller,
                            //username
                            style: (TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400)),
                            keyboardType: TextInputType.multiline,
                            obscureText: false,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              hintText: 'Enter your Username',
                              hintStyle: TextStyle(
                                  color: Colors.white30, fontSize: 12),
                              border: InputBorder.none,
                              fillColor: Color(0xfff3B324E),
                              filled: true,
                              prefixIcon: Image.asset('images/userid.png'),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff14DAE2), width: 2.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                            ),

                            validator: (username) {
                              return RegExp(r"^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$")
                                          .hasMatch(username) ||
                                      username.isNotEmpty
                                  ? null
                                  : "Please provide a valid UserId ";
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'E-mail',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 13,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: emailNameTextcontroller,
                            //email
                            style: (TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400)),
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              hintText: 'Enter your Email',
                              hintStyle: TextStyle(
                                  color: Colors.white30, fontSize: 12),
                              border: InputBorder.none,
                              fillColor: Color(0xfff3B324E),
                              filled: true,
                              prefixIcon: Image.asset('images/icon_email.png'),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff14DAE2), width: 2.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                            ),

                            validator: (email) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(email)
                                  ? null
                                  : "Please provide a valid email Id ";
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Password',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 13,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: passwordTextcontroller,
                            //password
                            style: (TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400)),
                            obscureText: true,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              hintText: 'Enter your Password',
                              hintStyle: TextStyle(
                                  color: Colors.white30, fontSize: 12),
                              border: InputBorder.none,
                              fillColor: Color(0xfff3B324E),
                              filled: true,
                              prefixIcon: Image.asset('images/icon_lock.png'),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff14DAE2), width: 2.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                            ),

                            validator: (password) {
                              return password.isEmpty || password.length < 6
                                  ? "password must be 6 or more characters"
                                  : null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: RoundedButton(
                          btnText: 'SIGN UP',
                          color: Color(0xff14DAE2),
                          onPressed: () async {
                            if (formkey.currentState.validate() == true) {
                              final name = userNameTextcontroller.text;
                              final email = emailNameTextcontroller.text;

                              _firestone.collection('users').add({
                                'name': name,
                                'email': email,
                              });

                              setState(() {
                                isLoading = true;
                              });
                            }
                            try {
                              final newUser =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: emailNameTextcontroller.text,
                                      password: passwordTextcontroller.text);
                              if (newUser != null) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                              currentUserID: newUser.user.uid,
                                            )));
                              }

                              setState(() {
                                isLoading = false;
                              });
                            } catch (e) {
                              print(e);
                            }
                            // Add login code
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Shimmer.fromColors(
                            baseColor: Color(0xff14DAE2),
                            highlightColor: Colors.white,
                            child: Text('Sign in',
                                style: TextStyle(
                                  color: Color(0xff14DAE2),
                                )),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _goBackButton(BuildContext context) {
  return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.grey[350]),
      onPressed: () {
        Navigator.of(context).pop(true);
      });
}
