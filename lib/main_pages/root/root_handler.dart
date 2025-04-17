import 'dart:convert';
import 'dart:developer';
import 'package:asset_management_local/helpers/secure_storage_service.dart';
import 'package:asset_management_local/main_pages/login_screen/login_screen.dart';
import 'package:asset_management_local/main_pages/root/root_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../global/global_variables.dart';
import '../../models/user_management_model/role_model/assign_role_details.dart';
import '../../models/user_management_model/user_model/particular_user_model.dart';
import '../../provider/main_providers/asset_provider.dart';

class RootHandler extends StatefulWidget {
  const RootHandler({super.key});

  @override
  State<RootHandler> createState() => _RootHandlerState();
}

class _RootHandlerState extends State<RootHandler> {
  String token = "";
  @override
  void initState() {
    // TODO: implement initState
    getToken();
    super.initState();
  }

  getToken() async {
    token = (await SecureStorageManager.getToken()) ?? "";
    log("${token}here");
    if (token.isEmpty) return false;
    String fetchedDateTime =
        await SecureStorageManager.readData("timestamp") ?? "";
    if (fetchedDateTime.isNotEmpty) {
      DateTime currentDateTime = DateTime.now();

      /// Parse the fetched DateTime string back into a DateTime object
      DateTime parsedDateTime = DateTime.parse(fetchedDateTime);

      /// Calculate the difference between the current DateTime and the fetched DateTime
      Duration difference = currentDateTime.difference(parsedDateTime);

      /// Check if the difference is greater than or equal to 10 minutes
      bool isDifferenceGreaterThan10Minutes = difference.inMinutes >= 10;
      if (isDifferenceGreaterThan10Minutes) {
        /// Discord the saved token
        await SecureStorageManager.deleteAllData();
        return false;
      } else {
        final res = await fetchUserDate(token, context);
        return res;
      }
    } else {
      return false;
    }
  }

  Future<bool> fetchUserDate(String token, BuildContext context) async {
    final headers = {
      'Authorization': token,
      'Content-Type': 'application/json',
    };
    bool result = true;
    try {
      log(websiteURL.toString());
      log(headers.toString());
      var response = await http.post(
        Uri.parse('$websiteURL/user/getCompleteUserInfo'),
        headers: headers,
        body: {},
      );
      var responseData = jsonDecode(response.body);
      log(responseData.toString());
      if (response.statusCode == 200) {
        if (responseData[0]) {
          Map data = responseData[1]["data"] ?? {};
          String token = data['token'];

          var userData = data['userDetails'];

          if (userData != null) {
            ParticularUserDetails user =
                ParticularUserDetails.fromMapObject(userData);

            Provider.of<AssetProvider>(context, listen: false).setUser(user);

            if (data["roles"] != null) {
              Provider.of<AssetProvider>(context, listen: false).userRole =
                  AssignRoleDetails.fromJson(data['roles']);
            }
            await SecureStorageManager.saveToken(token);
          } else {
            result = false;
          }
        } else {
          result = false;
        }
      } else {
        result = false;

        log('Login failed: ${response.body}');
      }
    } catch (e) {
      log('Error during login: $e');
      result = false;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getToken(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          log(snapshot.data.toString());
          if (snapshot.data == true) {
            return const AssetManagement();
          } else {
            return const LoginInScreen();
          }
        }
      },
    );
  }
}
