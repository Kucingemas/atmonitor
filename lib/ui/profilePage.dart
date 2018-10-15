import 'dart:async';

import 'package:atmonitor/colors.dart';
import 'package:atmonitor/ui/masterDrawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> formKeyNama = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyEmail = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyHandphone = GlobalKey<FormState>();
  bool canEdit = false;
  String nama = "";
  String email = "";
  String handPhone = "";

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
            Center(
              child: CircleAvatar(
                radius: 70.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
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
                Text(" Nomor Handphone: "),
              ],
            ),
            phoneListTile(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            canEdit == false ? canEdit = true : canEdit = false;
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

  Future<SharedPreferences> getSp() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences;
  }

  Widget nameListTile() {
    return FutureBuilder(
        future: getSp(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return Center();
          SharedPreferences sharedPreference = snapshot.data;
          return ListTile(
            title: Form(
                key: formKeyNama,
                child: TextFormField(
                  enabled: canEdit == false ? false : true,
                  onSaved: (value) {
                    nama = value;
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
      future: getSp(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return Center();
        SharedPreferences sharedPreference = snapshot.data;
        return ListTile(
          title: Form(
              key: formKeyEmail,
              child: TextFormField(
                enabled: canEdit == false ? false : true,
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
      future: getSp(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return Center();
        SharedPreferences sharedPreference = snapshot.data;
        return ListTile(
          title: Form(
              key: formKeyHandphone,
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
}
