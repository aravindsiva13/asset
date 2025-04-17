import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../global/global_variables.dart';
import '../../helpers/global_helper.dart';
import '../../helpers/secure_storage_service.dart';

import '../../models/user_management_model/role_model/assign_role_details.dart';
import '../../models/user_management_model/user_model/particular_user_model.dart';
import '../../provider/main_providers/asset_provider.dart';
import 'login_page_large_screen.dart';
import 'login_page_medium_screen.dart';
import 'login_page_small_screen.dart';
import 'package:http/http.dart' as http;

class LoginInScreen extends StatefulWidget {
  const LoginInScreen({Key? key}) : super(key: key);

  @override
  State<LoginInScreen> createState() => _LoginInScreenState();

  static Future<String> login(
      String email, String password, BuildContext context) async {
    var headers = {
      'authorization': 'apiitambackend',
      'Content-Type': 'application/json',
    };
    String errorMsg = "";
    try {
      var requestBody = jsonEncode({'email': email, 'password': password});

      var response = await http.post(
        Uri.parse('$websiteURL/user/login'),
        headers: headers,
        body: requestBody,
      );
      var responseData = jsonDecode(response.body);

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

            isToastMessageTrue = true;
          } else {
            Fluttertoast.showToast(msg: "Unable to login,contact your admin");
            isToastMessageFalse = true;
            isToastMessageTrue = false;
            errorMsg = responseData[1]["msg"] ?? "";
          }
        } else {
          isToastMessageFalse = true;
          isToastMessageTrue = false;
          errorMsg = responseData[1]["msg"] ?? "";
        }
      } else {
        isToastMessageFalse = true;
        isToastMessageTrue = false;

        errorMsg = responseData[1]["msg"] ?? "";
        log('Login failed: ${response.body}');
      }
    } catch (e) {
      log('Error during login: $e');
      isToastMessageFalse = true;
      isToastMessageTrue = false;
    }
    return errorMsg;
  }
}

class _LoginInScreenState extends State<LoginInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late VideoPlayerController videoController;

  @override
  void initState() {
    super.initState();
    GlobalHelper.getVersion();
    videoController =
        VideoPlayerController.asset("assets/video/asset_login.mp4")
          ..initialize().then((_) {
            videoController.play();
            videoController.setLooping(true);
            setState(() {});
          });
  }

  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return LoginSmallScreen(
                emailController: emailController,
                passwordController: passwordController,
                videoController: videoController);
          } else if (constraints.maxWidth > 600 &&
              constraints.maxWidth < 1000) {
            return LoginMediumScreen(
                emailController: emailController,
                passwordController: passwordController,
                videoController: videoController);
          } else if (constraints.maxWidth >= 1000) {
            return LoginLargeScreen(
                emailController: emailController,
                passwordController: passwordController,
                videoController: videoController);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class ProgressDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: !isDarkThemes ? Colors.black : Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Please wait...',
                style: GoogleFonts.ubuntu(
                    color: isDarkThemes ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold),
              ), // Message
            ],
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop(); // Close the dialog
  }
}

class LoginControllers {}
