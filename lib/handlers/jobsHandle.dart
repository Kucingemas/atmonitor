import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class JobsHandle {
  Firestore db = Firestore.instance;

  //get jobs with status == not accepted, saved as stream
  getAvailableJobs() {
    Stream<QuerySnapshot> stream = db
        .collection("jobs")
        .where("status", isEqualTo: "NOT ACCEPTED")
        .snapshots();
    return stream;
  }

  //get jobs with status == accepted, saved as stream
  getAcceptedJobs() {
    Stream<QuerySnapshot> stream = db
        .collection("jobs")
        .where("status", isEqualTo: "ACCEPTED")
        .snapshots();
    return stream;
  }

  //update status to accepted
  acceptJob(List<DocumentSnapshot> jobs, int position) {
    db.runTransaction((Transaction transaction) async {
      DocumentSnapshot documentSnapshot =
          await transaction.get(jobs[position].reference);
      await transaction
          .update(documentSnapshot.reference, {"status": "ACCEPTED"});
    });
  }

  //update status to finish
  finishJob(List<DocumentSnapshot> jobs, int position) {
    db.runTransaction((Transaction transaction) async {
      DocumentSnapshot documentSnapshot =
      await transaction.get(jobs[position].reference);
      await transaction
          .update(documentSnapshot.reference, {"status": "FINISHED"});
    });
  }

}
