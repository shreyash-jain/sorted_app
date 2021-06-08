import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeAnimationLR extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimationLR(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<DefaultAnimationProperties>()
      ..add(DefaultAnimationProperties.color, Tween(begin: 0.0, end: 1.0),
          Duration(milliseconds: 500))
      ..add(DefaultAnimationProperties.x, Tween(begin: -30.0, end: 0.0),
          Duration(milliseconds: 500));

    return PlayAnimation(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, animation) => Opacity(
        opacity: animation.get(DefaultAnimationProperties.color),
        child: Transform.translate(
            offset: Offset(animation.get(DefaultAnimationProperties.x), 0),
            child: child),
      ),
    );
  }
}
