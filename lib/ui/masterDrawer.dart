import 'dart:async';

import 'package:atmonitor/authHandle.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MasterDrawer extends StatelessWidget {
  final authHandle = AuthHandle();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: emailText(),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person),
            ),
            accountName: Text(""),
          ),
          ListTile(
            title: Text("Daftar Pekerjaan"),
            trailing: Icon(Icons.work),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/availablejobs");
            },
          ),
          ListTile(
            title: Text("Pekerjaan Aktif"),
            trailing: Icon(Icons.book),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/acceptedjobs");
            },
          ),
          ListTile(
            title: Text("Data Historik Atm"),
            trailing: Icon(Icons.history),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/historyatm");
            },
          ),
          Divider(),
          ListTile(
            title: Text("Keluar Aplikasi"),
            trailing: Icon(Icons.donut_large),
            onTap: () {
              authHandle.signOut(context);
            },
          ),
        ],
      ),
    );
  }
}

//get email from login
Future<SharedPreferences> getEmail() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences;
}

//build the text widget after getting email
Widget emailText() {
  SharedPreferences sharedPreferences;
  return FutureBuilder(
    future: getEmail(),
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
