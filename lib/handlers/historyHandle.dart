import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryHandle {
  final List<DocumentSnapshot> jobs;
  final int position;

  HistoryHandle([this.jobs, this.position]);

  //TODO: status or vStatus? STATUS
  getMachineHistory() {
    print("ini loh yang masuk: ${jobs[position].data["location"].toString()}");
    Future<QuerySnapshot> getJobs = Firestore.instance
        .collection("jobs")
        .where("status", isEqualTo: "FINISHED")
        .where("location",
            isEqualTo: jobs[position].data["location"].toString())
        .where("finishedTime",
            isGreaterThanOrEqualTo: DateTime.now().add(Duration(days: -90)))
        .getDocuments()
        .catchError((error) => print("$error"));

    return getJobs;
  }

  //get personal history
  getPersonalHistory(String id) async {
    Future<QuerySnapshot> getJobs = Firestore.instance
        .collection("jobs")
        .where("status", isEqualTo: "FINISHED")
        .where("assignedTo", isEqualTo: id)
        //.where("status", isEqualTo: "NEED HELP")
        .where("finishedTime",
            isGreaterThanOrEqualTo: DateTime.now().add(Duration(days: -7)))
        .getDocuments()
        .catchError((error) => print("$error"));

    return getJobs;
  }

  getPersonalHistoryVendor(String id) async {
    Future<QuerySnapshot> getJobs = Firestore.instance
        .collection("jobs")
        .where("vStatus", isEqualTo: "vFINISHED")
        .where("vAssignedTo", isEqualTo: id)
        //.where("status", isEqualTo: "NEED HELP")
        .where("vFinishedTime",
            isGreaterThanOrEqualTo: DateTime.now().add(Duration(days: -7)))
        .getDocuments()
        .catchError((error) => print("$error"));

    return getJobs;
  }
}
