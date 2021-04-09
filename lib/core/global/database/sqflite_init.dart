import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final todoTABLE = 'Todo';
final userTable = 'UserDetails';

List<String> tables = [
  "Revents",
  "Friends",
  "Cats",
  "Activity",
  "User_Activity",
  "Alog",
  "Notes",
  "Questions",
  "Answers",
  "UserDetails",
  "Inspirations",
  "Reminders",
  "ThumbnailDetails",
  "PlaceholderDetails",
  "SettingsDetails",
  "FavAffirmations",
  "Logs",
  "Links",
  "Tags",
  "Images",
  "Attachments",
  "Goals",
  "Todos",
  "TodoItems",
  "Tasks",
  "Tasks_Tags",
  "Tasks_Links",
  "BlockInfo",
  "BlockTextbox",
  "Goals_Images",
  "TaskStatus",
  "Todos_TodoItems",
  "BlockImage",
  "Notes_Logs",
  "Notes_Reviews",
  "Notes_Tags",
  "BlockColossal",
  "BlockSlider",
  "BlockYoutube",
  "Notes_Blocks",
  "BlockCalendarEvent",
  "BlockCalendar",
  "BlockTable",
  "BlockColumn",
  "BlockFormField",
  "BlockSequence",
  "BlockTableItem",
  "Track_Store_Search"
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

      await db.execute("CREATE TABLE Todo ("
          "id INTEGER PRIMARY KEY, "
          "event_id INTEGER, "
          "position INTEGER, "
          "description TEXT, "
          "saved_ts INTEGER, "
          /*SQLITE doesn't have boolean type
        so we store isDone as integer where 0 is false
        and 1 is true*/
          "is_done INTEGER "
          ")");

      await db.execute("CREATE TABLE Revents ("
          "id INTEGER PRIMARY KEY, "
          "event_id INTEGER, "
          "end_date TEXT, "
          "start_date TEXT, "
          "sun INTEGER, "
          "mon INTEGER, "
          "saved_ts INTEGER, "
          "tue INTEGER, "
          "wed INTEGER, "
          "thu INTEGER, "
          "fri INTEGER, "
          "sat INTEGER "
          ")");

      await db.execute("CREATE TABLE Inspirations ("
          "id INTEGER PRIMARY KEY, "
          "auther TEXT, "
          "text TEXT, "
          "imageUrl TEXT "
          ")");
      await db.execute("CREATE TABLE UserDetails ("
          "id INTEGER PRIMARY KEY, "
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
          "profession INTEGER "
          ")");
      await db.execute(
          'CREATE TABLE Friends (id INTEGER PRIMARY KEY, saved_ts INTEGER, name TEXT, total DOUBLE)');
      await db.execute(
          'CREATE TABLE Cats (id INTEGER PRIMARY KEY, saved_ts INTEGER, image TEXT,name TEXT, total DOUBLE)');

      await db.execute(
          'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');

      await db.execute(
          'CREATE TABLE Activity (id INTEGER PRIMARY KEY,  saved_ts INTEGER,image TEXT,name TEXT, weight INTEGER)');

      await db.execute(
          'CREATE TABLE User_Activity (id INTEGER PRIMARY KEY, saved_ts INTEGER, name TEXT, image TEXT, a_id INTEGER)');

      await db.execute(
          'CREATE TABLE Alog (id INTEGER PRIMARY KEY,a_id INTEGER, saved_ts INTEGER, duration INTEGER, date INTEGER)');

      await db.execute(
          '''CREATE TABLE Timelines (id INTEGER PRIMARY KEY, saved_ts INTEGER,status INTEGER, title TEXT, content TEXT, date TEXT,end_date TEXT);''');

      await db.execute(
          '''CREATE TABLE Notebooks (id INTEGER PRIMARY KEY, savedTs INTEGER,listCategory INTEGER,color TEXT, icon TEXT,description TEXT,numLogs INTEGER,numNotes INTEGER,templateId INTEGER, title TEXT, cover TEXT, noteEmoji TEXT, canDelete INTEGER,isDeleted INTEGER,isCustom INTEGER,isPublic INTEGER, assetPath TEXT);''');

      print('New table created at 2 $path');
      await db.execute(
          '''CREATE TABLE Questions (_id INTEGER PRIMARY KEY, min INTEGER, max INTEGER, content TEXT, c_name TEXT, c_id INTEGER, saved_ts INTEGER,c_streak INTEGER, l_streak INTEGER, l_interval INTEGER,v_streak TEXT,showDashboard INTEGER,  title TEXT, ans1 TEXT,ans2 TEXT,ans3 TEXT,type INTEGER, num_ans INTEGER, interval INTEGER,archive INTEGER,priority INTEGER,correct_ans INTEGER,last_date TEXT,weight DOUBLE);''');
      print('New table created at 3 $path');
      await db.execute(
          '''CREATE TABLE Answers (_id INTEGER PRIMARY KEY, date_id INTEGER, saved_ts INTEGER, c_summary TEXT,c_keywords TEXT,p_rating DOUBLE,p_ans INTEGER,  q_id INTEGER, response1 INTEGER,response2 INTEGER,response3 INTEGER,content TEXT, date TEXT,a_rating DOUBLE,discription TEXT);''');
      print('New table created at 4 $path');
      await db.execute(
          '''CREATE TABLE Reminders (_id INTEGER PRIMARY KEY, saved_ts INTEGER,note_id INTEGER, type INTEGER,content TEXT, date TEXT);''');
      await db.execute(
          'CREATE TABLE Reviews (id INTEGER PRIMARY KEY,  savedTs INTEGER,title TEXT,description TEXT,notificationTitle TEXT,startDate TEXT,endDate TEXT,time TEXT, imagePath TEXT, sun INTEGER, mon INTEGER, tue INTEGER, wed INTEGER, thu INTEGER, fri INTEGER, sat INTEGER, type INTEGER, remind INTEGER,frequency INTEGER)');

      await db.execute(
          'CREATE TABLE Attachments (id INTEGER PRIMARY KEY,  savedTs INTEGER,title TEXT,description TEXT, url TEXT, length DOUBLE, position INTEGER, type INTEGER, canDetete INTEGER, typeString TEXT, storagePath INTEGER, localPath TEXT )');
      await db.execute(
          'CREATE TABLE Logs (id INTEGER PRIMARY KEY, connectedId INTEGER, level INTEGER, savedTs INTEGER,message TEXT,date INTEGER, path TEXT, type INTEGER)');
      await db.execute(
          'CREATE TABLE Tags (id INTEGER PRIMARY KEY,  url TEXT,tag TEXT,color TEXT, savedTs INTEGER, items INTEGER)');
      // await db.execute(
      //     'CREATE TABLE Dates (id INTEGER PRIMARY KEY,  savedTs TEXT,appOpened INTEGER,date TEXT, dateFormatted Text, dateMilliSec INTEGER)');
      await db.execute(
          'CREATE TABLE Images (id INTEGER PRIMARY KEY, canDetete INTEGER, savedTs INTEGER,localPath TEXT,caption TEXT,storagePath TEXT, url TEXT, position INTEGER)');
      await db.execute(
          'CREATE TABLE Links (id INTEGER PRIMARY KEY,  savedTs INTEGER,siteName TEXT,image TEXT, url TEXT, title TEXT, description TEXT, position INTEGER)');
      await db.execute(
          'CREATE TABLE Goals (id INTEGER PRIMARY KEY, markCompleted INTEGER, coverImageId TEXT, goalImageId TEXT, savedTs INTEGER,title TEXT,description TEXT, startDate INTEGER,deadLine INTEGER,vision TEXT, progress DOUBLE,linkedTasks INTEGER,linkedImages INTEGER,linkedLinks INTEGER,linkedLogs INTEGER,linkedTracks INTEGER,linkedNotes INTEGER,linkedStatus INTEGER)');
      await db.execute(
          'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, coverImageId TEXT, taskImageId TEXT, savedTs INTEGER,title TEXT,description TEXT, startDate INTEGER,deadLine INTEGER, duration DOUBLE,priority DOUBLE,progress DOUBLE,linkedTags INTEGER,linkedGoals INTEGER,linkedReviews INTEGER,linkedActivities INTEGER,type INTEGER,linkedImages INTEGER,linkedLinks INTEGER,linkedLogs INTEGER,linkedDependencies INTEGER,linkedStatus INTEGER,linkedTodos INTEGER)');
      await db.execute(
          'CREATE TABLE Todos (id INTEGER PRIMARY KEY,  unit TEXT, searchId INTEGER, type INTEGER, operation INTEGER, savedTs INTEGER,title TEXT,description TEXT, numTodoItems INTEGER, position INTEGER)');
      await db.execute(
          'CREATE TABLE TodoItems (id INTEGER PRIMARY KEY, value DOUBLE, url TEXT,unit TEXT, savedTs INTEGER,todoItem TEXT,position INTEGER,todolistId INTEGER,description TEXT, state INTEGER)');
      await db.execute(
          'CREATE TABLE TaskStatus (id INTEGER PRIMARY KEY,canDelete INTEGER,numItems INTEGER, savedTs INTEGER,status INTEGER,imagePath TEXT)');
      await db.execute(
          'CREATE TABLE Goals_Images (goal_id INTEGER, image_id INTEGER,savedTs INTEGER,id INTEGER PRIMARY KEY)');
      await db.execute(
          'CREATE TABLE Goals_Attachments (goal_id INTEGER, attachment_id INTEGER,savedTs INTEGER,id INTEGER PRIMARY KEY)');
      await db.execute(
          'CREATE TABLE Goals_Tags (goal_id INTEGER, tag_id INTEGER,savedTs INTEGER,id INTEGER PRIMARY KEY)');
      await db.execute(
          'CREATE TABLE Goals_Links (goal_id INTEGER, link_id INTEGER,savedTs INTEGER,id INTEGER PRIMARY KEY)');
      await db.execute(
          'CREATE TABLE Goals_Logs (goal_id INTEGER, log_id INTEGER,savedTs INTEGER,id INTEGER PRIMARY KEY)');
      await db.execute(
          'CREATE TABLE Goals_Textboxes (goal_id INTEGER, textbox_id INTEGER,savedTs INTEGER,id INTEGER PRIMARY KEY)');
      await db.execute(
          'CREATE TABLE Goals_Tasks (goal_id INTEGER, task_id INTEGER,savedTs INTEGER,id INTEGER PRIMARY KEY)');
      await db.execute(
          'CREATE TABLE Textboxes (text TEXT, position INTEGER,savedTs INTEGER,date INTEGER,auther TEXT,id INTEGER PRIMARY KEY)');
      await db.execute(
          'CREATE TABLE Tasks_Images (task_id INTEGER, image_id INTEGER,savedTs INTEGER,id INTEGER PRIMARY KEY)');
      await db.execute(
          'CREATE TABLE Tasks_Attachments (task_id INTEGER, attachment_id INTEGER,savedTs INTEGER,id INTEGER PRIMARY KEY)');
      await db.execute(
          'CREATE TABLE Tasks_Tags (task_id INTEGER, tag_id INTEGER,savedTs INTEGER,id INTEGER PRIMARY KEY)');
      await db.execute(
          'CREATE TABLE Tasks_Links (task_id INTEGER, link_id INTEGER,savedTs INTEGER,id INTEGER PRIMARY KEY)');
      await db.execute(
          'CREATE TABLE Tasks_Logs (task_id INTEGER, log_id INTEGER,savedTs INTEGER,id INTEGER PRIMARY KEY)');
      await db.execute(
          'CREATE TABLE Tasks_Todos (task_id INTEGER, todo_id INTEGER,savedTs INTEGER,id INTEGER PRIMARY KEY)');
      await db.execute(
          'CREATE TABLE Tasks_Reviews (task_id INTEGER, review_id INTEGER,savedTs INTEGER,id INTEGER PRIMARY KEY)');
      await db.execute(
          'CREATE TABLE Tasks_Status (task_id INTEGER, status_id INTEGER,savedTs INTEGER,id INTEGER PRIMARY KEY)');
      await db.execute(
          'CREATE TABLE Tasks_Activities (task_id INTEGER, activity_id INTEGER,savedTs INTEGER,id INTEGER PRIMARY KEY)');
      await db.execute(
          'CREATE TABLE Tasks_Tasks (task_id INTEGER, dependency_id INTEGER,savedTs INTEGER,id INTEGER PRIMARY KEY)');
      await db.execute(
          'CREATE TABLE Todos_TodoItems (todo_id INTEGER, todoitem_id INTEGER,savedTs INTEGER,id INTEGER PRIMARY KEY)');

      await db.execute(
          'CREATE TABLE Notes (id INTEGER PRIMARY KEY, savedTs INTEGER,icon INTEGER,decoration INTEGER,numLogs INTEGER,startDate INTEGER,numReviews INTEGER,numBlocks INTEGER,numTags INTEGER, notebookId INTEGER, title TEXT, cover TEXT, noteEmoji TEXT, canDelete INTEGER,isDeleted INTEGER);');
      await db.execute(
          'CREATE TABLE BlockInfo (id INTEGER PRIMARY KEY, savedTs INTEGER,type INTEGER,height DOUBLE,itemId INTEGER,position INTEGER);');
      await db.execute(
          'CREATE TABLE BlockTextbox (id INTEGER PRIMARY KEY, savedTs INTEGER,decoration INTEGER,title TEXT,isRich INTEGER,imagePath TEXT,text TEXT,iconData INTEGER,color1 INTEGER,color2 INTEGER);');
      await db.execute(
          'CREATE TABLE BlockImage (id INTEGER PRIMARY KEY, savedTs INTEGER,decoration INTEGER,colossalId INTEGER,title TEXT,imagePath TEXT,caption TEXT,url TEXT,iconData INTEGER,color1 INTEGER,color2 INTEGER,remotePath TEXT);');
      await db.execute(
          'CREATE TABLE BlockColossal (id INTEGER PRIMARY KEY, savedTs INTEGER,decoration INTEGER,title TEXT,numImages INTEGER);');
      await db.execute(
          'CREATE TABLE BlockYoutube (id INTEGER PRIMARY KEY, savedTs INTEGER,title TEXT,videoId TEXT);');
      await db.execute(
          'CREATE TABLE BlockSlider (id INTEGER PRIMARY KEY, savedTs INTEGER,title TEXT, maxItem TEXT, minItem TEXT, value DOUBLE, isNotInt INTEGER, decoration INTEGER, min DOUBLE, max DOUBLE);');
      await db.execute(
          'CREATE TABLE BlockFormField (id INTEGER PRIMARY KEY, savedTs INTEGER,field TEXT,fieldValue TEXT,url TEXT,type INTEGER, decoration INTEGER);');
      await db.execute(
          'CREATE TABLE BlockTable (id INTEGER PRIMARY KEY, savedTs INTEGER,title TEXT,rows INTEGER,cols INTEGER, decoration INTEGER);');
      await db.execute(
          'CREATE TABLE BlockColumn (id INTEGER PRIMARY KEY, savedTs INTEGER,title TEXT,color TEXT,tableId INTEGER,type INTEGER, position INTEGER, isFirstCol INTEGER, isLastCol INTEGER, width DOUBLE);');
      await db.execute(
          'CREATE TABLE BlockTableItem (id INTEGER PRIMARY KEY, savedTs INTEGER,value TEXT,color TEXT,type INTEGER, colId INTEGER, align INTEGER);');
      await db.execute(
          'CREATE TABLE BlockCalendar (id INTEGER PRIMARY KEY, savedTs INTEGER,title TEXT,startDate INTEGER,view INTEGER, decoration INTEGER, numEvents INTEGER);');
      await db.execute(
          'CREATE TABLE BlockCalendarEvent (id INTEGER PRIMARY KEY, savedTs INTEGER,title TEXT,date INTEGER,state INTEGER, taskId INTEGER, type INTEGER,calId INTEGER);');
      await db.execute(
          'CREATE TABLE BlockSequence (id INTEGER PRIMARY KEY, savedTs INTEGER,title TEXT,date INTEGER,decoration INTEGER, content TEXT);');

      await db.execute(
          'CREATE TABLE Notes_Blocks (note_id INTEGER, block_id INTEGER,savedTs INTEGER,id INTEGER PRIMARY KEY)');
      await db.execute(
          'CREATE TABLE Notes_Tags (note_id INTEGER, tag_id INTEGER,savedTs INTEGER,id INTEGER PRIMARY KEY)');
      await db.execute(
          'CREATE TABLE Notes_Logs (note_id INTEGER, log_id INTEGER,savedTs INTEGER,id INTEGER PRIMARY KEY)');
      await db.execute(
          'CREATE TABLE Notes_Reviews (note_id INTEGER, review_id INTEGER,savedTs INTEGER,id INTEGER PRIMARY KEY)');
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
