import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryHandle {
  final List<DocumentSnapshot> jobs;
  final int position;

  HistoryHandle(this.jobs, this.position);

  getFixHistory() {
    Future<QuerySnapshot> getJobs = Firestore.instance
        .collection("jobs")
        .where("status", isEqualTo: "FINISHED")
        .where("location",
            isEqualTo: jobs[position].data["location"].toString())
        .where("time",
            isGreaterThanOrEqualTo: DateTime.now().add(Duration(days: -30)))
        .getDocuments()
        .catchError((error) => print("$error"));

    return getJobs;
  }
}
