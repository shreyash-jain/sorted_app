import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:auto_route/auto_route.dart';

class ClassListPage extends StatefulWidget {
  final String classId;
  ClassListPage({Key key, this.classId}) : super(key: key);

  @override
  _ClassListPageState createState() => _ClassListPageState();
}

class _ClassListPageState extends State<ClassListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Gtheme.stext(widget.classId),
            ),
          ],
        ),
      ),
    );
  }
}
