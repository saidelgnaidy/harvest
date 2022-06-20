import 'package:flutter/material.dart';
import 'package:simple_animations/multi_tween/multi_tween.dart';
import 'package:simple_animations/stateless_animation/play_animation.dart';

enum _AniProps { opacity, translateX }

class FadeX extends StatelessWidget {
  final Widget child;

  const FadeX({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<_AniProps>()
      ..add(
        _AniProps.opacity,
        Tween(begin: 0.0, end: 1.0),
      )
      ..add(_AniProps.translateX, Tween(begin: 200.0, end: 0.0));

    return PlayAnimation<MultiTweenValues<_AniProps>>(
      delay: Duration(milliseconds: (500).round()),
      duration: const Duration(milliseconds: 500),
      tween: tween,
      child: child,
      curve: Curves.easeOutCubic,
      builder: (context, child, value) => Opacity(
        opacity: value.get(_AniProps.opacity),
        child: Transform.translate(
          offset: Offset(0, value.get(_AniProps.translateX)),
          child: child,
        ),
      ),
    );
  }
}

class FadeY extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeY({Key? key, required this.delay, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<_AniProps>()
      ..add(
        _AniProps.opacity,
        Tween(begin: 0.0, end: 1.0),
      )
      ..add(_AniProps.translateX, Tween(begin: 200.0, end: 0.0));

    return PlayAnimation<MultiTweenValues<_AniProps>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: const Duration(milliseconds: 500),
      tween: tween,
      child: child,
      curve: Curves.easeOutCubic,
      builder: (context, child, value) => Opacity(
        opacity: value.get(_AniProps.opacity),
        child: Transform.translate(
          offset: Offset(0, value.get(_AniProps.translateX)),
          child: child,
        ),
      ),
    );
  }
}
