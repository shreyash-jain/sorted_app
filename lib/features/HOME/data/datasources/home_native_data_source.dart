import 'dart:math';

import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/data/models/challenge_model.dart';
import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/data/models/motivation/pep_talks.dart';
import 'package:sorted/features/HOME/data/models/motivation/transformation.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe_howto.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe_ingredient.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe_nutrition.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe_step.dart';
import 'package:sorted/features/HOME/data/models/recipes/tagged_recipe.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/data/models/placeholder_info.dart';
import 'package:sorted/features/HOME/domain/entities/unsplash_image.dart';

abstract class HomeNative {
  Future<void> deleteSavedAffirmationsTable();
  Future<void> deleteInspirationTable();
  Future<void> deletePlaceHolderTable();
  Future<void> deleteThumbnailTable();
  Future<void> deleteUnsplashImagesTable();
  Future<void> deleteDayAffirmationTable();
  Future<void> addInspirations(List<InspirationModel> inspirations);
  Future<void> addAffirmationsToSaved(List<AffirmationModel> affirmations);
  Future<bool> doFavExists(AffirmationModel affirmation);
  Future<List<DayAffirmation>> addAffirmationsToCurrentDay(
      List<DayAffirmation> affirmations);
  Future<void> addPlaceholderDetails(List<Placeholder> details);
  Future<void> addThumbnailDetails(List<Placeholder> details);
  Future<void> addUnsplashImagesDetails(List<UnsplashImage> details);
  Future<void> deleteFromFav(AffirmationModel affirmation);
  Future<void> addToFav(AffirmationModel affirmation);
  Future<void> updateDayAffirmation(DayAffirmation affirmation);
  Future<List<DayAffirmation>> get dayAffirmations;
  Future<InspirationModel> get todayInspiration;
  Future<List<AffirmationModel>> get savedAffirmations;
  Future<List<AffirmationModel>> get favAffirmations;
  Future<List<Placeholder>> get placeholderDetails;
  Future<List<Placeholder>> get thumbnailDetails;
  Future<List<UnsplashImage>> get unsplashImages;
  Future<void> addTaggedRecipes(List<TaggedRecipe> recipes);
  Future<List<TaggedRecipe>> get taggedRecipes;
  Future<void> deleteRecipeTable();
  Future<void> addPepTalk(PepTalkModel talk);
  Future<PepTalkModel> get pepTalk;
  Future<void> deleteTalkTable();
  Future<void> addChallenge(ChallengeModel challenge);
  Future<ChallengeModel> get challenge;
  Future<void> deleteChallengeTable();
  Future<void> addTransformation(TransformationModel recipes);
  Future<TransformationModel> get transformation;
  Future<void> deleteTransformationTable();
}

class HomeNativeDataSourceImpl implements HomeNative {
  final SqlDatabaseService nativeDb;

  HomeNativeDataSourceImpl({@required this.nativeDb});

  @override
  Future<List<DayAffirmation>> addAffirmationsToCurrentDay(
      List<DayAffirmation> affirmations) async {
    List<DayAffirmation> list = [];
    affirmations.forEach((element) async {
      print(element);
      final db = await nativeDb.database;
      var result = await db.insert('CurrentAffirmations', element.toMap());
      element = element.copyWith(id: result);
      list.add(element);
    });
    return list;
  }

  @override
  Future<void> addAffirmationsToSaved(
      List<AffirmationModel> affirmations) async {
    final db = await nativeDb.database;

    List<Map<String, dynamic>> result, this_result;

    result = await db.query('SavedAffirmations');

    if (result.length > 50) {
      await db.delete('SavedAffirmations');
    }
    affirmations.forEach((element) async {
      this_result = await db
          .query('SavedAffirmations', where: "id = ?", whereArgs: [element.id]);
      if (this_result.length == 0)
        await db.insert('SavedAffirmations', element.toMap());
    });
  }

  @override
  Future<void> addInspirations(List<InspirationModel> inspirations) async {
    final db = await nativeDb.database;

    List<Map<String, dynamic>> result;

    result = await db.query('Inspirations');

    if (result.length > 50) {
      await db.delete('Inspirations');
    }
    inspirations.forEach((element) async {
      await db.insert('Inspirations', element.toMap());
    });
  }

  @override
  Future<void> addToFav(AffirmationModel affirmation) async {
    final db = await nativeDb.database;

    await db.insert('FavAffirmations', affirmation.toMap());
  }

  @override
  Future<void> deleteDayAffirmationTable() async {
    final db = await nativeDb.database;
    await db.delete('CurrentAffirmations');
  }

  @override
  Future<void> deleteFromFav(AffirmationModel affirmation) async {
    final db = await nativeDb.database;
    await db.delete('FavAffirmations');
  }

  @override
  Future<void> deleteInspirationTable() async {
    final db = await nativeDb.database;
    await db.delete('Inspirations');
  }

  @override
  Future<void> deleteSavedAffirmationsTable() async {
    final db = await nativeDb.database;
    await db.delete('SavedAffirmations');
  }

  @override
  Future<List<AffirmationModel>> get favAffirmations async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db
        .rawQuery("SELECT * FROM FavAffirmations ORDER BY RANDOM() LIMIT 5");

    List<AffirmationModel> affirmations = result.isNotEmpty
        ? result.map((item) => AffirmationModel.fromMap(item)).toList()
        : [];
    return affirmations;
  }

  @override
  Future<List<AffirmationModel>> get savedAffirmations async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db
        .rawQuery("SELECT * FROM SavedAffirmations ORDER BY RANDOM() LIMIT 5");

    List<AffirmationModel> affirmations = result.isNotEmpty
        ? result.map((item) => AffirmationModel.fromMap(item)).toList()
        : [];
    return affirmations;
  }

  @override
  Future<InspirationModel> get todayInspiration async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    result = await db
        .rawQuery("SELECT * FROM Inspirations ORDER BY RANDOM() LIMIT 1");
    List<InspirationModel> inpirations = result.isNotEmpty
        ? result.map((item) => InspirationModel.fromMap(item)).toList()
        : [
            InspirationModel(
                text: "You have the best in you",
                imageUrl: "https://source.unsplash.com/1080x1920/?inspiration")
          ];
    return inpirations[0];
  }

  @override
  Future<void> updateDayAffirmation(DayAffirmation affirmation) async {
    final db = await nativeDb.database;
    var result = await db.update("CurrentAffirmations", affirmation.toMap(),
        where: "id = ?", whereArgs: [affirmation.id]);
    print("updated");
    return result;
  }

  @override
  Future<void> addPlaceholderDetails(List<Placeholder> details) async {
    final db = await nativeDb.database;
    details.forEach((element) async {
      await db.insert('PlaceholderDetails', element.toMap());
    });
  }

  @override
  Future<void> deletePlaceHolderTable() async {
    final db = await nativeDb.database;
    await db.delete('PlaceholderDetails');
  }

  @override
  Future<List<Placeholder>> get placeholderDetails async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    result = await db.rawQuery("SELECT * FROM PlaceholderDetails");
    List<Placeholder> details = result.isNotEmpty
        ? result.map((item) => Placeholder.fromMap(item)).toList()
        : [];
    return details;
  }

  @override
  Future<void> addThumbnailDetails(List<Placeholder> details) async {
    final db = await nativeDb.database;
    details.forEach((element) async {
      await db.insert('ThumbnailDetails', element.toMap());
    });
  }

  @override
  Future<void> deleteThumbnailTable() async {
    final db = await nativeDb.database;
    await db.delete('ThumbnailDetails');
  }

  @override
  Future<List<Placeholder>> get thumbnailDetails async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    result = await db.rawQuery("SELECT * FROM ThumbnailDetails");
    List<Placeholder> details = result.isNotEmpty
        ? result.map((item) => Placeholder.fromMap(item)).toList()
        : [];
    return details;
  }

  @override
  Future<List<DayAffirmation>> get dayAffirmations async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    result = await db.rawQuery("SELECT * FROM CurrentAffirmations");
    List<DayAffirmation> details = result.isNotEmpty
        ? result.map((item) => DayAffirmation.fromMap(item)).toList()
        : [];
    return details;
  }

  @override
  Future<void> addUnsplashImagesDetails(List<UnsplashImage> details) async {
    final db = await nativeDb.database;
    details.forEach((element) async {
      await db.insert('UnsplashDetails', element.toMap());
    });
  }

  @override
  Future<void> deleteUnsplashImagesTable() async {
    final db = await nativeDb.database;
    await db.delete('UnsplashDetails');
  }

  @override
  Future<List<UnsplashImage>> get unsplashImages async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    result = await db.rawQuery("SELECT * FROM UnsplashDetails");
    List<UnsplashImage> details = result.isNotEmpty
        ? result.map((item) => UnsplashImage.fromMap(item)).toList()
        : [];
    return details;
  }

  @override
  Future<bool> doFavExists(AffirmationModel affirmation) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    result = await db
        .query('FavAffirmations', where: 'id = ?', whereArgs: [affirmation.id]);

    if (result.length > 0)
      return true;
    else
      return false;
  }

  @override
  Future<void> addChallenge(ChallengeModel challenge) async {
    final db = await nativeDb.database;

    await db.insert(challengeTable, challenge.toMap());
  }

  @override
  Future<void> addPepTalk(PepTalkModel talk) async {
    final db = await nativeDb.database;

    await db.insert(pepTalkTable, talk.toMap());
  }

  @override
  Future<void> addTaggedRecipes(List<TaggedRecipe> recipes) async {
    final db = await nativeDb.database;

    List<Map<String, dynamic>> result;

    recipes.forEach((element) async {
      await db.insert(recipeTable, element.toMap());
    });
  }

  @override
  Future<void> addTransformation(TransformationModel recipes) async {
    final db = await nativeDb.database;

    await db.insert(transformationTable, recipes.toMap());
  }

  @override
  Future<ChallengeModel> get challenge async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    result = await db.rawQuery("SELECT * FROM $challengeTable");
    List<ChallengeModel> inpirations = result.isNotEmpty
        ? result.map((item) => ChallengeModel.fromMap(item)).toList()
        : [ChallengeModel(id: -1)];
    return inpirations[0];
  }

  @override
  Future<PepTalkModel> get pepTalk async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    result = await db.rawQuery("SELECT * FROM $pepTalkTable");
    List<PepTalkModel> inpirations = result.isNotEmpty
        ? result.map((item) => PepTalkModel.fromMap(item)).toList()
        : [PepTalkModel(id: -1)];
    return inpirations[0];
  }

  @override
  Future<List<TaggedRecipe>> get taggedRecipes async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    result = await db.rawQuery("SELECT * FROM $recipeTable");
    List<TaggedRecipe> details = result.isNotEmpty
        ? result.map((item) => TaggedRecipe.fromMap(item)).toList()
        : [];
    return details;
  }

  @override
  Future<TransformationModel> get transformation async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    result = await db.rawQuery("SELECT * FROM $transformationTable");
    List<TransformationModel> inpirations = result.isNotEmpty
        ? result.map((item) => TransformationModel.fromMap(item)).toList()
        : [TransformationModel(id: -1)];
    return inpirations[0];
  }

  @override
  Future<void> deleteChallengeTable() async {
    final db = await nativeDb.database;
    await db.delete(challengeTable);
  }

  @override
  Future<void> deleteRecipeTable() async {
    final db = await nativeDb.database;
    await db.delete(recipeTable);
  }

  @override
  Future<void> deleteTalkTable() async {
    final db = await nativeDb.database;
    await db.delete(pepTalkTable);
  }

  @override
  Future<void> deleteTransformationTable() async {
    final db = await nativeDb.database;
    await db.delete(transformationTable);
  }
}
