import 'dart:async';

import 'package:atmonitor/handlers/jobsHandle.dart';
import 'package:atmonitor/ui/masterDrawer.dart';
import 'package:atmonitor/ui/onGoingJobDetailsPage.dart';
import 'package:atmonitor/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcceptedJobsPage extends StatefulWidget {
  @override
  _AcceptedJobsPageState createState() => _AcceptedJobsPageState();
}

class _AcceptedJobsPageState extends State<AcceptedJobsPage> {
  JobsHandle jobsHandle = JobsHandle();
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Pekerjaan Aktif"),
        centerTitle: true,
      ),
      drawer: MasterDrawer(1),
      body: StreamBuilder(
          stream: role == "Teknisi PKT"
              ? jobsHandle.getAcceptedJobs(id)
              : jobsHandle.getAcceptedJobsVendor(id),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            List<DocumentSnapshot> jobs = snapshot.data.documents;
            if (jobs.length == 0)
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.tag_faces, color: aBlue700,),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Text(
                      "tidak ada pekerjaan yang tersedia saat ini",
                      style: TextStyle(color: aBlue700),
                    ),
                  ],
                ),
              );
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
            builder: (context) => OnGoingJobDetailsPage(
                  jobs,
                  position,
                )));
  }

  //get user id
  Future getSp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString("userid");
      role = prefs.getString("role");
    });
  }
}
