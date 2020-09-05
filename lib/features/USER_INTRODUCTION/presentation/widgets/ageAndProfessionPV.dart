import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/animations/fade_animation.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/features/PROFILE/data/models/activity.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/flow_bloc/flow_bloc.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/pages/loginDetails.dart';

class AgeAndProfession extends StatefulWidget {
  final LoginPage loginWidget;
  const AgeAndProfession({
    Key key,
    this.loginWidget,
  }) : super(key: key);

  @override
  _AgeAndProfessionState createState() => _AgeAndProfessionState();
}

class _AgeAndProfessionState extends State<AgeAndProfession> {
  final controller = TextEditingController();
  String inputStr;
  Profession selectedProfession;

  FocusNode ageFocus = FocusNode();

  TextEditingController ageController = TextEditingController();

  @override
  void initState() {
    super.initState();

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
          Padding(
            padding: EdgeInsets.only(
                top: Gparam.topPadding,
                left: Gparam.widthPadding,
                right: Gparam.widthPadding),
            child: FadeAnimation(
              1.6,
              Container(
                child: Text(
                  '${(widget.loginWidget.userDetail.name=="")?"Hey ":widget.loginWidget.userDetail.name}, how old are you ?',
                  style: TextStyle(
                      fontFamily: 'ZillaSlab',
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
            child: FadeAnimation(
                2.2,
                Container(
                  child: TextField(
                    focusNode: ageFocus,
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    onChanged: (text){
                      try{
                       BlocProvider.of<UserIntroductionBloc>(context)
                          .add(UpdateAge(int.parse(text)));
                      }
                      on Exception{
                        BlocProvider.of<UserIntroductionBloc>(context)
                          .add(UpdateAge(0));
                      }


                    },
                    onSubmitted: (text) {
                       
                      ageFocus.unfocus();
                    },
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 26,
                        color: Colors.black45,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Enter your age',
                      hintStyle: TextStyle(
                          color: Colors.black38,
                          fontSize: 26,
                          fontFamily: 'ZillaSlab',
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
              child: FadeAnimation(
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
                        'and what are you doing nowadays ?',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'ZillaSlab',
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
                          height: Gparam.height / 5,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    selectProfession(Profession.student),
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                  Colors.white12,
                                  (selectedProfession == Profession.student)
                                      ? BlendMode.dst
                                      : BlendMode.srcIn,
                                ),
                                                                  child: ProfessionItem(
                                    imagePath: "assets/images/student.png",
                                    professionName: "Studying",
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
                                onTap: () =>
                                    selectProfession(Profession.working),
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                  Colors.white12,
                                  (selectedProfession == Profession.working)
                                      ? BlendMode.dst
                                      : BlendMode.srcIn,
                                ),
                                                                  child: ProfessionItem(
                                    imagePath: "assets/images/working.png",
                                    professionName: "Working",
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
                                  Colors.white12,
                                  (selectedProfession == Profession.both)
                                      ? BlendMode.dst
                                      : BlendMode.srcIn,
                                ),child: ProfessionItem(
                                    imagePath: "assets/images/bothProfession.png",
                                    professionName: "Both",
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

  selectProfession(Profession profession) {
    print("gender tapped" + profession.toString());
    if (selectedProfession != profession) {
      BlocProvider.of<UserIntroductionBloc>(context).add(UpdateProfession(profession));
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
    return FadeAnimation(
      1.6,
      Column(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.white30,
              BlendMode.dst,
            ),
            child: Container(
              child: Image(
                image: AssetImage(
                  imagePath,
                ),
                height: Gparam.height / 8,
                width: Gparam.height / 8,
              ),
            ),
          ),
          Text(professionName, style: Gtheme.black20)
        ],
      ),
    );
  }
}
