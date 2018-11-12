import 'dart:async';

import 'package:atmonitor/handlers/jobsHandle.dart';
import 'package:atmonitor/ui/jobDetailsPage.dart';
import 'package:atmonitor/ui/masterDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvailableJobsPage extends StatefulWidget {
  @override
  _AvailableJobsPage createState() => _AvailableJobsPage();
}

class _AvailableJobsPage extends State<AvailableJobsPage> {
  JobsHandle jobsHandle = JobsHandle();
  String id = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Pekerjaan"),
        centerTitle: true,
      ),
      drawer: MasterDrawer(0),
      body: StreamBuilder(
          stream: jobsHandle.getAvailableJobs(id),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Center();
            List<DocumentSnapshot> jobs = snapshot.data.documents;
            return ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (BuildContext context, int position) {
                  String location = jobs[position].data["location"].toString();
                  String problem =
                      jobs[position].data["problemDesc"].toString();
                  return Card(
                    child: Container(
                      child: ListTile(
                        title: Text("$location"),
                        subtitle: Text("$problem"),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          pressDetailShow(jobs, position);
                        },
                        onLongPress: () {
                          longPressDetailShow(
                              context, location, problem, jobs, position);
                        },
                      ),
                    ),
                  );
                });
          }),
    );
  }

  //on press, go to detail page
  pressDetailShow(List<DocumentSnapshot> jobs, int position) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => JobDetailsPage(
                  jobs,
                  position,
                )));
  }

  //on long press, then show details
  longPressDetailShow(BuildContext context, String location, String problem,
      List<DocumentSnapshot> jobs, int position) {
    var alert = AlertDialog(
      title: Text(location),
      content: Text(problem),
      actions: <Widget>[
        Row(
          children: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("TUTUP"),
            ),
            FlatButton(
              onPressed: () {
                jobsHandle.acceptJob(jobs, position);
                Navigator.pop(context);
                Navigator.of(context).pushReplacementNamed("/acceptedjobs");
              },
              child: Text("TERIMA"),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        )
      ],
    );
    showDialog(context: context, builder: (context) => alert);
  }

  //get user id
  Future<Null> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString("userid");
    });
  }
}
