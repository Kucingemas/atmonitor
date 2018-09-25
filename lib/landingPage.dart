import 'package:atmonitor/ui/availableJobsPage.dart';
import 'package:atmonitor/ui/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget getLandingPage() {
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
