import 'dart:async';
import 'dart:io';

import 'package:atmonitor/handlers/jobsHandle.dart';
import 'package:atmonitor/ui/jobHistoryPage.dart';
import 'package:atmonitor/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String id = "";
  String role = "";
  static var httpClient = new HttpClient();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUid();
  }

  @override
  Widget build(BuildContext context) {
    JobsHandle jobsHandle = JobsHandle();
    String location = widget.jobs[widget.position].data["location"].toString();
    String problem =
        widget.jobs[widget.position].data["problemDesc"].toString();
    String aptra = widget.jobs[widget.position].data["ticketNum"].toString();
    String serial = widget.jobs[widget.position].data["serialNum"].toString();
    String vendorId = widget.jobs[widget.position].data["vendorId"].toString();
    String vendorName =
        widget.jobs[widget.position].data["vendorName"].toString();
    String status = widget.jobs[widget.position].data["status"].toString();
    String time = DateFormat("d-MM-yyyy hh:mm")
        .format(widget.jobs[widget.position].data["startDatetime"])
        .toString();
    String wsid = widget.jobs[widget.position].data["wsid"].toString();
    String problemCode =
        widget.jobs[widget.position].data["problemCode"].toString();
    String triedSolution =
        widget.jobs[widget.position].data["triedSolution"].toString();
    String triedImage =
        widget.jobs[widget.position].data["triedImage"].toString();
    String needHelpTime =
        widget.jobs[widget.position].data["needHelpTime"].toString();
    String needHelpReason =
        widget.jobs[widget.position].data["needHelpReason"].toString();

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
                  title: Text("Aptra ID"),
                  subtitle: Text("$aptra"),
                ),
                Divider(),
                ListTile(
                  title: Text("WSID"),
                  subtitle: Text("$wsid"),
                ),
                Divider(),
                ListTile(
                  title: Text("Lokasi"),
                  subtitle: Text("$location"),
                ),
                Divider(),
                ListTile(
                  title: Text("Serial Number"),
                  subtitle: Text("$serial"),
                ),
                Divider(),
                ListTile(
                  title: Text("Vendor"),
                  subtitle: Text("$vendorId - $vendorName"),
                ),
                Divider(),
                ListTile(
                  title: Text("Waktu Mulai"),
                  subtitle: Text("$time"),
                ),
                Divider(),
                ListTile(
                  title: Text("Deskripsi Masalah"),
                  subtitle: Text("$problem"),
                ),
                //HELPER START
                needHelpTime == "null"
                    ? Column()
                    : Column(
                        children: <Widget>[
                          Divider(),
                          ListTile(
                            title: Text("Kode Masalah"),
                            subtitle: Text("$problemCode"),
                          ),
                          Divider(),
                          ListTile(
                            title: Text("Masalah Yang Dihadapi"),
                            subtitle: Text("$needHelpReason"),
                          ),
                          Divider(),
                          ListTile(
                            title: Text("Solusi Yang Dicoba"),
                            subtitle: Text("$triedSolution"),
                          ),
                          Divider(),
                          ListTile(
                              title: Text("Tautan Gambar"),
                              subtitle: Text("klik untuk melihat"),
                              onTap: () {
                                openImage(triedImage);
                              }),
                        ],
                      ),
                //HELPER END
                Divider(),
                ListTile(
                  title: Text("Status"),
                  subtitle: Text("$status"),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Konfirmasi Penerimaan Pekerjaan"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              "BATAL",
                              style: TextStyle(color: aBlue800),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          RaisedButton(
                            color: aOrange500,
                            child: Text(
                              "TERIMA",
                              style: TextStyle(color: aBlue800),
                            ),
                            onPressed: () {
                              role == "Teknisi PKT"
                                  ? jobsHandle.acceptJob(
                                      widget.jobs, widget.position)
                                  : jobsHandle.acceptJobVendor(
                                      widget.jobs, widget.position);
                              Navigator.pop(context);
                              Navigator.of(context)
                                  .pushReplacementNamed("/acceptedjobs");
                            },
                          )
                        ],
                      );
                    });
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
            Padding(
              padding: EdgeInsets.all(7.0),
            ),
            FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Konfirmasi Penolakan Pekerjaan"),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "BATAL",
                              style: TextStyle(color: aBlue800),
                            ),
                          ),
                          RaisedButton(
                            color: aOrange500,
                            child: Text(
                              "TOLAK",
                              style: TextStyle(color: aBlue800),
                            ),
                            onPressed: () {
                              role == "Teknisi PKT"
                                  ? jobsHandle.declineJob(
                                      widget.jobs, widget.position)
                                  : jobsHandle.declineJobVendor(
                                      widget.jobs, widget.position);
                              Navigator.pop(context);
                              Navigator.of(context)
                                  .pushReplacementNamed("/availablejobs");
                            },
                          )
                        ],
                      );
                    });
              },
              label: Text(
                "Tolak",
                style: TextStyle(color: aBlue800),
              ),
              icon: Icon(
                Icons.assignment_late,
                color: aBlue800,
              ),
            ),
          ],
        ));
  }

  Future getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString("userid");
      role = prefs.get("role");
    });
  }

  openImage(String url) async {
    await canLaunch(url) ? launch(url) : print("error");
  }
}
