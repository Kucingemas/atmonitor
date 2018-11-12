import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class JobsHandle {
  Firestore db = Firestore.instance;

  //get jobs with status == not accepted, and assigned to == id saved as stream
  getAvailableJobs(String id) {
    Stream<QuerySnapshot> stream = db
        .collection("jobs")
        .where("status", isEqualTo: "NOT ACCEPTED")
        .where("assignedTo", isEqualTo: id)
        .snapshots();
    return stream;
  }

  //get jobs with status == accepted, saved as stream
  getAcceptedJobs(String id) {
    Stream<QuerySnapshot> stream = db
        .collection("jobs")
        .where("status", isEqualTo: "ACCEPTED")
        .where("assignedTo", isEqualTo: id)
        .snapshots();
    return stream;
  }

  //update status to onProcess (arrived at location)
  arrivedAtLocation(List<DocumentSnapshot> jobs, int position) {
    db.runTransaction((Transaction transaction) async {
      DocumentSnapshot documentSnapshot =
          await transaction.get(jobs[position].reference);
      await transaction
          .update(documentSnapshot.reference, {"status": "ON PROCESS"});
      await transaction.update(documentSnapshot.reference,
          {"arrivedTime": FieldValue.serverTimestamp()});
    });
  }

  //update status to accepted
  acceptJob(List<DocumentSnapshot> jobs, int position) {
    db.runTransaction((Transaction transaction) async {
      DocumentSnapshot documentSnapshot =
          await transaction.get(jobs[position].reference);
      await transaction
          .update(documentSnapshot.reference, {"status": "ACCEPTED"});
      await transaction.update(documentSnapshot.reference,
          {"acceptedTime": FieldValue.serverTimestamp()});
    });
  }

  //update status to declined
  //TODO: decline - what to do in db?
  declineJob(List<DocumentSnapshot> jobs, int position) {
    db.runTransaction((Transaction transaction) async {
      DocumentSnapshot documentSnapshot =
          await transaction.get(jobs[position].reference);
      await transaction
          .update(documentSnapshot.reference, {"status": "DECLINED"});
    });
  }

  //update status to need help
  //TODO: triedImage, kode problem, masalah yang dihadapi
  helpJob(List<DocumentSnapshot> jobs, int position, String triedSolution, File image, String problem, String problemCode) async {
    Uuid uuid = Uuid();

    //upload image to storage
    StorageUploadTask storageUploadTask = FirebaseStorage.instance
        .ref()
        .child("buktiGambarNeedHelp/" +
        image.lastModifiedSync().toString() +
        "_" +
        uuid.v1().toString())
        .putFile(image);

    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

    db.runTransaction((Transaction transaction) async {
      DocumentSnapshot documentSnapshot =
          await transaction.get(jobs[position].reference);
      await transaction
          .update(documentSnapshot.reference, {"status": "NEED HELP"});
      await transaction.update(documentSnapshot.reference,
          {"needHelpTime": FieldValue.serverTimestamp()});
      await transaction
          .update(documentSnapshot.reference, {"triedSolution": triedSolution});
      await transaction
          .update(documentSnapshot.reference, {"triedImage": downloadUrl.toString()});
      await transaction
          .update(documentSnapshot.reference, {"needHelpReason": problem});
      await transaction
          .update(documentSnapshot.reference, {"problemCode": problemCode});
    });
  }

  //update status to finish
  //TODO: parts upload
  finishJob(List<DocumentSnapshot> jobs, int position, File image,
      String solution) async {
    Uuid uuid = Uuid();

    //upload image to storage
    StorageUploadTask storageUploadTask = FirebaseStorage.instance
        .ref()
        .child("buktiGambarSelesai/" +
            image.lastModifiedSync().toString() +
            "_" +
            uuid.v1().toString())
        .putFile(image);

    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

    //update image url, solution, status
    //TODO parts upload
    db.runTransaction((Transaction transaction) async {
      DocumentSnapshot documentSnapshot =
          await transaction.get(jobs[position].reference);
      await transaction
          .update(documentSnapshot.reference, {"status": "FINISHED"});
      await transaction.update(documentSnapshot.reference,
          {"finishedTime": FieldValue.serverTimestamp()});
      await transaction.update(
          documentSnapshot.reference, {"solution": solution.toString()});
      await transaction.update(
          documentSnapshot.reference, {"image": downloadUrl.toString()});
    });
  }
}
