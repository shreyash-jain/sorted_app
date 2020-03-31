

import 'package:intl/intl.dart';
import 'package:notes/data/answer.dart';
import 'package:notes/data/date.dart';
import 'package:notes/data/event.dart';
import 'package:notes/data/notebook.dart';
import 'package:notes/data/question.dart';
import 'package:notes/data/reminder.dart';
import 'package:notes/data/todo.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_porter/utils/csv_utils.dart';
import '../data/models.dart';
import 'dart:io';
final todoTABLE = 'Todo';
class NotesDatabaseService {
  String path;

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
      /*SQLITE doesn't have boolean type
        so we store isDone as integer where 0 is false
        and 1 is true*/
          "is_done INTEGER "
          ")");
      await db.execute("CREATE TABLE Dates ("
          "id INTEGER PRIMARY KEY, "
          "date TEXT, "
          "time_start TEXT, "
          "time_end TEXT "
      /*SQLITE doesn't have boolean type
        so we store isDone as integer where 0 is false
        and 1 is true*/

          ")");
      await db.execute("CREATE TABLE Events ("
          "id INTEGER PRIMARY KEY, "
          "todo_id INTEGER, "
          "date_id INTEGER, "
          "content TEXT, "
          "title TEXT, "
          "date TEXT, "
          "time TEXT, "
          "isImportant INTEGER, "
      "duration DOUBLE, "
      "reminder INTEGER "
          ")");
      await db.execute(
          'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');

      await db.execute(
          '''CREATE TABLE Notes (_id INTEGER PRIMARY KEY, book_id INTEGER, title TEXT, content TEXT, date TEXT, isImportant INTEGER);''');
      print('New table created at 1 $path');
      await db.execute(
          '''CREATE TABLE Notebooks (_id INTEGER PRIMARY KEY, title TEXT, notes_num INTEGER, date TEXT, isImportant INTEGER);''');
      print('New table created at 2 $path');
      await db.execute(
          '''CREATE TABLE Questions (_id INTEGER PRIMARY KEY, title TEXT, ans1 TEXT,ans2 TEXT,ans3 TEXT,type INTEGER, num_ans INTEGER, interval INTEGER,archive INTEGER,priority INTEGER,correct_ans INTEGER);''');
      print('New table created at 3 $path');
      await db.execute(
          '''CREATE TABLE Library (_id INTEGER PRIMARY KEY, title TEXT, ans1 TEXT,ans2 TEXT,ans3 TEXT,type INTEGER, num_ans INTEGER, interval INTEGER,archive INTEGER,priority INTEGER,correct_ans INTEGER);''');
      await db.execute(
          '''CREATE TABLE Answers (_id INTEGER PRIMARY KEY,q_id INTEGER, response1 INTEGER,response2 INTEGER,response3 INTEGER,content TEXT, date TEXT,streak INTEGER,discription TEXT);''');
      print('New table created at 4 $path');
      await db.execute(
          '''CREATE TABLE Reminders (_id INTEGER PRIMARY KEY,note_id INTEGER, type INTEGER,content TEXT, date TEXT);''');
      print('New table created at $path');
    });

  }

  Future<int> createTodo(Todo todo) async {
    final db = await database;
    var result = db.insert('Todo', todo.toDatabaseJson());
    return result;
  }
  Future<List<NotesModel>> getNotesFromDB(int id) async {
    final db = await database;
    List<NotesModel> notesList = [];
    String strId = id.toString();
    List<Map> maps = await db.query('Notes',
        where: "book_id=" + strId,
        columns: ['_id', 'title', 'book_id', 'content', 'date', 'isImportant']);
    if (maps.length > 0) {
      maps.forEach((map) {
        notesList.add(NotesModel.fromMap(map));
      });
    }
    for (var i = 0; i < notesList.length; i++) {
      print("idhar" + notesList[i].content);
      notesList[i].content = notesList[i].content.replaceAll("'", '"');
    }
    return notesList;
  }
  Future<NotesModel> getNoteByIDFromDB(int id) async {
    final db = await database;
    List<NotesModel> notesList = [];
    String strId = id.toString();
    List<Map> maps = await db.query('Notes',
        where: "_id=" + strId,
        columns: ['_id', 'title', 'book_id', 'content', 'date', 'isImportant']);
    if (maps.length > 0) {
      maps.forEach((map) {
        notesList.add(NotesModel.fromMap(map));
      });
    }
    for (var i = 0; i < notesList.length; i++) {
      print("idhar" + notesList[i].content);
      notesList[i].content = notesList[i].content.replaceAll("'", '"');
    }
    return notesList[0];
  }

  Future<List<NotesModel>> getAllNotesFromDB() async {
    final db = await database;
    List<NotesModel> notesList = [];

    List<Map> maps = await db.query('Notes',

        columns: ['_id', 'title', 'book_id', 'content', 'date', 'isImportant']);
    print(maps.length);
    if (maps.length > 0) {
      maps.forEach((map) {
        notesList.add(NotesModel.fromMap(map));
      });
    }
    for (var i = 0; i < notesList.length; i++) {
      print("idhar" + notesList[i].content);
      notesList[i].content = notesList[i].content.replaceAll("'", '"');
    }
    return notesList;
  }
  Future<List<AnswerModel>> getAllAnswersFromDB() async {
    final db = await database;
    List<AnswerModel> notesList = [];

    List<Map> maps = await db.query('Answers',

        columns: ['_id', 'q_id' , 'response1' ,'response2' ,'response3' ,'content' , 'date' ,'streak','discription' ]);
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
        columns: ['_id', 'note_id', 'type', 'content', 'date']);
    if (maps.length > 0) {
      maps.forEach((map) {
        remList.add(ReminderModel.fromMap(map));
      });
    }
    return remList;
  }

  Future<List<NoteBookModel>> getNotebookFromDB() async {
    final db = await database;
    List<NoteBookModel> notesList = [];
    print('Note updated....');
    List<Map> maps = await db.query('Notebooks',
        columns: ['_id', 'title', 'notes_num', 'date', 'isImportant']);
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
      'ans3'
    ]);
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
    List<Map> maps = await db.query('Library', columns: [
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
      'ans3'
    ],
        where: 'archive=?',
        whereArgs: [0]);
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
        columns: ['id', 'title', 'time','content', 'date', 'isImportant','reminder','duration','date_id','todo_id']
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
  Future<List<EventModel>> getEventsFromDB() async {
    final db = await database;
    List<EventModel> eventsList = [];
    List<Map> maps = await db.query('Events',

        columns: ['id', 'title', 'time','content', 'date', 'isImportant','reminder','duration','date_id','todo_id']

        );
    if (maps.length > 0) {
      maps.forEach((map) {
        eventsList.add(EventModel.fromMap(map));
      });
    }
    return eventsList;
  }
  Future<EventModel> getEventFromDB(int query) async {
    final db = await database;
    List<EventModel> event = [];
    List<Map> maps = await db.query('Events',
        columns: ['id', 'title','time', 'content', 'date', 'isImportant','reminder','duration','date_id','todo_id']
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
        columns: ['_id', 'title', 'notes_num', 'date', 'isImportant'],
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

  deleteQuestionInDB(QuestionModel quesToDelete) async {
    final db = await database;
    await db
        .delete('Questions', where: '_id = ?', whereArgs: [quesToDelete.id]);
    print('Question deleted');
  }
  deleteLibraryQuestionInDB(QuestionModel quesToDelete) async {
    final db = await database;
    await db
        .delete('Library', where: '_id = ?', whereArgs: [quesToDelete.id]);
    print('Question deleted');
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
        columns: ['_id', 'title', 'notes_num', 'date', 'isImportant']);
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
    if (!newQues.title.trim().isEmpty) {
      int id = await db.transaction((transaction) {
        transaction.rawInsert(
            'INSERT into Questions(title, num_ans, type, interval, ans1,ans2,ans3,archive,correct_ans,priority) VALUES ("${newQues.title}",${newQues.num_ans}, ${newQues.type}, ${newQues.interval}, "${newQues.ans1}","${newQues.ans2}","${newQues.ans3}", ${newQues.archive}, ${newQues.correct_ans}, ${newQues.priority});');
      });
      print("insert Question with id: " + id.toString());
      newQues.id = id;
      return newQues;
    }
  }
  Future<QuestionModel> addLibraryQuestionInDB(QuestionModel newQues) async {
    final db = await database;
    if (!newQues.title.trim().isEmpty) {
      int id = await db.transaction((transaction) {
        transaction.rawInsert(
            'INSERT into Library(title, num_ans, type, interval, ans1,ans2,ans3,archive,correct_ans,priority) VALUES ("${newQues.title}",${newQues.num_ans}, ${newQues.type}, ${newQues.interval}, "${newQues.ans1}","${newQues.ans2}","${newQues.ans3}", ${newQues.archive}, ${newQues.correct_ans}, ${newQues.priority});');
      });
      print("insert Question with id: " + id.toString());
      newQues.id = id;
      return newQues;
    }
  }

  Future<ReminderModel> addReminderInDB(ReminderModel newRem) async {
    final db = await database;
    int id = await db.transaction((transaction) {
      transaction.rawInsert(
          'INSERT into Reminders(note_id, type, content, date) VALUES ("${newRem.note_id}",${newRem.type}, "${newRem.content}","${newRem.date.toIso8601String()}");');
    });
    print("insert Reminder with id: " + id.toString());
    newRem.id = id;
    return newRem;
  }

  Future<AnswerModel> addAnswerInDB(AnswerModel newAns) async {
    final db = await database;
    int id = await db.transaction((transaction) {
      transaction.rawInsert(
          'INSERT into Answers(q_id, streak, response1,response2,response3,content,date,discription) VALUES ("${newAns.q_id}","${newAns.streak}", "${newAns.res1}", "${newAns.res2}", ${newAns.res3},"${newAns.content}","${newAns.date.toIso8601String()}","${newAns.discription}");');
    });
    print("going in "+ newAns.content);
    newAns.id = id;
    return newAns;
  }


  Future<DateModel> getDateByIdFromDB(int query) async {
    final db = await database;
    List<DateModel> event = [];
    List<Map> maps = await db.query('Dates',
        columns: ['id',  'date', 'time_start','time_end']
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
    if (newNote.title.trim().isEmpty) newNote.title = 'Untitled Notebook';
    newNote.notes_num = 0;
    int id = await db.transaction((transaction) {
      transaction.rawInsert(
          'INSERT into Notebooks(title, notes_num, date, isImportant) VALUES ("${newNote.title}", "${newNote.notes_num}", "${newNote.date.toIso8601String()}",${newNote.isImportant == true ? 1 : 0});');
    });
    newNote.id = id;
    print('Notebook added id: ' + id.toString());
    print('Notebook added: ${newNote.title} ${newNote.notes_num}');
    return newNote;
  }
  Future<DateModel> getDateByDateFromDB(String query) async {
    print(query);
    final db = await database;
    List<DateModel> event = [];
    List<Map> maps = await db.query('Dates',
        columns: ['id',  'date', 'time_start','time_end']
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
    updatedNote.content = updatedNote.content.replaceAll('"', "\'");
    await db.update('Notes', updatedNote.toMap(),
        where: '_id = ?', whereArgs: [updatedNote.id]);
    print('Note updated: ${updatedNote.title} ${updatedNote.content}');
    print('Note updated: ${updatedNote.title} ${updatedNote.content}');
  }
  updateQuestionInDB(QuestionModel updatedQues) async {
    final db = await database;

    await db.update('Questions', updatedQues.toMap(),
        where: '_id = ?', whereArgs: [updatedQues.id]);

  }
  updateLibraryQuestionInDB(QuestionModel updatedQues) async {
    final db = await database;

    await db.update('Library', updatedQues.toMap(),
        where: '_id = ?', whereArgs: [updatedQues.id]);

  }

  updateDateInDB(DateModel updatedDate) async {
    final db = await database;
    await db.update('Dates', updatedDate.toMap(),
        where: '_id = ?', whereArgs: [updatedDate.id]);
    print('Date updated ');
  }
  updateEventInDB(EventModel updatedEvent) async {
    final db = await database;
    await db.update('Events', updatedEvent.toMap(),

        where: 'id = ?', whereArgs: [updatedEvent.id]);
    print('Event updated: ${updatedEvent.title} ${updatedEvent.content}');
  }

  deleteNoteInDB(NotesModel noteToDelete) async {
    final db = await database;
    await db.delete('Notes', where: '_id = ?', whereArgs: [noteToDelete.id]);
    print('Note deleted');
  }
  deleteEventInDB(EventModel eventToDelete) async {
    final db = await database;
    await db.delete('Events', where: 'id = ?', whereArgs: [eventToDelete.id]);
    print('Event deleted');
  }

  Future<NotesModel> addNoteInDB(NotesModel newNote) async {
    final db = await database;
    if (newNote.title.trim().isEmpty) newNote.title = 'Untitled Note';
    newNote.content = newNote.content.replaceAll('"', "\'");
    print("replaced : " + newNote.content);
    int id = await db.transaction((transaction) {
      transaction.rawInsert(
          'INSERT into Notes(title, book_id, content, date, isImportant) VALUES ("${newNote.title}","${newNote.book_id}", "${newNote.content}", "${newNote.date.toIso8601String()}", ${newNote.isImportant == true ? 1 : 0});');
    });
    newNote.id = id;
    print('Note added: ${newNote.title} ${newNote.content}');
    return newNote;
  }

  Future<DateModel> addDateInDB(DateModel newDate) async {
    final db = await database;

    await db.transaction((transaction) async {
      var formatter = new DateFormat('dd-MM-yyyy');
      String formatted_date = formatter.format(newDate.date);
      int id = await transaction.rawInsert(
          'INSERT into Dates(time_start, time_end, date) VALUES ("${newDate.time_start.toIso8601String()}","${newDate.time_end.toIso8601String()}" , "${formatted_date}");');
      newDate.id = id;
      print('Date added: $formatted_date ${id}');
    });


    return newDate;
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

    int id = await db.transaction((transaction) async{
      transaction.rawInsert(
          'INSERT into Events(title, content, date, isImportant, duration, reminder, todo_id,date_id,time) VALUES ("${newEvent.title}", "${newEvent.content}", "${newEvent.date.toIso8601String()}", ${newEvent.isImportant == true ? 1 : 0},${newEvent.duration},${newEvent.reminder},${newEvent.todo_id},${newEvent.date_id}, "${newEvent.time.toIso8601String()}");');
    });
    newEvent.id = id;
    print('Event added: ${newEvent.title} $id');
    return newEvent;
  }





  //We are not going to use this in the demo

}

