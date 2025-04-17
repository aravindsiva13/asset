import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../global/global_variables.dart';

/// <!-- GlobalHelper --!> ///
class GlobalHelper {
  GlobalHelper._internal();

  static final GlobalHelper _instance = GlobalHelper._internal();

  static GlobalHelper get instance => _instance;

  static textStyle(TextStyle? style) {
    if(style!=null) {
      return GoogleFonts.ubuntu(textStyle: style);
    }
    else {
      return GoogleFonts.ubuntu(textStyle: const TextStyle());
    }
  }

  /// Get Version Details ///
  static getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }
  /// Get Version Details ///
}
/// <!-- GlobalHelper --!> ///