import 'package:flutter/material.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';

class AffirmationPV extends StatefulWidget {
  const AffirmationPV({Key key})
      : super(key: key);

  
  @override
  State<StatefulWidget> createState() => AffirmationPVState();
}

class AffirmationPVState extends State<AffirmationPV>
    {
  

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      
      child: Center(
          child: Container(
        width: 10,
        height: 10,
        color: Colors.blue,
      )),
    );
  }
}
