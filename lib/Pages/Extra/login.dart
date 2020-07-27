import 'package:dockchat/Pages/HomePage.dart';
import 'package:dockchat/Pages/Extra/create_account.dart';
import 'package:dockchat/Widgets/rounded_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmer/shimmer.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formkey =
      GlobalKey<FormState>(); //to get he current state of any widget
  bool showSpinner = false;
  TextEditingController emailTextEditcontroller = TextEditingController();
  TextEditingController passTextEditcontroller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          //Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Chattify',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        resizeToAvoidBottomPadding: true,
        backgroundColor: Color(0xff251F34),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Center(
                child: Hero(
                  tag: "login",
                  child: SizedBox(
                      width: 250,
                      height: 250,
                      child: Image.asset('images/welcome.png')),
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
              Form(
                key: formkey,
                child: Column(
                  //wtapped to wrap all the textform feild inside a container
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                              controller: emailTextEditcontroller,
                              validator: (emailid) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(emailid)
                                    ? null
                                    : "Please provide a valid email Id ";
                              },
                              style: (TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400)),
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: Colors.white,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText: 'Enter your Email',
                                hintStyle: TextStyle(
                                    color: Colors.white30, fontSize: 12),
                                border: InputBorder.none,
                                fillColor: Color(0xfff3B324E),
                                filled: true,
                                prefixIcon:
                                    Image.asset('images/icon_email.png'),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xff14DAE2), width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                            controller: passTextEditcontroller,
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
                          btnText: 'LOGIN',
                          color: Color(0xff14DAE2),
                          onPressed: () async {
                            if (formkey.currentState.validate() == true) {
                              setState(() {
                                showSpinner = true;
                              });
                            }
                            try {
                              final user =
                                  await _auth.signInWithEmailAndPassword(
                                      email: emailTextEditcontroller.text,
                                      password: passTextEditcontroller.text);
                              if (user != null) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                              currentUserID: user.user.uid,
                                            )));
                              }
                              setState(() {
                                showSpinner = false;
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Color(0xff14DAE2)),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Dont have an account?',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateAccount()));
                          },
                          child: Shimmer.fromColors(
                            baseColor: Color(0xff14DAE2),
                            highlightColor: Colors.white,
                            child: Text('Sign up',
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
