import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AtmNotification {
  enableNotification() {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) {
        print("onLaunch called");
      },
      onMessage: (Map<String, dynamic> msg) {
        print("onMessage called");
      },
      onResume: (Map<String, dynamic> msg) {
        print("onResume called");
      },
    );
    firebaseMessaging.requestNotificationPermissions();
    firebaseMessaging.getToken().then((token) {
      print(token);
      update(token);
    });
  }

  update(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Firestore.instance
        .collection("users")
        .where("uid", isEqualTo: sharedPreferences.getString("userid"))
        .getDocuments()
        .then((snapshot) {
      DocumentReference documentReference = snapshot.documents.first.reference;
      Firestore.instance.runTransaction((Transaction transaction) async {
        DocumentSnapshot documentSnapshot =
        await transaction.get(documentReference);
        await transaction.update(documentSnapshot.reference, {
          "notifToken": token,
        });
      });
    });
  }
}
