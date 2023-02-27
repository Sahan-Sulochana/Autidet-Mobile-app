import 'package:Autidet/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgetScreen extends StatefulWidget {
  @override
  _ForgetScreenState createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  String _email;
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
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  labelText: 'Email',
                  labelStyle: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 20, 12, 5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.red[400],
                    minimumSize: Size(100, 36),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)))),
                onPressed: () async {
                  auth.sendPasswordResetEmail(email: _email);
                  Fluttertoast.showToast(
                      msg: "Your request has been sent to your e-mail",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);

                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text('Submit',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
