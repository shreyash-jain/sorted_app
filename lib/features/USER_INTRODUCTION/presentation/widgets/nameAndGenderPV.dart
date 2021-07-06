import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/constants.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/flow_bloc/flow_bloc.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/pages/loginDetails.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/progressBar.dart';

class NameAndGender extends StatefulWidget {
  final LoginPage loginWidget;
  final int currentPage;
  const NameAndGender({
    Key key,
    this.loginWidget,
    this.currentPage,
  }) : super(key: key);

  @override
  _NameAndGenderState createState() => _NameAndGenderState();
}

class _NameAndGenderState extends State<NameAndGender> {
  final controller = TextEditingController();
  String inputStr;
  Gender selectedGender = Gender.unknown;

  FocusNode nameFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  Timer searchOnStoppedTyping;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    if (nameController.text == "" &&
        widget.loginWidget.userDetail.name != null) {
      nameController.text = widget.loginWidget.userDetail.userName;
    }

    print("Login Body");
  }

  _onChangeHandler(value) {
    const duration = Duration(
        milliseconds:
            800); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel()); // clear timer
    }
    setState(() =>
        searchOnStoppedTyping = new Timer(duration, () => sendForCheck(value)));
  }

  sendForCheck(value) {
    print('hello world from search . the value is $value');
    BlocProvider.of<UserIntroductionBloc>(context).add(UpdateUsername(value));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserIntroductionBloc, UserIntroductionState>(
        listener: (context, state) {
          if (state is LoginState) {
            setState(() {
              phoneController.text = state.phoneNumber ?? "";
            });
          }
        },
        child: Container(
          height: Gparam.height + 100,
          child: Padding(
              padding: EdgeInsets.all(0.0),
              child: SingleChildScrollView(
                child: ListView(
                    controller: scrollController,
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                        height: 80,
                        margin: EdgeInsets.only(top: Gparam.heightPadding),
                        child: Stack(
                          children: [
                            Row(children: <Widget>[
                              SizedBox(
                                width: Gparam.widthPadding,
                              ),
                              if (widget.loginWidget.userDetail.imageUrl !=
                                      null &&
                                  Gparam.isHeightBig)
                                Hero(
                                    tag: UserIntroStrings.userImageTag,
                                    child: Container(
                                      height: Gparam.height / 13,
                                      width: Gparam.height / 13,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.black12, width: 2),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              widget.loginWidget.userDetail
                                                  .imageUrl,
                                            ),
                                            backgroundColor: Colors.transparent,
                                          )
                                        ],
                                      ),
                                    )),
                              Container(
                                  height: Gparam.height / 10,
                                  width:
                                      ((Gparam.width / 1 - Gparam.height / 10) >
                                              0
                                          ? (Gparam.width / 1 -
                                              Gparam.widthPadding -
                                              Gparam.height / 13)
                                          : Gparam.width / 1.6),
                                  child: Stack(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                      SizedBox(
                        height: Gparam.heightPadding / 2,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(widget.loginWidget.message),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: Gparam.topPadding,
                            left: Gparam.widthPadding,
                            right: Gparam.widthPadding),
                        child: Row(
                          children: [
                            Icon((widget.loginWidget.valid == 9)
                                ? Icons.cancel
                                : Icons.whatshot),
                            SizedBox(
                              width: 12,
                            ),
                            FadeAnimationTB(
                              1.6,
                              Container(
                                child: Text(
                                  'Select a username',
                                  style: TextStyle(
                                      fontFamily: 'Milliard',
                                      fontSize: Gparam.textSmall,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(.8)),
                                ),
                              ),
                            ),
                          ],
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
                                inputFormatters: [
                                  LowerCaseTextFormatter(),
                                ],
                                focusNode: nameFocus,
                                controller: nameController,
                                textCapitalization: TextCapitalization.none,
                                maxLength: 16,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                onChanged: (text) {
                                  _onChangeHandler(text);
                                },
                                onSubmitted: (text) {
                                  nameFocus.unfocus();
                                },
                                textInputAction: TextInputAction.done,
                                style: TextStyle(
                                    fontFamily: 'Milliard',
                                    fontSize: Gparam.textSmall,
                                    color: (widget.loginWidget.valid > 0 &&
                                            widget.loginWidget.valid != 9)
                                        ? Colors.blueAccent
                                        : Colors.redAccent,
                                    fontWeight: FontWeight.w500),
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Enter your username',
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
                      Padding(
                        padding: EdgeInsets.only(
                            top: Gparam.topPadding,
                            left: Gparam.widthPadding,
                            right: Gparam.widthPadding),
                        child: Row(
                          children: [
                            Icon(Icons.phone),
                            SizedBox(
                              width: 12,
                            ),
                            FadeAnimationTB(
                              1.6,
                              Container(
                                child: Text(
                                  'Type your mobile number',
                                  style: TextStyle(
                                      fontFamily: 'Milliard',
                                      fontSize: Gparam.textSmall,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(.8)),
                                ),
                              ),
                            ),
                          ],
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
                                focusNode: phoneFocus,
                                controller: phoneController,
                                maxLength: 10,
                                keyboardType: TextInputType.phone,
                                maxLines: 1,
                                onChanged: (text) {
                                  //
                                },
                                onSubmitted: (text) {
                                  phoneFocus.unfocus();
                                },
                                textInputAction: TextInputAction.done,
                                style: TextStyle(
                                    fontFamily: 'Milliard',
                                    fontSize: Gparam.textSmall,
                                    color: (widget.loginWidget.valid > 0 &&
                                            widget.loginWidget.valid != 9)
                                        ? Colors.blueAccent
                                        : Colors.redAccent,
                                    fontWeight: FontWeight.w500),
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Enter your number',
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
                      SizedBox(
                        height: 30,
                      )
                    ]),
              )),
        ));
  }

  selectGender(Gender gender) {
    print("gender tapped" + gender.toString());
    if (selectedGender != gender) {
      BlocProvider.of<UserIntroductionBloc>(context).add(UpdateGender(gender));
      selectedGender = gender;
    }
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue?.text.replaceAll(" ", "_").toLowerCase(),
      selection: newValue.selection,
    );
  }
}
