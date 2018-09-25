import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHandle {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences sharedPreferences;

  signIn(String email, String password, BuildContext context) async {
    this
        ._auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) async {
      //settingemail to shared preferences to pass into other screens
      sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString("useremail", user.email);
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed("/availablejobs");
    }).catchError((e) {
      print("error: $e");
    });
  }

  signOut(BuildContext context) {
    this._auth.signOut();
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed("/login");
  }
}
