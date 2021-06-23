

var serviceAccount = require("./serviceAccountKey.json");
const { backup, backups, initializeApp } = require('firestore-export-import')
var fs = require('fs');

initializeApp(serviceAccount);
backup('articles')
    .then((data) => fs.writeFile("input.json", JSON.stringify(data), function (err) {
        if (err) throw err;
        console.log('complete');
    }   
    ));


