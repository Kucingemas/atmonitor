import 'package:atmonitor/ui/acceptedJobsPage.dart';
import 'package:atmonitor/ui/availableJobsPage.dart';
import 'package:atmonitor/ui/loginPage.dart';
import 'package:atmonitor/ui/profilePage.dart';
import 'package:atmonitor/atmnotification.dart';
import 'package:flutter/material.dart';


import 'landingPage.dart';
import 'theme.dart';

main() {
  AtmNotification atmNotification = AtmNotification();
  atmNotification.enableNotification();
  runApp(MaterialApp(
    theme: buildAtmTheme(),
    debugShowCheckedModeBanner: false,
    title: "ATMonitor",
    home: getLandingPage(),
    routes: <String, WidgetBuilder>{
      "/availablejobs": (BuildContext context) => AvailableJobsPage(),
      "/login": (BuildContext context) => LoginPage(),
      "/acceptedjobs": (BuildContext context) => AcceptedJobsPage(),
      "/profile": (BuildContext context) => ProfilePage(),
    },
  ));
}
