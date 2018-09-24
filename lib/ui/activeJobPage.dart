import 'package:atmonitor/ui/masterDrawer.dart';
import 'package:flutter/material.dart';
import 'package:atmonitor/jobsHandle.dart';

class ActiveJobPage extends StatefulWidget {
  @override
  _ActiveJobPageState createState() => _ActiveJobPageState();
}

class _ActiveJobPageState extends State<ActiveJobPage> {
  JobsHandle jobsHandle = JobsHandle();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pekerjaan Aktif"),
        centerTitle: true,
      ),
      drawer: MasterDrawer(),
      body: jobsHandle.jobListBuilder("ACCEPTED"),
    );
  }
}
