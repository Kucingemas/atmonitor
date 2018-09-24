import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobsHandle {
  Firestore db = Firestore.instance;

  //build list for available jobs
  Widget jobListBuilder(String status) {
    return StreamBuilder(
      stream: db
          .collection("jobs")
          .where("status", isEqualTo: "$status")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    onLongPress: () {
                      status == "NOT ACCEPTED"
                          ? detailShow(context, title, detail, jobs, position)
                          : null;
                    },
                  ),
                  Divider(
                    height: 5.5,
                  ),
                ],
              );
            });
      },
    );
  }

  //accept job
  updateStatus(List<DocumentSnapshot> jobs, int position) {
    db.runTransaction((Transaction transaction) async {
      DocumentSnapshot documentSnapshot =
          await transaction.get(jobs[position].reference);
      await transaction
          .update(documentSnapshot.reference, {"status": "ACCEPTED"});
    });
  }

  //long press detail show
  detailShow(BuildContext context, String location, String problem,
      List<DocumentSnapshot> jobs, int position) {
    var alert = AlertDialog(
      title: Text(location),
      content: Text(problem),
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
                  updateStatus(jobs, position);
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacementNamed("/activejob");
                },
                child: Text("ACCEPT"))
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        )
      ],
    );
    showDialog(context: context, builder: (context) => alert);
  }
}
