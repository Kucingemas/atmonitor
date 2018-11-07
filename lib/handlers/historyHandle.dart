import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryHandle {
  final List<DocumentSnapshot> jobs;
  final int position;

  HistoryHandle([this.jobs, this.position]);

  getFixHistory() {
    Future<QuerySnapshot> getJobs = Firestore.instance
        .collection("jobs")
        .where("status", isEqualTo: "FINISHED")
        .where("location",
            isEqualTo: jobs[position].data["location"].toString())
        .where("time",
            isGreaterThanOrEqualTo: DateTime.now().add(Duration(days: -90)))
        .getDocuments()
        .catchError((error) => print("$error"));

    return getJobs;
  }

  getPersonalHistory() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print("user id yang masuk: ${sharedPreferences.getString("userid")}");
    Future<QuerySnapshot> getJobs = Firestore.instance
        .collection("jobs")
        .where("assignedTo", isEqualTo: sharedPreferences.getString("userid"))
        .where("status", isEqualTo: "FINISHED")
        .where("finishTime",
            isGreaterThanOrEqualTo: DateTime.now().add(Duration(days: -7)))
        .getDocuments()
        .catchError((error) => print("$error"));

    return getJobs;
  }
}
