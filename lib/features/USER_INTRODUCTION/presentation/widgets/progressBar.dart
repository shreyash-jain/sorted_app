import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/pages/loginDetails.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    Key key,
    @required this.widget,
    @required int currentPage,
  })  : _currentPage = currentPage,
        super(key: key);

  final LoginPage widget;

  final int _currentPage;

  @override
  Widget build(BuildContext context) {
    print(_currentPage);
    return Column(
      children: [
        if (widget.valid != 8)
          Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: Gparam.height / 100,
                    decoration: BoxDecoration(
                      // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0)),
                      color: Colors.black.withOpacity(.04),

                      // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (_currentPage == 0)
                        Text(
                          "Account setup",
                          style: Gtheme.blackShadowBold32,
                        ),
                      if (_currentPage == 0)
                        SizedBox(
                          height: Gparam.height / 50,
                        ),
                      if (widget.valid == null || widget.valid <= 1)
                        Container(
                            width: Gparam.height / 60,
                            height: Gparam.height / 60,
                            decoration: BoxDecoration(
                              // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              color: (_currentPage == 0)
                                  ? Colors.black12
                                  : (widget.valid != null && widget.valid > 1)
                                      ? Colors.black.withOpacity(.09)
                                      : Colors.red.withOpacity(.3),
                            )),
                      if (widget.valid != null && widget.valid > 1)
                        Container(
                            decoration: BoxDecoration(
                              // border: Border.all(color: Theme.of(context).primaryColor, width: 5),

                              color: (_currentPage == 0)
                                  ? Colors.transparent
                                  : Colors.black.withOpacity(.09),
                            ),
                            child: Icon(
                                (widget.valid != 9)
                                    ? Icons.check
                                    : Icons.cancel,
                                color: Colors.black)),
                    ],
                  ),
                  Column(
                    children: [
                      if (_currentPage == 1)
                        Text(
                          "Health Profile",
                          style: Gtheme.blackShadowBold32,
                        ),
                      if (_currentPage == 1)
                        SizedBox(
                          height: Gparam.height / 50,
                        ),
                      if (widget.valid != null &&
                              widget.valid <= 3 &&
                              widget.valid != 9 ||
                          _currentPage < 1)
                        Container(
                            width: Gparam.height / 60,
                            height: Gparam.height / 60,
                            decoration: BoxDecoration(
                              // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              color: (_currentPage == 1)
                                  ? Colors.white24
                                  : (widget.valid > 3 || _currentPage < 1)
                                      ? Colors.black.withOpacity(.09)
                                      : Colors.red.withOpacity(.3),
                            )),
                      if (widget.valid != null &&
                          widget.valid > 3 &&
                          widget.valid != 9 &&
                          _currentPage >= 1)
                        Container(
                            decoration: BoxDecoration(
                              // border: Border.all(color: Theme.of(context).primaryColor, width: 5),

                              color: (_currentPage == 1)
                                  ? Colors.transparent
                                  : Colors.black.withOpacity(.09),
                            ),
                            child: Icon(Icons.check, color: Colors.black26)),
                      if (widget.valid == 9)
                        Container(
                            decoration: BoxDecoration(
                              // border: Border.all(color: Theme.of(context).primaryColor, width: 5),

                              color: Colors.black.withOpacity(.09),
                            ),
                            child: Icon(Icons.stop, color: Colors.redAccent)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        if (widget.valid == 8)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Container(child: Text("Loading")),
            ],
          ),
      ],
    );
  }
}
