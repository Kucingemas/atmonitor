import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
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
      Navigator.of(context).pushReplacementNamed("/joblist");
    }).catchError((e) {
      Flushbar()
        ..message = "nama pengguna atau kata sandi tidak cocok"
        ..icon = Icon(
          Icons.info_outline,
          color: Colors.red,
        )
        ..duration = Duration(seconds: 2)
        ..leftBarIndicatorColor = Colors.red
        ..show(context);

//      flushbar
//        ..onStatusChanged = (FlushbarStatus status) {
//          if (status == FlushbarStatus.DISMISSED) {
//            print("a");
//          } else {
//            print("b");
//          }
//        }
//        ..show(context);
    });
  }

  signOut(BuildContext context) {
    this._auth.signOut();
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed("/login");
  }
}
