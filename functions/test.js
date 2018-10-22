const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp({
    credential: admin.credential.cert('./android/app/google-services.json'),
    databaseURL: "https://fir-testing-c9acf.firebaseio.com",
    
});
const receiver = "wkXUHw05W9XgZzmRiLLoCGlK5pf1"
console.log(receiver);
const receiverFcm = admin.firestore().collection("users").where("uid","==",receiver).get().then(val => {
    if(val.exists){
        console.log("ada");
    }
    else{
        console.log("tidak ada!");
    }
});