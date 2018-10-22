const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.atmonitor = functions.firestore
       .document('jobs/{id}')
       .onCreate((snapShot, context) => {
            const receiver = snapShot.data().assignedTo
            console.log(receiver);
            const receiverFcm = admin.firestore().collection("users").where("uid","==",receiver).get();
            //const receiverFcm = admin.firestore().collection("users").doc(receiver).get();
            if(receiverFcm == null) console.log("kosong");
            return Promise.all([receiverFcm]).then(hasil => {
                const tokenId = hasil[0].data().notifToken;
                const notificationContent = {
                    notification: {
                        title: "ada pekerjaan baru untukmu!",
                        body: "ayo cek aplikasi atmonitor > daftar pekerjaan, sekarang",
                        icon: "default",
                        sound: "default"
                    }};
                return admin.messaging().sendToDevice(tokenId, notificationContent).then(result => {console.log("sent");
            });
            });
         
       });
