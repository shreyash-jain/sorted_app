import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeAnimationTB extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimationTB(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<DefaultAnimationProperties>()
      ..add(DefaultAnimationProperties.color, Tween(begin: 0.0, end: 1.0),
          Duration(milliseconds: 500))
      ..add(DefaultAnimationProperties.y, Tween(begin: -30.0, end: 0.0),
          Duration(milliseconds: 500));

    return PlayAnimation(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, animation) => Opacity(
        opacity:animation.get(DefaultAnimationProperties.color),
        child: Transform.translate(
            offset: Offset(0, animation.get(DefaultAnimationProperties.y)), child: child),
      ),
    );
  }
}
