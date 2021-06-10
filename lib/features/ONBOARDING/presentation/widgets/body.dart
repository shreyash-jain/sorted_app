import 'package:flutter/material.dart';
import 'package:sorted/core/global/widgets/indicator_oval.dart';
import 'package:sorted/features/ONBOARDING/presentation/constants.dart';

import 'package:sorted/features/ONBOARDING/presentation/widgets/button_up_down.dart';

import 'package:sorted/features/ONBOARDING/presentation/widgets/page_template.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/features/ONBOARDING/presentation/bloc/onboarding_bloc.dart';

class OnboardBody extends StatefulWidget {
  const OnboardBody({
    Key key,
  }) : super(key: key);

  @override
  _OnboardBodyState createState() => _OnboardBodyState();
}

class _OnboardBodyState extends State<OnboardBody> {
  int _currentPage = 0;

  final _numPages = OnboardFixtures.MAX_PAGES;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    BlocProvider.of<OnboardingBloc>(context).add(OpenBottomSheet());

    print("Body");
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage
          ? IndicatorOval(isActive: true)
          : IndicatorOval(isActive: false));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.2, 0.9],
            colors: [
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              child: PageView(
                scrollDirection: Axis.horizontal,
                physics: AlwaysScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: <Widget>[
                  PageTemplate(
                      title: OnboardStrings.onboardTitle1,
                      description: OnboardStrings.onboardDiscription1,
                      imagepath: OnboardStrings.imagePath1),
                  PageTemplate(
                      title: OnboardStrings.onboardTitle2,
                      description: OnboardStrings.onboardDiscription2,
                      imagepath: OnboardStrings.imagePath2),
                  PageTemplate(
                      title: OnboardStrings.onboardTitle3,
                      description: OnboardStrings.onboardDiscription3,
                      imagepath: OnboardStrings.imagePath3),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50, right: 0),
              child: Align(
                alignment: FractionalOffset.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _buildPageIndicator(),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 30, right: 0),
                
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    // if (_currentPage > 0)
                    //   Align(
                    //       alignment: FractionalOffset.bottomRight,
                    //       child: Button(
                    //         direction: false,
                    //         onTapAction: moveUp,
                    //       )),
                    if (_currentPage < 2)
                      Align(
                          alignment: FractionalOffset.bottomRight,
                          child: Button(
                            direction: true,
                            onTapAction: moveDown,
                          )),
                  ],
                ))
          ],
        ),
      ),
    ]);
  }

  moveDown() {
    print("button down");
    if (_currentPage + 1 == 2) {
      print("add openbottomsheet");
      
    }
    setState(() {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  moveUp() {
    print("button Up");
    setState(() {
      if (_currentPage > 0) {
        _pageController.animateToPage(
          _currentPage - 1,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }
}
