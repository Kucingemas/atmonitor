import 'dart:async';

import 'package:atmonitor/ui/jobDoneConfirmationPage.dart';
import 'package:atmonitor/ui/jobHistoryPage.dart';
import 'package:atmonitor/ui/needHelpPage.dart';
import 'package:atmonitor/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnGoingJobDetailsPage extends StatefulWidget {
  final List<DocumentSnapshot> jobs;
  final int position;

  OnGoingJobDetailsPage(this.jobs, this.position);

  @override
  OnGoingJobDetailsPageState createState() {
    return new OnGoingJobDetailsPageState();
  }
}

class OnGoingJobDetailsPageState extends State<OnGoingJobDetailsPage> {
  String id = "";
  String role = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSp();
  }

  @override
  Widget build(BuildContext context) {
//    String hAssignedTo =
//        widget.jobs[widget.position].data["hAssignedTo"].toString();
    DateTime needHelpTime = widget.jobs[widget.position].data["needHelpTime"];
    print("ini need help time: $needHelpTime");
    String location = widget.jobs[widget.position].data["location"].toString();
    String problem =
        widget.jobs[widget.position].data["problemDesc"].toString();
    String aptra = widget.jobs[widget.position].data["ticketNum"].toString();
    String serial = widget.jobs[widget.position].data["serialNum"].toString();
    String vendorId = widget.jobs[widget.position].data["vendorId"].toString();
    String vendorName =
        widget.jobs[widget.position].data["vendorName"].toString();
    String status = widget.jobs[widget.position].data["status"].toString();
    String time = DateFormat("dd-MM-yyyy hh:mm")
        .format(widget.jobs[widget.position].data["startDatetime"])
        .toString();
    String wsid = widget.jobs[widget.position].data["wsid"].toString();

    return Scaffold(
        appBar: AppBar(
          title: Text("Detil Pekerjaan"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.history,
                color: aWhite,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            JobHistoryPage(widget.jobs, widget.position)));
              },
            )
          ],
        ),
        body: Card(
          child: Container(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text("Aptra ID"),
                  subtitle: Text("$aptra"),
                ),
                Divider(),
                ListTile(
                  title: Text("WSID"),
                  subtitle: Text("$wsid"),
                ),
                Divider(),
                ListTile(
                  title: Text("Lokasi"),
                  subtitle: Text("$location"),
                ),
                Divider(),
                ListTile(
                  title: Text("Serial Number"),
                  subtitle: Text("$serial"),
                ),
                Divider(),
                ListTile(
                  title: Text("Vendor"),
                  subtitle: Text("$vendorId - $vendorName"),
                ),
                Divider(),
                ListTile(
                  title: Text("Waktu Mulai"),
                  subtitle: Text("$time"),
                ),
                Divider(),
                ListTile(
                  title: Text("Deskripsi Masalah"),
                  subtitle: Text("$problem"),
                ),
                Divider(),
                ListTile(
                  title: Text("Status"),
                  subtitle: Text("$status"),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => JobDoneConfirmationPage(
                            widget.jobs, widget.position)));
              },
              icon: Icon(
                Icons.assignment_turned_in,
                color: aBlue800,
              ),
              label: Text(
                "Selesai",
                style: TextStyle(color: aBlue800),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(7.0),
            ),
            role == "Teknisi PKT" && needHelpTime == null
                ? FloatingActionButton.extended(
                    heroTag: null,
                    label: Text(
                      "Bantuan",
                      style: TextStyle(color: aBlue800),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NeedHelpPage(widget.position, widget.jobs)));
                    },
                    icon: Icon(
                      Icons.person,
                      color: aBlue800,
                    ),
                  )
                : Column(),
          ],
        ));
  }

  Future getSp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString("userid");
      role = prefs.getString("role");
    });
  }
}
