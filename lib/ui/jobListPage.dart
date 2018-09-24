import 'package:atmonitor/jobsHandle.dart';
import 'package:atmonitor/ui/masterDrawer.dart';
import 'package:flutter/material.dart';

class JobListPage extends StatefulWidget {
  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  JobsHandle jobsHandle = JobsHandle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Daftar Pekerjaan"),
          centerTitle: true,
          actions: <Widget>[],
        ),
        drawer: MasterDrawer(),
        body: jobsHandle.jobListBuilder("NOT ACCEPTED")
        //RefreshIndicator(child: jobsHandle.jobListBuilder(), onRefresh: jobsHandle.getJobList)
        //jobsHandle.jobListBuilder()
        //RefreshIndicator(child: jobListBuilder(), onRefresh: getJobList)
        );
  }
}
