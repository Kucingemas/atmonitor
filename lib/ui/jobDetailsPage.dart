import 'package:atmonitor/utils/colors.dart';
import 'package:atmonitor/handlers/jobsHandle.dart';
import 'package:atmonitor/ui/jobHistoryPage.dart';
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
      floatingActionButton: FloatingActionButton.extended(
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
    );
  }
}
