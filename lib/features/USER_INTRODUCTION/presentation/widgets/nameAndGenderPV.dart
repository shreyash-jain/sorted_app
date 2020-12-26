import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/flow_bloc/flow_bloc.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/pages/loginDetails.dart';

class NameAndGender extends StatefulWidget {
  final LoginPage loginWidget;
  const NameAndGender({
    Key key,
    this.loginWidget,
  }) : super(key: key);

  @override
  _NameAndGenderState createState() => _NameAndGenderState();
}

class _NameAndGenderState extends State<NameAndGender> {
  final controller = TextEditingController();
  String inputStr;
  Gender selectedGender = Gender.unknown;

  FocusNode nameFocus = FocusNode();

  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (nameController.text == "" &&
        widget.loginWidget.userDetail.name != null) {
      nameController.text = widget.loginWidget.userDetail.name;
    }
    if (widget.loginWidget.userDetail.gender != null) {
      Gender savedGender = widget.loginWidget.userDetail.gender;
      selectedGender = savedGender;
    }

    print("Login Body");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(0.0),
        child: ListView(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: Gparam.topPadding,
                left: Gparam.widthPadding,
                right: Gparam.widthPadding),
            child: FadeAnimationTB(
              1.6,
              Container(
                child: Text(
                  'So what do I call you\nlike people close to you do ?',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(.8)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: Gparam.topPadding,
                left: Gparam.widthPadding,
                right: Gparam.widthPadding),
            child: FadeAnimationTB(
                2.2,
                Container(
                  child: TextField(
                    focusNode: nameFocus,
                    controller: nameController,
                    maxLength: 16,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    onChanged: (text) {
                      BlocProvider.of<UserIntroductionBloc>(context)
                          .add(UpdateName(text));
                    },
                    onSubmitted: (text) {
                      nameFocus.unfocus();
                    },
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 26,
                        color: Colors.black45,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Enter your username',
                      hintStyle: TextStyle(
                          color: Colors.black38,
                          fontSize: 26,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500),
                      border: InputBorder.none,
                    ),
                  ),
                )),
          ),
          AnimatedOpacity(
              duration: Duration(seconds: 1),
              curve: Curves.easeOutQuint,
              opacity: 1,
              child: FadeAnimationTB(
                .9,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: Gparam.topPadding,
                          left: Gparam.widthPadding,
                          right: Gparam.widthPadding * 2),
                      child: Text(
                        'Please tell me about your gender ?',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 22.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(.8)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: Gparam.topPadding,
                          left: Gparam.widthPadding,
                          right: Gparam.widthPadding),
                      child: Container(
                          child: Row(
                        children: [
                          FadeAnimationTB(
                            1.6,
                            GestureDetector(
                              onTap: () => selectGender(Gender.male),
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.white12,
                                  (selectedGender == Gender.male)
                                      ? BlendMode.dst
                                      : BlendMode.srcIn,
                                ),
                                child: Container(
                                  child: Image(
                                    image: AssetImage(
                                      "assets/images/male.png",
                                    ),
                                    height: Gparam.width / 3,
                                    width: Gparam.width / 3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                              height: Gparam.height / 8,
                              width: 2,
                              color: Colors.black12),
                          FadeAnimationTB(
                            1.6,
                            GestureDetector(
                              onTap: () => selectGender(Gender.female),
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.white12,
                                  (selectedGender == Gender.female)
                                      ? BlendMode.dst
                                      : BlendMode.srcIn,
                                ),
                                child: Container(
                                  child: Image(
                                    image: AssetImage(
                                      "assets/images/female.png",
                                    ),
                                    height: Gparam.width / 3,
                                    width: Gparam.width / 3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ],
                ),
              ))
        ]));
  }

  selectGender(Gender gender) {
    print("gender tapped" + gender.toString());
    if (selectedGender != gender) {
      BlocProvider.of<UserIntroductionBloc>(context).add(UpdateGender(gender));
      selectedGender = gender;
    }
  }
}
