const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const nodemailer = require("nodemailer");

const app = express();

//configure the Express middleware to accept CORS requests and parse request body into JSON
app.use(cors({ origin: "*" }));
app.use(bodyParser.json());

//start application server on port 3000
app.listen(3000, () => {
    console.log("The server started on port 3000");
});

// define a sendmail endpoint, which will send emails and response with the corresponding status
app.post("/sendmail", (req, res) => {
    console.log("request came");
    let user = req.body;
    sendMail(user, (err, info) => {
        if (err) {
            console.log(err);
            res.status(400);
            res.send({ error: "Failed to send email" });
        } else {
            console.log("Email has been sent");
            res.send(info);
        }
    });
});

const sendMail = (body, callback) => {
    const transporter = nodemailer.createTransport({
        host: "smtp.gmail.com",
        port: 587,
        secure: false,
        auth: {
            user: "donotreply.sortedlife@gmail.com",
            pass: "ThisIsSortedLife"
        }
    });

    const mailOptions = {
        from: `"Shreyash Jain", "donotreply.sortedlife@gmail.com"`,
        to: `shreyashjain1996@gmail.com`,
        subject: "[IMPORTANT] Sort.it : NEW Customer Reached on Website ",
        html: `<${body}>`,
    };

    transporter.sendMail(mailOptions, callback);
}