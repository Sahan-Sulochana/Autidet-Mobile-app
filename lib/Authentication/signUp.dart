import 'package:Autidet/firstScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;
  final auth = FirebaseAuth.instance;
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12, 75, 12, 8),
              child: Image(
                  image: AssetImage("assets/images/boy.png"), height: 200),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 5, 20, 5),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelText: 'Username',
                    labelStyle: TextStyle(fontSize: 16, color: Colors.white),
                    hintText: 'Enter a valid email address',
                    hintStyle: TextStyle(fontSize: 13, color: Colors.white38)),
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 5, 20, 5),
              child: TextField(
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(fontSize: 16, color: Colors.white),
                  hintText: 'Please enter more than six characters',
                  hintStyle: TextStyle(fontSize: 13, color: Colors.white38),
                ),
                onChanged: (value) {
                  setState(() {
                    _password = value.trim();
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(12, 20, 12, 5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red[400],
                        minimumSize: Size(100, 36),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)))),
                    onPressed: () async {
                      setState(() {
                        show = true;
                      });
                      try {
                        await auth
                            .createUserWithEmailAndPassword(
                                email: _email, password: _password)
                            .then((_) async {
                          User user = FirebaseAuth.instance.currentUser;
                          if (!user.emailVerified) {
                            await user.sendEmailVerification();
                            Fluttertoast.showToast(
                                msg: "Please verify your account",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        });
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');

                          Fluttertoast.showToast(
                              msg: "The password provided is too weak.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                          Fluttertoast.showToast(
                              msg: "The account already exists for that email.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          print("Incorrect email!");
                        }
                      }

                      /*
                      auth
                          .createUserWithEmailAndPassword(
                              email: _email, password: _password)
                          .then((_) async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        preferences.setString('Access', 'Yes');
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => FirstScreen()));
                      });*/
                    },
                    child: Text('SignUp',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Visibility(
                  visible: show,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 20, 12, 5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red[400],
                          minimumSize: Size(100, 36),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)))),
                      onPressed: () async {
                        auth
                            .signInWithEmailAndPassword(
                                email: _email, password: _password)
                            .then((_) async {});
                        await FirebaseAuth.instance.signOut();
                        auth
                            .signInWithEmailAndPassword(
                                email: _email, password: _password)
                            .then((_) async {
                          User user = FirebaseAuth.instance.currentUser;
                          if (user.emailVerified) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => FirstScreen()));
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            preferences.setString('Access', 'Yes');
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please verify your account.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        });
                      },
                      child: Text('Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
