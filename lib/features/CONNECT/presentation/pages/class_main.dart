import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:auto_route/auto_route.dart';

class ClassMain extends StatefulWidget {
  ClassMain({Key key}) : super(key: key);

  @override
  _ClassMainState createState() => _ClassMainState();
}

class _ClassMainState extends State<ClassMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: MaterialButton(
                onPressed: () {
                  context.router.push(CashFreeTest());
                },
                child: Gtheme.stext("payments"))),
      ),
    );
  }
}
