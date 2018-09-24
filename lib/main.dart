import 'package:atmonitor/ui/activeJobPage.dart';
import 'package:atmonitor/ui/historyAtmPage.dart';
import 'package:atmonitor/ui/jobListPage.dart';
import 'package:atmonitor/ui/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "ATMonitor",
    home: _getLandingPage(),
    routes: <String, WidgetBuilder>{
      "/joblist": (BuildContext context) => JobListPage(),
      "/historyatm": (BuildContext context) => HistoryAtmPage(),
      "/login": (BuildContext context) => LoginPage(),
      "/activejob": (BuildContext context) => ActiveJobPage()
    },
  ));
}

Widget _getLandingPage() {
  return StreamBuilder<FirebaseUser>(
    stream: FirebaseAuth.instance.onAuthStateChanged,
    builder: (BuildContext context, snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data.providerData.length == 1) {
          return snapshot.data.isEmailVerified ? JobListPage() : LoginPage();
        } else {
          return JobListPage();
        }
      } else {
        return LoginPage();
      }
    },
  );
}
