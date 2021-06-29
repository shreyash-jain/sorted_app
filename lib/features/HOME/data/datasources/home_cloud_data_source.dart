import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:meta/meta.dart';

import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/data/models/blog_textbox.dart';
import 'package:sorted/features/HOME/data/models/blogs.dart';
import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/data/models/placeholder_info.dart';
import 'package:sorted/features/HOME/data/models/recipe.dart';
import 'package:sorted/features/HOME/data/models/tagged_recipe.dart';
import 'package:sorted/features/HOME/data/models/transformation.dart';
import 'package:sorted/features/HOME/data/models/video_recipe.dart';
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

  Future<BlogModel> getBlogFromId(int id);

  Future<List<BlogTextboxModel>> getTextBoxes(int blogId);

  Future<List<TaggedRecipe>> getTaggedRecipes(int count);

  Future<TaggedRecipe> getTaggedRecipesOfId(int id);

  Future<TransformationModel> getTransformationStory();

  Future<VideoRecipe> getVideoRecipe();

  Future<RecipeModel> getRecipeById(int id);
  Future<List<BlogModel>> getBlog(int count);
}

class HomeCloudDataSourceImpl implements HomeCloud {
  HomeCloudDataSourceImpl(
      {@required this.cloudDb, @required this.auth, @required this.nativeDb});

  final FirebaseAuth auth;
  Batch batch;
  final FirebaseFirestore cloudDb;
  final SqlDatabaseService nativeDb;
  final _random = new Random();
  int next(int min, int max) => min + _random.nextInt(max - min);
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
      print((value.data() as Map).containsKey("signInId").toString());
      print((value.data() as Map)['signInId']);
      ans = (value.data() as Map)['signInId'];
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
      print((value.data() as Map).containsKey("deviceName").toString());
      print((value.data() as Map)['deviceName']);
      ans = (value.data() as Map)['deviceName'];
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
  Future<List<Placeholder>> get thumbnailDetails async {
    QuerySnapshot snapShot = await cloudDb.collection('thumbnailInfo').get();
    if (snapShot != null && snapShot.docs.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.docs;
      return documents.map((e) => Placeholder.fromSnapshot(e)).toList();
    }
    return Future.value([]);
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
  Future<BlogModel> getBlogFromId(int id) async {
    var snapShot = await cloudDb
        .collection('articles')
        .where(FieldPath.documentId, isEqualTo: id.toString())
        .get();
    if (snapShot != null && snapShot.docs.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.docs;
      return documents.map((e) => BlogModel.fromSnapshot(e)).toList()[0];
    }
    return Future.value(BlogModel.empty());
  }

  @override
  Future<List<BlogModel>> getBlog(int count) async {
    List<BlogModel> blogsList = [];
    var rng = new Random();
    var key = rng.nextInt(10000);

    await cloudDb
        .collection('articles')
        .orderBy("random", descending: true)
        .where("random", isLessThanOrEqualTo: key)
        .limit(count)
        .get()
        .then((snapshot) async {
      if (snapshot.docs.length > 0) {
        snapshot.docs.forEach((element) {
          blogsList.add(BlogModel.fromSnapshot(element));
        });
      } else {
        await cloudDb
            .collection('RecipesDb/data/TaggedRecipes')
            .orderBy("random")
            .where("random", isGreaterThanOrEqualTo: key)
            .orderBy("random")
            .limit(count)
            .get()
            .then((value) {
          snapshot.docs.forEach((element) {
            blogsList.add(BlogModel.fromSnapshot(element));
          });
        });
      }
    });
    return blogsList;
  }

  @override
  Future<RecipeModel> getRecipeById(int id) async {
    var snapShot = await cloudDb
        .collection('Recipes')
        .where(FieldPath.documentId, isEqualTo: id.toString())
        .get();
    if (snapShot != null && snapShot.docs.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.docs;
      return documents.map((e) => RecipeModel.fromSnapshot(e)).toList()[0];
    }
    return Future.value(RecipeModel.empty());
  }

  @override
  Future<List<TaggedRecipe>> getTaggedRecipes(int count) async {
    List<TaggedRecipe> recipeList = [];
    var rng = new Random();
    var key = rng.nextInt(10000);

    await cloudDb
        .collection('RecipesDb/data/TaggedRecipes')
        .where("random", isLessThanOrEqualTo: key)
        .where("is_healthy", isEqualTo: "y")
        .orderBy("random", descending: true)
        .limit(count)
        .get()
        .then((snapshot) async {
      if (snapshot.docs.length > 0) {
        snapshot.docs.forEach((element) {
          recipeList.add(TaggedRecipe.fromSnapshot(element));
        });
      } else {
        await cloudDb
            .collection('RecipesDb/data/TaggedRecipes')
            .where("random", isGreaterThanOrEqualTo: key)
            .where("is_healthy", isEqualTo: "y")
            .orderBy("random")
            .limit(count)
            .get()
            .then((value) {
          snapshot.docs.forEach((element) {
            recipeList.add(TaggedRecipe.fromSnapshot(element));
          });
        });
      }
    });
    return recipeList;
  }

  @override
  Future<TaggedRecipe> getTaggedRecipesOfId(int id) async {
    var snapShot = await cloudDb
        .collection('RecipesDb/data/TaggedRecipes')
        .where(FieldPath.documentId, isEqualTo: id.toString())
        .get();
    if (snapShot != null && snapShot.docs.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.docs;
      return documents.map((e) => TaggedRecipe.fromSnapshot(e)).toList()[0];
    }
    return Future.value(TaggedRecipe.empty());
  }

  @override
  Future<List<BlogTextboxModel>> getTextBoxes(int blogId) async {
    var snapShot = await cloudDb
        .collection('articles')
        .doc(blogId.toString())
        .collection('textboxes')
        .get();
    if (snapShot != null && snapShot.docs.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.docs;
      return documents.map((e) => BlogTextboxModel.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<TransformationModel> getTransformationStory() async {
    List<TransformationModel> transformations = [];

    var key = next(1, 41);

    await cloudDb
        .collection('TransformationDb/data/Transformations')
        .where('id', isEqualTo: key)
        .limit(1)
        .get()
        .then((snapshot) async {
      if (snapshot.docs.length > 0) {
        snapshot.docs.forEach((element) {
          transformations.add(TransformationModel.fromSnapshot(element));
        });
      } else {
        await cloudDb
            .collection('TransformationDb/data/Transformations')
            .where('id', isGreaterThanOrEqualTo: key)
            .limit(1)
            .get()
            .then((value) {
          snapshot.docs.forEach((element) {
            transformations.add(TransformationModel.fromSnapshot(element));
          });
        });
      }
    });
    return transformations.length == 0
        ? TransformationModel.empty()
        : transformations[0];
  }

  @override
  Future<VideoRecipe> getVideoRecipe() async {
    List<VideoRecipe> recipe = [];

    var key = next(1, 23);

    await cloudDb
        .collection('RecipesDb/data/Videos')
        .where('id', isEqualTo: key)
        .limit(1)
        .get()
        .then((snapshot) async {
      if (snapshot.docs.length > 0) {
        print("in first");
        snapshot.docs.forEach((element) {
          recipe.add(VideoRecipe.fromSnapshot(element));
        });
      } else {
        print("in second");
        await cloudDb
            .collection('RecipesDb/data/Videos')
            .where('id', isGreaterThanOrEqualTo: key)
            .limit(1)
            .get()
            .then((value) {
          snapshot.docs.forEach((element) {
            recipe.add(VideoRecipe.fromSnapshot(element));
          });
        });
      }
    });
    return recipe.length == 0 ? VideoRecipe.empty() : recipe[0];
  }
}
