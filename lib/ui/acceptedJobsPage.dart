import 'package:atmonitor/jobsHandle.dart';
import 'package:atmonitor/ui/masterDrawer.dart';
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
      drawer: MasterDrawer(),
      body: StreamBuilder(
          stream: jobsHandle.getAcceptedJobs(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Center();
            List<DocumentSnapshot> jobs = snapshot.data.documents;
            return ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (BuildContext context, int position) {
                  String title = jobs[position].data["location"].toString();
                  String detail = jobs[position].data["problemDesc"].toString();
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("$title"),
                        subtitle: Text("$detail"),
                        trailing: Icon(Icons.chevron_right),
                        onLongPress: () {},
                      ),
                      Divider(
                        height: 5.5,
                      ),
                    ],
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
