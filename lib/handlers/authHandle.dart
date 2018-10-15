import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHandle {
  UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
  final FirebaseAuth auth = FirebaseAuth.instance;
  SharedPreferences sp;

  signIn(String email, String password, BuildContext context,
      GlobalKey<ScaffoldState> key) async {
    this
        .auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) async {

      sp = await SharedPreferences.getInstance();
      sp.setString("userid", user.uid);
      sp.setString("useremail", user.email);
      sp.setString("username", user.displayName);
      sp.setString("userphoto", user.photoUrl);
      sp.setString("userphone", user.phoneNumber);
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed("/availablejobs");
    }).catchError((e) {
      print("error: $e");
      key.currentState.showSnackBar(SnackBar(
        content: Text(
          "Nama Pengguna Atau Kata Sandi Salah!",
        ),
        duration: Duration(milliseconds: 750),
      ));
    });
  }

  signOut(BuildContext context) {
    this.auth.signOut();
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed("/login");
  }
}
