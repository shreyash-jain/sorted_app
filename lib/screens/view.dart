import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:notes/data/models.dart';
import 'package:notes/data/reminder.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:notes/screens/richedit.dart';
import 'package:notes/services/database.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import 'package:zefyr/zefyr.dart';

class ViewNotePage extends StatefulWidget {
  Function() triggerRefetch;
  NotesModel currentNote;

  ViewNotePage({Key key, Function() triggerRefetch, NotesModel currentNote})
      : super(key: key) {
    this.triggerRefetch = triggerRefetch;
    this.currentNote = currentNote;
  }

  @override
  _ViewNotePageState createState() => _ViewNotePageState();
}

class _ViewNotePageState extends State<ViewNotePage> {
  int alarm = 0;
  ZefyrController _controller;
  String _date = "Not set";
  ReminderModel rem = new ReminderModel();
  FocusNode _focusNode;
  String content_show;
  double height = 100;
  ScreenshotController screenshotController = ScreenshotController();
  File _imageFile;
  var flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

  bool screenshot=false;

  Image myImage;
  @override
  void initState() {


    super.initState();

    showHeader();
    print("view_content: " +
        widget.currentNote.content
            .substring(1, widget.currentNote.content.length - 1));
    String f_content = "";
    List<dynamic> list = jsonDecode(widget.currentNote.content);
    int lines = list.length;

    if (lines > 1) {
      height = height + (30 * (lines - 1)) + 50;
    }


    final document = _loadDocument();

      setState(() {
        _controller = ZefyrController(document);
      });
    myImage= Image.asset("assets/images/SortedLogo.png");
    _focusNode = FocusNode();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(myImage.image, context);
  }
  void showHeader() async {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        headerShouldShow = true;
      });
    });
  }

  bool headerShouldShow = false;

  @override
  Widget build(BuildContext context) {
    if (height<MediaQuery.of(context).size.height-230)
      height=MediaQuery.of(context).size.height-228;
    //precacheImage( AssetImage( "assets/images/SortedLogo.png"),context);
    final editor = ZefyrField(

      height: height,
      // set the editor's height
      decoration: InputDecoration(
        labelText: 'Note',
        filled: true,
        fillColor: Colors.transparent,

      ),
      controller: _controller,
      focusNode: _focusNode,
      imageDelegate: MyAppZefyrImageDelegate(),
      mode: ZefyrMode(canEdit: false, canSelect: true, canFormat: false),
      autofocus: false,
      physics: ClampingScrollPhysics(),
    );
    return Scaffold(
        body: ZefyrScaffold(
            child:  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: <Widget>[
                    Screenshot(
                        controller: screenshotController,
                        child:
                Stack(
                children: <Widget>[

                  ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      if (!screenshot)Container(
                        height: 40,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 104, bottom: 24),
                        child: editor,
                      ),
                    ],
                  ),
                  ClipRect(
                    child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          height: 180,
                          color:
                          Theme.of(context).canvasColor.withOpacity(0.2),
                          child: SafeArea(
                            child: Row(
                              children: <Widget>[
                                Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 68.0, bottom: 8),
                                        child: AnimatedOpacity(
                                          opacity: headerShouldShow ? 1 : 0,
                                          duration:
                                          Duration(milliseconds: 200),
                                          curve: Curves.easeIn,
                                          child: Text(
                                            widget.currentNote.title,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontFamily: 'ZillaSlab',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 24,
                                            ),
                                            overflow: TextOverflow.visible,
                                            softWrap: true,
                                          ),
                                        ),
                                      ),
                                      AnimatedOpacity(
                                        duration: Duration(milliseconds: 500),
                                        opacity: headerShouldShow ? 1 : 0,
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(left: 16),
                                          child: Text(
                                            DateFormat.yMd().add_jm().format(
                                                widget.currentNote.date),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey.shade500),
                                          ),
                                        ),
                                      ),
                                    ]),
                                Spacer(),
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 500),
                                  opacity: headerShouldShow ? 1 : 0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 52, right: 12),
                                    child: IconButton(
                                      icon: Icon(
                                        (alarm == 0)
                                            ? Icons.alarm_add
                                            : Icons.alarm_on,
                                        size: 36,
                                        color: (alarm == 0)
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey,
                                      ),
                                      onPressed: addReminder,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),

                  if (screenshot)Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,

                    children: <Widget>[
                      SizedBox(width: 10,),
                      Image(
                        image: AssetImage(
                          "assets/images/SortedLogo.png",
                        ),
                        height:75,
                        width:75,
                      ),
                      SizedBox(width: 10,),


                        Text("Stay Sorted",style: TextStyle(
                          fontFamily: 'ZillaSlab',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),),
                        Text(", It starts here !",style: TextStyle(
                          fontFamily: 'ZillaSlab',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),)



                    ],),
                ])),

                    if (!screenshot)ClipRect(
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            height: 80,
                            color:
                                Theme.of(context).canvasColor.withOpacity(0.3),
                            child: SafeArea(
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    onPressed: handleBack,
                                  ),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(OMIcons.edit),
                                    onPressed: handleEdit,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.info_outline),
                                    onPressed: handleDelete,
                                  ),
                                  IconButton(
                                    icon: Icon(widget.currentNote.isImportant
                                        ? Icons.flag
                                        : Icons.outlined_flag),
                                    onPressed: () {
                                      markImportantAsDirty();
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline),
                                    onPressed: handleDelete,
                                  ),
                                  IconButton(
                                    icon: Icon(OMIcons.share),
                                    onPressed:() async {

                                       setState(() {


                                        screenshot=true;
                                        _imageFile = null;
                                         screenshotController
                                            .capture(delay: Duration(milliseconds: 10))
                                            .then((File image) async {
                                          //print("Capture Done");
                                          setState(() {
                                            _imageFile = image;


                                          });
                                          await handleShare(_imageFile);
                                        });
                                      });




                                      },
                                  ),
                                ],
                              ),
                            ),
                          )),
                    )
                  ],
                ))));
  }

  void handleSave() async {
    await NotesDatabaseService.db.updateNoteInDB(widget.currentNote);
    widget.currentNote.content = widget.currentNote.content.replaceAll('*%', '"');

  }

  void markImportantAsDirty() {
    setState(() {
      widget.currentNote.isImportant = !widget.currentNote.isImportant;
    });
    handleSave();
  }

  void handleEdit() {
    Navigator.pop(context);
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => EditorPage(
                  existingNote: widget.currentNote,
                  triggerRefetch: widget.triggerRefetch,
                )));
  }
  Future<void> _shareImage(File file) async {
    Uint8List bytes=  file.readAsBytesSync()  ;
    try {


      await Share.file(
          'esys image', 'esys.png', bytes, 'image/png', text: 'My optional text.');
    } catch (e) {
      print('error: $e');
    }
    setState(() {
      screenshot=false;
    });
  }
  Future<void> handleShare(File file) async {

    await _shareImage(file);
   }

  void handleBack() {
    Navigator.pop(context);
  }

  void handleDelete() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Delete Note'),
            content: Text('This note will be deleted permanently'),
            actions: <Widget>[
              FlatButton(
                child: Text('DELETE',
                    style: TextStyle(
                        color: Colors.red.shade300,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1)),
                onPressed: () async {
                  await NotesDatabaseService.db
                      .deleteNoteInDB(widget.currentNote);
                  await NotesDatabaseService.db
                      .decreaseNotebookInDB(widget.currentNote.book_id);
                  widget.triggerRefetch();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('CANCEL',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1)),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

 NotusDocument _loadDocument()  {
    return NotusDocument.fromJson(jsonDecode(widget.currentNote.content));
  }

  Future addReminder() async {
    if (alarm == 0) {
      DateTime rem_date=DateTime.now().add((Duration(days: 0)));
      DateTime date = await showDatePicker(
        context: context,
        firstDate:  DateTime.now().add((Duration(days: -1))),
        lastDate: DateTime.now().add((Duration(days: 60))),
        initialDate: rem_date,
      );
      if(date != null)
        {
          final TimeOfDay response = await showTimePicker(
            context: context,

            initialTime: TimeOfDay(hour:10,minute: 10 ),
          );
          if (response!=null)
          setState(()  {
          rem_date= date;
          date= DateTime(date.year,date.month,date.day,response.hour,response.minute);
          });
          var scheduledNotificationDateTime =
         date;
          var androidPlatformChannelSpecifics =
          AndroidNotificationDetails('your other channel id',
              'your other channel name', 'your other channel description');
          var iOSPlatformChannelSpecifics =
          IOSNotificationDetails();
          NotificationDetails platformChannelSpecifics = NotificationDetails(
              androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
          await flutterLocalNotificationsPlugin.schedule(
              0,

              ' ${widget.currentNote.title}',
              'Please go through this note, revisions are always helpful',
              scheduledNotificationDateTime,

              platformChannelSpecifics,
           payload: "note${widget.currentNote.id}");
          setState(() {
            rem.type = 0;
            rem.content =
            "Please go through this note, revisions are always helpful";
            rem.note_id = widget.currentNote.id;
            rem.date = date;
            alarm = 1;
          });
          await NotesDatabaseService.db.addReminderInDB(rem);
        }

    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: Text('Delete Reminder'),
              content: Text('This reminder will be deleted permanently'),
              actions: <Widget>[
                FlatButton(
                  child: Text('DELETE',
                      style: TextStyle(
                          color: Colors.red.shade300,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1)),
                  onPressed: () async {
                    await NotesDatabaseService.db.deleteReminderInDB(rem);
                    setState(() {
                      alarm = 0;
                    });
                    widget.triggerRefetch();
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('CANCEL',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
  }
}