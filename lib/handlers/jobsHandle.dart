import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class JobsHandle {
  Firestore db = Firestore.instance;
  StorageReference ref = FirebaseStorage.instance.ref();

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
  finishJob(List<DocumentSnapshot> jobs, int position, File image,
      String solution) async {
    //upload image to storage
    StorageUploadTask uploadTask = ref
        .child("buktiGambarSelesai/"+image.lastModifiedSync().toString())
        .putFile(image);
    //getting download url
    Uri location = (await uploadTask.future).downloadUrl;

    //update image url, solution, status
    db.runTransaction((Transaction transaction) async {
      DocumentSnapshot documentSnapshot =
          await transaction.get(jobs[position].reference);
      await transaction
          .update(documentSnapshot.reference, {"status": "FINISHED"});
      await transaction.update(
          documentSnapshot.reference, {"solution": solution.toString()});
      await transaction
          .update(documentSnapshot.reference, {"image": location.toString()});
    });
  }
}
