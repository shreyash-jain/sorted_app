import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/data/notebook.dart';
import '../data/models.dart';

List<Color> colorList = [
  Colors.blue,
  Colors.green,
  Colors.indigo,
  Colors.red,
  Colors.cyan,
  Colors.teal,
  Colors.amber.shade900,
  Colors.deepOrange
];

class NotebookCardComponent extends StatelessWidget {
  const NotebookCardComponent({
    this.notebookData,
    this.onTapAction,
    Key key,
  }) : super(key: key);
  final NoteBookModel notebookData;
  final Function(NoteBookModel noteData) onTapAction;

  @override
  Widget build(BuildContext context) {
    String neatDate = DateFormat.yMd().add_jm().format(notebookData.date);
    Color color =
        colorList.elementAt(notebookData.title.length % colorList.length);
    return Container(
        margin: EdgeInsets.fromLTRB(10, 8, 10, 8),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),

          boxShadow: [buildBoxShadow(color, context)],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          color: Theme.of(context).dialogBackgroundColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              onTapAction(notebookData);
            },
            splashColor: color.withAlpha(20),
            highlightColor: color.withAlpha(10),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${notebookData.title.trim().length <= 20 ? notebookData.title.trim() : notebookData.title.trim().substring(0, 20) + '...'}',
                    style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 20,
                        fontWeight: notebookData.isImportant
                            ? FontWeight.w800
                            : FontWeight.normal),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      '${notebookData.notes_num} notes',
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade400),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 14),
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.flag,
                            size: 16,
                            color: notebookData.isImportant
                                ? color
                                : Colors.transparent),
                        Spacer(),
                        Text(
                          '$neatDate',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  BoxShadow buildBoxShadow(Color color, BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return BoxShadow(
          color: notebookData.isImportant == true
              ? Colors.black.withAlpha(100)
              : Colors.black.withAlpha(10),
          blurRadius: 8,
          offset: Offset(0, 8));
    }
    return BoxShadow(
        color: notebookData.isImportant == true
            ? color.withAlpha(60)
            : color.withAlpha(25),
        blurRadius: 8,
        offset: Offset(0, 8));
  }
}

class AddNotebookCardComponent extends StatelessWidget {
  const AddNotebookCardComponent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 8, 10, 8),

        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),

          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [BoxShadow(color: Theme.of(context).primaryColor,offset: Offset(0, 0),
              blurRadius:10),
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColor,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Add new notebook',
                            style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                color: Theme.of(context).primaryColor,
                                fontSize: 20),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
