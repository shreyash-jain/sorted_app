import { db } from './firebase'



const getAllEntries = async (req: any, res: any) => {
    // London is UTC + 1hr;
    // [START_EXCLUDE silent]
    // [START cache]
    var resultJson: any = {};
    // London is UTC + 1hr;
    // [START_EXCLUDE silent]
    // [START cache]
    try {
        const uidRef = await db.collection('experts/publicInfo/usernames/').doc(`${req.params.userName}`);
        const doc = await uidRef.get();


        res.set('Cache-Control', `public, max-age=300, s-maxage=600`);
        if (!doc.exists) {
            console.log('No such document!');
            return res.status(500).json({ "message": "No expert" });
        }
        else {
            var uid = doc.data()['uid'];
            const profileRef = await db.collection(`experts/data/uid/`).doc(uid);
            const profileDoc = await profileRef.get();
            if (profileDoc.exists) {
                resultJson['profileData'] = profileDoc.data();
                const websiteSettingsRef = await db.collection(`experts/data/uid/`).doc(uid).collection('webSettings').doc('data');
                const websiteSettingsDoc = await websiteSettingsRef.get();
                if (websiteSettingsDoc.exists)
                    resultJson['websiteSettingsData'] = websiteSettingsDoc.data();
                const classesRef = await db.collection(`classrooms`);
                const classesSnap = await classesRef.where('coachUid', '==', uid).limit(5).get();
                if (!classesSnap.empty) {
                    resultJson['classesData'] = classesSnap.docs.map((thisdoc: any) => thisdoc.data());

                }



                if (profileDoc.data()['instititeId'] != "") {
                    const instituteRef = await db.collection(`institutions`).doc(profileDoc.data()['instititeId']);
                    const instituteDoc = await instituteRef.get();
                    if (instituteDoc.exists)
                        resultJson['instituteData'] = instituteDoc.data();
                }


            }



        }
        console.log("test_fun run");
        return res.status(200).json(resultJson);
    }
    catch (error) {
        return res.status(501).json(error.message);
    }




    // [END cache]
    // [END_EXCLUDE silent]
    //res.send('Route match for User Name: ' + req.params.userName);
};
export { getAllEntries }