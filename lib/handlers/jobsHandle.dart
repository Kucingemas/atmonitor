import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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

  getAvailableJobsVendor(String id) {
    Stream<QuerySnapshot> streamVendor = db
        .collection("jobs")
        .where("vStatus", isEqualTo: "vNOT ACCEPTED")
        .where("vAssignedTo", isEqualTo: id)
        .snapshots();
    return streamVendor;
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

  getAcceptedJobsVendor(String id) {
    Stream<QuerySnapshot> stream = db
        .collection("jobs")
        .where("vStatus", isEqualTo: "vACCEPTED")
        .where("vAssignedTo", isEqualTo: id)
        .snapshots();
    return stream;
  }

  //update status to accepted
  acceptJob(
    List<DocumentSnapshot> jobs,
    int position,
  ) {
    db.runTransaction((Transaction transaction) async {
      DocumentSnapshot documentSnapshot =
          await transaction.get(jobs[position].reference);
      //if pkt technician is not a helper
      if (jobs[position].data["needHelpTime"] == null) {
        await transaction
            .update(documentSnapshot.reference, {"status": "ACCEPTED"});
        await transaction.update(documentSnapshot.reference,
            {"acceptedTime": FieldValue.serverTimestamp()});
      }
      //if a helper
      else {
        await transaction
            .update(documentSnapshot.reference, {"status": "ACCEPTED"});
        await transaction.update(documentSnapshot.reference,
            {"hAcceptedTime": FieldValue.serverTimestamp()});
      }
    });
  }

  acceptJobVendor(List<DocumentSnapshot> jobs, int position) {
    db.runTransaction((Transaction transaction) async {
      DocumentSnapshot documentSnapshot =
          await transaction.get(jobs[position].reference);
      await transaction
          .update(documentSnapshot.reference, {"vStatus": "vACCEPTED"});
      await transaction.update(documentSnapshot.reference,
          {"vAcceptedTime": FieldValue.serverTimestamp()});
    });
  }

  //update status to declined
  declineJob(List<DocumentSnapshot> jobs, int position) {
    db.runTransaction((Transaction transaction) async {
      DocumentSnapshot documentSnapshot =
          await transaction.get(jobs[position].reference);
      await transaction
          .update(documentSnapshot.reference, {"status": "DECLINED"});
    });
  }

  declineJobVendor(List<DocumentSnapshot> jobs, int position) {
    db.runTransaction((Transaction transaction) async {
      DocumentSnapshot documentSnapshot =
          await transaction.get(jobs[position].reference);
      await transaction
          .update(documentSnapshot.reference, {"vStatus": "vDECLINED"});
    });
  }

  //update status to need help
  helpJob(
      List<DocumentSnapshot> jobs,
      int position,
      String triedSolution,
      File image,
      String problem,
      String problemCode,
      BuildContext context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: <Widget>[
                Text("Mengunggah"),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                ),
                CircularProgressIndicator()
              ],
            ),
          );
        });
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
      await transaction.update(
          documentSnapshot.reference, {"triedImage": downloadUrl.toString()});
      await transaction
          .update(documentSnapshot.reference, {"needHelpReason": problem});
      await transaction
          .update(documentSnapshot.reference, {"problemCode": problemCode});
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed("/acceptedjobs");
    });
  }

  //update status to finish
  //TODO: parts upload for pkt? -- don't have to?
  finishJob(List<DocumentSnapshot> jobs, int position, File image,
      String solution, List<String> parts, BuildContext context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: <Widget>[
                Text("Mengunggah"),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                ),
                CircularProgressIndicator()
              ],
            ),
          );
        });
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

    //update image url, solution, status, parts
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
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed("/acceptedjobs");
    });
  }

  finishJobVendor(List<DocumentSnapshot> jobs, int position, File image,
      String solution, List<String> parts, BuildContext context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: <Widget>[
                Text("Mengunggah"),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                ),
                CircularProgressIndicator()
              ],
            ),
          );
        });
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

    //update image url, solution, status, parts
    db.runTransaction((Transaction transaction) async {
      DocumentSnapshot documentSnapshot =
          await transaction.get(jobs[position].reference);
      await transaction
          .update(documentSnapshot.reference, {"vStatus": "vFINISHED"});
      await transaction.update(documentSnapshot.reference,
          {"vFinishedTime": FieldValue.serverTimestamp()});
      await transaction.update(
          documentSnapshot.reference, {"vSolution": solution.toString()});
      await transaction.update(
          documentSnapshot.reference, {"vImage": downloadUrl.toString()});
      await transaction
          .update(documentSnapshot.reference, {"partsName": parts});
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed("/acceptedjobs");
    });
  }
}
