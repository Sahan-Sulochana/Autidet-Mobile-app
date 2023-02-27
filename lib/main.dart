//import 'package:firebase_core/firebase_core.dart';
//import 'dart:html';

import 'package:Autidet/firstScreen.dart';
import 'package:Autidet/Authentication/passwordReset.dart';
import 'package:Autidet/Authentication/signIn.dart';
import 'package:Autidet/Authentication/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var accesscondition = preferences.getString('Access');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: accesscondition == null ? Login() : FirstScreen(),
    theme: new ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 4, 20, 64)),
  ));
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool access = false;
  final auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(12, 75, 12, 8),
              child: Image(
                  image: AssetImage("assets/images/logo.png"), height: 200),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 8, 20, 8),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
                controller: emailController,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  labelText: 'Username',
                  labelStyle: TextStyle(fontSize: 16, color: Colors.white),
                  hintText: 'E-mail',
                  hintStyle: TextStyle(fontSize: 13, color: Colors.white38),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 5, 20, 5),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
                obscureText: true,
                controller: passController,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(fontSize: 16, color: Colors.white),
                  hintText: 'password',
                  hintStyle: TextStyle(fontSize: 13, color: Colors.white38),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.red[400],
                  minimumSize: Size(100, 36),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)))),
              onPressed: () async {
                auth
                    .signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passController.text)
                    .then((_) async {
                  access = true;
                  //Shared preferences
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  preferences.setString('Access', 'Yes');
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => FirstScreen()));
                });
                await new Future.delayed(const Duration(milliseconds: 1200));
                if (access == false) {
                  Fluttertoast.showToast(
                      msg: "Incorrect Username or Password.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
              child: Text('Login',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgetScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Forget Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: _emailSignInButton()),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 5, 8, 50),
              child: _signInButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _signInButton() {
    // ignore: deprecated_member_use
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().then((result) async {
          access = true;
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString('Access', 'Yes');
          if (result != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return FirstScreen();
                },
              ),
            );
          }
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/images/google.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _emailSignInButton() {
    // ignore: deprecated_member_use
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return LoginScreen();
            },
          ),
        );
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/images/mail.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with E-mail',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
