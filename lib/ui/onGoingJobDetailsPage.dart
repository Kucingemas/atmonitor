import 'package:atmonitor/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OnGoingJobDetailsPage extends StatefulWidget {
  final List<DocumentSnapshot> jobs;
  final int position;

  OnGoingJobDetailsPage(this.jobs, this.position);

  @override
  onGoingJobDetailsPageState createState() {
    return new onGoingJobDetailsPageState();
  }
}

class onGoingJobDetailsPageState extends State<OnGoingJobDetailsPage> {
  @override
  Widget build(BuildContext context) {
    String location = widget.jobs[widget.position].data["location"].toString();
    String problem =
        widget.jobs[widget.position].data["problemDesc"].toString();
    String aptra = widget.jobs[widget.position].data["aptraTicket"].toString();
    String serial = widget.jobs[widget.position].data["serialNum"].toString();
    String status = widget.jobs[widget.position].data["status"].toString();
    String time = widget.jobs[widget.position].data["time"].toString();
    String wsid = widget.jobs[widget.position].data["wsid"].toString();

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
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {},
              icon: Icon(
                Icons.assignment_turned_in,
                color: aBlue800,
              ),
              label: Text(
                "Selesai",
                style: TextStyle(color: aBlue800),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(7.0),
            ),
            FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {},
              icon: Icon(
                Icons.person,
                color: aBlue800,
              ),
              label: Text(
                "Bantuan",
                style: TextStyle(color: aBlue800),
              ),
            ),
          ],
        ));
  }
}
