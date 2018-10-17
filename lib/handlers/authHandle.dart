import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHandle {
  FirebaseAuth auth = FirebaseAuth.instance;
  SharedPreferences sp;

  signIn(String email, String password, BuildContext context,
      GlobalKey<ScaffoldState> key) async {
    this
        .auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) async {
      Firestore.instance
          .collection("users")
          .where("uid", isEqualTo: user.uid.toString())
          .getDocuments()
          .then((snapshot) async {
        String name = snapshot.documents.first.data["name"];
        String email = snapshot.documents.first.data["email"];
        String phone = snapshot.documents.first.data["phone"];
        String photo = snapshot.documents.first.data["photo"];

        sp = await SharedPreferences.getInstance();
        sp.setString("userid", user.uid);
        sp.setString("useremail", email);
        sp.setString("username", name);
        sp.setString("userphoto", photo);
        sp.setString("userphone", phone);
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed("/availablejobs");
      });
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
