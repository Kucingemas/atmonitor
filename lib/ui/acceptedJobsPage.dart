import 'package:atmonitor/handlers/jobsHandle.dart';
import 'package:atmonitor/ui/masterDrawer.dart';
import 'package:atmonitor/ui/onGoingJobDetailsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AcceptedJobsPage extends StatefulWidget {
  @override
  _AcceptedJobsPageState createState() => _AcceptedJobsPageState();
}

class _AcceptedJobsPageState extends State<AcceptedJobsPage> {
  JobsHandle jobsHandle = JobsHandle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pekerjaan Aktif"),
        centerTitle: true,
      ),
      drawer: MasterDrawer(1),
      body: StreamBuilder(
          stream: jobsHandle.getAcceptedJobs(),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OnGoingJobDetailsPage(
                                        jobs,
                                        position,
                                      )));
                        },
                        onLongPress: () {},
                      ),
                    ),
                  );
                });
          }),
    );
  }

  //on press, show...
  pressDetailShow() {}

  //on long press show...
  longPressDetailShow() {}
}
