import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/PROFILE/data/models/activity.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/flow_bloc/flow_bloc.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/interest_bloc/interest_bloc.dart';

class ActivityItem extends StatelessWidget {
  final int index;
  final ActivityModel activity;
  final List<UserAModel> userActivities;
  final Function(ActivityModel activity, UserInterestBloc interestBloc) onTapAction;


  const ActivityItem({
    Key key,
    this.activity,
    this.onTapAction,
    this.userActivities, this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        onTapAction(activity,BlocProvider.of<UserInterestBloc>(context))  
      },
      child: Padding(
        padding: EdgeInsets.only(),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8.0),
          width: Gparam.width/4,
          
         
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
              if(userActivities.where((element) => element.aId==activity.id).length==0)Padding(
                padding: EdgeInsets.all(4),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    activity.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'ZillaSlab',
                        fontSize: 20,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 4.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2.0,
                            color: Color.fromARGB(255, 0, 0, 2),
                          ),
                        ],
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              if(userActivities.where((element) => element.aId==activity.id).length>0)Padding(
                padding: EdgeInsets.only(),
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.add_circle,
                    size: 50,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
