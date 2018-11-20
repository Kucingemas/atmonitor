import 'package:atmonitor/utils/atmNotification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHandle {
  FirebaseAuth auth = FirebaseAuth.instance;
  SharedPreferences sp;

  signIn(String email, String password, BuildContext context,
      GlobalKey<ScaffoldState> key) async {
    AtmNotification atmNotification = AtmNotification();
    key.currentState.showSnackBar(SnackBar(
      duration: Duration(seconds: 4),
      content: Row(
        children: <Widget>[
          SizedBox(
            child: CircularProgressIndicator(),
            width: 15.0,
            height: 15.0,
          ),
          Padding(padding: EdgeInsets.only(left: 20.0)),
          Text("Mencoba Masuk . . .")
        ],
      ),
    ));
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
        String role = snapshot.documents.first.data["role"];

        sp = await SharedPreferences.getInstance();
        sp.setString("role", role);
        sp.setString("userid", user.uid);
        sp.setString("useremail", email);
        sp.setString("username", name);
        sp.setString("userphoto", photo);
        sp.setString("userphone", phone);

        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed("/availablejobs");
        atmNotification.enableNotification();
      });
    }).catchError((e) {
      print("error: $e");
      key.currentState.showSnackBar(SnackBar(
        content: Text(
          "Nama Pengguna Atau Kata Sandi Salah!",
        ),
        duration: Duration(seconds: 2),
      ));
    });
  }

  signOut(BuildContext context) {
    this.auth.signOut();
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed("/login");
  }
}
