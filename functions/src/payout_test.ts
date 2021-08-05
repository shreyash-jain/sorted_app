const fs = require('fs');
const crypto = require('crypto');
const axios = require('axios');

const getCurrentTimeInSecs = () => Date.now() / 1000;


function getSignature(): String {
    var publicKey = fs.readFileSync('./certs/accountId_111715_public_key.pem', 'utf8');
    if (!publicKey) {
        return "";
    }
    // var publicKeyPEM = publicKey
    //     .replace("-----BEGIN PUBLIC KEY-----", "")
    //     .replaceAll("[\\t\\n\\r]", "")
    //     .replace("-----END PUBLIC KEY-----", "");



    const curTimeStamp = getCurrentTimeInSecs();
    const plainText = `CF86340C45AQ4CPRI0BTG2EAUFG.${curTimeStamp}`;
    const buffer = Buffer.from(plainText);

    const encrypted = crypto.publicEncrypt(
        {
            key: publicKey,
            padding: crypto.constants.RSA_PKCS1_OAEP_PADDING,
        },
        buffer,
    );

    return encrypted.toString('base64');
}





const testPayout = async (req: any, res: any) => {
    let certificate;
    let token = "";
    var data1: any;
    //let tokenResponse = {};

    try {
        certificate = getSignature();
    }
    catch (error) {
        return res.status(501).json({ cert: certificate, error: error });

    }

    // London is UTC + 1hr;
    // [START_EXCLUDE silent]
    // [START cache]
    try {


        try {

            const headers = {
                'X-Cf-Signature': certificate,
                'X-Client-Secret': '22a970e80c43b8f98f540feae971d8ecd84b5574',
                'X-Client-Id': 'CF86340C45AQ4CPRI0BTG2EAUFG'
            }


            await axios.post("https://payout-gamma.cashfree.com/payout/v1/authorize", { data: "" }, {
                headers: headers
            }).then((response: any) => {
                token = response.data.data.token.toString();
                //return res.status(200).json({ message: response.data, tokenData: response.data.status });
                data1 = response.data;

                // return res.status(200).json({
                //     message: response.data
                // })
            })
                .catch((err: any) => {
                    return res.status(500).json({
                        error: token
                    })
                });

            return axios.get("https://payout-gamma.cashfree.com/payout/v1/getBalance", {
                headers: {
                    Authorization: `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            }).then((response: any) => {

                return res.status(200).json({
                    message: response.data,
                    "token": token,
                    "data1": data1

                })
            })
                .catch((err: any) => {
                    return res.status(501).json({
                        error: token
                    })
                });



            // return res.status(201).json(tokenResponse);
            // token = tokenResponse.data.data.token;
            // var balanceResponse = await axios.post("https://payout-gamma.cashfree.com/payout/v1/getBalance", {}, {
            //     headers: {
            //         Authorization: `Bearer ${token}`,
            //         'Content-Type': 'application/json'
            //     }
            // });
            // return res.status(200).json(balanceResponse);

        }
        catch (error) {
            return res.status(400).json({ 'error': certificate });


        }
    } catch (error) {
        return res.status(401).json({ 'error': {} });
    }

    // London is UTC + 1hr;
    // [START_EXCLUDE silent]
    // [START cache]


    // try {

    //     return res.status(200).json(resultJson);
    // }
    // catch (error) {
    //     return res.status(501).json(error.message);
    // }




    // [END cache]
    // [END_EXCLUDE silent]
    //res.send('Route match for User Name: ' + req.params.userName);
};
export { testPayout }