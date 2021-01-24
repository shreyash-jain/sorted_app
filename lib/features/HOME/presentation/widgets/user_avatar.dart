import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key key,
    @required this.user_image,
  }) : super(key: key);

  final String user_image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(right: 0),
              height: Gparam.widthPadding*1.5,
              width: Gparam.widthPadding*1.5,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Image(
                          image: AssetImage(
                            user_image,
                          ),
                        
                        ),
                      ],
                    ),
                  ])),
        ],
      ),
    );
  }
}
