import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomSizeTransition extends CustomTransitionPage {
  CustomSizeTransition({required LocalKey super.key, required super.child})
      : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SizeTransition(
            sizeFactor: animation,
            axisAlignment: 0.0,
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 500),
        );
}

class CustomSlideTransition extends CustomTransitionPage {
  CustomSlideTransition({required LocalKey super.key, required super.child})
      : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
            position: Tween(
              begin: const Offset(1.0, 0.0),
              end: const Offset(0.0, 0.0),
            ).animate(animation),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 200),
        );
}

class CustomFadeTransition extends CustomTransitionPage {
  CustomFadeTransition({required LocalKey super.key, required super.child})
      : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 200),
        );
}

class CustomNormalTransition extends CustomTransitionPage {
  CustomNormalTransition({required LocalKey super.key, required super.child})
      : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 0),
          reverseTransitionDuration: const Duration(milliseconds: 0),
        );
}
