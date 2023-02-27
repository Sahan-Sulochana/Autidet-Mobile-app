import 'package:Autidet/firstScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import '../lib/Homepage.dart';

//import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
//import 'package:flutter_signin_button/flutter_signin_button.dart';
class Loginin extends StatefulWidget {
  @override
  _LogininState createState() => _LogininState();
}

class _LogininState extends State<Loginin> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  SharedPreferences preferences;
  bool loading = false;
  bool isLogedIn = false;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    setState(() {
      loading = true;
    });
    preferences = await SharedPreferences.getInstance();
    isLogedIn = await googleSignIn.isSignedIn();
    if (isLogedIn) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => FirstScreen()));
    }
    setState(() {
      loading = false;
    });
  }

  Future<Null> handleSignIn() async {
    preferences = await SharedPreferences.getInstance();
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    User user = (await firebaseAuth.signInWithCredential(credential)).user;

    if (user != null) {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .get();
      List<DocumentSnapshot> documents = result.docs;
      if (documents.length == 0) {
        //insert user to collection
        FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          "id": user.uid,
          "username": user.displayName,
          "photourl": user.photoURL
        });
        await preferences.setString("id", user.uid);
        await preferences.setString("username", user.displayName);
        await preferences.setString("photourl", user.photoURL);
      } else {
        await preferences.setString("id", documents[0].data()['id']);
        await preferences.setString(
            "username", documents[0].data()['username']);
        await preferences.setString(
            "photourl", documents[0].data()['photoUrl']);
      }
      Fluttertoast.showToast(msg: "Login Was successful");
      setState(() {
        loading = false;
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FirstScreen()));
    } else {
      Fluttertoast.showToast(msg: "Login Failed");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
              // ignore: deprecated_member_use
              child: FlatButton(
            color: Colors.red,
            onPressed: () {
              handleSignIn();
            },
            child: Text(
              "sigin",
              style: TextStyle(color: Colors.white),
            ),
          )),
          Visibility(
              visible: loading ?? true,
              child: Center(
                  child: Container(
                alignment: Alignment.center,
                color: Colors.white.withOpacity(0.8),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              )))
        ],
      ),
    );
  }
}
