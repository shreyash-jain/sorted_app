import 'package:flutter/material.dart';
import 'package:sorted/core/global/animations/shimmer.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/database/cacheDataClass.dart';

class LoadingAffirmationWidget extends StatelessWidget {
  const LoadingAffirmationWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0)),
            ),
            margin: EdgeInsets.only(top: 0, left: 0),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: Gparam.width / 7, right: 12,),
                          child: Icon(
                            
                                Icons.check,
                            color: Colors.black12,
                            size: 16,
                          ),
                        ),
                        Text(
                           greeting() + " " + CacheDataClass.cacheData.getUserDetail().name ,
                          style: TextStyle(
                              color: (Theme.of(context).brightness ==
                                      Brightness.light)
                                  ? Colors.white.withOpacity(.2)
                                  : Colors.black26,
                              fontFamily: 'Eastman',
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    
                      Container(
                        height: Gparam.height / 10,
                        width: Gparam.width,
                        margin:
                                EdgeInsets.only(top:10),
                        child: ListView.builder(
                           
                            
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 6,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0)
                                return SizedBox(
                                  width: Gparam.width / 7,
                                );
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
                            }),
                      ),
                    
                  ],
                ),
                
              ],
            )),
      ],
    );
  }
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }
}
