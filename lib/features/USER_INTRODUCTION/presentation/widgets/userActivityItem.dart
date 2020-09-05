import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';

import 'package:sorted/features/PROFILE/data/models/user_activity.dart';

class UserActivityItem extends StatelessWidget {
  final int index;
  final UserAModel activity;
  
  const UserActivityItem({
    Key key,
    this.activity,
     this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.only(),
        child: Container(
          
          margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2.0),
         
          
          
         
          child: Stack(
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      image: DecorationImage(
                          image:
                              AssetImage("assets/images/${activity.image}.jpg"),
                          fit: BoxFit.cover))),
             
            ],
          ),
        ),
      ),
    );
  }
}
