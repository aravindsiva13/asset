import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import '../../global/global_variables.dart';
import '../../helpers/global_helper.dart';
import '../../helpers/ui_components.dart';
import '../root/root_view.dart';
import 'login_screen.dart';

class LoginMediumScreen extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VideoPlayerController videoController;

  const LoginMediumScreen({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.videoController,
  }) : super(key: key);

  @override
  State<LoginMediumScreen> createState() => _LoginMediumScreenState();
}

class _LoginMediumScreenState extends State<LoginMediumScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Wrap(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.70,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(237, 234, 232, 1),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 25, 8, 8),
                        child: Text(
                          "Asset Management",
                          textAlign: TextAlign.center,
                          style: GlobalHelper.textStyle(
                            const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      AspectRatio(
                          aspectRatio: widget.videoController.value.aspectRatio,
                          child: VideoPlayer(widget.videoController)),
                      Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Color(0xfff3f1ef),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Column(
                                children: [
                                  Image(
                                    image: const AssetImage(
                                        'assets/images/asset_logo.png'),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                  ),
                                  Text(
                                    "Login",
                                    style: GoogleFonts.ubuntu(
                                        textStyle: const TextStyle(
                                      fontSize: 28,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )),
                                  ),
                                  AutofillGroup(
                                    child: Column(
                                      children: [
                                        getEmailTextFieldUI(
                                          validators: emailValidator,
                                          controllers: widget.emailController,
                                          prefixIcon: Icons.mail,
                                          iconColor: Colors.black,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.65,
                                          hintText: 'Email',
                                          type: TextInputType.emailAddress,
                                        ),
                                        gePasswordTextField(
                                            controllers:
                                                widget.passwordController,
                                            validators: passwordValidator,
                                            prefixIcon: Icons.lock,
                                            iconColor: Colors.black,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.65,
                                            hintText: 'Password',
                                            suffixIcons: isHidden
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            onPressed: () {
                                              setState(() {
                                                isHidden = !isHidden;
                                              });
                                            }),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          information(context);
                                        },
                                        child: Text(
                                          "Forgot Password?",
                                          style: GoogleFonts.ubuntu(
                                              textStyle: const TextStyle(
                                            fontSize: 12,
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            ProgressDialog.show(context);
                                            final error =
                                                await LoginInScreen.login(
                                                    widget.emailController.text,
                                                    widget.passwordController
                                                        .text,
                                                    context);

                                            ProgressDialog.hide(context);
                                            if (isToastMessageTrue) {
                                              setState(() {
                                                showToast("Login Success");
                                              });
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const AssetManagement()));
                                            } else if (isToastMessageFalse) {
                                              setState(() {
                                                showToast(
                                                    "Login Failed:$error");
                                              });
                                            }
                                          } else {
                                            return;
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)))),
                                        child: Text(
                                          "Login",
                                          style: GoogleFonts.ubuntu(
                                              textStyle: const TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15,
                                          )),
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      information(context);
                                    },
                                    child: Text(
                                      'Sign Up? Contact Administrator',
                                      style: GoogleFonts.ubuntu(
                                          textStyle: const TextStyle(
                                        fontSize: 12,
                                      )),
                                    ),
                                  ),
                                  Text(
                                    "v$version $buildNumber",
                                    style: GoogleFonts.ubuntu(
                                        textStyle: const TextStyle(
                                            fontSize: 10,
                                            color: Color.fromRGBO(
                                                117, 117, 117, 1))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> information(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Dialog(
                child: Wrap(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Color(0xfff3f1ef),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "INFORMATION",
                                style: GoogleFonts.ubuntu(
                                    textStyle: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Please Contact Your Administrator...",
                                style: GoogleFonts.ubuntu(
                                    textStyle: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)))),
                                  child: Text(
                                    "OK",
                                    style: GoogleFonts.ubuntu(
                                        textStyle: const TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                    )),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
