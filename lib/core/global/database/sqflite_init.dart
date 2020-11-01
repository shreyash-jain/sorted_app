import 'package:firebase_database/firebase_database.dart';
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
  "Notebooks",
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
  "TodoItems",
  "Tasks",
  "Goals_Images",
  "TaskStatus"
];
List<String> imagePath = [];
List<int> imageTotal = [];

List<String> placeHolders = [];

class SqlDatabaseService {
  String path;

  final FirebaseDatabase fbDB = FirebaseDatabase.instance;
  StorageReference refStorage = FirebaseStorage.instance.ref();

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
          '''CREATE TABLE Notes (_id INTEGER PRIMARY KEY, saved_ts INTEGER, c_keywords TEXT,c_summary TEXT, s_value DOUBLE, book_id INTEGER, title TEXT, content TEXT, date TEXT, isImportant INTEGER);''');
      print('New table created at 1 $path');
      await db.execute(
          '''CREATE TABLE Notebooks (_id INTEGER PRIMARY KEY, saved_ts INTEGER,title TEXT, notes_num INTEGER, date TEXT, isImportant INTEGER);''');
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
          'CREATE TABLE Todos (id INTEGER PRIMARY KEY,  savedTs INTEGER,title TEXT,description TEXT, numTodoItems INTEGER, position INTEGER)');
      await db.execute(
          'CREATE TABLE TodoItems (id INTEGER PRIMARY KEY, savedTs INTEGER,todoItem TEXT,position INTEGER,description TEXT, state INTEGER)');
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
