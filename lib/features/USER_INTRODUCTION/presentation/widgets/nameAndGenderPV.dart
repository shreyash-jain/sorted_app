import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
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
  Profession selectedProfession;

  FocusNode ageFocus = FocusNode();

  TextEditingController ageController = TextEditingController();
  FocusNode nameFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  Timer searchOnStoppedTyping;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String currentText = "";
  ScrollController scrollController;
  int _start = 60;
  Timer _timer;
  String currentOtp = "";
  String currentPhonenumber = "";
  LoginState loginState;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();

    if (nameController.text == "" &&
        widget.loginWidget.userDetail.name != null) {
      nameController.text = widget.loginWidget.userDetail.userName;
    }
    if (phoneController.text == "" &&
        widget.loginWidget.userDetail.mobileNumber != 0) {
      phoneController.text =
          widget.loginWidget.userDetail.mobileNumber.toString();
    }
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

    print("Login Body");
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          if (_timer.isActive)
            setState(() {
              timer.cancel();
              _start = 60;
            });
        } else {
          if (_timer.isActive)
            setState(() {
              _start--;
            });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserIntroductionBloc, UserIntroductionState>(
        listener: (context, state) {
      if (state is LoginState) {
        setState(() {
          phoneController.text = state.userDetail.mobileNumber.toString() ?? "";
        });

        if (state.currentNumber != null && state.currentNumber != "") {
          startTimer();
          setState(() {
            currentOtp = state.actualOtp;
            currentPhonenumber = state.currentNumber;
          });
        }
      }
    }, child: BlocBuilder<UserIntroductionBloc, UserIntroductionState>(
      builder: (context, state) {
        if (state is LoginState)
          return Container(
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
                                              backgroundColor:
                                                  Colors.transparent,
                                            )
                                          ],
                                        ),
                                      )),
                                Container(
                                    height: Gparam.height / 10,
                                    width: ((Gparam.width / 1 -
                                                Gparam.height / 10) >
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
                        if (currentPhonenumber == "")
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
                        if (currentPhonenumber == "")
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Gparam.widthPadding),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: 61,
                                    padding: EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black26),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10))),
                                    child: Gtheme.stext("+91",
                                        size: GFontSize.M,
                                        color: GColors.B,
                                        weight: GFontWeight.B1)),
                                Container(
                                  width: Gparam.width -
                                      2 * Gparam.widthPadding -
                                      80,
                                  child: TextField(
                                    cursorColor: Colors.black45,
                                    style: Gtheme.blackShadowBold28,
                                    keyboardType: TextInputType.number,
                                    controller: phoneController,
                                    focusNode: phoneFocus,
                                    maxLength: 10,
                                    onChanged: (text) {
                                      BlocProvider.of<UserIntroductionBloc>(
                                              context)
                                          .add(SetInvalidPhone());
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      labelText: "Enter Mobile Number",
                                      labelStyle: Gtheme.blackShadowBold28,
                                      enabledBorder: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade100,
                                            width: 2.0),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                      ),
                                      focusedBorder: new OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        borderSide: const BorderSide(
                                            color: Colors.black, width: 2.0),
                                      ),
                                      border: const OutlineInputBorder(),
                                    ),
                                    cursorWidth: 2.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (!state.isPhoneCorrect && !state.isOtpLoading)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 160,
                                child: MaterialButton(
                                    elevation: 0,
                                    color: Colors.grey.shade300,
                                    onPressed: () {
                                      BlocProvider.of<UserIntroductionBloc>(
                                              context)
                                          .add(
                                              RequestOTP(phoneController.text));
                                    },
                                    child: Text(
                                      "Send Otp",
                                      style: Gtheme.blackShadowBold32,
                                    )),
                              ),
                            ],
                          ),
                        if (state.isOtpLoading)
                          Container(child: LoadingWidget()),
                        SizedBox(
                          height: 16,
                        ),
                        if (currentPhonenumber != "")
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 30),
                              child: PinCodeTextField(
                                appContext: context,
                                pastedTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                length: 6,
                                obscureText: true,
                                backgroundColor: Colors.white,
                                obscuringCharacter: '*',

                                blinkWhenObscuring: true,
                                animationType: AnimationType.fade,

                                pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(5),
                                    fieldHeight: 50,
                                    activeColor: Colors.black,
                                    inactiveFillColor: Colors.white,
                                    inactiveColor: Colors.white,
                                    selectedColor: Colors.white,
                                    fieldWidth: 40,
                                    activeFillColor: Colors.white,
                                    selectedFillColor: Colors.black12),
                                cursorColor: Colors.black,
                                animationDuration: Duration(milliseconds: 300),
                                enableActiveFill: true,

                                keyboardType: TextInputType.number,
                                boxShadows: [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Colors.black12,
                                    blurRadius: 10,
                                  )
                                ],
                                onCompleted: (v) {
                                  print("Completed");
                                },
                                // onTap: () {
                                //   print("Pressed");
                                // },
                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    currentText = value;
                                  });

                                  if (state.actualOtp != null &&
                                      currentText == state.actualOtp) {
                                    BlocProvider.of<UserIntroductionBloc>(
                                            context)
                                        .add(SetValidPhone());
                                  }
                                },
                                beforeTextPaste: (text) {
                                  print("Allowing to paste ");
                                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                  return true;
                                },
                              )),
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 0,
                              left: Gparam.widthPadding,
                              right: Gparam.widthPadding),
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
                                      BlocProvider.of<UserIntroductionBloc>(
                                              context)
                                          .add(UpdateAge(int.parse(text)));
                                    } on Exception {
                                      BlocProvider.of<UserIntroductionBloc>(
                                              context)
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
                                        onTap: () =>
                                            selectGender(Gender.female),
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
                        SizedBox(
                          height: 30,
                        )
                      ]),
                )),
          );
        else
          return Container(
            height: 0,
          );
      },
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
