import 'dart:core';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:asset_management_local/helpers/secure_storage_service.dart';
import 'package:asset_management_local/models/asset_model/asset_stock_model/asset_stock_details.dart';
import '../models/user_management_model/user_model/user_details.dart';

bool isDarkThemes = false;
bool enableDebugMode = false;
bool isHidden = true;
bool isApiCallInProgress = true;
bool isToastMessageTrue = false;
bool isToastMessageFalse = false;
bool isDark = false;
bool showLoader = true;
bool? isToastMessage;

/// It is used to filter the data and download as CSV report
List<AssetStockDetails> filteredStockList = [];
List<UserDetails> filteredUserList = [];

/// Screen Type ///
ScreenType screenType = ScreenType.large;
enum ScreenType { small, medium, large }
/// Screen Type ///

/// Version & Build Number ///
String? version;
String? buildNumber;
/// Version & Build Number ///

/// URL ///
String? websiteURL = dotenv.env['WEBSITE_URL'];
/// URL ///

/// Logout Function ///
Future<void> logout() async {
  await SecureStorageManager.deleteAllData();
}
/// Logout Function ///
