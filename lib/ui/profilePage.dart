import 'dart:io';

import 'package:atmonitor/utils/colors.dart';
import 'package:atmonitor/handlers/profileHandle.dart';
import 'package:atmonitor/ui/masterDrawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> formKeyName = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyEmail = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyHandPhone = GlobalKey<FormState>();
  ProfileHandle profileHandle = ProfileHandle();
  bool canEdit = false;
  String name = "";
  String email = "";
  String handPhone = "";
  String photo = "";
  File pictureChosen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Pengguna"),
        centerTitle: true,
      ),
      drawer: MasterDrawer(2),
      body: Center(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            profilePhotoCircle(),
            Padding(
              padding: EdgeInsets.all(20.0),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                ),
                Text("Nama Lengkap: "),
              ],
            ),
            nameListTile(),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                ),
                Text("Email: "),
              ],
            ),
            emailListTile(),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                ),
                Text("Nomor Handphone: "),
              ],
            ),
            phoneListTile(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            if (canEdit == false) {
              canEdit = true;
            } else {
              formKeyName.currentState.save();
              formKeyHandPhone.currentState.save();
              profileHandle.updateProfile(name, handPhone);
              canEdit = false;
            }
          });
        },
        icon: canEdit == false
            ? Icon(
                Icons.edit,
                color: aBlue800,
              )
            : Icon(
                Icons.check,
                color: aBlue800,
              ),
        label: canEdit == false
            ? Text(
                "Edit",
                style: TextStyle(color: aBlue800),
              )
            : Text(
                "Simpan",
                style: TextStyle(color: aBlue800),
              ),
      ),
    );
  }

  Widget profilePhotoCircle() {
    return FutureBuilder(
      future: profileHandle.getSp(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return Center();
        SharedPreferences sharedPreferences = snapshot.data;
        return Center(
          child: CircleAvatar(
            child: InkWell(
              onTap: () {
                choosePicture(context, ImageSource.gallery);
              },
            ),
            backgroundColor: aOrange500,
            backgroundImage: sharedPreferences.getString("userphoto") == "" ||
                    sharedPreferences.getString("userphoto") == null
                ? CachedNetworkImageProvider(
                    "https://i.pinimg.com/originals/f5/7e/00/f57e00306f3183cc39fa919fec41418b.jpg")
                : CachedNetworkImageProvider(
                    sharedPreferences.getString("userphoto")),
            radius: 70.0,
          ),
        );
      },
    );
  }

  Widget nameListTile() {
    return FutureBuilder(
        future: profileHandle.getSp(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return Center();
          SharedPreferences sharedPreference = snapshot.data;
          return ListTile(
            title: Form(
                key: formKeyName,
                child: TextFormField(
                  enabled: canEdit == false ? false : true,
                  onSaved: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  initialValue: sharedPreference.getString("username"),
                  validator: (value) => value.isEmpty || value == ""
                      ? "nama tidak boleh kosong"
                      : null,
                )),
          );
        });
  }

  Widget emailListTile() {
    return FutureBuilder(
      future: profileHandle.getSp(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return Center();
        SharedPreferences sharedPreference = snapshot.data;
        return ListTile(
          title: Form(
              key: formKeyEmail,
              child: TextFormField(
                enabled: false,
                onSaved: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                initialValue: sharedPreference.getString("useremail"),
                validator: (value) => value.isEmpty || value == ""
                    ? "email tidak boleh kosong"
                    : null,
              )),
        );
      },
    );
  }

  Widget phoneListTile() {
    return FutureBuilder(
      future: profileHandle.getSp(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return Center();
        SharedPreferences sharedPreference = snapshot.data;
        return ListTile(
          title: Form(
              key: formKeyHandPhone,
              child: TextFormField(
                enabled: canEdit == false ? false : true,
                onSaved: (value) {
                  handPhone = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                initialValue: sharedPreference.getString("userphone"),
                validator: (value) => value.isEmpty || value == ""
                    ? "no. handphone tidak boleh kosong"
                    : null,
              )),
        );
      },
    );
  }

  void choosePicture(BuildContext context, ImageSource imageSource) {
    ImagePicker.pickImage(source: imageSource).then((File image) {
      setState(() {
        profileHandle.updatePicture(image);
      });
    });
  }
}
