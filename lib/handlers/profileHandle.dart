import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileHandle {
  FirebaseAuth auth = FirebaseAuth.instance;
  UserUpdateInfo userUpdateInfo = UserUpdateInfo();

  Future<SharedPreferences> getSp() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences;
  }

  //update profile picture
  updatePicture(File image, BuildContext context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: <Widget>[
                Text("Mengunggah"),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                ),
                CircularProgressIndicator()
              ],
            ),
          );
        });
    //upload image and get the download url
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    StorageUploadTask storageUploadTask = FirebaseStorage.instance
        .ref()
        .child("profilePicture/" + sharedPreferences.getString("userid"))
        .putFile(image);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

    //setting up shared preferences
    sharedPreferences.setString("userphoto", downloadUrl.toString());
    print("link sp: ${sharedPreferences.getString("userphoto")}");
    Firestore.instance
        .collection("users")
        .where("uid", isEqualTo: sharedPreferences.getString("userid"))
        .getDocuments()
        .then((snapshot) {
      DocumentReference documentReference = snapshot.documents.first.reference;
      Firestore.instance.runTransaction((Transaction transaction) async {
        DocumentSnapshot documentSnapshot =
            await transaction.get(documentReference);
        await transaction.update(documentSnapshot.reference, {
          "photo": sharedPreferences.getString("userphoto"),
        });
      });
    });
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed("/profile");
  }

  //update profile information
  updateProfile(String name, String phone) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("username", name);
    sharedPreferences.setString("userphone", phone);

    Firestore.instance
        .collection("users")
        .where("uid", isEqualTo: sharedPreferences.getString("userid"))
        .getDocuments()
        .then((snapshot) {
      DocumentReference documentReference = snapshot.documents.first.reference;
      Firestore.instance.runTransaction((Transaction transaction) async {
        DocumentSnapshot documentSnapshot =
            await transaction.get(documentReference);
        await transaction.update(documentSnapshot.reference, {
          "name": sharedPreferences.getString("username"),
          "phone": sharedPreferences.getString("userphone")
        });
      });
    });
  }
}
