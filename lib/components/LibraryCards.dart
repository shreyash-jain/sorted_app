import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/components/faderoute.dart';
import 'package:notes/data/notebook.dart';
import 'package:notes/data/question.dart';
import 'package:notes/screens/ListQuestion.dart';
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
String int_text;
String type;

class QuestionCardComponent extends StatelessWidget {
  const QuestionCardComponent({
    this.QuestionData,
    this.onTapAction,
    Key key,
  }) : super(key: key);
  final QuestionModel QuestionData;
  final Function(QuestionModel noteData) onTapAction;

  @override
  Widget build(BuildContext context) {
    int interval_int = QuestionData.interval;
    int q_type = QuestionData.type;
    if (q_type == 1)
      type = "has multipls choices";
    else if (q_type == 0)
      type = "has a short discription";
    else if (q_type == 2)
      type = "has a counter";
    else
      type = "has a time";
    if (interval_int == 1)
      int_text = "repeats Daily";
    else if (interval_int == 2)
      int_text = "repeats Weekly";
    else if (interval_int == 3) int_text = "repeats Monthly";
    Color color =
        colorList.elementAt(QuestionData.title.length % colorList.length);
    return Container(
        margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [buildBoxShadow(color, context)],
        ),
        child: Material(
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            color: Theme.of(context).dialogBackgroundColor,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                onTapAction(QuestionData);
              },
              splashColor: color.withAlpha(20),
              highlightColor: color.withAlpha(10),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${QuestionData.title.trim().length <= 45 ? QuestionData.title.trim() : QuestionData.title.trim().substring(0, 45) + '...'}',
                        style: TextStyle(
                            fontFamily: 'ZillaSlab',
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Text(
                          int_text,
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade400),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Text(
                          QuestionData.id.toString(),
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade400),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Text(
                              type,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Text(
                              "Add +",
                              style: TextStyle(
                                  fontFamily: 'ZillaSlab',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
            )));
  }

  BoxShadow buildBoxShadow(Color color, BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return BoxShadow(
          color: QuestionData.interval == 1
              ? Colors.black.withAlpha(100)
              : Colors.black.withAlpha(10),
          blurRadius: 8,
          offset: Offset(0, 8));
    }
    return BoxShadow(
        color: QuestionData.interval == 1
            ? color.withAlpha(60)
            : color.withAlpha(25),
        blurRadius: 8,
        offset: Offset(0, 8));
  }
}

