import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// <!-- Other Providers --!> ///
class BoolProvider extends ChangeNotifier {
  bool selected = false;

  bool _isDialogVisible = false;

  bool _deleteVisible = false;

  bool _isDarkTheme = false;

  bool toastMessages = false;

  bool get isVisible => selected;

  bool get isDialogVisible => _isDialogVisible;

  bool get deleteVisible => _deleteVisible;

  bool get isToastMessage => toastMessages;

  BoolProvider() {
    final initialBrightness =
        SchedulerBinding.instance.window.platformBrightness;
    _isDarkTheme = initialBrightness == Brightness.light;
  }

  bool get isDarkTheme => _isDarkTheme;

  /// Checkbox Visibility ///
  void setVisibility(bool value) {
    selected = value;
    notifyListeners();
  }
  /// Checkbox Visibility ///

  /// Dialog Visibility ///
  void setDialogVisibility(bool value) {
    _isDialogVisible = value;
    notifyListeners();
  }
  /// Dialog Visibility ///

  /// Delete Button Visibility ///
  void setDeleteVisibility(bool value) {
    _deleteVisible = value;
    notifyListeners();
  }
  /// Delete Button Visibility ///

  /// Toggle Theme ///
  void toogleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }
  /// Toggle Theme ///

  /// Toast Visibility ///
  void setToastVisibility(bool value) {
    toastMessages = value;
    notifyListeners();
  }
   /// Toast Visibility ///
}
/// <!-- Other Providers --!> ///
