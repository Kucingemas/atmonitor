import 'package:atmonitor/jobsHandle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobDetailsPage extends StatelessWidget {
  final List<DocumentSnapshot> jobs;
  final int position;

  JobDetailsPage(this.jobs, this.position);

  @override
  Widget build(BuildContext context) {
    JobsHandle jobsHandle = JobsHandle();
    String location = jobs[position].data["location"].toString();
    String problem = jobs[position].data["problemDesc"].toString();
    String aptra = jobs[position].data["aptraTicket"].toString();
    String serial = jobs[position].data["serialNum"].toString();
    String status = jobs[position].data["status"].toString();
    String time = jobs[position].data["time"].toString();
    String wsid = jobs[position].data["wsid"].toString();

    return Scaffold(
      appBar: AppBar(
        title: Text("Detil Pekerjaan"),
        centerTitle: true,
      ),
      body: Container(
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
              title: Text("Jam"),
              subtitle: Text("$time}"),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          jobsHandle.acceptJob(jobs, position);
          Navigator.pop(context);
          Navigator.of(context).pushReplacementNamed("/acceptedjobs");
        },
        child: Icon(Icons.assignment_turned_in),
      ),
    );
  }
}
