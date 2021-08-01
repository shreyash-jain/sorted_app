
import { db } from './firebase'






const getAllEntries = async (req: any, res: any) => {
    // London is UTC + 1hr;
    // [START_EXCLUDE silent]
    // [START cache]
    try {
        const cityRef = await db.collection('experts/publicInfo/usernames/').doc(`${req.params.userName}`);
        const doc = await cityRef.get();
        res.set('Cache-Control', `public, max-age=300, s-maxage=600`);
        if (!doc.exists) {
            console.log('No such document!');
            return res.status(500).json({ "message": "No expert" })
        } else {
            console.log('Document data:', doc.data());
        }

        console.log("test_fun run");
        return res.status(200).json(doc.data())
    } catch (error) { return res.status(501).json(error.message) }

    // [END cache]
    // [END_EXCLUDE silent]
    //res.send('Route match for User Name: ' + req.params.userName);
};
export { getAllEntries }