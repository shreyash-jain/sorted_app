const admin = require("firebase-admin");


const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://sorted-98c02.firebaseio.com"
});

const db = admin.firestore()
export { admin, db }