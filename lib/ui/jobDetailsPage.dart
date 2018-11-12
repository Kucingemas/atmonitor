import 'package:atmonitor/handlers/jobsHandle.dart';
import 'package:atmonitor/ui/jobHistoryPage.dart';
import 'package:atmonitor/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JobDetailsPage extends StatefulWidget {
  final List<DocumentSnapshot> jobs;
  final int position;

  JobDetailsPage(this.jobs, this.position);

  @override
  JobDetailsPageState createState() {
    return new JobDetailsPageState();
  }
}

class JobDetailsPageState extends State<JobDetailsPage> {
  @override
  Widget build(BuildContext context) {
    JobsHandle jobsHandle = JobsHandle();
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
                jobsHandle.acceptJob(widget.jobs, widget.position);
                Navigator.pop(context);
                Navigator.of(context).pushReplacementNamed("/acceptedjobs");
              },
              label: Text(
                "Terima",
                style: TextStyle(color: aBlue800),
              ),
              icon: Icon(
                Icons.assignment_return,
                color: aBlue800,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(7.0),
            ),
            FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {
                jobsHandle.declineJob(widget.jobs, widget.position);
                Navigator.pop(context);
                Navigator.of(context).pushReplacementNamed("/availablejobs");
              },
              label: Text(
                "Tolak",
                style: TextStyle(color: aBlue800),
              ),
              icon: Icon(
                Icons.assignment_late,
                color: aBlue800,
              ),
            ),
          ],
        ));
  }
}
