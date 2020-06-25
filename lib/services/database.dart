

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/data/answer.dart';
import 'package:notes/data/date.dart';
import 'package:notes/data/eCat.dart';
import 'package:notes/data/event.dart';
import 'package:notes/data/rEvent.dart';
import 'package:notes/data/expense.dart';
import 'package:notes/data/timeline.dart';
import 'package:notes/data/friend.dart';
import 'package:notes/data/notebook.dart';
import 'package:notes/data/question.dart';
import 'package:notes/data/reminder.dart';
import 'package:notes/data/activity.dart';
import 'package:notes/data/user_activity.dart';
import 'package:notes/data/activityLog.dart';
import 'package:notes/data/todo.dart';
import 'package:notes/services/auth.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/src/observables/observable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_porter/utils/csv_utils.dart';
import '../data/models.dart';
import 'dart:io';
final todoTABLE = 'Todo';

List<String> tables=[
  "Todo",
  "Dates",
  "Events",
  "Revents",
  "Expenses",
  "Friends",
  "Cats",
  "Activity",
  "User_Activity",
  "Alog",
  "Timelines",
  "Notes",
  "Notebooks",
  "Questions",
  "Answers",
  "Reminders"





];
List<String> imagePath=[];
List<int> imageTotal=[];

List<String> placeHolders=[];

class NotesDatabaseService {
  String path;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _fireDB = Firestore.instance;
 final FirebaseDatabase fbDB= FirebaseDatabase.instance;
  StorageReference refStorage = FirebaseStorage.instance.ref();
  final _random = new Random();

  Batch batch;
  NotesDatabaseService._();

  static final NotesDatabaseService db = NotesDatabaseService


      ._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await init();
    return _database;
  }

  init() async {
    String path = await getDatabasesPath();
    path = join(path, 'notes.db');
    print("Entered path $path");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {

      await db.execute("CREATE TABLE Todo ("
          "id INTEGER PRIMARY KEY, "
          "event_id INTEGER, "
          "position INTEGER, "
          "description TEXT, "
          "saved_ts TEXT, "
      /*SQLITE doesn't have boolean type
        so we store isDone as integer where 0 is false
        and 1 is true*/
          "is_done INTEGER "
          ")");
      await db.execute("CREATE TABLE Dates ("
          "id INTEGER PRIMARY KEY, "
          "date TEXT, "
          "time_start TEXT, "
          "time_end TEXT, "
          "saved_ts TEXT, "
          "dayName TEXT, "
          "ImageUrl TEXT, "
          "a_rating DOUBLE, "
          "p_rating DOUBLE, "

          "l_streak INTEGER, "
          "l_interval INTEGER, "
          "c_streak INTEGER, "
          "survey INTEGER "
      /*SQLITE doesn't have boolean type
        so we store isDone as integer where 0 is false
        and 1 is true*/

          ")");
      await db.execute("CREATE TABLE Events ("
          "id INTEGER PRIMARY KEY, "
          "todo_id INTEGER, "
          "date_id INTEGER, "
          "content TEXT, "
          "a_id INTEGER, "
          "cal_id TEXT, "
          "saved_ts TEXT, "
          "title TEXT, "
          "timeline_id INTEGER, "
          "date TEXT, "
          "time TEXT, "
          "isImportant INTEGER, "
      "duration DOUBLE, "
      "r_id INTEGER "
          ")");
      await db.execute("CREATE TABLE Revents ("
          "id INTEGER PRIMARY KEY, "
          "event_id INTEGER, "
          "end_date TEXT, "
          "start_date TEXT, "
          "sun INTEGER, "
          "mon INTEGER, "
          "saved_ts TEXT, "
          "tue INTEGER, "
          "wed INTEGER, "
          "thu INTEGER, "
          "fri INTEGER, "
          "sat INTEGER "
          ")");

      await db.execute("CREATE TABLE Expenses ("
          "id INTEGER PRIMARY KEY, "
          "friend_id INTEGER, "
          "cat_id INTEGER, "
          "date_id INTEGER, "
          "content TEXT, "
          "title TEXT, "
          "saved_ts TEXT, "
          "date TEXT, "
          "money DOUBLE, "
          "type INTEGER "
          ")");
      await db.execute(
          'CREATE TABLE Friends (id INTEGER PRIMARY KEY, saved_ts TEXT, name TEXT, total DOUBLE)');
      await db.execute(
          'CREATE TABLE Cats (id INTEGER PRIMARY KEY, saved_ts TEXT, image TEXT,name TEXT, total DOUBLE)');

      await db.execute(
          'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');

      await db.execute(
          'CREATE TABLE Activity (id INTEGER PRIMARY KEY,  saved_ts TEXT,image TEXT,name TEXT, weight INTEGER)');

      await db.execute(
          'CREATE TABLE User_Activity (id INTEGER PRIMARY KEY, saved_ts TEXT, name TEXT, image TEXT, a_id INTEGER)');

      await db.execute(
          'CREATE TABLE Alog (id INTEGER PRIMARY KEY,a_id INTEGER, saved_ts TEXT, duration INTEGER, date TEXT)');

      await db.execute(
          '''CREATE TABLE Timelines (id INTEGER PRIMARY KEY, saved_ts TEXT,status INTEGER, title TEXT, content TEXT, date TEXT,end_date TEXT);''');

      await db.execute(
          '''CREATE TABLE Notes (_id INTEGER PRIMARY KEY, saved_ts TEXT, c_keywords TEXT,c_summary TEXT, s_value DOUBLE, book_id INTEGER, title TEXT, content TEXT, date TEXT, isImportant INTEGER);''');
      print('New table created at 1 $path');
      await db.execute(
          '''CREATE TABLE Notebooks (_id INTEGER PRIMARY KEY, saved_ts TEXT,title TEXT, notes_num INTEGER, date TEXT, isImportant INTEGER);''');
      print('New table created at 2 $path');
      await db.execute(
          '''CREATE TABLE Questions (_id INTEGER PRIMARY KEY, min INTEGER, max INTEGER, content TEXT, c_name TEXT, c_id INTEGER, saved_ts TEXT,c_streak INTEGER, l_streak INTEGER, l_interval INTEGER,v_streak TEXT,showDashboard INTEGER,  title TEXT, ans1 TEXT,ans2 TEXT,ans3 TEXT,type INTEGER, num_ans INTEGER, interval INTEGER,archive INTEGER,priority INTEGER,correct_ans INTEGER,last_date TEXT,weight DOUBLE);''');
      print('New table created at 3 $path');
         await db.execute(
          '''CREATE TABLE Answers (_id INTEGER PRIMARY KEY, date_id INTEGER, saved_ts TEXT, c_summary TEXT,c_keywords TEXT,p_rating DOUBLE,p_ans INTEGER,  q_id INTEGER, response1 INTEGER,response2 INTEGER,response3 INTEGER,content TEXT, date TEXT,a_rating DOUBLE,discription TEXT);''');
      print('New table created at 4 $path');
      await db.execute(
          '''CREATE TABLE Reminders (_id INTEGER PRIMARY KEY, saved_ts TEXT,note_id INTEGER, type INTEGER,content TEXT, date TEXT);''');
      print('New table created at $path');
    });

  }


  Stream<double> GetCloudData() async* {
    yield (0);
    FirebaseUser user = await _auth.currentUser();
    final db = await database;
    batch = db.batch();
    double progress=0;
    for (int i=0;i<tables.length;i++){
      QuerySnapshot snapShot = await _fireDB.collection('users').document(user.uid).collection(tables[i]).getDocuments();
      if (snapShot != null && snapShot.documents.length!=0){


        final List<DocumentSnapshot> documents = snapShot.documents;

        for (int j=0;j<documents.length;j++){

          batch.insert((tables[i]),documents[j].data);

        }

        progress+=(1/tables.length);
        yield(progress);

      }




    }
    yield (1);
    await batch.commit(noResult: true);






  }

  Future<List<String>>getPlaceHolders() async {
    if ( placeHolders.length!=0) return placeHolders;

    int rand = next(1, 100);

    if (imagePath.length==0)await getImagePath();


    for (int i=0;i<imagePath.length;i++){
      int selectImageId=next(1,imageTotal[i]);
      String path=imagePath[i]+"/"+selectImageId.toString()+".jpg";
      print("path is here "+path);
      String url=await refStorage.child(path).getDownloadURL();
      placeHolders.add(url);





    }
    return placeHolders;
  }
  void updateBackupSetting(bool backup) async {
    FirebaseUser user = await _auth.currentUser();
    DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("user_data").document("data");

    ref.setData({'backup':backup},merge: true);


  }
  void updateUnfilledSetting(bool backup) async {
    FirebaseUser user = await _auth.currentUser();
    DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("user_data").document("data");

    ref.setData({'unfilled':backup},merge: true);


  }
  Stream<double> GetCloudDataFirstTime() async* {
    yield (0);
    FirebaseUser user = await _auth.currentUser();
    final db = await database;
    batch = db.batch();
    double progress=0;


    for (int i=0;i<tables.length;i++){





      QuerySnapshot snapShot = await _fireDB.collection('StartData').document('data').collection(tables[i]).getDocuments();
      if (snapShot != null && snapShot.documents.length!=0){

        final List<DocumentSnapshot> documents = snapShot.documents;

        for (int j=0;j<documents.length;j++){
          DocumentReference ref = _fireDB.collection('users').document(user.uid).collection(tables[i]).document(documents[j].documentID);
          ref.setData(documents[j].data).then((value) => print(ref.documentID)).catchError((onError)=>{
            print("nhi chala\n"),print("hello")
          });

          batch.insert((tables[i]),documents[j].data);


        }
        progress+=(1/tables.length);
        yield(progress);

      }




    }
    yield (1);
    await batch.commit(noResult: true);






  }
  Future<List<NotesModel>> getNotesFromDB(int id) async {
    final db = await database;
    List<NotesModel> notesList = [];
    String strId = id.toString();
    List<Map> maps = await db.query('Notes',
        where: "book_id=" + strId,
        columns: ['_id', 'title', 'book_id', 'content', 'date', 'isImportant' , 'saved_ts' , 'c_keywords' , 'c_summary' , 's_value']);
    if (maps.length > 0) {
      maps.forEach((map) {
        notesList.add(NotesModel.fromMap(map));
      });
    }
    for (var i = 0; i < notesList.length; i++) {
      print("idhar" + notesList[i].content);
      notesList[i].content = notesList[i].content.replaceAll("*%", '"');
    }
    return notesList;
  }
  Future<NotesModel> getNoteByIDFromDB(int id) async {
    final db = await database;
    List<NotesModel> notesList = [];
    String strId = id.toString();
    List<Map> maps = await db.query('Notes',
        where: "_id=" + strId,
        columns: ['_id', 'title', 'book_id', 'content', 'date', 'isImportant', 'saved_ts' , 'c_keywords' , 'c_summary' , 's_value']);
    if (maps.length > 0) {
      maps.forEach((map) {
        notesList.add(NotesModel.fromMap(map));
      });
    }
    for (var i = 0; i < notesList.length; i++) {
      print("idhar" + notesList[i].content);
      notesList[i].content = notesList[i].content.replaceAll("*%", '"');
    }
    return notesList[0];
  }


  Future<int> getCloudId() async {

    FirebaseUser user = await _auth.currentUser();
    int ans=0;
    DocumentReference document = _fireDB.collection('users').document(user.uid).collection("user_data").document("data");

    await document.get().then((value) {
      print(value.data.containsKey("signInId").toString());
      print(value.data['signInId']);
      ans=value.data['signInId'];
      return ans;


    });
    return ans;

  }


  int next(int min, int max) => min + _random.nextInt(max - min);
  Future<int> makeSingleSignIn() async {
    FirebaseUser user = await _auth.currentUser();
    DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("user_data").document("data");
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceName="";
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.model}');

      deviceName=androidInfo.model;
    }

    else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Running on ${iosInfo.utsname.machine}');  //
      deviceName=iosInfo.utsname.machine;    }
    int deviceId=next(1,4294967290);
    try {
      ref.setData({
        'signInId': deviceId,
        'deviceName': deviceName,

      }, merge: true);

     // await prefs.setInt('signInId', deviceId);
    }


    catch (error) {
      print("hello is there");// executed for errors of all types other than Exception
    }

    return deviceId;
  }

  Future<String> getCloudDevice() async {

    FirebaseUser user = await _auth.currentUser();
    DocumentReference document =  _fireDB.collection('users').document(user.uid).collection("user_data").document("data");

    String ans;
    await document.get().then((value) {
      print(value.data.containsKey("deviceName").toString());
      print(value.data['deviceName']);
      ans=value.data['deviceName'];
      return ans;


    }

    );

    return ans;

  }
  Future<List<NotesModel>> getAllNotesFromDB() async {
    final db = await database;
    List<NotesModel> notesList = [];

    List<Map> maps = await db.query('Notes',

        columns: ['_id', 'title', 'book_id', 'content', 'date', 'isImportant','saved_ts' , 'c_keywords' , 'c_summary' , 's_value']);
    print(maps.length);
    if (maps.length > 0) {
      maps.forEach((map) {
        notesList.add(NotesModel.fromMap(map));
      });
    }
    for (var i = 0; i < notesList.length; i++) {
      print("idhar" + notesList[i].content);
      notesList[i].content = notesList[i].content.replaceAll("*%", '"');
    }
    return notesList;
  }


  Future<List<AnswerModel>> getAllAnswersFromDB() async {
    final db = await database;
    List<AnswerModel> notesList = [];

    List<Map> maps = await db.query('Answers',

        columns: ['_id', 'q_id' , 'response1' ,'response2' ,'response3' ,'content' , 'date' ,'a_rating','discription','p_rating' ,'p_ans', 'c_keywords', 'c_summary', 'saved_ts']);
    print(maps.length);
    var csv = mapListToCsv(maps);
    String text;
    String csv_file=csv;
    print(csv_file);
    final directory = await getExternalStorageDirectory();
    final pathOfTheFileToWrite = directory.path + "/myCsvFile.csv";
print(directory.path);
    var fileCopy = await File(pathOfTheFileToWrite).writeAsString(csv);
    final File file = File('${directory.path}/my_file.txt');
    try { await file.writeAsString(csv_file); }
    catch(e){
      print (e);
      print("hua");
    }
    try {
      final Directory directory =await getExternalStorageDirectory();
      final File file = File('${directory.path}/my_file.txt');
      text = await file.readAsString();
print(text);
    } catch (e) {
      print(e);
      print("Couldn't read file");
    }
    if (maps.length > 0) {
      maps.forEach((map) {
        notesList.add(AnswerModel.fromMap(map));
      });
    }

    return notesList;
  }

  Future<List<ReminderModel>> getRemindersFromDB() async {
    final db = await database;
    List<ReminderModel> remList = [];
    List<Map> maps = await db.query('Reminders',
        columns: ['_id', 'note_id', 'type', 'content', 'date','saved_ts']);
    if (maps.length > 0) {
      maps.forEach((map) {
        remList.add(ReminderModel.fromMap(map));
      });
    }
    return remList;
  }

  Future<List<TimelineModel>> getTimelinesFromDB() async {
    final db = await database;
    List<TimelineModel> remList = [];
    List<Map> maps = await db.query('Timelines',
        columns: ['id', 'status', 'title', 'content', 'date','saved_ts']);
    if (maps.length > 0) {

      maps.forEach((map) {
        remList.add(TimelineModel.fromMap(map));
      });
    }
    return remList;
  }

  Future<TimelineModel> getTimelineFromIdFromDB(int id) async {
    final db = await database;
    print("sj "+id.toString());
    List<TimelineModel> remList = [];
    List<Map> maps = await db.query('Timelines',
        columns: ['id', 'status', 'title', 'content', 'date','saved_ts'],
        where: 'id = ?',
        whereArgs: [id]);
    if (maps.length > 0) {

      maps.forEach((map) {
        remList.add(TimelineModel.fromMap(map));
      });
    }
    print(remList[0].title);
    return remList[0];
  }
  Future<List<UserAModel>> getUserActiviyFromDB() async {
    final db = await database;
    List<UserAModel> remList = [];
    List<Map> maps = await db.query('User_Activity',
        columns: ['id', 'image', 'name', 'a_id','saved_ts']);
    if (maps.length > 0) {
      maps.forEach((map) {
        remList.add(UserAModel.fromMap(map));
      });
    }
    return remList;
  }

  Future<List<UserAModel>> getUserActiviyAfterFromDB(int id) async {
    final db = await database;
    List<UserAModel> remList = [];
    List<Map> maps = await db.query('User_Activity',
        columns: ['id', 'image', 'name', 'a_id','saved_ts'],
    where: 'id > ?',
    whereArgs: [id]);
    if (maps.length > 0) {
      maps.forEach((map) {
        remList.add(UserAModel.fromMap(map));

      });
    }
    return remList;
  }

  Future<List<ActivityModel>> getActiviyAfterFromDB(int id) async {
    final db = await database;
    List<ActivityModel> remList = [];
    List<Map> maps = await db.query('Activity',
        columns: ['id', 'image', 'name', 'weight','saved_ts'],
        where: 'id > ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      maps.forEach((map) {
        remList.add(ActivityModel.fromMap(map));

      });
    }
    print("col cool "+remList.toString());
    return remList;
  }

  Future<List<FriendModel>> getFriendsDB() async {
    final db = await database;
    List<FriendModel> remList = [];
    List<Map> maps = await db.query('Friends',
        columns: ['id',  'name', 'total','saved_ts']);
    if (maps.length > 0) {
      maps.forEach((map) {
        remList.add(FriendModel.fromMap(map));

      });
    }
    return remList;
  }
  Future<List<CatModel>> getCatsFromDB() async {
    final db = await database;
    List<CatModel> remList = [];
    List<Map> maps = await db.query('Cats',
        columns: ['id', 'image' ,'name', 'total','saved_ts']);
    if (maps.length > 0) {
      maps.forEach((map) {
        remList.add(CatModel.fromMap(map));

      });
    }
    return remList;
  }

  Future<List<NoteBookModel>> getNotebookFromDB() async {
    final db = await database;
    List<NoteBookModel> notesList = [];
    print('Note updated....');
    List<Map> maps = await db.query('Notebooks',
        columns: ['_id', 'title', 'notes_num', 'date', 'isImportant','saved_ts']);
    if (maps.length > 0) {
      maps.forEach((map) {
        print('Note updated....  ' + NoteBookModel.fromMap(map).toString());
        notesList.add(NoteBookModel.fromMap(map));
      });
    }
    return notesList;
  }

  Future<List<QuestionModel>> getQuestionsFromDB() async {
    final db = await database;
    List<QuestionModel> QList = [];
    print('questions updated....');
    List<Map> maps = await db.query('Questions', columns: [
      '_id',
      'title',
      'num_ans',
      'type',
      'interval',
      'priority',
      'correct_ans',
      'archive',
      'ans1',
      'ans2',
      'weight',
      'content',
      'min',
      'max',
      'c_id',
      'c_name',
      'c_streak',
      'l_streak',
      'l_interval',
      'v_streak',
      'saved_ts',
      'showDashboard',
      'last_date',
      'ans3'
    ],
      where: 'archive =?',
      whereArgs: [0]
    );
    if (maps.length > 0) {
      maps.forEach((map) {
        QList.add(QuestionModel.fromMap(map));
      });
    }
    return QList;
  }
  Future<List<QuestionModel>> getLibraryQuestionsFromDB() async {
    final db = await database;
    List<QuestionModel> QList = [];
    print('questions updated....');
    List<Map> maps = await db.query('Questions', columns: [
      '_id',
      'title',
      'num_ans',
      'type',
      'interval',
      'priority',
      'correct_ans',
      'archive',
      'content',
      'c_id',
      'c_name',
      'ans1',
      'min',
      'max',
      'ans2',
      'weight',
      'last_date',
      'c_streak',
      'l_streak',
      'l_interval',
      'v_streak',
      'saved_ts',
      'showDashboard',
      'ans3'
    ],
        where: 'archive =?',
        whereArgs: [1]);
    if (maps.length > 0) {
      maps.forEach((map) {
        QList.add(QuestionModel.fromMap(map));
      });
    }
    return QList;
  }

  Future<List<EventModel>> getEventsOfDateFromDB(int query) async {
    final db = await database;
    List<EventModel> eventsList = [];
    List<Map> maps = await db.query('Events',
        columns: ['id', 'title','a_id','cal_id','time','content', 'date','saved_ts', 'isImportant','r_id','duration','date_id','todo_id','timeline_id']
    ,
        where: 'date_id=?',
        whereArgs: [query]);
    if (maps.length > 0) {
      maps.forEach((map) {
        eventsList.add(EventModel.fromMap(map));
      });
    }
    return eventsList;
  }

      Future<List<EventModel>> getEventsOfTimelineFromDB(int query) async {
        final db = await database;
        List<EventModel> eventsList = [];
        List<Map> maps = await db.query('Events',
            columns: ['id', 'title','a_id', 'time','cal_id','content', 'date','saved_ts', 'isImportant','r_id','duration','date_id','todo_id','timeline_id']
            ,
            where: 'timeline_id=?',
            whereArgs: [query]);
        print("timelines "+ maps.length.toString() );
        if (maps.length > 0) {
          maps.forEach((map) {
            eventsList.add(EventModel.fromMap(map));
          });
        }
        return eventsList;
      }

  Future<List<EventModel>> getEventWithCalIdFromDB(int query) async {
    final db = await database;
    List<EventModel> eventsList = [];
    List<Map> maps = await db.query('Events',
        columns: ['id', 'title','a_id', 'time','cal_id','content', 'date','saved_ts', 'isImportant','r_id','duration','date_id','todo_id','timeline_id']
        ,
        where: 'timeline_id=?',
        whereArgs: [query]);
    print("timelines "+ maps.length.toString() );
    if (maps.length > 0) {
      maps.forEach((map) {
        eventsList.add(EventModel.fromMap(map));
      });
    }
    return eventsList;
  }
  Future<EventModel> getEventOfReventFromDB(int query) async {
    final db = await database;
    List<EventModel> eventsList = [];
    List<Map> maps = await db.query('Events',
        columns: ['id', 'title','a_id','cal_id', 'time','content', 'date','saved_ts', 'isImportant','r_id','duration','date_id','todo_id','timeline_id']
        ,
        where: 'r_id=?',
        whereArgs: [query]);
    if (maps.length > 0) {
      maps.forEach((map) {
        eventsList.add(EventModel.fromMap(map));
      });
    }
    return eventsList[0];
  }
  Future<List<EventModel>> getEventsFromDB() async {
    final db = await database;
    List<EventModel> eventsList = [];
    List<Map> maps = await db.query('Events',

        columns: ['id', 'title','cal_id', 'a_id','time','content','saved_ts', 'date', 'isImportant','r_id','duration','date_id','todo_id','timeline_id']

        );
    if (maps.length > 0) {
      maps.forEach((map) {
        eventsList.add(EventModel.fromMap(map));
      });
    }
    return eventsList;
  }
  Future<List<ExpenseModel>> getExpensesFromDB() async {
    final db = await database;
    List<ExpenseModel> eventsList = [];
    List<Map> maps = await db.query('Expenses',

        columns: ['id', 'title', 'cat_id','date_id','saved_ts','content', 'date', 'friend_id','money','type']

    );
    if (maps.length > 0) {
      maps.forEach((map) {
        eventsList.add(ExpenseModel.fromMap(map));
      });
    }
    return eventsList;
  }

  Future<List<ReventModel>> getReventsWithFilterDayFromDB(int day) async {
    final db = await database;
    String weekday;

    print("day: "+ day.toString());
    if (day==1) weekday='sun';
    else  if (day==2) weekday='mon';
    else  if (day==3) weekday='tue';
    else  if (day==4) weekday='wed';
    else  if (day==5) weekday='thu';
    else  if (day==6) weekday='fri';
    else  if (day==7) weekday='sat';
    List<ReventModel> eventsList = [];
    List<Map> maps = await db.query('Revents',
        columns: ['id',  'start_date', 'end_date', 'event_id','saved_ts', 'sun','mon','tue','wed','thu','fri','sat']
        ,

      where: '$weekday=1',
       );
    print(maps.length.toString()+" shreyash");

    if (maps.length > 0) {
      int i=0;
      maps.forEach((map) {
        eventsList.add(ReventModel.fromMap(map));
        print("sun" +eventsList[i].sun.toString());
        print("mon"+eventsList[i].mon.toString());
            print("tue"+eventsList[i].tue.toString());
            print("wed"+eventsList[i].wed.toString());

        print("thu"+eventsList[i].thu.toString());

        print("fri"+eventsList[i].fri.toString());

        print("sat"+eventsList[i].sat.toString());
        print("next");


        i++;
      });
    }
    return eventsList;
  }
  Future<EventModel> getEventFromDB(int query) async {
    final db = await database;
    List<EventModel> event = [];
    List<Map> maps = await db.query('Events',
        columns: ['id', 'title','a_id','time','saved_ts', 'content', 'date', 'isImportant','r_id','duration','date_id','todo_id','timeline_id','cal_id']
        ,
        where: 'id=?',
        whereArgs: [query]);
    if (maps.length == 1) {
      maps.forEach((map) {
        event.add(EventModel.fromMap(map));
      });
    }
    return event[0];
  }
  Future<NoteBookModel> getNotebookByIDFromDB(int id) async {
    final db = await database;
    List<NoteBookModel> notesList = [];
    print('Note updated....');
    List<Map> maps = await db.query('Notebooks',
        columns: ['_id', 'title', 'notes_num','saved_ts', 'date', 'isImportant'],
    where: '_id=?',
    whereArgs: [id]);
    if (maps.length > 0) {
      maps.forEach((map) {
        print('Note updated....  ' + NoteBookModel.fromMap(map).toString());
        notesList.add(NoteBookModel.fromMap(map));
      });
    }
    return notesList[0];
  }
  updateNotebookInDB(int id) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE Notebooks SET notes_num = notes_num+1 WHERE _id =' +
          id.toString(),
    );
  }


  decreaseNotebookInDB(int id) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE Notebooks SET notes_num = notes_num-1 WHERE _id =' +
          id.toString(),
    );
  }


  deleteReminderInDB(ReminderModel remToDelete) async {
    final db = await database;
    await db.delete('Reminders', where: '_id = ?', whereArgs: [remToDelete.id]);
    print('Reminder deleted');
  }

  deleteReventInDB(ReventModel remToDelete) async {
    final db = await database;
    await db.delete('Revents', where: 'id = ?', whereArgs: [remToDelete.id]);
    print('Revent deleted');
  }

  deleteUserActivityTable()async{
    final db = await database;
    await db.delete('User_Activity', where: 'id >8');
  }


  deleteNotebookInDB(NoteBookModel noteToDelete) async {
    final db = await database;
    await db
        .delete('Notebooks', where: '_id = ?', whereArgs: [noteToDelete.id]);
    print('Note deleted');
  }

  Future<List<NoteBookModel>> getNotebookname(int id) async {
    final db = await database;
    String name = id.toString();
    List<NoteBookModel> notesList = [];
    List<Map> maps = await db.query('Notebooks',
        where: "_id=" + name,
        columns: ['_id', 'title', 'notes_num','saved_ts', 'date', 'isImportant']);
    if (maps.length > 0) {
      maps.forEach((map) {
        print('Note updated....  ' + NoteBookModel.fromMap(map).toString());
        notesList.add(NoteBookModel.fromMap(map));
      });
    }
    return notesList;
  }

  Future<QuestionModel> addQuestionInDB(QuestionModel newQues) async {
    final db = await database;
    if (newQues.saved_ts==null)newQues.saved_ts=DateTime.now();
    if (newQues.v_streak==null)newQues.v_streak="[]";
    if (newQues.showDashboard==null)newQues.showDashboard=0;
    if (newQues.c_streak==null)newQues.c_streak=0;
    if (newQues.l_streak==null)newQues.l_streak=0;
    if (newQues.l_interval==null)newQues.l_interval=0;
    if (newQues.content==null)newQues.content="";
    if (newQues.c_id==null)newQues.c_id=0;
    if (newQues.c_name==null)newQues.c_name="Others";
    if (!newQues.title.trim().isEmpty) {
     await db.transaction((transaction) async {
        int id = await transaction.rawInsert(
            'INSERT into Questions(title, num_ans, type, interval, ans1,ans2,ans3,archive,correct_ans,priority,last_date,weight,c_streak,l_streak,l_interval,v_streak,saved_ts,showDashboard,c_id,c_name,content,min,max) VALUES ("${newQues.title}",${newQues.num_ans}, ${newQues.type}, ${newQues.interval}, "${newQues.ans1}","${newQues.ans2}","${newQues.ans3}", ${newQues.archive}, ${newQues.correct_ans}, ${newQues.priority},"${newQues.last_date.toIso8601String()}", ${newQues.weight}, ${newQues.c_streak},${newQues.l_streak},${newQues.l_interval},"${newQues.v_streak}","${newQues.saved_ts.toIso8601String()}",${newQues.showDashboard},${newQues.c_id},"${newQues.c_name}","${newQues.content}",${newQues.min},${newQues.max});');
        print("insert Question with id: " + id.toString());
        newQues.id = id;
        FirebaseUser user = await _auth.currentUser();

        DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Questions").document(newQues.id.toString());


        ref.setData(newQues.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
          print("nhi chala\n"),print("hello")
        }).timeout(Duration(seconds: 2),onTimeout:() {

          //FirebaseDatabase.instance.purgeOutstandingWrites();

          print("timeout nhi chala\n");
        });

     });

      return newQues;
    }
  }

  Future<List<int>> getImageTotal() async {
    List<int> ans=[];
    CollectionReference ref = _fireDB.collection('images_info');
    QuerySnapshot querySnapshot = await ref.getDocuments();
    var list = querySnapshot.documents;
    for (int i = 0; i < list.length; i++) {
      var a = list[i];
      imageTotal.add(a.data['total']);
      print("cellooooooooo");
    }

    return ans;

  }
  Future<List<String>> getImagePath() async {
    List<String> ans=[];
    CollectionReference ref = _fireDB.collection('images_info');
    QuerySnapshot querySnapshot = await ref.getDocuments();
    var list = querySnapshot.documents;
    for (int i = 0; i < list.length; i++) {
      var a = list[i];
      imagePath.add(a.data['path']);
      imageTotal.add(a.data['total']);

      print("hellooooooooo");
    }



  }
  Future<QuestionModel> addQuestionInInitailCloud(QuestionModel newQues) async {
    final db = await database;

    if (newQues.saved_ts==null)newQues.saved_ts=DateTime.now();
    if (newQues.v_streak==null)newQues.v_streak="[]";
    if (newQues.showDashboard==null)newQues.showDashboard=0;
    if (newQues.c_streak==null)newQues.c_streak=0;
    if (newQues.l_streak==null)newQues.l_streak=0;
    if (newQues.l_interval==null)newQues.l_interval=0;
    if (newQues.min==null)newQues.min=0;
    if (newQues.max==null)newQues.max=0;
    if (newQues.content==null)newQues.content="";
    if (newQues.c_id==null)newQues.c_id=0;
    if (newQues.c_name==null)newQues.c_name="Others";
    if (newQues.last_date==null)newQues.last_date=DateTime.now();
    if (!newQues.title.trim().isEmpty) {

        FirebaseUser user = await _auth.currentUser();

        DocumentReference ref = _fireDB.collection('StartData').document('data').collection("Questions").document(newQues.id.toString());


        ref.setData(newQues.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
          print("nhi chala\n"),print("hello")
        }).timeout(Duration(seconds: 2),onTimeout:() {

          //FirebaseDatabase.instance.purgeOutstandingWrites();

          print("timeout nhi chala\n");
        });



      return newQues;
    }
  }

  Future<TimelineModel> addTimelineInDB(TimelineModel newTimeline) async {
    final db = await database;
    if (newTimeline.saved_ts==null)newTimeline.saved_ts=DateTime.now();
    if (newTimeline.end_date==null)newTimeline.saved_ts=DateTime.now();
    print(newTimeline.title);
    if (!newTimeline.title.trim().isEmpty) {
      print("mello");
      await db.transaction((transaction) async {
        int id = await transaction.rawInsert(
            'INSERT into Timelines(title, content, status, date, saved_ts,end_date) VALUES ("${newTimeline.title}","${newTimeline.content}", ${newTimeline.status},"${newTimeline.date.toIso8601String()}","${newTimeline.saved_ts.toIso8601String()}","${newTimeline.end_date.toIso8601String()}");');
        print("insert Timeline with id: " + id.toString());
        newTimeline.id = id;
        FirebaseUser user = await _auth.currentUser();

        DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Timelines").document(newTimeline.id.toString());


        ref.setData(newTimeline.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
          print("nhi chala\n"),print("hello")
        }).timeout(Duration(seconds: 2),onTimeout:() {

          //FirebaseDatabase.instance.purgeOutstandingWrites();

          print("timeout nhi chala\n");
        });

      });

      return newTimeline;
    }
    return newTimeline;
  }

  Future<ReminderModel> addReminderInDB(ReminderModel newRem) async {
    final db = await database;
    if (newRem.saved_ts==null)newRem.saved_ts=DateTime.now();
    await db.transaction((transaction) async {
      int id= await transaction.rawInsert(
          'INSERT into Reminders(note_id, type, content, date, saved_ts) VALUES ("${newRem.note_id}",${newRem.type}, "${newRem.content}","${newRem.date.toIso8601String()}","${newRem.saved_ts.toIso8601String()}");');


      print("insert Reminder with id: " + id.toString());
      newRem.id = id;
      FirebaseUser user = await _auth.currentUser();

      DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Reminders").document(newRem.id.toString());


      ref.setData(newRem.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
        print("nhi chala\n"),print("hello")
      }).timeout(Duration(seconds: 2),onTimeout:() {

        //FirebaseDatabase.instance.purgeOutstandingWrites();

        print("timeout nhi chala\n");
      });

    });

    return newRem;
  }

  Future<AnswerModel> addAnswerInDB(AnswerModel newAns) async {
    final db = await database;
    if (newAns.saved_ts==null)newAns.saved_ts=DateTime.now();
    if (newAns.c_keywords==null)newAns.c_keywords="";
    if (newAns.c_summary==null)newAns.c_summary="";
    if (newAns.p_rating==null)newAns.p_rating=0;
    if (newAns.p_ans==null)newAns.p_ans=0;
    await db.transaction((transaction) async {
      int id=await transaction.rawInsert(
          'INSERT into Answers(q_id, a_rating, response1,response2,response3,content,date,discription,c_summary,c_keywords,p_ans,p_rating,saved_ts) VALUES ("${newAns.q_id}","${newAns.a_rating}", "${newAns.res1}", "${newAns.res2}", ${newAns.res3},"${newAns.content}","${newAns.date.toIso8601String()}","${newAns.discription}","${newAns.c_summary}","${newAns.c_keywords}", ${newAns.p_ans},${newAns.p_rating},"${newAns.saved_ts.toIso8601String()}");');
      newAns.id = id;
      FirebaseUser user = await _auth.currentUser();

      DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Answers").document(newAns.id.toString());


      ref.setData(newAns.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
        print("nhi chala\n"),print("hello")
      }).timeout(Duration(seconds: 2),onTimeout:() {

        //FirebaseDatabase.instance.purgeOutstandingWrites();

        print("timeout nhi chala\n");
      });

    });


    return newAns;
  }
  Future<AlogModel> addActivityLogInDB(AlogModel newAns) async {
    final db = await database;
    if (newAns.saved_ts==null)newAns.saved_ts=DateTime.now();
    await db.transaction((transaction) async{
      int id= await transaction.rawInsert(
          'INSERT into Alog(a_id, duration, date, saved_ts ) VALUES (${newAns.a_id},${newAns.duration},  "${newAns.date.toIso8601String()}", "${newAns.saved_ts.toIso8601String()}");');
      newAns.id = id;
      FirebaseUser user = await _auth.currentUser();

      DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Alog").document(newAns.id.toString());


      ref.setData(newAns.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
        print("nhi chala\n"),print("hello")
      }).timeout(Duration(seconds: 2),onTimeout:() {

        //FirebaseDatabase.instance.purgeOutstandingWrites();

        print("timeout nhi chala\n");
      });

    });


    return newAns;
  }
  void addNotebookToInitailCloud(NoteBookModel newNote) async {
    final db = await database;

    if (newNote.saved_ts==null)newNote.saved_ts=DateTime.now();
    if (newNote.title.trim().isEmpty) newNote.title = 'Untitled Notebook';
    newNote.notes_num = 0;
    FirebaseUser user = await _auth.currentUser();

    DocumentReference ref = _fireDB.collection('StartData').document('data').collection("Notebooks").document(newNote.id.toString());


    ref.setData(newNote.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
      print("nhi chala\n"),print("hello")
    }).timeout(Duration(seconds: 2),onTimeout:() {

      //FirebaseDatabase.instance.purgeOutstandingWrites();

      print("timeout nhi chala\n");
    });
  }


  Future<DateModel> getDateByIdFromDB(int query) async {
    final db = await database;
    List<DateModel> event = [];
    List<Map> maps = await db.query('Dates',
        columns: ['id',  'date', 'time_start','time_end','survey','ImageUrl','dayName','p_rating','a_rating','c_streak','l_streak','l_interval','saved_ts']
        ,
        where: 'id=?',
        whereArgs: [query]);

    if (maps.length == 1) {
      maps.forEach((map) {
        event.add(DateModel.fromMap(map));
      });
      return event[0];
    }
    else {
      return null;
    }

  }
  Future<NoteBookModel> addNoteBookInDB(NoteBookModel newNote) async {
    final db = await database;
    if (newNote.saved_ts==null)newNote.saved_ts=DateTime.now();
    if (newNote.title.trim().isEmpty) newNote.title = 'Untitled Notebook';
    newNote.notes_num = 0;
    await db.transaction((transaction) async {
      int id = await transaction.rawInsert(
          'INSERT into Notebooks(title, notes_num, date, isImportant, saved_ts) VALUES ("${newNote.title}", "${newNote.notes_num}", "${newNote.date.toIso8601String()}",${newNote.isImportant == true ? 1 : 0},"${newNote.saved_ts.toIso8601String()}");');
      newNote.id = id;
      print('Notebook added id: ' + id.toString());
      print('Notebook added: ${newNote.title} ${newNote.notes_num}');
      FirebaseUser user = await _auth.currentUser();

      DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Notebooks").document(newNote.id.toString());


      ref.setData(newNote.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
        print("nhi chala\n"),print("hello")
      }).timeout(Duration(seconds: 2),onTimeout:() {

        //FirebaseDatabase.instance.purgeOutstandingWrites();

        print("timeout nhi chala\n");
      });


      return newNote;
    });
  }

  getAnswersFromCloud() async {

    FirebaseUser user = await _auth.currentUser();

    CollectionReference ref = _fireDB.collection('users').document(user.uid).collection("Answers");
    ref.where(
        "q_id",
        isEqualTo: 100
    ).where("date",isLessThanOrEqualTo: "${DateTime.now().toIso8601String()}").snapshots().listen(
            (data) => print('grower ${data.documents[0]['date']}')
    );
  }

   addTodoToCloud(Todo newNote) async  {

    if (newNote.saved_ts==null)newNote.saved_ts=DateTime.now();


      FirebaseUser user = await _auth.currentUser();

      DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Todo").document(newNote.id.toString());


      ref.setData(newNote.toDatabaseJson()).then((value) => print(ref.documentID)).catchError((onError)=>{
        print("nhi chala\n"),print("hello")
      }).timeout(Duration(seconds: 2),onTimeout:() {

        //FirebaseDatabase.instance.purgeOutstandingWrites();

        print("timeout nhi chala\n");



      return newNote;
    });
  }
  deleteTodoToCloud(Todo newNote) async  {
    final db = await database;
    if (newNote.saved_ts==null)newNote.saved_ts=DateTime.now();


    FirebaseUser user = await _auth.currentUser();

    DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Todo").document(newNote.id.toString());


    ref.delete().then((value) => print(ref.documentID)).catchError((onError)=>{
      print("nhi chala\n"),print("hello")
    }).timeout(Duration(seconds: 2),onTimeout:() {

      //FirebaseDatabase.instance.purgeOutstandingWrites();

      print("timeout nhi chala\n");



      return newNote;
    });
  }
  Future<DateModel> getDateByDateFromDB(String query) async {
    print(query);
    final db = await database;
    List<DateModel> event = [];
    List<Map> maps = await db.query('Dates',
        columns: ['id',  'date', 'time_start','time_end','survey','dayName','p_rating','a_rating','c_streak','l_streak','l_interval','saved_ts']
        ,
        where: 'date LIKE ?',
        whereArgs:["%$query%"]);
    if (maps.length >= 1) {
      maps.forEach((map) {
        event.add(DateModel.fromMap(map));
      });
      return event[0];
    }
    else {
      print("nhi pakada");
      return null;
    }

  }

  Future<ReventModel> getReventByIdFromDB(int query) async {
    print(query);
    final db = await database;
    List<ReventModel> event = [];
    List<Map> maps = await db.query('Revents',
        columns: ['id',  'start_date', 'end_date', 'event_id', 'sun','mon','tue','wed','thu','fri','sat','saved_ts']
        ,
        where: 'id=?',
        whereArgs:[query]);
    if (maps.length >= 1) {
      maps.forEach((map) {
        event.add(ReventModel.fromMap(map));
      });
      return event[0];
    }
    else {

      return null;
    }

  }

  Future<List<Todo>> getTodos( int query) async {
    final db = await database;
    print("kaisemujhe");
    print(query);
    List<Map<String, dynamic>> result;


    print ("yaha pe");
    result = await db.query(todoTABLE,

        where: 'event_id = ?',
        whereArgs: [query]);


    List<Todo> todos = result.isNotEmpty
        ? result.map((item) => Todo.fromDatabaseJson(item)).toList()
        : [];
    return todos;
  }

  updateNoteInDB(NotesModel updatedNote) async {
    final db = await database;
    updatedNote.content = updatedNote.content.replaceAll('"', "\*%");
    await db.update('Notes', updatedNote.toMap(),
        where: '_id = ?', whereArgs: [updatedNote.id]);
    FirebaseUser user = await _auth.currentUser();

    DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Notes").document(updatedNote.id.toString());


    ref.setData(updatedNote.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
      print("nhi chala\n"),print("hello")
    }).timeout(Duration(seconds: 2),onTimeout:() {

      //FirebaseDatabase.instance.purgeOutstandingWrites();

      print("timeout nhi chala\n");
    });
    print('Note updated: ${updatedNote.title} ${updatedNote.content}');
    print('Note updated: ${updatedNote.title} ${updatedNote.content}');
  }
  updateTimelineInDB(TimelineModel updatedTimeline) async {
    final db = await database;

    await db.update('Timelines', updatedTimeline.toMap(),
        where: 'id = ?', whereArgs: [updatedTimeline.id]);
    FirebaseUser user = await _auth.currentUser();

    DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Timelines").document(updatedTimeline.id.toString());


    ref.setData(updatedTimeline.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
      print("nhi chala\n"),print("hello")
    }).timeout(Duration(seconds: 2),onTimeout:() {

      //FirebaseDatabase.instance.purgeOutstandingWrites();

      print("timeout nhi chala\n");
    });

  }
  updateAnswerInDB(AnswerModel updatedTimeline) async {
    final db = await database;

    await db.update('Answers', updatedTimeline.toMap(),
        where: 'id = ?', whereArgs: [updatedTimeline.id]);
    FirebaseUser user = await _auth.currentUser();

    DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Answers").document(updatedTimeline.id.toString());


    ref.setData(updatedTimeline.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
      print("nhi chala\n"),print("hello")
    }).timeout(Duration(seconds: 2),onTimeout:() {

      //FirebaseDatabase.instance.purgeOutstandingWrites();

      print("timeout nhi chala\n");
    });

  }
  updateQuestionInDB(QuestionModel updatedQues) async {
    final db = await database;

    await db.update('Questions', updatedQues.toMap(),
        where: '_id = ?', whereArgs: [updatedQues.id]);
    FirebaseUser user = await _auth.currentUser();

    DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Questions").document(updatedQues.id.toString());


    ref.setData(updatedQues.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
      print("nhi chala\n"),print("hello")
    }).timeout(Duration(seconds: 2),onTimeout:() {

      //FirebaseDatabase.instance.purgeOutstandingWrites();

      print("timeout nhi chala\n");
    });

  }

  updateExpensesInDB(ExpenseModel updatedExpense) async {
    final db = await database;

    await db.update('Expenses', updatedExpense.toMap(),
        where: 'id = ?', whereArgs: [updatedExpense.id]);
    FirebaseUser user = await _auth.currentUser();

    DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Expenses").document(updatedExpense.id.toString());


    ref.setData(updatedExpense.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
      print("nhi chala\n"),print("hello")
    }).timeout(Duration(seconds: 2),onTimeout:() {

      //FirebaseDatabase.instance.purgeOutstandingWrites();

      print("timeout nhi chala\n");
    });

  }

  updateReventInDB(ReventModel updatedQues) async {
    final db = await database;

    await db.update('Revents', updatedQues.toMap(),
        where: 'id = ?', whereArgs: [updatedQues.id]);

    FirebaseUser user = await _auth.currentUser();

    DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Revents").document(updatedQues.id.toString());



    ref.setData(updatedQues.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
      print("nhi chala\n"),print("hello")
    }).timeout(Duration(seconds: 2),onTimeout:() {

      //FirebaseDatabase.instance.purgeOutstandingWrites();

      print("timeout nhi chala\n");
    });
    print("updated revent "+ updatedQues.id.toString() +" sun -> "+updatedQues.sun.toString()+" "+updatedQues.mon.toString()+" "+updatedQues.tue.toString()+" "+updatedQues.wed.toString()+" "+updatedQues.thu.toString()+" "+updatedQues.fri.toString()+" "+updatedQues.sat.toString());

  }

  updateDateInDB(DateModel updatedDate) async {
    final db = await database;
    await db.update('Dates', updatedDate.toMap(),
        where: 'id = ?', whereArgs: [updatedDate.id]);
    FirebaseUser user = await _auth.currentUser();

    DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Dates").document(updatedDate.id.toString());


    ref.setData(updatedDate.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
      print("nhi chala\n"),print("hello")
    }).timeout(Duration(seconds: 2),onTimeout:() {

      //FirebaseDatabase.instance.purgeOutstandingWrites();

      print("timeout nhi chala\n");
    });
    print('Date updated ');
  }
  updateEventInDB(EventModel updatedEvent) async {
    final db = await database;
    await db.update('Events', updatedEvent.toMap(),

        where: 'id = ?', whereArgs: [updatedEvent.id]);
    FirebaseUser user = await _auth.currentUser();

    DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Events").document(updatedEvent.id.toString());


    ref.setData(updatedEvent.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
      print("nhi chala\n"),print("hello")
    }).timeout(Duration(seconds: 2),onTimeout:() {

      //FirebaseDatabase.instance.purgeOutstandingWrites();

      print("timeout nhi chala\n");
    });
    print('Event updated: ${updatedEvent.title} ${updatedEvent.content}');
  }

  deleteNoteInDB(NotesModel noteToDelete) async {
    final db = await database;
    await db.delete('Notes', where: '_id = ?', whereArgs: [noteToDelete.id]);

    print('Note deleted');
  }
  deleteTimelineInDB(TimelineModel timelineToDelete) async {
    final db = await database;
    await db.delete('Timelines', where: 'id = ?', whereArgs: [timelineToDelete.id]);
    print('Timeline deleted');
  }
  deleteEventInDB(EventModel eventToDelete) async {
    final db = await database;
    await db.delete('Events', where: 'id = ?', whereArgs: [eventToDelete.id]);
    print('Event deleted');
  }
  deleteUserActivityInDB(UserAModel actToDelete) async {
    final db = await database;
    await db.delete('Events', where: 'id = ?', whereArgs: [actToDelete.id]);
    print('User Activity deleted');
  }


  Future<NotesModel> addNoteInDB(NotesModel newNote) async {
    final db = await database;
    if(newNote.s_value==null)newNote.s_value=0;
    if(newNote.c_summary==null)newNote.c_summary="0";
    if(newNote.c_keywords==null)newNote.c_keywords="0";
    if(newNote.saved_ts==null)newNote.saved_ts=DateTime.now();
    if (newNote.title.trim().isEmpty) newNote.title = 'Note without name';
    newNote.content = newNote.content.replaceAll('"', "\*%");
    print("replaced : " + newNote.content);
    await db.transaction((transaction)async {
      int id=await transaction.rawInsert(
          'INSERT into Notes(title, book_id, content, date, isImportant,saved_ts,c_keywords,c_summary,s_value) VALUES ("${newNote.title}","${newNote.book_id}", "${newNote.content}", "${newNote.date.toIso8601String()}", ${newNote.isImportant == true ? 1 : 0},"${newNote.saved_ts.toIso8601String()}","${newNote.c_summary}","${newNote.c_keywords}",${newNote.s_value});');

      newNote.id = id;
      print('Note added: ${newNote.title} ${newNote.content}');
      FirebaseUser user = await _auth.currentUser();

      DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Notes").document(newNote.id.toString());


      ref.setData(newNote.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
        print("nhi chala\n"),print("hello")
      }).timeout(Duration(seconds: 2),onTimeout:() {

        //FirebaseDatabase.instance.purgeOutstandingWrites();

        print("timeout nhi chala\n");
      });
      return newNote;
    });

  }
  Future<int> fun1() async {
    final db = await database;
    await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
      print('inserted1: $id1');
      int id2 = await txn.rawInsert(
          'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
          ['another name', 12345678, 3.1416]);
      print('inserted2: $id2');
      return id1;
    });
  }
  Future<ExpenseModel> addExpense(ExpenseModel newExpense) async{
    final db = await database;
    if(newExpense.saved_ts==null)newExpense.saved_ts=DateTime.now();
    await db.transaction((transaction) async {


      int id = await transaction.rawInsert(
          'INSERT into Expenses(title, type, content, money, date, cat_id, saved_ts,friend_id,date_id) VALUES ("${newExpense.title}",${newExpense.type} , "${newExpense.content}", ${newExpense.money},"${newExpense.date.toIso8601String()}", ${newExpense.cat_id},"${newExpense.saved_ts.toIso8601String()}", ${newExpense.friend_id},${newExpense.date_id} );');
      newExpense.id = id;
      print('Expense added: ${id}');

      FirebaseUser user = await _auth.currentUser();

      DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Expenses").document(newExpense.id.toString());


      ref.setData(newExpense.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
        print("nhi chala\n"),print("hello")
      }).timeout(Duration(seconds: 2),onTimeout:() {

        //FirebaseDatabase.instance.purgeOutstandingWrites();

        print("timeout nhi chala\n");
      });
    });
    return newExpense;
  }
  Future<CatModel> addCat(CatModel newActivity) async{
    final db = await database;
    if(newActivity.saved_ts==null)newActivity.saved_ts=DateTime.now();
    await db.transaction((transaction) async {


      int id = await transaction.rawInsert(
          'INSERT into Cats (name, image, total,saved_ts) VALUES ("${newActivity.name}","${newActivity.image}" , ${newActivity.total},"${newActivity.saved_ts.toIso8601String()}");');
      newActivity.id = id;
      print('Activity added: ${id}');
      FirebaseUser user = await _auth.currentUser();

      DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Cats").document(newActivity.id.toString());


      ref.setData(newActivity.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
        print("nhi chala\n"),print("hello")
      }).timeout(Duration(seconds: 2),onTimeout:() {

        //FirebaseDatabase.instance.purgeOutstandingWrites();

        print("timeout nhi chala\n");
      });

      return newActivity;
    });

  }

  Future<CatModel> addCatToInitialCloud(CatModel newActivity) async{
    final db = await database;
    if(newActivity.saved_ts==null)newActivity.saved_ts=DateTime.now();



      DocumentReference ref = _fireDB.collection('StartData').document('data').collection("Cats").document( newActivity.id.toString());


      ref.setData(newActivity.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
        print("nhi chala\n"),print("hello")
      }).timeout(Duration(seconds: 2),onTimeout:() {

        //FirebaseDatabase.instance.purgeOutstandingWrites();

        print("timeout nhi chala\n");
      });




  }
  Future<FriendModel> addFriend(FriendModel newActivity) async{
    final db = await database;
    if(newActivity.saved_ts==null)newActivity.saved_ts=DateTime.now();
    await db.transaction((transaction) async {


      int id = await transaction.rawInsert(
          'INSERT into Friends (name,  total, saved_ts) VALUES ("${newActivity.name}" , ${newActivity.total},"${newActivity.saved_ts.toIso8601String()}");');
      newActivity.id = id;
      print('Activity added: ${id}');

      FirebaseUser user = await _auth.currentUser();

      DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Friends").document(newActivity.id.toString());


      ref.setData(newActivity.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
        print("nhi chala\n"),print("hello")
      }).timeout(Duration(seconds: 2),onTimeout:() {

        //FirebaseDatabase.instance.purgeOutstandingWrites();

        print("timeout nhi chala\n");
      });

      return newActivity;
    });

  }
  Future<ActivityModel> addActivity(ActivityModel newActivity) async{
    final db = await database;
    if(newActivity.saved_ts==null)newActivity.saved_ts=DateTime.now();
    await db.transaction((transaction) async {


      int id = await transaction.rawInsert(
          'INSERT into Activity(name, image, weight,saved_ts) VALUES ("${newActivity.name}","${newActivity.image}" , ${newActivity.weight},"${newActivity.saved_ts.toIso8601String()}");');
      newActivity.id = id;
      print('Activity added: ${id}');
      FirebaseUser user = await _auth.currentUser();

      DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Activity").document(newActivity.id.toString());


      ref.setData(newActivity.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
        print("nhi chala\n"),print("hello")
      }).timeout(Duration(seconds: 2),onTimeout:() {

        //FirebaseDatabase.instance.purgeOutstandingWrites();

        print("timeout nhi chala\n");
      });
      return newActivity;
    });

  }
  void addActivityToInitialCloud(ActivityModel newActivity) async{
    final db = await database;

    if(newActivity.saved_ts==null)newActivity.saved_ts=DateTime.now();




      FirebaseUser user = await _auth.currentUser();

      DocumentReference ref = _fireDB.collection('StartData').document('data').collection("Activity").document( newActivity.id.toString());


      ref.setData(newActivity.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
        print("nhi chala\n"),print("hello")
      }).timeout(Duration(seconds: 2),onTimeout:() {

        //FirebaseDatabase.instance.purgeOutstandingWrites();

        print("timeout nhi chala\n");
      });


  }
  Future<UserAModel> addUserActivity(UserAModel newActivity) async{
    final db = await database;
    if(newActivity.saved_ts==null)newActivity.saved_ts=DateTime.now();
    await db.transaction((transaction) async {


      int id = await transaction.rawInsert(
          'INSERT into User_Activity(name, image, a_id,saved_ts) VALUES ("${newActivity.name}","${newActivity.image}" , ${newActivity.a_id},"${newActivity.saved_ts.toIso8601String()}");');
      newActivity.id = id;
      print('Activity added: ${id}');

      FirebaseUser user = await _auth.currentUser();

      DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("User_Activity").document(newActivity.id.toString());


      ref.setData(newActivity.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
        print("nhi chala\n"),print("hello")
      }).timeout(Duration(seconds: 2),onTimeout:() {

        //FirebaseDatabase.instance.purgeOutstandingWrites();

        print("timeout nhi chala\n");
      });
    });
    return newActivity;
  }
  Future<UserAModel> addUserActivityToInitialCloud(UserAModel newActivity) async{
    final db = await database;

    if(newActivity.saved_ts==null)newActivity.saved_ts=DateTime.now();

      FirebaseUser user = await _auth.currentUser();

      DocumentReference ref = _fireDB.collection('StartData').document('data').collection("User_Activity").document(newActivity.id.toString());


      ref.setData(newActivity.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
        print("nhi chala\n"),print("hello")
      }).timeout(Duration(seconds: 2),onTimeout:() {

        //FirebaseDatabase.instance.purgeOutstandingWrites();

        print("timeout nhi chala\n");
      });


  }
  Future<DateModel> addDateInDB(DateModel newDate) async {
    final db = await database;
    if(newDate.saved_ts==null)newDate.saved_ts=DateTime.now();
    if (newDate.l_interval==null)newDate.l_interval=0;
    if (newDate.l_streak==null)newDate.l_streak=0;
    if (newDate.c_streak==null)newDate.c_streak=0;
    if (newDate.p_rating==null)newDate.p_rating=0;
    if (newDate.a_rating==null)newDate.a_rating=0;
    if (newDate.ImageUrl==null)newDate.ImageUrl="https://i.picsum.photos/id/108/200/300.jpg";
    if (newDate.dayName==null)newDate.dayName="";

    await db.transaction((transaction) async {
      var formatter = new DateFormat('dd-MM-yyyy');
      String formatted_date = formatter.format(newDate.date);
      int id = await transaction.rawInsert(
          'INSERT into Dates(time_start, time_end, date, survey, ImageUrl, dayName, p_rating, a_rating, c_streak, l_streak, l_interval, saved_ts) VALUES ("${newDate.time_start.toIso8601String()}","${newDate.time_end.toIso8601String()}" , "${formatted_date}",${newDate.survey},"${newDate.ImageUrl}","${newDate.dayName}",${newDate.p_rating},${newDate.a_rating},${newDate.c_streak},${newDate.l_streak},${newDate.l_interval},"${newDate.saved_ts.toIso8601String()}");');
      newDate.id = id;
      print('Date added: $formatted_date ${id}');
      FirebaseUser user = await _auth.currentUser();

      DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Dates").document(newDate.id.toString());


      ref.setData(newDate.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
        print("nhi chala\n"),print("hello")
      }).timeout(Duration(seconds: 2),onTimeout:() {

        //FirebaseDatabase.instance.purgeOutstandingWrites();

        print("timeout nhi chala\n");
      });
    });


    return newDate;
  }
  Future<ReventModel> addReventInDB(ReventModel newRevent) async {
    final db = await database;
    if(newRevent.saved_ts==null)newRevent.saved_ts=DateTime.now();
    await db.transaction((transaction) async {


      int id = await transaction.rawInsert(
          'INSERT into Revents(start_date, end_date, event_id, sun,mon,tue,wed,thu,fri,sat,saved_ts) VALUES ("${newRevent.start_date.toIso8601String()}","${newRevent.end_date.toIso8601String()}" , ${newRevent.event_id},${newRevent.sun},${newRevent.mon},${newRevent.tue},${newRevent.wed},${newRevent.thu},${newRevent.fri},${newRevent.sat},"${newRevent.saved_ts.toIso8601String()}");');
      newRevent.id = id;
      print("Revent saved");
      FirebaseUser user = await _auth.currentUser();

      DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Revents").document(newRevent.id.toString());


      ref.setData(newRevent.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
        print("nhi chala\n"),print("hello")
      }).timeout(Duration(seconds: 2),onTimeout:() {

        //FirebaseDatabase.instance.purgeOutstandingWrites();

        print("timeout nhi chala\n");
      });

    });


    return newRevent;
  }


  Future<int> fun() async {
    final db = await database;
    await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
      print('inserted1: $id1');
      int id2 = await txn.rawInsert(
          'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
          ['another name', 12345678, 3.1416]);
      print('inserted2: $id2');
      return id1;
    });
  }
  Future<EventModel> addEventInDB(EventModel newEvent) async {
    final db = await database;
    if(newEvent.saved_ts==null)newEvent.saved_ts=DateTime.now();
    if(newEvent.cal_id==null)newEvent.cal_id="0";
    await db.transaction((transaction) async{
      int id=await transaction.rawInsert(
          'INSERT into Events(title, content, date, isImportant, duration, r_id, todo_id,date_id,time,a_id,timeline_id,saved_ts,cal_id) VALUES ("${newEvent.title}", "${newEvent.content}", "${newEvent.date.toIso8601String()}", ${newEvent.isImportant == true ? 1 : 0},${newEvent.duration},${newEvent.r_id},${newEvent.todo_id},${newEvent.date_id}, "${newEvent.time.toIso8601String()}",${newEvent.a_id},${newEvent.timeline_id},"${newEvent.saved_ts.toIso8601String()}","${newEvent.cal_id}");');
      newEvent.id = id;

      FirebaseUser user = await _auth.currentUser();

      DocumentReference ref = _fireDB.collection('users').document(user.uid).collection("Events").document(newEvent.id.toString());


      ref.setData(newEvent.toMap()).then((value) => print(ref.documentID)).catchError((onError)=>{
        print("nhi chala\n"),print("hello")
      }).timeout(Duration(seconds: 2),onTimeout:() {

        //FirebaseDatabase.instance.purgeOutstandingWrites();

        print("timeout nhi chala\n");
      });

    });


    return newEvent;
  }


   Future<void> cleanDatabase() async {
    try{
      final db = await database;
      await db.transaction((txn) async {
        var batch = txn.batch();
        for (int i=0;i<tables.length;i++){
          batch.delete(tables[i]);
        }

        await batch.commit();
        print("deleted all data");
      });
    } catch(error){
      throw Exception('DbBase.cleanDatabase: ' + error.toString());
    }
  }


  //We are not going to use this in the demo

}

