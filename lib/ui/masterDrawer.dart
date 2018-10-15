import 'dart:async';

import 'package:atmonitor/colors.dart';
import 'package:atmonitor/handlers/authHandle.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MasterDrawer extends StatelessWidget {
  final authHandle = AuthHandle();
  final int drawerIndex;

  MasterDrawer(this.drawerIndex);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListTileTheme(
        selectedColor: aOrange500,
        iconColor: aBlue700,
        textColor: aBlue700,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: emailText(),
              accountName: nameText(),
            ),
            ListTile(
              title: Text("Daftar Pekerjaan"),
              leading: Icon(Icons.work),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed("/availablejobs");
              },
              selected: drawerIndex == 0,
            ),
            ListTile(
              title: Text("Pekerjaan Aktif"),
              leading: Icon(Icons.assignment),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed("/acceptedjobs");
              },
              selected: drawerIndex == 1,
            ),
            Divider(),
            ListTile(
              title: Text("Profil Pengguna"),
              leading: Icon(Icons.person),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed("/profile");
              },
              selected: drawerIndex == 2,
            ),
            Divider(),
            ListTile(
              title: Text("Keluar Aplikasi"),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                authHandle.signOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<SharedPreferences> getSp() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences;
  }

//build the text widget after getting email
  Widget emailText() {
    SharedPreferences sharedPreferences;
    return FutureBuilder(
      future: getSp(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          sharedPreferences = snapshot.data;
          return Text("${sharedPreferences.get("useremail")}");
        } else {
          return Text("");
        }
      },
    );
  }

  Widget nameText() {
    SharedPreferences sharedPreferences;
    return FutureBuilder(
      future: getSp(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          sharedPreferences = snapshot.data;
          return Text("${sharedPreferences.get("username")}");
        } else {
          return Text("");
        }
      },
    );
  }
}
