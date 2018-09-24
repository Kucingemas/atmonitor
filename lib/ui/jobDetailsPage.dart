import 'package:flutter/material.dart';

class JobDetailsPage extends StatelessWidget {
  String location;
  String problem;
  String aptra;
  String serial;
  String time;
  String status;
  String wsid;

  JobDetailsPage(this.location, this.problem, this.aptra, this.serial,
      this.time, this.status, this.wsid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detil Pekerjaan"),
        centerTitle: true,
      ),
    );
  }
}
