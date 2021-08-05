import * as functions from "firebase-functions";
import { getAllEntries } from "./getExpertProfile";
import { testPayout } from "./payout_test";
var bodyParser = require('body-parser');
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript

const admin = require("firebase-admin");
const nodemailer = require('nodemailer');
const express = require('express');
const app = express();
app.use(bodyParser.json());
// [START middleware]
const cors = require('cors')({ origin: true });
app.use(cors);
// [END middleware]

export const helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", { structuredData: true });
  response.send("Hello from Firebase!");
});


exports.sendEmail = functions.https.onRequest((request, response) => {
  const mailOptions = {
    from: '"Shreyash Jain", "donotreply.sortedlife@gmail.com"',
    to: 'shreyashjain1996@gmail.com,sort.it.team@gmail.com',
    subject: "[IMPORTANT] Sort.it : NEW Customer Reached on Website ",
    html: `<h1>Customer Details</h1><p><br><b>Email: </b>${request.query.email} </p>
    <br><b>Name: </b>${request.query.name} </p ><br><b>Phone: </b>${request.query.phone} 
    </p ><br><b>Message: </b>${request.query.message} </p >`,

  };
  const transporter = nodemailer.createTransport({
    host: "smtp.gmail.com",
    port: 587,
    secure: false,
    auth: {
      user: "donotreply.sortedlife@gmail.com",
      pass: "ThisIsSortedLife",
    },
  });
  response.send(request.body);

  return transporter.sendMail(mailOptions, (error: any, data: any) => {
    if (error) {
      console.log(error);
      return;
    }
    console.log("Sent!");
  });
});

const deviceToken = functions.config().dev_motivator.device_token;

exports.appinstalled = functions.analytics.event("first_open").onLog((event) => {
  const thisuser = event.user;
  const message = {
    notification: {
      title: "You have a new user \uD83D\uDE43",
      body: thisuser?.deviceInfo.mobileModelName + " from " + thisuser?.geoInfo.city + "   " + thisuser?.geoInfo.country,
    },
    data: {
      channel_id: "high_importance_channel",
    },
    android: {
      ttl: 3600 * 1000,
      notification: {

        color: '#f45342',
      },
    },
    apns: {
      payload: {
        aps: {
          badge: 42,
        },
      },
    },
    token: deviceToken,
  };

  return admin.messaging().send(message);
});

exports.appremoved = functions.analytics.event("app_remove").onLog((event) => {
  const thisuser = event.user;
  functions.logger.info("app_remove!", { structuredData: true });
  functions.logger.info(deviceToken, { structuredData: true });
  const message = {
    notification: {
      title: "You lost a user \uD83D\uDE1E",
      body: thisuser?.deviceInfo.mobileModelName + " from " + thisuser?.geoInfo.city + "   " + thisuser?.geoInfo.country,
    },
    data: {
      channel_id: "high_importance_channel",
    },
    android: {
      ttl: 3600 * 1000,
      notification: {

        color: '#f45342',
      },
    },
    apns: {
      payload: {
        aps: {
          badge: 42,
        },
      },
    },
    token: deviceToken,
  };

  return admin.messaging().send(message);
});


app.get('^/users/:userName([a-z0-9_\-]+$)', getAllEntries)
app.get('/balance', testPayout);
exports.expertWebsiteDataFun = functions.https.onRequest(app)