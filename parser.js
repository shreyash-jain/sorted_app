const fs = require('fs')
fs.readFile('./input.json', 'utf8', (err, jsonString) => {
    if (err) {
        console.log("Error reading file from disk:", err)
        return
    }
    try {
        const customer = JSON.parse(jsonString)

        //console.log("Customer address is:", customer.articles) // => "Customer address is: Infinity Loop Drive"
        count = 0
        for (i in customer.articles) {
            count++;
            
            console.log(customer.articles[i]["tags"]);

        }

    } catch (err) {
        console.log('Error parsing JSON string:', err)
    }
})