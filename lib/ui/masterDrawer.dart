import 'package:atmonitor/utils/colors.dart';
import 'package:atmonitor/handlers/authHandle.dart';
import 'package:atmonitor/handlers/profileHandle.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MasterDrawer extends StatelessWidget {
  final authHandle = AuthHandle();
  final int drawerIndex;
  final ProfileHandle profileHandle = ProfileHandle();

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
              currentAccountPicture: profilePhotoCircle(),
              accountEmail: phoneText(),
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

  Widget profilePhotoCircle() {
    SharedPreferences sharedPreferences;
    return FutureBuilder(
      future: profileHandle.getSp(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          sharedPreferences = snapshot.data;
          return CircleAvatar(
            backgroundColor: aOrange500,
            backgroundImage: sharedPreferences.getString("userphoto") == "" ||
                    sharedPreferences.getString("userphoto") == null
                ? CachedNetworkImageProvider(
                    "https://i.pinimg.com/originals/f5/7e/00/f57e00306f3183cc39fa919fec41418b.jpg")
                : CachedNetworkImageProvider(
                    sharedPreferences.getString("userphoto")),
          );
        } else
          return Center();
      },
    );
  }

//build the text widget after getting email
  Widget phoneText() {
    SharedPreferences sharedPreferences;
    return FutureBuilder(
      future: profileHandle.getSp(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          sharedPreferences = snapshot.data;
          return Text("${sharedPreferences.get("userphone")}");
        } else {
          return Text("");
        }
      },
    );
  }

  Widget nameText() {
    SharedPreferences sharedPreferences;
    return FutureBuilder(
      future: profileHandle.getSp(),
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
