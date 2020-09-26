import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key key,
    @required this.scaleAnimation,
    @required this.user_image,
  }) : super(key: key);

  final Animation<double> scaleAnimation;
  final String user_image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
            onTap: () {},
            child: Stack(
                        alignment: Alignment.center,

              children: [
                AnimatedBuilder(
    animation: scaleAnimation,
    builder: (context, child) =>
        Transform.scale(
            scale:
                0.2+scaleAnimation.value * 0.7,
            child: Container(
              margin:
                  EdgeInsets.only(right: 0),
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  color: Theme.of(context)
                      .textSelectionHandleColor
                      .withOpacity((((1.5 -
                                  scaleAnimation
                                      .value)) *
                              16) /
                          100),
                  borderRadius:
                      BorderRadius.all(
                          Radius.circular(
                              50))),
            ))),
                  AnimatedBuilder(
    animation: scaleAnimation,
    builder: (context, child) =>
        Transform.scale(
            scale:
                scaleAnimation.value * .9,
            child: Container(
              margin:
                  EdgeInsets.only(right: 0),
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  color: Theme.of(context)
                      .textSelectionHandleColor
                      .withOpacity((((1.5 -
                                  scaleAnimation
                                      .value)) *
                              40) /
                          100),
                  borderRadius:
                      BorderRadius.all(
                          Radius.circular(
                              50))),
            ))),
                Container(
                    margin: EdgeInsets.only(
                        right: 0),
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        color:
                            Colors.transparent,
                        border: Border.all(
                            color: Colors
                                .transparent),
                        borderRadius:
                            BorderRadius.all(
                                Radius.circular(
                                    50))),
                    child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .center,
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Image(
                                image:
                                    AssetImage(
                                  user_image,
                                ),
                                height:33,
                                width: 33,
                              ),
                            ],
                          ),
                        ])),
              ],
            ),
          );
  }
}