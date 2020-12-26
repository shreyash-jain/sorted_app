import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/features/ONBOARDING/presentation/bloc/onboarding_bloc.dart';



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
  Animation<double> rippleAnimation;
  AnimationController rippleController;
  Animation<double> scaleAnimation;
  AnimationController scaleController;

  @override
  void initState() {
    super.initState();

    setScaleController();
    setRippleAnimation();

   scaleAnimation = Tween<double>(
        begin: 1.0,
        end: 35.0
    ).animate(scaleController);
   rippleController.forward();
   print("bottom sheet");
  }
  @override
  void dispose() {
    rippleController.dispose();
    
    scaleController.dispose();
    super.dispose();
  }
  void setScaleController() {
    scaleController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..addStatusListener((status) async {
            if (status == AnimationStatus.completed) {
              BlocProvider.of<OnboardingBloc>(context).add(LogInWithGoogle());
            }
          });
  }

  void setRippleAnimation() {
    rippleController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    rippleAnimation =
        Tween<double>(begin: 80, end: 90.0).animate(rippleController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              rippleController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              rippleController.forward();
            }
          });
  }

  void dispatchGetStarted() {}

  void dispatchGoogleSignIn() {}

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          "Get started   >>",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 24.0,
          ),
        ),
        Container(
            height: 120,
            padding: EdgeInsets.all(16),
            child: FadeAnimationTB(
                5.6,
                Container(
                    child: AnimatedBuilder(
                  animation: rippleAnimation,
                  builder: (context, child) => Container(
                    width: rippleAnimation.value,
                    height: rippleAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.indigo),
                      child: InkWell(
                        onTap: () {
                          scaleController.forward();
                        },
                        child: AnimatedBuilder(
                          animation: scaleAnimation,
                          builder: (context, child) => Transform.scale(
                            scale: scaleAnimation.value,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ))))
      ],
    );
  }
}
