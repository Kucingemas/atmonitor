import 'package:atmonitor/ui/acceptedJobsPage.dart';
import 'package:atmonitor/ui/availableJobsPage.dart';
import 'package:atmonitor/ui/loginPage.dart';
import 'package:atmonitor/ui/personalHistoryPage.dart';
import 'package:atmonitor/ui/profilePage.dart';
import 'package:atmonitor/utils/landingPage.dart';
import 'package:atmonitor/utils/theme.dart';
import 'package:flutter/material.dart';

main() {
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
      "/personalhistory": (BuildContext context) => PersonalHistoryPage(),
    },
  ));
}
