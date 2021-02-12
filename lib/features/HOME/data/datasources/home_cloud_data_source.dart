import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:meta/meta.dart';

import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/data/models/placeholder_info.dart';
import 'package:sqflite/sqflite.dart';

abstract class HomeCloud {
  Future<List<InspirationModel>> get inspirations;
  Future<List<AffirmationModel>> get affirmations;
  Future<List<Placeholder>> get placeholderDetails;
  Future<List<Placeholder>> get thumbnailDetails;
  Future<void> addAffirmationsToFav(AffirmationModel affirmation);
  Future<void> deleteAffirmationsFromFav(AffirmationModel affirmation);
  Future<int> get currentId;
  Future<String> get deviceName;
}

class HomeCloudDataSourceImpl implements HomeCloud {
  final FirebaseFirestore cloudDb;
  final FirebaseAuth auth;
  final SqlDatabaseService nativeDb;
  Batch batch;

  HomeCloudDataSourceImpl(
      {@required this.cloudDb, @required this.auth, @required this.nativeDb});

  /// Gets a random inspiration from cloud
  ///
  ///
  @override
  Future<List<InspirationModel>> get inspirations async {
    List<InspirationModel> inspirationsList = [];
    var key = cloudDb.collection('inspiration').doc().id;

    await cloudDb
        .collection('inspiration')
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: key)
        .limit(1)
        .get()
        .then((snapshot) async => {
              if (snapshot.docs.length > 0)
                {
                  snapshot.docs.forEach((element) {
                    inspirationsList
                        .add(InspirationModel.fromSnapshot(element));
                  })
                }
              else
                {
                  await cloudDb
                      .collection('inspiration')
                      .where(FieldPath.documentId, isLessThan: key)
                      .limit(1)
                      .get()
                      .then((value) => {
                            snapshot.docs.forEach((element) {
                              inspirationsList
                                  .add(InspirationModel.fromSnapshot(element));
                            })
                          })
                }
            });

    return inspirationsList;
  }

  @override
  Future<List<Placeholder>> get placeholderDetails async {
    QuerySnapshot snapShot = await cloudDb.collection('images_info').get();
    if (snapShot != null && snapShot.docs.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.docs;
      return documents.map((e) => Placeholder.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<int> get currentId async {
    User user = auth.currentUser;
    int ans = 0;
    DocumentReference document = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc("data");

    await document.get().then((value) {
      print(value.data().containsKey("signInId").toString());
      print(value.data()['signInId']);
      ans = value.data()['signInId'];
      return ans;
    });
    return ans;
  }

  @override
  Future<String> get deviceName async {
    User user = auth.currentUser;
    DocumentReference document = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc("data");

    String ans;
    await document.get().then((value) {
      print(value.data().containsKey("deviceName").toString());
      print(value.data()['deviceName']);
      ans = value.data()['deviceName'];
      return ans;
    });

    return ans;
  }

  @override
  Future<List<AffirmationModel>> get affirmations async {
    List<AffirmationModel> affirmationList = [];
    var key = cloudDb.collection('affirmations').doc().id;
    print("key : " + key);
    var quote;
    print("ds_cloud/affirmations" + " " + "1");
    await cloudDb
        .collection('affirmations')
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: key)
        .limit(8)
        .get()
        .then((snapshot) async {
      if (snapshot.docs.length > 0) {
        print("ds_cloud/affirmations" + " " + "2");
        snapshot.docs.forEach((element) {
          print("ds_cloud/affirmations" + " " + "2");
          affirmationList.add(AffirmationModel.fromSnapshot(element));
        });
      } else {
        quote = await cloudDb
            .collection('affirmations')
            .where(FieldPath.documentId, isLessThan: key)
            .limit(8)
            .get()
            .then((value) {
          print("ds_cloud/affirmations" + " " + value.docs.length.toString());
          snapshot.docs.forEach((element) {
            print("ds_cloud/affirmations" + " " + "3");
            affirmationList.add(AffirmationModel.fromSnapshot(element));
          });
        });
      }
    });

    return Future.value(affirmationList);
  }

  @override
  Future<void> addAffirmationsToFav(AffirmationModel affirmation) async {
    User user = auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("FavAffirmations")
        .doc(affirmation.id.toString());

    ref
        .set(affirmation.toMap())
        .then((value) => print(ref.id))
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> deleteAffirmationsFromFav(AffirmationModel affirmation) async {
    User user = auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("FavAffirmations")
        .doc(affirmation.id.toString());

    ref
        .delete()
        .then((value) => print(ref.id))
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<List<Placeholder>> get thumbnailDetails async {
    QuerySnapshot snapShot = await cloudDb.collection('thumbnailInfo').get();
    if (snapShot != null && snapShot.docs.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.docs;
      return documents.map((e) => Placeholder.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }
}
