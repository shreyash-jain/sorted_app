import 'package:flutter/material.dart';
import 'package:sorted/core/global/animations/shimmer.dart';
import 'package:sorted/core/global/constants/constants.dart';

class LoadingAffirmationWidget extends StatelessWidget {
  const LoadingAffirmationWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.end,
          children: [
            Container(
                height: Gparam.height / 8,
            width: 5.4 * Gparam.width / 6,
            decoration: new BoxDecoration(
              
              borderRadius:
                  new BorderRadius.only(
                      topLeft:
                          Radius.circular(20.0),
                      bottomLeft:
                          Radius.circular(
                              20.0)),
              
            ),
            margin: EdgeInsets.only(
                top: 0, left: 0),
                child: ListView.builder(
                  scrollDirection:
                      Axis.horizontal,
                  physics:
                      BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 6,
                  itemBuilder:
                      (BuildContext contect,
                          int index) {
                    if (index == 0) {
                      return SizedBox(
                          width: Gparam
                                  .widthPadding /
                              3);
                    }
                    return Shimmer(
                      period: Duration(
                          milliseconds: 1600),
                      gradient: LinearGradient(
                        begin:
                            Alignment.topLeft,
                        end: Alignment
                            .centerRight,
                        colors: [
                          Colors.grey[200],
                          Colors.grey[200],
                          Colors.grey[350],
                          Colors.grey[200],
                          Colors.grey[200]
                        ],
                        stops: const [
                          0.0,
                          0.35,
                          0.5,
                          0.65,
                          1.0
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: Gparam.height / 18,
                  width: Gparam.height / 18,
                  margin: EdgeInsets.only(left:8,right:8),
                            decoration:
                                new BoxDecoration(
                              borderRadius:
                                  new BorderRadius
                                          .all(
                                      Radius.circular(
                                          60.0)),
                              boxShadow: [
                                BoxShadow(
                                    offset:
                                        Offset(
                                            0,
                                            1),
                                    color: Colors
                                        .black
                                        .withAlpha(
                                            80),
                                    blurRadius:
                                        4)
                              ],
                              gradient:
                                  new LinearGradient(
                                      colors: [
                                        Colors
                                            .white,
                                        Colors
                                            .white,
                                      ],
                                      begin: FractionalOffset
                                          .topCenter,
                                      end: FractionalOffset
                                          .bottomCenter,
                                      stops: [
                                        1.0,
                                        0.0
                                      ],
                                      tileMode:
                                          TileMode
                                              .clamp),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )),
          ],
        ),
      ],
    );
  }
}
