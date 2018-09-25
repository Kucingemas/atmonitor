import 'package:atmonitor/ui/acceptedJobsPage.dart';
import 'package:atmonitor/ui/availableJobsPage.dart';
import 'package:atmonitor/ui/historyAtmPage.dart';
import 'package:atmonitor/ui/loginPage.dart';
import 'package:atmonitor/ui/profilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
    title: "ATMonitor",
    home: _getLandingPage(),
    routes: <String, WidgetBuilder>{
      "/availablejobs": (BuildContext context) => AvailableJobsPage(),
      "/historyatm": (BuildContext context) => HistoryAtmPage(),
      "/login": (BuildContext context) => LoginPage(),
      "/acceptedjobs": (BuildContext context) => AcceptedJobsPage(),
      "/profile": (BuildContext context) => ProfilePage(),
      //"/details": (BuildContext context) => JobDetailsPage("","")
    },
  ));
}

//check user if user has logged-in
Widget _getLandingPage() {
  return StreamBuilder<FirebaseUser>(
    stream: FirebaseAuth.instance.onAuthStateChanged,
    builder: (BuildContext context, snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data.providerData.length == 1) {
          return snapshot.data.isEmailVerified
              ? AvailableJobsPage()
              : LoginPage();
        } else {
          return AvailableJobsPage();
        }
      } else {
        return LoginPage();
      }
    },
  );
}
