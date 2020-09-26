import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:meta/meta.dart';

import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/data/models/placeholder_info.dart';
import 'package:sqflite/sqflite.dart';

abstract class SettingsCloud {
  Future<List<InspirationModel>> get inspirations;
  Future<List<AffirmationModel>> get affirmations;
  Future<List<Placeholder>> get placeholderDetails;
  Future<List<Placeholder>> get thumbnailDetails;
  Future<void> addAffirmationsToFav(AffirmationModel affirmation);
  Future<void> deleteAffirmationsFromFav(AffirmationModel affirmation);
  Future<int> get currentId;
  Future<String> get deviceName;
}

class HomeCloudDataSourceImpl implements SettingsCloud {
  final Firestore cloudDb;
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
    var key = cloudDb.collection('inspiration').document().documentID;

    await cloudDb
        .collection('inspiration')
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: key)
        .limit(1)
        .getDocuments()
        .then((snapshot) async => {
              if (snapshot.documents.length > 0)
                {
                  snapshot.documents.forEach((element) {
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
                      .getDocuments()
                      .then((value) => {
                            snapshot.documents.forEach((element) {
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
    QuerySnapshot snapShot =
        await cloudDb.collection('images_info').getDocuments();
    if (snapShot != null && snapShot.documents.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.documents;
      return documents.map((e) => Placeholder.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<int> get currentId async {
    FirebaseUser user = await auth.currentUser();
    int ans = 0;
    DocumentReference document = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("data");

    await document.get().then((value) {
      print(value.data.containsKey("signInId").toString());
      print(value.data['signInId']);
      ans = value.data['signInId'];
      return ans;
    });
    return ans;
  }

  @override
  Future<String> get deviceName async {
    FirebaseUser user = await auth.currentUser();
    DocumentReference document = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("data");

    String ans;
    await document.get().then((value) {
      print(value.data.containsKey("deviceName").toString());
      print(value.data['deviceName']);
      ans = value.data['deviceName'];
      return ans;
    });

    return ans;
  }

  @override
  Future<List<AffirmationModel>> get affirmations async {
    List<AffirmationModel> affirmationList = [];
    var key = cloudDb.collection('affirmations').document().documentID;
    print("key : " + key);
    var quote;
    print("ds_cloud/affirmations" + " " + "1");
    await cloudDb
        .collection('affirmations')
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: key)
        .limit(8)
        .getDocuments()
        .then((snapshot) async {
      if (snapshot.documents.length > 0) {
        print("ds_cloud/affirmations" + " " + "2");
        snapshot.documents.forEach((element) {
          print("ds_cloud/affirmations" + " " + "2");
          affirmationList.add(AffirmationModel.fromSnapshot(element));
        });
      } else {
        quote = await cloudDb
            .collection('affirmations')
            .where(FieldPath.documentId, isLessThan: key)
            .limit(8)
            .getDocuments()
            .then((value) {
          print("ds_cloud/affirmations" +
              " " +
              value.documents.length.toString());
          snapshot.documents.forEach((element) {
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
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("FavAffirmations")
        .document(affirmation.id.toString());

    ref
        .setData(affirmation.toMap())
        .then((value) => print(ref.documentID))
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> deleteAffirmationsFromFav(AffirmationModel affirmation) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("FavAffirmations")
        .document(affirmation.id.toString());

    ref
        .delete()
        .then((value) => print(ref.documentID))
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<List<Placeholder>> get thumbnailDetails async {
    QuerySnapshot snapShot =
        await cloudDb.collection('thumbnailInfo').getDocuments();
    if (snapShot != null && snapShot.documents.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.documents;
      return documents.map((e) => Placeholder.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }
}
