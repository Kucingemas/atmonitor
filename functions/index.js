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
       .onUpdate((snapShot, context) => {
           if(snapShot.after.data().status == "NOT ACCEPTED"){
            console.log("masuk if pertama")
            const receiver = snapShot.after.data().assignedTo
            console.log(receiver);
            const receiverFcm = admin.firestore().collection("users").where("uid","==",receiver).get().then(val => {
                if(!val.empty){
                    console.log("ada");
                    const documents = val.docs;
                    const tokenId = documents[0].data().notifToken;
                    const notificationContent = {
                        notification: {
                            title: "ada pekerjaan baru untukmu!",
                            body: "ayo cek aplikasi atmonitor > daftar pekerjaan, sekarang",
                            icon: "default",
                            sound: "default"
                        }};
                        admin.messaging().sendToDevice(tokenId, notificationContent).then(result => {console.log("sent");});
                        return "selsai send nih cihuy";
                }
                else{
                    console.log("tidak ada!");
                }
            });
        }

            //const receiverFcm = admin.firestore().collection("users").doc(receiver).get();
            // if(receiverFcm.exists) console.log("ada");
            // console.log(receiverFcm);
            // console.log(receiverFcm[0].data().uid);
            // console.log(receiverFcm[0].data().name);
            // return Promise.all([receiverFcm]).then(hasil => {
            //     const tokenId = hasil[0].data().notifToken;
            //     const notificationContent = {
            //         notification: {
            //             title: "ada pekerjaan baru untukmu!",
            //             body: "ayo cek aplikasi atmonitor > daftar pekerjaan, sekarang",
            //             icon: "default",
            //             sound: "default"
            //         }};
            //     return admin.messaging().sendToDevice(tokenId, notificationContent).then(result => {console.log("sent");
            // });
            // });

       });
