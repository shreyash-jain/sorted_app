import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/models/user_details.dart';

import 'package:sorted/features/USER_INTRODUCTION/presentation/constants.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/flow_bloc/flow_bloc.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/pages/loginDetails.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/progressBar.dart';

class AgeAndProfession extends StatefulWidget {
  final int currentPage;
  final LoginPage loginWidget;
  const AgeAndProfession({
    Key key,
    this.loginWidget,
    this.currentPage,
  }) : super(key: key);

  @override
  _AgeAndProfessionState createState() => _AgeAndProfessionState();
}

class _AgeAndProfessionState extends State<AgeAndProfession> {
  final controller = TextEditingController();
  String inputStr;
  Profession selectedProfession;
  Gender selectedGender = Gender.unknown;
  FocusNode ageFocus = FocusNode();

  TextEditingController ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.loginWidget.userDetail.gender != null) {
      Gender savedGender = widget.loginWidget.userDetail.gender;
      selectedGender = savedGender;
    }

    if (ageController.text == "" && widget.loginWidget.userDetail.age != null) {
      ageController.text = widget.loginWidget.userDetail.age.toString();
    }

    if (widget.loginWidget.userDetail.profession != null) {
      Profession savedProfession = widget.loginWidget.userDetail.profession;
      selectedProfession = savedProfession;
    }

    print("age and name");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: ListView(
        children: <Widget>[
          Container(
            height: 80,
            margin: EdgeInsets.only(top: Gparam.heightPadding),
            child: Stack(
              children: [
                Row(children: <Widget>[
                  Container(
                      height: Gparam.height / 10,
                      width: (Gparam.width / 1),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ProgressBar(
                                  currentPage: widget.currentPage,
                                  widget: widget.loginWidget)
                            ],
                          ),
                        ],
                      )),
                ]),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 0, left: Gparam.widthPadding, right: Gparam.widthPadding),
            child: FadeAnimationTB(
              1.6,
              Container(
                child: Text(
                  '${(widget.loginWidget.userDetail.name == "") ? "Hey " : widget.loginWidget.userDetail.name}, how old are you ?',
                  style: TextStyle(
                      fontFamily: 'Milliard',
                      fontSize: Gparam.textSmall,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(.8)),
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
                    focusNode: ageFocus,
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    onChanged: (text) {
                      try {
                        BlocProvider.of<UserIntroductionBloc>(context)
                            .add(UpdateAge(int.parse(text)));
                      } on Exception {
                        BlocProvider.of<UserIntroductionBloc>(context)
                            .add(UpdateAge(0));
                      }
                    },
                    onSubmitted: (text) {
                      ageFocus.unfocus();
                    },
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                        fontFamily: 'Milliard',
                        fontSize: Gparam.textSmall,
                        color: Colors.black45,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Enter your age',
                      hintStyle: TextStyle(
                          color: Colors.black38,
                          fontSize: Gparam.textSmall,
                          fontFamily: 'Milliard',
                          fontWeight: FontWeight.w500),
                      border: InputBorder.none,
                    ),
                  ),
                )),
          ),
          FadeAnimationTB(
            2.9,
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
                        fontFamily: 'Milliard',
                        fontSize: Gparam.textSmall,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(.8)),
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
                              Colors.black12,
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
                              Colors.black12,
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
                        UserIntroStrings.askProfesssion,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'Milliard',
                            fontSize: Gparam.textSmall,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(.8)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: Gparam.topPadding,
                      ),
                      child: Container(
                          height: Gparam.height / 6,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              SizedBox(
                                width: Gparam.widthPadding,
                              ),
                              GestureDetector(
                                onTap: () =>
                                    selectProfession(Profession.student),
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Colors.black12,
                                    (selectedProfession == Profession.student)
                                        ? BlendMode.dst
                                        : BlendMode.srcIn,
                                  ),
                                  child: ProfessionItem(
                                    imagePath:
                                        UserIntroStrings.studentImagePath,
                                    professionName: UserIntroStrings
                                        .studentImageDescription,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      height: Gparam.height / 12,
                                      width: 2,
                                      color: Colors.black12),
                                ],
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              GestureDetector(
                                onTap: () =>
                                    selectProfession(Profession.working),
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Colors.black12,
                                    (selectedProfession == Profession.working)
                                        ? BlendMode.dst
                                        : BlendMode.srcIn,
                                  ),
                                  child: ProfessionItem(
                                    imagePath:
                                        UserIntroStrings.workingImagePath,
                                    professionName: UserIntroStrings
                                        .workingImageDescription,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      height: Gparam.height / 12,
                                      width: 2,
                                      color: Colors.black12),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () => selectProfession(Profession.both),
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Colors.black12,
                                    (selectedProfession == Profession.both)
                                        ? BlendMode.dst
                                        : BlendMode.srcIn,
                                  ),
                                  child: ProfessionItem(
                                    imagePath: UserIntroStrings
                                        .bothProfessionImagePath,
                                    professionName: UserIntroStrings
                                        .bothProfessionImageDescription,
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  selectGender(Gender gender) {
    print("gender tapped" + gender.toString());
    if (selectedGender != gender) {
      BlocProvider.of<UserIntroductionBloc>(context).add(UpdateGender(gender));
      selectedGender = gender;
    }
  }

  selectProfession(Profession profession) {
    print("gender tapped" + profession.toString());
    if (selectedProfession != profession) {
      BlocProvider.of<UserIntroductionBloc>(context)
          .add(UpdateProfession(profession));
      selectedProfession = profession;
    }
  }
}

class ProfessionItem extends StatelessWidget {
  final String imagePath;
  final String professionName;
  const ProfessionItem({
    Key key,
    this.imagePath,
    this.professionName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeAnimationTB(
      1.6,
      Column(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black12,
              BlendMode.dst,
            ),
            child: Container(
              child: Image(
                image: AssetImage(
                  imagePath,
                ),
                height: Gparam.height / 10,
                width: Gparam.height / 10,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(professionName, style: Gtheme.black20)
        ],
      ),
    );
  }
}
