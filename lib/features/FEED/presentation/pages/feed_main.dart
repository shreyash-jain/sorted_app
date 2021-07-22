import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/FEED/presentation/widgets/image_post.dart';

class FeedHomePage extends StatefulWidget {
  FeedHomePage({Key key}) : super(key: key);

  @override
  _FeedHomePageState createState() => _FeedHomePageState();
}

class _FeedHomePageState extends State<FeedHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(Gparam.widthPadding),
                  child: Row(
                    children: [
                      Icon(
                        Icons.post_add,
                        size: 35,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gtheme.stext("CREATE A POST",
                                size: GFontSize.XS, weight: GFontWeight.B1),
                            SizedBox(
                              height: 4,
                            ),
                            Gtheme.stext(
                                "Show the world what you are working on",
                                size: GFontSize.XXS,
                                weight: GFontWeight.L),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Divider(color: Colors.grey.shade400),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Gparam.widthPadding, vertical: 10),
                  child: Row(
                    children: [
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.camera_outlined,
                              size: 20,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Gtheme.stext("Photo",
                                size: GFontSize.XXS, weight: GFontWeight.N),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.upload_outlined,
                              size: 20,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Gtheme.stext("Gallery",
                                size: GFontSize.XXS, weight: GFontWeight.N),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.question_answer_outlined,
                              size: 20,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Gtheme.stext("Discussion",
                                size: GFontSize.XXS, weight: GFontWeight.N),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey.shade400,
                  thickness: 2,
                ),
                Container(
                    height: 35,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        SizedBox(width: Gparam.widthPadding),
                        Container(
                          padding: EdgeInsets.all(4),
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 3.0, color: Colors.lightBlue),
                            ),
                          ),
                          child: Gtheme.stext("FEED",
                              size: GFontSize.XXS, weight: GFontWeight.N),
                        ),
                        Container(
                          padding: EdgeInsets.all(4),
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(),
                          child: Gtheme.stext("BY SORT IT",
                              size: GFontSize.XXS, weight: GFontWeight.N),
                        ),
                        Container(
                          padding: EdgeInsets.all(4),
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(),
                          child: Gtheme.stext("DISCUSSIONS",
                              size: GFontSize.XXS, weight: GFontWeight.N),
                        ),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.all(Gparam.widthPadding / 2),
                  child: ImagePost(
                    senderImageUrl:
                        'https://cms.qz.com/wp-content/uploads/2019/07/IMG_8407-copy-e1563479651241.jpg?quality=75&strip=all&w=200&h=200',
                    senderName: "Rajat",
                    imageUrl:
                        "https://www.india.com/wp-content/uploads/2017/12/Yoga-for-men.jpg",
                    caption: "What a great day for yoga",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(Gparam.widthPadding / 2),
                  child: ImagePost(
                    senderImageUrl:
                        'https://img.etimg.com/photo/msid-73693525,quality-100/the-young-woman-has-been-working-really-hard-on-her-fitness-and-is-trying-to-get-her-a-game-on-.jpg',
                    senderName: "Namita Chandel",
                    imageUrl:
                        "https://i2.wp.com/pixahive.com/wp-content/uploads/2020/09/Girl-Doing-Triangle-Pose-in-Yoga-61130-pixahive.jpg?fit=1560%2C2340&ssl=1",
                    caption:
                        "Tried this for 1st time, and thanks to my trainer I did it correctly, Trangle pose check ✔️",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(Gparam.widthPadding / 2),
                  child: ImagePost(
                    senderImageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/feed%2Fic_launcher.png?alt=media&token=998542ba-2eeb-42bb-9fe9-895504fdc970',
                    senderName: "Sort It Expert",
                    userDiscription: "By Sort It team",
                    imageUrl:
                        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/feed%2Fplaceholders%2FArtboard%201-100.jpg?alt=media&token=f4f5877b-6cbd-4097-b761-001b55cc7e36",
                    caption: "Oh! I just found this, did you knew",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(Gparam.widthPadding / 2),
                  child: ImagePost(
                    senderImageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/feed%2Fic_launcher.png?alt=media&token=998542ba-2eeb-42bb-9fe9-895504fdc970',
                    senderName: "Sort It Expert",
                    userDiscription: "By Sort It team",
                    imageUrl:
                        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/feed%2Fplaceholders%2FArtboard%201.png?alt=media&token=e8c6356f-570a-42bf-a2f7-300db9b8f55d",
                    caption:
                        "As offices all over world are reopening, find out best ways to be fit while working at your office",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
