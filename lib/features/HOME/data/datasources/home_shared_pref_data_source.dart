import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorted/core/error/exceptions.dart';

abstract class HomeSharedPref {
  Future<DateTime> get lastUpdatedAffirmation;
  Future<DateTime> get lastUpdatedInspiration;
  Future<DateTime> get lastUpdatedThumbnailDetail;
  Future<DateTime> get lastUpdatedPlaceholderDetail;
  Future<int> get signInId;
  Future<String> get currentDevice;
  Future<bool> get loggedInState;
  Future<void> updateDeviceName(String name);
  Future<void> updateAffirmation(DateTime filled);
  Future<void> updateInspiration(DateTime filled);
  Future<void> updateThumbnailDetail(DateTime filled);
  Future<void> updatePlaceholderDetail(DateTime filled);

  Future<DateTime> get lastUpdatedPepTalk;
  Future<DateTime> get lastUpdatedChallenge;
  Future<DateTime> get lastUpdatedTranformationStory;
  Future<DateTime> get lastUpdatedInfo;
  Future<DateTime> get lastUpdatedRecipes;

  Future<void> updatePeptalk(DateTime filled);
  Future<void> updateChallenge(DateTime filled);
  Future<void> updateTransformationStory(DateTime filled);
  Future<void> updateInfo(DateTime filled);
  Future<void> updateRecipes(DateTime filled);
}

const LOGGED_IN_STATE_TAG = 'LoggedIn';
const SIGN_IN_ID_TAG = 'google_name';
const LAST_UPDATED_INSPIRATIONS_TAG = 'inspiration_last_updated';
const LAST_UPDATED_AFFIRMATIONS_TAG = 'affirmations_last_updated';
const LAST_UPDATED_THUMBNAILS_TAG = 'thumbnail_last_updated';
const LAST_UPDATED_PLACEHOLDER_TAG = 'placeholder_last_updated';
const CURRENT_DEVICE_NAME_ID_TAG = 'device_name';
const LAST_UPDATED_CHALLENGE_TAG = 'challenge_last_updated';
const LAST_UPDATED_INFO_TAG = 'updated_last_info';
const LAST_UPDATED_PEPTALK_TAG = 'updated_last_peptalk';
const LAST_UPDATED_TSTORY_TAG = 'updated_last_tstory';
const LAST_UPDATED_RECIPE_TAG = 'updated_last_recipe';

class HomeSharedPrefDataSourceImpl implements HomeSharedPref {
  final SharedPreferences sharedPreferences;

  HomeSharedPrefDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<DateTime> get lastUpdatedAffirmation async {
    String lastUpdatedAffirmation =
        DateTime.now().add(Duration(days: -10)).toIso8601String();
    if (sharedPreferences.getString(LAST_UPDATED_AFFIRMATIONS_TAG) != null) {
      lastUpdatedAffirmation =
          sharedPreferences.getString(LAST_UPDATED_AFFIRMATIONS_TAG);
    }

    try {
      return Future.value(DateTime.parse(lastUpdatedAffirmation));
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<DateTime> get lastUpdatedInspiration async {
    String lastUpdatedInspiration =
        DateTime.now().add(Duration(days: -10)).toIso8601String();
    if (sharedPreferences.getString(LAST_UPDATED_INSPIRATIONS_TAG) != null) {
      lastUpdatedInspiration =
          sharedPreferences.getString(LAST_UPDATED_INSPIRATIONS_TAG);
    }

    try {
      return Future.value(DateTime.parse(lastUpdatedInspiration));
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<DateTime> get lastUpdatedPlaceholderDetail async {
    String lastUpdatedPlaceholderDetail =
        DateTime.now().add(Duration(days: -10)).toIso8601String();
    if (sharedPreferences.getString(LAST_UPDATED_PLACEHOLDER_TAG) != null) {
      lastUpdatedPlaceholderDetail =
          sharedPreferences.getString(LAST_UPDATED_PLACEHOLDER_TAG);
    }

    try {
      return Future.value(DateTime.parse(lastUpdatedPlaceholderDetail));
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<DateTime> get lastUpdatedThumbnailDetail async {
    String lastUpdatedPlaceholderDetail =
        DateTime.now().add(Duration(days: -10)).toIso8601String();
    if (sharedPreferences.getString(LAST_UPDATED_THUMBNAILS_TAG) != null) {
      lastUpdatedPlaceholderDetail =
          sharedPreferences.getString(LAST_UPDATED_THUMBNAILS_TAG);
    }

    try {
      return Future.value(DateTime.parse(lastUpdatedPlaceholderDetail));
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<bool> get loggedInState async {
    bool oldState = false;
    if (sharedPreferences.getBool(LOGGED_IN_STATE_TAG) != null) {
      oldState = sharedPreferences.getBool(LOGGED_IN_STATE_TAG);
    }

    try {
      return Future.value(oldState);
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<int> get signInId async {
    int signInId = 0;
    if (sharedPreferences.getInt(SIGN_IN_ID_TAG) != null) {
      signInId = sharedPreferences.getInt(SIGN_IN_ID_TAG);
    }

    try {
      return Future.value(signInId);
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<void> updateAffirmation(DateTime filled) async {
    try {
      sharedPreferences.setString(
          LAST_UPDATED_AFFIRMATIONS_TAG, filled.toIso8601String());
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<void> updateInspiration(DateTime filled) async {
    try {
      sharedPreferences.setString(
          LAST_UPDATED_INSPIRATIONS_TAG, filled.toIso8601String());
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<void> updatePlaceholderDetail(DateTime filled) async {
    try {
      sharedPreferences.setString(
          LAST_UPDATED_PLACEHOLDER_TAG, filled.toIso8601String());
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<void> updateThumbnailDetail(DateTime filled) async {
    try {
      sharedPreferences.setString(
          LAST_UPDATED_THUMBNAILS_TAG, filled.toIso8601String());
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<String> get currentDevice async {
    String currentDevice = "";
    if (sharedPreferences.getString(CURRENT_DEVICE_NAME_ID_TAG) != null) {
      currentDevice = sharedPreferences.getString(CURRENT_DEVICE_NAME_ID_TAG);
    }

    try {
      return Future.value(currentDevice);
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<void> updateDeviceName(String name) async {
    try {
      sharedPreferences.setString(CURRENT_DEVICE_NAME_ID_TAG, name);
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<DateTime> get lastUpdatedChallenge async {
    String lastUpdatedValue =
        DateTime.now().add(Duration(days: -10)).toIso8601String();
    if (sharedPreferences.getString(LAST_UPDATED_CHALLENGE_TAG) != null) {
      lastUpdatedValue =
          sharedPreferences.getString(LAST_UPDATED_CHALLENGE_TAG);
    }

    try {
      return Future.value(DateTime.parse(lastUpdatedValue));
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<DateTime> get lastUpdatedInfo async {
    String lastUpdatedValue =
        DateTime.now().add(Duration(days: -10)).toIso8601String();
    if (sharedPreferences.getString(LAST_UPDATED_INFO_TAG) != null) {
      lastUpdatedValue = sharedPreferences.getString(LAST_UPDATED_INFO_TAG);
    }

    try {
      return Future.value(DateTime.parse(lastUpdatedValue));
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<DateTime> get lastUpdatedPepTalk async {
    String lastUpdatedValue =
        DateTime.now().add(Duration(days: -10)).toIso8601String();
    if (sharedPreferences.getString(LAST_UPDATED_PEPTALK_TAG) != null) {
      lastUpdatedValue = sharedPreferences.getString(LAST_UPDATED_PEPTALK_TAG);
    }

    try {
      return Future.value(DateTime.parse(lastUpdatedValue));
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<DateTime> get lastUpdatedRecipes async {
    String lastUpdatedValue =
        DateTime.now().add(Duration(days: -10)).toIso8601String();
    if (sharedPreferences.getString(LAST_UPDATED_RECIPE_TAG) != null) {
      lastUpdatedValue = sharedPreferences.getString(LAST_UPDATED_RECIPE_TAG);
    }

    try {
      return Future.value(DateTime.parse(lastUpdatedValue));
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<DateTime> get lastUpdatedTranformationStory async {
    String lastUpdatedValue =
        DateTime.now().add(Duration(days: -10)).toIso8601String();
    if (sharedPreferences.getString(LAST_UPDATED_TSTORY_TAG) != null) {
      lastUpdatedValue = sharedPreferences.getString(LAST_UPDATED_TSTORY_TAG);
    }

    try {
      return Future.value(DateTime.parse(lastUpdatedValue));
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<void> updateChallenge(DateTime filled) {
    try {
      sharedPreferences.setString(
          LAST_UPDATED_CHALLENGE_TAG, filled.toIso8601String());
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<void> updateInfo(DateTime filled) {
    try {
      sharedPreferences.setString(
          LAST_UPDATED_INFO_TAG, filled.toIso8601String());
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<void> updatePeptalk(DateTime filled) {
    try {
      sharedPreferences.setString(
          LAST_UPDATED_PEPTALK_TAG, filled.toIso8601String());
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<void> updateRecipes(DateTime filled) {
    try {
      sharedPreferences.setString(
          LAST_UPDATED_RECIPE_TAG, filled.toIso8601String());
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<void> updateTransformationStory(DateTime filled) {
    try {
      sharedPreferences.setString(
          LAST_UPDATED_TSTORY_TAG, filled.toIso8601String());
    } on Exception {
      throw CacheException();
    }
  }
}
