import 'dart:async';
import 'dart:convert';

import 'package:atmonitor/ui/masterDrawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class JobListPage extends StatefulWidget {
  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Daftar Pekerjaan"),
          centerTitle: true,
          actions: <Widget>[],
        ),
        drawer: MasterDrawer(),
        body: RefreshIndicator(child: jobListBuilder(), onRefresh: getJobList)
        );
  }
}

//getting data from api
Future<List> getJobList() async {
  String url = "https://jsonplaceholder.typicode.com/posts";
  http.Response response = await http.get(url);
  print(json.decode(response.body));
  return json.decode(response.body);
}

//building the job list after getting data
Widget jobListBuilder() {
  return FutureBuilder(
    future: getJobList(),
    builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
      print(snapshot.data);
      if (snapshot.hasData) {
        print("hello your snapshot has data");
        List _jobs = snapshot.data;
        return ListView.builder(
            itemCount: _jobs.length,
            itemBuilder: (BuildContext context, int position) {
              String jobTitle = _jobs[position]["title"].toString();
              String jobDetail = _jobs[position]["body"].toString();
              String jobId = _jobs[position]["id"].toString();
              return Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                  ),
                  ListTile(
                    onTap: () => jobPopUp(context, jobTitle, jobDetail),
                    title: Text("$jobTitle"),
                    subtitle: Text("$jobDetail"),
                    leading: CircleAvatar(
                      child: Text("$jobId"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  Divider(
                    height: 5.5,
                  ),
                ],
              );
            });
      } else {
        return Container();
      }
    },
  );
}

//show job details
jobPopUp(BuildContext context, String title, String detail) {
  var alert = AlertDialog(
    title: Text(title),
    content: Text(detail),
    actions: <Widget>[
      Row(
        children: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("CLOSE")),
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("ACCEPT"))
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      )
    ],
  );
  showDialog(context: context, builder: (context) => alert);
}
