import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/data/notebook.dart';
import 'package:notes/services/database.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:convert';

// access to jsonEncode()
import 'dart:io';

// access to File and Directory classes
import 'package:notes/data/models.dart';

class EditorPage extends StatefulWidget {
  @override
  Function() triggerRefetch;
  NotesModel existingNote;
  final int book_id;

  EditorPage(
      {Key key,
      Function() triggerRefetch,
      NotesModel existingNote,
      @required this.book_id})
      : super(key: key) {
    this.triggerRefetch = triggerRefetch;
    this.existingNote = existingNote;
  }

  @override
  EditorPageState createState() => EditorPageState(book_id);
}

class EditorPageState extends State<EditorPage> {
  /// Allows to control the editor and the document.
  ZefyrController _controller;   /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;
  bool isDirty = false;
  bool isNoteNew = true;
  List<NoteBookModel> notebookList = [];
  FocusNode titleFocus = FocusNode();
  NotesModel currentNote;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  int my_id;
  String title_text;
  final List<String> _types = [];

  var _selectedType; //The list of values we want on the dropdown

  EditorPageState(int book_id) {
    my_id = book_id;
  }

  @override
  void initState() {
    super.initState();
    // Here we must load the document and pass it to Zefyr controller.
    if (widget.existingNote == null) {
      currentNote = NotesModel(
          content: '',
          title: 'Add a title',
          date: DateTime.now(),
          isImportant: false,
          book_id: my_id);
      isNoteNew = true;
    } else {
      currentNote = widget.existingNote;
      isNoteNew = false;
    }
    LoadNotebooks();
    titleController.text = "hello";
    title_text = currentNote.title;
    titleController.text = currentNote.title;
    final document = _loadDocument();
    _loadDocument().then((document) {
      setState(() {
        _controller = ZefyrController(document);
      });
    });
    _focusNode = FocusNode();
  }
  LoadNotebooks() async {
    var fetchedNotes = await NotesDatabaseService.db.getNotebookFromDB();
    setState(() {
      notebookList = fetchedNotes;
    });
    for(int i=0;i<notebookList.length;i++){
      _types.add(notebookList[i].title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor.withOpacity(0.2),
        actions: <Widget>[
          IconButton(
            tooltip: 'Mark note as important',
            icon: Icon(
                Icons.book),
            onPressed:()=> _displayDialog(context)

          ),
          IconButton(
            tooltip: 'Mark note as important',
            icon: Icon(
                currentNote.isImportant ? Icons.flag : Icons.outlined_flag),
            onPressed: currentNote.title != "Add a title"
                ? markImportantAsDirty
                : null,
          ),
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              handleDelete();
            },
          ),
          AnimatedContainer(
            margin: EdgeInsets.only(left: 10),
            duration: Duration(milliseconds: 200),
            width: null,
            height: 42,
            curve: Curves.decelerate,
            child: RaisedButton.icon(
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      bottomLeft: Radius.circular(100))),
              icon: Icon(Icons.done),
              label: Text(
                'SAVE',
                style: TextStyle(letterSpacing: 1),
              ),
              onPressed: handleSave,
            ),
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: handleBack,
        ),
        bottom: PreferredSize(
          child: GestureDetector(
            onTap: () {
              _settingModalBottomSheet(context);
            },
            child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 8),
                  child: Text(
                    title_text,
                    style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 22,
                        fontWeight: FontWeight.w700),
                  ),
                )),
          ),
          preferredSize: Size(0.0, 30.0),
        ),
      ),
      body: ZefyrScaffold(
        child: ZefyrEditor(
          padding: EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
          controller: _controller,
          focusNode: _focusNode,
          imageDelegate: MyAppZefyrImageDelegate(),
        ),
      ),
    );
  }
  _displayDialog(BuildContext context)  async {
    isDirty=true;


    return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
    return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('Change Notebook',style: TextStyle(
              fontFamily: 'ZillaSlab',
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),),
            content:  new DropdownButton(
              hint: Text(
                'Select',
                style: TextStyle(
                    fontFamily: 'ZillaSlab',
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: Colors.white),
              ),
              value: _selectedType,
              onChanged: (newValue)  {
                setState(() {
                  _selectedType = newValue;
                  int index=_types.indexOf(newValue);
                  currentNote.book_id=notebookList[index].id;

                isDirty=true;


                });
              },
              items: _types.map((location) {
                return DropdownMenuItem(
                  child: new Text(
                    location,
                    style: TextStyle(
                      fontFamily: 'ZillaSlab',
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                  value: location,
                );
              }).toList(),
            ),

            actions: <Widget>[
              new FlatButton(
                child: new Text('Confirm',style:TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );

  });});}

  Future<NotusDocument> _loadDocument() async {
    if (currentNote.content.trim() == "") {
      final Delta delta = Delta()..insert("\n");
      return NotusDocument.fromDelta(delta);
    } else {
      return NotusDocument.fromJson(jsonDecode(currentNote.content));
    }
  }

  void _saveDocument(BuildContext context) {
    // Notus documents can be easily serialized to JSON by passing to     //
    //`jsonEncode` directly
    final contents = jsonEncode(_controller
        .document); // For this example we save our document to a temporary file.
    final file = File(Directory.systemTemp.path +
        "/quick_start.json"); // And show a snack bar on success.
    file.writeAsString(contents).then((_) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Saved.")));
    });
  }

  void markImportantAsDirty() {
    setState(() {
      currentNote.isImportant = !currentNote.isImportant;
    });
    handleSave();
  }

  void handleDelete() async {
    if (isNoteNew) {
      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
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
                    await NotesDatabaseService.db.deleteNoteInDB(currentNote);
                    await NotesDatabaseService.db
                        .decreaseNotebookInDB(currentNote.book_id);
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
  }

  void handleSave() async {
    setState(() {
      currentNote.title = titleController.text;
      final contents = jsonEncode(_controller.document);
      currentNote.content = contents;
      print('Hey there ${currentNote.content}');
    });
    if (isNoteNew) {
      var latestNote = await NotesDatabaseService.db.addNoteInDB(currentNote);
      await NotesDatabaseService.db.updateNotebookInDB(currentNote.book_id);
      setState(() {
        currentNote = latestNote;
      });
    } else {
      await NotesDatabaseService.db.updateNoteInDB(currentNote);
    }
    setState(() {
      isNoteNew = false;
      isDirty = false;
    });
    widget.triggerRefetch();
    Navigator.pop(context);
    //contentFocus.unfocus();
  }

  void handleBack() {
    Navigator.pop(context);
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      left: 20,
                      top: 20),
                  child: TextField(
                    focusNode: titleFocus,
                    autofocus: true,
                    controller: titleController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 1,
                    onSubmitted: (text) {
                      titleFocus.unfocus();
                      currentNote.title = titleController.text;
                      setState(() {
                        title_text = currentNote.title;
                      });
                      Navigator.pop(context);
                    },
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 32,
                        fontWeight: FontWeight.w700),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Enter a title',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 32,
                          fontFamily: 'ZillaSlab',
                          fontWeight: FontWeight.w700),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  // this will take space as minimum as posible(to center)
                  children: <Widget>[
                    new RaisedButton(
                      child: new Text('Add'),
                      onPressed: () async {
                        //handleSave();
                        setState(() {
                          currentNote.title = titleController.text;
                          title_text = currentNote.title;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    new RaisedButton(
                        child: new Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class MyAppZefyrImageDelegate implements ZefyrImageDelegate<ImageSource> {
  @override
  Future<String> pickImage(ImageSource source) async {
    final file = await ImagePicker.pickImage(source: source);
    if (file == null)
      return null; // We simply return the absolute path to selected file.
    return file.uri.toString();
  }

  @override
  Widget buildImage(BuildContext context, String key) {
    final file = File.fromUri(Uri.parse(key));

    /// Create standard [FileImage] provider. If [key] was an HTTP link   /// we could use [NetworkImage] instead.
    final image = FileImage(file);
    return Image(image: image);
  }

  @override // TODO: implement cameraSource
  ImageSource get cameraSource => ImageSource.camera;

  @override // TODO: implement gallerySource
  ImageSource get gallerySource => ImageSource.gallery;
}
