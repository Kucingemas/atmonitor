import 'package:atmonitor/utils/colors.dart';
import 'package:atmonitor/ui/jobDoneConfirmationPage.dart';
import 'package:atmonitor/ui/jobHistoryPage.dart';
import 'package:atmonitor/ui/needHelpPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  @override
  Widget build(BuildContext context) {
    String location = widget.jobs[widget.position].data["location"].toString();
    String problem =
        widget.jobs[widget.position].data["problemDesc"].toString();
    String aptra = widget.jobs[widget.position].data["aptraTicket"].toString();
    String serial = widget.jobs[widget.position].data["serialNum"].toString();
    String status = widget.jobs[widget.position].data["status"].toString();
    String time = DateFormat("dd-MM-yyyy hh:mm")
        .format(widget.jobs[widget.position].data["time"])
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
                  title: Text("Lokasi"),
                  subtitle: Text("$location"),
                ),
                Divider(),
                ListTile(
                  title: Text("Detil Masalah"),
                  subtitle: Text("$problem"),
                ),
                Divider(),
                ListTile(
                  title: Text("Waktu"),
                  subtitle: Text("$time"),
                ),
                Divider(),
                ListTile(
                  title: Text("APTRA ID"),
                  subtitle: Text("$aptra"),
                ),
                Divider(),
                ListTile(
                  title: Text("Serial Number"),
                  subtitle: Text("$serial"),
                ),
                Divider(),
                ListTile(
                  title: Text("WSID"),
                  subtitle: Text("$wsid"),
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
            FloatingActionButton.extended(
              heroTag: null,
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
              label: Text(
                "Bantuan",
                style: TextStyle(color: aBlue800),
              ),
            ),
          ],
        ));
  }
}
