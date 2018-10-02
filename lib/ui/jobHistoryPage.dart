import 'package:atmonitor/handlers/historyHandle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobHistoryPage extends StatefulWidget {
  final List<DocumentSnapshot> jobs;
  final int position;

  JobHistoryPage(this.jobs, this.position);

  @override
  _JobHistoryPageState createState() => _JobHistoryPageState();
}

class _JobHistoryPageState extends State<JobHistoryPage> {
  @override
  Widget build(BuildContext context) {
    HistoryHandle historyHandle = HistoryHandle(widget.jobs, widget.position);
    return Scaffold(
        appBar: AppBar(
          title: Text("Data Historik"),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: historyHandle.getFixHistory(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Center();
            List<DocumentSnapshot> jobs = snapshot.data.documents;
            return ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (BuildContext context, int position) {
                  String date = jobs[position].data["time"].toString();
                  String problem =
                      jobs[position].data["problemDesc"].toString();
                  String solution = jobs[position].data["solution"].toString();
                  String aptra = jobs[position].data["aptraTicket"].toString();
                  return ExpansionTile(
                    initiallyExpanded: true,
                    title: Text("$date"),
                    trailing: Icon(Icons.keyboard_arrow_down),
                    children: <Widget>[
                      ListTile(
                        title: Text("Detil Masalah"),
                        subtitle: Text("$problem"),
                      ),
                      Divider(),
                      ListTile(
                        title: Text("Solusi"),
                        subtitle: Text("$solution"),
                      ),
                      Divider(),
                      ListTile(
                        title: Text("APTRA ID"),
                        subtitle: Text("$aptra"),
                      ),
                    ],
                  );
                });
          },
        ));
  }
}
