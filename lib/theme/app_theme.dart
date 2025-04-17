import 'package:animations/animations.dart';
import 'package:asset_management_local/helpers/store_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../helpers/global_helper.dart';
import '../global/global_variables.dart';

/// <!-- App theme --!> ///
class AppTheme with ChangeNotifier {
  AppTheme._();

  ThemeData? _themeData;

  bool kDarkTheme = false;

  ThemeData? getTheme() => _themeData;
  static const lightColor = Colors.white;
  static const darkColor = Colors.black87;
  final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeThroughPageTransitionsBuilder()
      },
    ),
    textTheme: TextTheme(
        bodyMedium: GlobalHelper.textStyle(const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.normal)),
        labelLarge: GlobalHelper.textStyle(
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
    iconTheme: const IconThemeData(
      color: Colors.black87,
    ),
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    primaryColor: const Color.fromRGBO(239, 129, 58, 1),
    primaryColorDark: Colors.blue,
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        titleTextStyle: GlobalHelper.textStyle(const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontSize: 19,
        )),
        toolbarTextStyle: GlobalHelper.textStyle(const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontSize: 19,
        )),
        iconTheme: const IconThemeData(color: Colors.black87),
        actionsIconTheme: const IconThemeData(color: Colors.black87)),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(),
    dividerColor: Colors.grey[300],
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
        primary: Colors.blue, secondary: Color(0xffffa726)),
  );

  final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeThroughPageTransitionsBuilder()
        },
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          color: Colors.white,
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      cardColor: Colors.grey[900],
      scaffoldBackgroundColor: const Color.fromARGB(255, 40, 42, 57),
      primarySwatch: Colors.blue,
      primaryColorDark: const Color.fromRGBO(234, 87, 45, 1),
      primaryColor: Colors.blue,
      colorScheme: const ColorScheme.dark(
          primary: Colors.blue, secondary: Color(0xffffa726)),
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.black87,
          iconTheme: const IconThemeData(color: Colors.white),
          actionsIconTheme: const IconThemeData(color: Colors.white),
          toolbarTextStyle: TextTheme(
              titleLarge: GlobalHelper.textStyle(const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 19,
          ))).bodyMedium,
          titleTextStyle: const TextTheme(
              titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 19,
          )).titleLarge),
      dividerColor: Colors.grey[100]);

  AppTheme() {
    StorageManager.readData('themeMode').then((value) {
      var themeMode = value[1];
      if (!value[0]) {
        themeMode = checkDeviceTheme();
        if (themeMode == "Light") {
          isDarkThemes = false;
          _themeData = lightTheme;
        } else {
          _themeData = darkTheme;
          isDarkThemes = true;
        }
        StorageManager.saveData('themeMode', 'System Default');
        notifyListeners();
      } else {
        if (themeMode == "System Default") {
          String getThemeMode;
          getThemeMode = checkDeviceTheme();
          if (getThemeMode == "Light") {
            isDarkThemes = false;
            _themeData = lightTheme;
          } else {
            _themeData = darkTheme;
            isDarkThemes = true;
          }
          notifyListeners();
        } else if (themeMode == 'Dark') {
          _themeData = darkTheme;
          setDarkMode();
        } else if (themeMode == "Light") {
          setLightMode();
        }
      }
      kDarkTheme = isDarkThemes;
      notifyListeners();
    });
  }

  void setDarkMode() async {
    isDarkThemes = true;
    _themeData = darkTheme;
    kDarkTheme = true;
    StorageManager.saveData('themeMode', 'Dark');
    notifyListeners();
  }

  void setLightMode() async {
    isDarkThemes = false;
    kDarkTheme = false;
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'Light');
    notifyListeners();
  }

  void setSystemDefault() async {
    String mode = checkDeviceTheme();
    if (mode == "Light") {
      kDarkTheme = false;
      isDarkThemes = false;
      _themeData = lightTheme;
    } else {
      _themeData = darkTheme;
      kDarkTheme = true;
      isDarkThemes = true;
    }
    StorageManager.saveData('themeMode', 'System Default');
    notifyListeners();
  }

  String checkDeviceTheme() {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    var mode = darkModeOn ? "Dark" : "Light";
    return mode;
  }
}
/// <!-- App theme --!> ///
