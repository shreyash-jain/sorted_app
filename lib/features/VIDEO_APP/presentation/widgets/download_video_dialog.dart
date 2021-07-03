import 'package:flutter/material.dart';

class DynamicDialog extends StatefulWidget {
  DynamicDialog({this.title, this.progress});

  final String title;
  final double progress;

  @override
  _DynamicDialogState createState() => _DynamicDialogState();
}

class _DynamicDialogState extends State<DynamicDialog> {
  String _title;
  double _progress;

  @override
  void initState() {
    _title = widget.title;
    _progress = widget.progress;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              final newText = 'Updated Title!';
              setState(() {
                _title = newText;
              });
            },
            child: Text('Change'))
      ],
    );
  }
}
