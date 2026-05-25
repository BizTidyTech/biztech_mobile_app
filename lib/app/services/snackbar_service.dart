// ignore_for_file: unused_element_parameter

import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context,
  String message, {
  Color? bgColor,
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 60,
      left: 20,
      right: 20,
      child: _FadeSnackBar(
        message: message,
        bgColor: bgColor,
        onDismiss: () {
          entry.remove();
        },
      ),
    ),
  );

  overlay.insert(entry);
}

class _FadeSnackBar extends StatefulWidget {
  final String message;
  final VoidCallback onDismiss;
  final Color? bgColor;

  const _FadeSnackBar({
    super.key,
    required this.message,
    required this.onDismiss,
    this.bgColor,
  });

  @override
  State<_FadeSnackBar> createState() => __FadeSnackBarState();
}

class __FadeSnackBarState extends State<_FadeSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Set up the AnimationController with your desired duration.
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Use a curved animation for ease in/out.
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Start the fade in.
    _controller.forward();

    // Automatically dismiss after a delay.
    Future.delayed(const Duration(seconds: 3), () {
      _controller.reverse().then((_) {
        widget.onDismiss();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(8),
        color: widget.bgColor ?? AppColors.coolRed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Text(
            widget.message,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.normalStringStyle(16, AppColors.plainWhite),
          ),
        ),
      ),
    );
  }
}
