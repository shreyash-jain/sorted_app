import * as functions from "firebase-functions";

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript

const admin = require("firebase-admin");


admin.initializeApp();
export const helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

const deviceToken = functions.config().dev_motivator.device_token;

exports.appinstalled = functions.analytics.event("first_open").onLog((event) => {
  const thisuser = event.user;

  const payload = {
    notification: {
      title: "You have a new user \uD83D\uDE43",
      body: thisuser?.deviceInfo.mobileModelName + " from " + thisuser?.geoInfo.city + "   " + thisuser?.geoInfo.country,
    },
  };

  return admin.messaging().sendToDevice(deviceToken, payload);
});

exports.appremoved = functions.analytics.event("app_remove").onLog((event) => {
  const thisuser = event.user;
  functions.logger.info("app_remove!", {structuredData: true});
  functions.logger.info(deviceToken, {structuredData: true});
  const payload = {
    notification: {
      title: "You lost a user \uD83D\uDE1E",
      body: thisuser?.deviceInfo.mobileModelName + " from " + thisuser?.geoInfo.city + "   " + thisuser?.geoInfo.country,
    },
  };

  return admin.messaging().sendToDevice(deviceToken, payload);
});
