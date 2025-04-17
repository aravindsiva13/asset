import 'package:flutter/material.dart';
import 'dart:async';
import '../main_pages/login_screen/login_screen.dart';

/// It automatically logs the user out of the website when there is no interaction ///
class UserInteractionTimer {
  static Timer? timer;

  static void startTimer(BuildContext context) {
    timer = Timer.periodic(const Duration(minutes: 30), (timer) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginInScreen()),
      );
    });
  }

  /// Stop Timer ///
  static void stopTimer() {
    timer?.cancel();
  }
  /// Stop Timer ///

  /// Reset Timer ///
  static void resetTimer(BuildContext context) {
    stopTimer();
    startTimer(context);
  }
  /// Reset Timer ///
}
/// It automatically logs the user out of the website when there is no interaction ///
