import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/PROFILE/data/models/activity.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/models/user_tag.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/flow_bloc/flow_bloc.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/interest_bloc/interest_bloc.dart';

class UserTagItem extends StatelessWidget {
  final int index;
  final type;
  final UserTag userTag;
  final List<UserTag> userSelectedTags;
  final Function(UserTag tag, UserInterestBloc interestBloc, int type)
      onTapAction;

  const UserTagItem({
    Key key,
    this.userTag,
    this.onTapAction,
    this.userSelectedTags,
    this.index,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(type);
        onTapAction(userTag, BlocProvider.of<UserInterestBloc>(context), type);
      },
      child: Padding(
        padding: EdgeInsets.only(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
                color: (userSelectedTags
                            .where((element) => (element.id == userTag.id))
                            .toList()
                            .length ==
                        0)
                    ? Colors.black.withOpacity(.05)
                    : getColorFromType(type),
                width: 1),
            borderRadius: new BorderRadius.only(
                topRight: Radius.circular(12.0),
                topLeft: Radius.circular(12.0),
                bottomLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0)),
          ),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8.0),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(4),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    userTag.tag,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontSize: Gparam.textVerySmall,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getColorFromType(int type) {
    if (type == 0)
      return Color(0xFF307df0);
    else if (type == 1)
      return Color(0xFF0ec76a);
    else if (type == 2)
      return Color(0xFFffbb29);
    else if (type == 3)
      return Color(0xFF63056e);
    else if (type == 4)
      return Color(0xFFe37724);
    else if (type == 5)
      return Color(0xFFed4040);
    else if (type == 6) return Color(0xFF42ede5);
  }
}
