import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/features/ONBOARDING/presentation/bloc/onboarding_bloc.dart';
import 'package:sorted/features/ONBOARDING/presentation/widgets/signin_button.dart';

class ButtomSheet extends StatefulWidget {
  const ButtomSheet({
    Key key,
  }) : super(key: key);

  @override
  _bottomSheetState createState() => _bottomSheetState();
}

class _bottomSheetState extends State<ButtomSheet>
    with TickerProviderStateMixin {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    print("bottom sheet");
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setScaleController() {}

  void setRippleAnimation() {}

  void dispatchGetStarted() {}

  void dispatchGoogleSignIn() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          color: Colors.grey.shade400,
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[GoogleSignInButton()],
        ),
      ],
    );
  }
}
