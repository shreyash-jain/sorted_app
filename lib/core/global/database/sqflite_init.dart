import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final todoTABLE = 'Todo';
final userTable = 'UserDetails';
final recipeTable = 'TaggedRecipes';
final challengeTable = 'ChallengeModel';
final pepTalkTable = 'PepTalk';
final transformationTable = 'TransformationModel';

List<String> tables = [
  "UserDetails",
  "Inspirations",
  "ThumbnailDetails",
  "PlaceholderDetails",
  "SettingsDetails",
  "FavAffirmations",
  "Logs",
  "Tags",
];

List<String> imagePath = [];
List<int> imageTotal = [];

List<String> placeHolders = [];

class SqlDatabaseService {
  String path;

  Reference refStorage = FirebaseStorage.instance.ref();

  Batch batch;
  SqlDatabaseService._();

  static final SqlDatabaseService db = SqlDatabaseService._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await init();
    return _database;
  }

  init() async {
    String path = await getDatabasesPath();
    path = join(path, 'sorted.db');
    print("Entered path $path");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE FavAffirmations ("
          "id INTEGER PRIMARY KEY, "
          "text TEXT, "
          "imageUrl TEXT, "
          "category TEXT "
          ")");
      await db.execute("CREATE TABLE SavedAffirmations ("
          "id INTEGER PRIMARY KEY, "
          "text TEXT, "
          "imageUrl TEXT, "
          "category TEXT "
          ")");
      await db.execute("CREATE TABLE CurrentAffirmations ("
          "id INTEGER PRIMARY KEY, "
          "cloudId INTEGER, "
          "text TEXT, "
          "lastSeen TEXT, "
          "category TEXT, "
          "thumbnailUrl TEXT, "
          "profileLink TEXT, "
          "photoGrapherName TEXT, "
          "sImageUrl TEXT, "
          "downloadLink TEXT, "
          "imageUrl TEXT, "
          "isFav INTEGER, "
          "waitSeconds INTEGER, "
          "read INTEGER "
          ")");
      await db.execute("CREATE TABLE PlaceholderDetails ("
          "name TEXT, "
          "path TEXT, "
          "total INTEGER "
          ")");

      await db.execute("CREATE TABLE UnsplashDetails ("
          "imageUrl TEXT, "
          "imageUrlThumb TEXT, "
          "profileLink TEXT, "
          "firstName TEXT, "
          "lastName TEXT, "
          "downloadLink TEXT "
          ")");

      await db.execute("CREATE TABLE SettingsDetails ("
          "unfilledSurveyPreference INTEGER, "
          "currency TEXT, "
          "reminderTime TEXT, "
          "theme TEXT, "
          "surveyTime INTEGER, "
          "budget DOUBLE "
          ")");
      await db.execute("CREATE TABLE ThumbnailDetails ("
          "name TEXT, "
          "path TEXT, "
          "total INTEGER "
          ")");

      await db.execute("CREATE TABLE Inspirations ("
          "id INTEGER PRIMARY KEY, "
          "auther TEXT, "
          "text TEXT, "
          "imageUrl TEXT "
          ")");
      await db.execute("CREATE TABLE UserDetails ("
          "id TEXT, "
          "name TEXT, "
          "imageUrl TEXT, "
          "email TEXT, "
          "userName TEXT, "
          "currentDeviceId INTEGER, "
          "currentDevice TEXT, "
          "age INTEGER, "
          "diary_streak INTEGER, "
          "points INTEGER, "
          "level INTEGER, "
          "gender INTEGER, "
          "profession INTEGER, "
          "status TEXT, "
          "mobileNumber INTEGER "
          ")");

      await db.execute(
          'CREATE TABLE Attachments (id INTEGER PRIMARY KEY,  savedTs INTEGER,title TEXT,description TEXT, url TEXT, length DOUBLE, position INTEGER, type INTEGER, canDetete INTEGER, typeString TEXT, storagePath INTEGER, localPath TEXT )');
      await db.execute(
          'CREATE TABLE Logs (id INTEGER PRIMARY KEY, connectedId INTEGER, level INTEGER, savedTs INTEGER,message TEXT,date INTEGER, path TEXT, type INTEGER)');
      await db.execute(
          'CREATE TABLE Tags (id INTEGER PRIMARY KEY,  url TEXT,tag TEXT,color TEXT, savedTs INTEGER, items INTEGER)');
      // await db.execute(
      //     'CREATE TABLE Dates (id INTEGER PRIMARY KEY,  savedTs TEXT,appOpened INTEGER,date TEXT, dateFormatted Text, dateMilliSec INTEGER)');
      await db.execute(
          'CREATE TABLE TaggedRecipes ( difficulty TEXT,  id INTEGER,  is_breakfast TEXT,  is_dieting TEXT,  is_dinner TEXT,  is_healthy TEXT,  is_high_calorie TEXT,  is_high_protien TEXT,  is_kapha_balancing TEXT,  is_keto TEXT,  is_loose_weight TEXT ,  is_low_cholesterol TEXT,  is_low_sugar TEXT,  is_lunch TEXT,  is_pitta_balancing TEXT,  is_pregnency TEXT,  is_sattvik TEXT,  is_vata_balancing TEXT,  is_vegan TEXT,  is_vegetarian TEXT,  is_weight_gain TEXT,  name TEXT,  recipe_id INTEGER,  recipe_link TEXT,  image_url TEXT,  description TEXT )');

      await db.execute(
          'CREATE TABLE TransformationModel ( image_url TEXT,  id INTEGER,  person TEXT, source_title TEXT, source_link TEXT,  story TEXT,  title TEXT )');

      await db.execute(
          'CREATE TABLE PepTalk ( content TEXT,  id INTEGER,  imageUrl TEXT,  fileLink TEXT,  title TEXT )');
      await db.execute(
          'CREATE TABLE ChallengeModel ( category INTEGER,  id INTEGER,  output_type INTEGER,  type INTEGER,  name TEXT )');

      await db.execute(
          'CREATE TABLE Track_Store_Search (id INTEGER PRIMARY KEY, track_id INTEGER, track_name TEXT, track_icon TEXT)');
      await db.execute("""CREATE TABLE Sub_Tracks (id INTEGER PRIMARY KEY,
              name TEXT,
              m_description TEXT,
              is_m_description_rich INTEGER,
              m_facts TEXT,
              is_m_facts_rich INTEGER,
              m_reward TEXT,
              is_m_reward_rich INTEGER,
              icon TEXT,
              m_banner TEXT,
              m_level INTEGER,
              m_u_freq INTEGER,
              ts_multifil INTEGER,
              ts_log_types INTEGER,
              ts_root_logging_db_path TEXT,
              m_db_string TEXT,
              m_custom_db_string TEXT,
              m_template_string TEXT,
              m_db_icon TEXT,
              m_custom_db_icon TEXT,
              m_template_icon TEXT,

              u_root_level_logging_saved_path TEXT,
              u_root_level_logging_history_path TEXT,
              has_market_detail INTEGER,
              ts_num_properties INTEGER,
              m_num_subs INTEGER,
              u_chat_groups INTEGER,
              m_num_expert_groups INTEGER,
              num_comments INTEGER,
              m_recent_subs INTEGER,
              m_string_1 TEXT,
              m_string_2 TEXT,
              m_color TEXT,
              saved_ts INTEGER,
              u_sub_ts INTEGER,
              u_sub_end_ts INTEGER,
              m_rating DOUBLE,
              ts_default_sub_days INTEGER,
              u_first_fill INTEGER,
              u_last_fill INTEGER,
              u_num_fills INTEGER,
              u_habit_score DOUBLE,
              u_expert_sub INTEGER,
              u_friends_sub INTEGER,
              ts_can_delete INTEGER,
              ts_autofill INTEGER,
              ts_permission_type INTEGER,
              ts_autofill_freq INTEGER,
              u_last_autofill_ts INTEGER,
              ts_has_confirmation INTEGER,
              ts_templates_path TEXT,
              ts_combined_db_path TEXT,

              u_active_state INTEGER,
              u_pause_open_ts INTEGER,
              ts_reminder_state INTEGER,
              ts_reminder_text TEXT,
              ts_reminder_sub_text TEXT,
              ts_reminder_week_day_sun INTEGER,
              ts_reminder_week_day_mon INTEGER,
              ts_reminder_week_day_tue INTEGER,
              ts_reminder_week_day_wed INTEGER,
              ts_reminder_week_day_thu INTEGER,
              ts_reminder_week_day_fri INTEGER,
              ts_reminder_week_day_sat INTEGER,
              ts_reminder_interval_days INTEGER,
              ts_reminder_day_state INTEGER,
              ts_reminder_day_start_ts INTEGER,
              ts_reminder_day_end_ts INTEGER,
              u_last_reminded_ts INTEGER,
              ts_realtime_id INTEGER)""");

      await db.execute("""CREATE TABLE Track_Properties (id INTEGER PRIMARY KEY,
              track_id INTEGER,
              property_type INTEGER,
              property_name TEXT,
              property_key TEXT,
              property_description TEXT,
              property_question TEXT,
              property_icon_url TEXT,
              priority INTEGER,
              is_required INTEGER,
              is_active INTEGER,
              is_move_ahead INTEGER,
              auto_fill_status INTEGER,
              last_autofill_ts INTEGER,
              default_db_path TEXT,
              u_history_path TEXT,
              custom_user_path TEXT,
              t_text_length INTEGER,
              t_limit INTEGER,
              t_is_rich INTEGER,
              t_hint_text TEXT,
              n_after_decimal INTEGER,
              n_hint_text TEXT,
              n_min DOUBLE,
              n_max DOUBLE,
              n_unit TEXT,
              n_unit_val INTEGER,
              n_u_aim_start DOUBLE,
              n_u_aim_end DOUBLE,
              n_aim_type INTEGER,
              n_default_unit_id INTEGER,
              n_u_unfilled_autofill INTEGER,
              n_u_aim_condition INTEGER,
              n_stat_condition INTEGER,
              n_possible_units_list_id INTEGER,
              el_max_items INTEGER,
              el_hint_text TEXT,
              el_aim_limit INTEGER,
              el_default_aim_limit INTEGER,
              el_aim_condition INTEGER,
              el_is_multi_choice INTEGER,
              rl_item_num INTEGER,
              rl_aim_limit INTEGER,
              rl_default_aim_limit INTEGER,
              rl_hint_text TEXT,
              rl_is_multi_choice INTEGER,
              erl_item_num INTEGER,
              erl_hint_text TEXT,
              erl_is_multi_choice INTEGER,
              erl_aim_limit INTEGER,
              erl_default_aim_limit INTEGER,
              erl_property_link TEXT,
              erl_operation_type INTEGER,
              d_default_start_time INTEGER,
              d_u_start_time INTEGER,
              d_default_interval_time INTEGER,
              d_u_interval_time INTEGER,
              d_max_duration_min INTEGER,
              d_start_time_ts INTEGER,
              d_is_realtime INTEGER,
              l_num_levels INTEGER,
              l_map_level_path TEXT,
              l_map_image_path TEXT,
              l_u_start_level INTEGER,
              r_max INTEGER,
              r_map_value_path TEXT,
              i_url TEXT,
              i_cloud_path TEXT,
              i_width DOUBLE,
              i_height DOUBLE,
              FOREIGN KEY(track_id) REFERENCES Sub_Tracks(id))""");

      print('New table created at $path');
    });
  }

  Future<void> cleanDatabase() async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        var batch = txn.batch();
        for (int i = 0; i < tables.length; i++) {
          batch.delete(tables[i]);
        }

        await batch.commit();
        print("deleted all data");
      });
    } catch (error) {
      throw Exception('DbBase.cleanDatabase: ' + error.toString());
    }
  }

  //We are not going to use this in the demo

}
