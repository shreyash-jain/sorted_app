import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/dfareporting/v3_3.dart';
import 'package:sorted/core/global/utility/utils.dart';
import '../../../../../core/global/constants/constants.dart';
import '../../domain/entities/track.dart';

class SingleTrackPage extends StatelessWidget {
  final Track track;
  SingleTrackPage({this.track});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: Gparam.widthPadding),
          child: ListView(
            children: [
              SizedBox(
                height: Gparam.topPadding,
              ),
              Container(
                height: Gparam.height * 0.15,
                child: Row(
                  children: [
                    Container(
                      width: Gparam.height * 0.15,
                      height: Gparam.height * 0.15,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: CachedNetworkImageProvider(track.icon),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Gparam.widthPadding / 2,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Gparam.height * 0.03,
                          ),
                          Text(
                            track.name,
                            style: TextStyle(
                              fontSize: Gparam.textMedium,
                            ),
                          ),
                          Text(
                            "Market name",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Gparam.textSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Gparam.heightPadding * 2,
              ),
              Container(
                height: Gparam.height * 0.11,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track.m_num_subs.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Gparam.textSmall,
                            ),
                          ),
                          Text(
                            "people",
                            style: TextStyle(
                              fontSize: Gparam.textSmall,
                            ),
                          ),
                          Text(
                            "Tracking",
                            style: TextStyle(
                              fontSize: Gparam.textSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: Gparam.widthPadding * 2,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track.ts_default_sub_days.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Gparam.textSmall,
                            ),
                          ),
                          Text(
                            "Track",
                            style: TextStyle(
                              fontSize: Gparam.textSmall,
                            ),
                          ),
                          Text(
                            "Duration",
                            style: TextStyle(
                              fontSize: Gparam.textSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: Gparam.widthPadding * 2,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fromLevelToDifficulty(track.m_level),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Gparam.textSmall,
                            ),
                          ),
                          Text(
                            "Habit",
                            style: TextStyle(
                              fontSize: Gparam.textSmall,
                            ),
                          ),
                          Text(
                            "Difficulty",
                            style: TextStyle(
                              fontSize: Gparam.textSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: Gparam.widthPadding,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Gparam.heightPadding,
              ),
              Container(
                height: Gparam.height * 0.07,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SimpleButton(
                      text: "Self tracking",
                      onTap: () {},
                    ),
                    SizedBox(
                      width: Gparam.widthPadding / 2,
                    ),
                    track.m_num_expert_groups > 0
                        ? SimpleButton(
                            text: "Track with Expert",
                            onTap: () {},
                          )
                        : Container(),
                    SizedBox(
                      width: Gparam.widthPadding / 2,
                    ),
                    SimpleButton(
                      text: "Track with Friends",
                      onTap: () {},
                    ),
                    SizedBox(
                      width: Gparam.widthPadding,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Gparam.heightPadding * 2,
              ),
              Container(
                height: Gparam.height * 0.32,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4 * 2,
                  itemBuilder: (_, i) {
                    if (i % 2 == 0) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: Gparam.width * 0.33,
                      );
                    } else {
                      return SizedBox(
                        width: Gparam.widthPadding / 2,
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SimpleButton extends StatelessWidget {
  final String text;
  final Function onTap;
  SimpleButton({this.onTap, this.text});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Gparam.widthPadding * 0.7,
        ),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Gparam.textSmaller,
            ),
          ),
        ),
      ),
    );
  }
}