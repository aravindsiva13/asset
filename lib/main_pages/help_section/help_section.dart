import 'dart:developer';
import 'package:asset_management_local/helpers/ui_components.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../helpers/global_helper.dart';
import '../../helpers/http_helper.dart';
import '../../models/help_model/help.dart';
import '../../provider/main_providers/asset_provider.dart';

class HelpSection extends StatefulWidget {
  const HelpSection({super.key});

  @override
  State<HelpSection> createState() => _HelpSectionState();
}

class _HelpSectionState extends State<HelpSection>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController queriesController = TextEditingController();

  late AnimationController animationController;
  late Animation<double> animation;

  bool firstTimeAnimation = true;

  List<PlatformFile> selectedFiles = [];

  PlatformFile? imagePicked;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: const Duration(seconds: 11),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            firstTimeAnimation = false;
          });
        }
      });
    if (firstTimeAnimation) {
      animationController.forward();
    } else {
      return;
    }
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BoolProvider, AssetProvider>(
        builder: (context, themeProvider, user, child) {
      return Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 10, 10, 10),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                "The FAQs",
                                style: GlobalHelper.textStyle(
                                  TextStyle(
                                    color: themeProvider.isDarkTheme
                                        ? Colors.white70
                                        : Colors.black45,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Help Centre",
                                style: GlobalHelper.textStyle(
                                  TextStyle(
                                    color: themeProvider.isDarkTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "We will handle your Assets",
                                style: GlobalHelper.textStyle(
                                  TextStyle(
                                    color: themeProvider.isDarkTheme
                                        ? Colors.white70
                                        : Colors.black45,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Lottie.asset(
                            'assets/lottie/support.json',
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 75,
                ),
                Wrap(children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                          color: themeProvider.isDarkTheme
                              ? Colors.black
                              : Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Frequently Asked Questions",
                              style: GlobalHelper.textStyle(
                                TextStyle(
                                  color: themeProvider.isDarkTheme
                                      ? Colors.white70
                                      : Colors.black45,
                                  fontSize: 35,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          displayFAQ(
                              questionText:
                                  "How do I raise a ticket for an asset?",
                              answerText:
                                  'Open the Tickets section in the dashboard. Select the add icon, which will display a dialog box where you can enter the details.'),
                          displayFAQ(
                              questionText: "How do I view my asset details?",
                              answerText:
                                  "Open the Asset section in the dashboard. The Asset section displays all the assets you are handling."),
                          displayFAQ(
                              questionText:
                                  "How do I view the status of raised tickets?",
                              answerText:
                                  'In the Ticket Section, each ticket is listed. You can expand each ticket to view its details, including its status.'),
                          displayFAQ(
                              questionText: "How do I change the theme?",
                              answerText:
                                  "In the left side menu at the bottom, you will find an option to change the theme."),
                          displayFAQ(
                              questionText: "How do I log out?",
                              answerText:
                                  "In the left side menu at the bottom, you will find an option to log out from the website."),
                          const SizedBox(
                            height: 15,
                          )
                        ],
                      )),
                ]),
                const SizedBox(
                  height: 50,
                ),
                Wrap(children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                        color: themeProvider.isDarkTheme
                            ? Colors.black
                            : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Lottie.asset(
                          'assets/lottie/question_mark.json',
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Still have Queries",
                            style: GlobalHelper.textStyle(
                              TextStyle(
                                color: themeProvider.isDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: TextFormField(
                                keyboardType: TextInputType.multiline,
                                controller: queriesController,
                                validator: commonValidator,
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  border: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.orangeAccent),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.redAccent),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  contentPadding: const EdgeInsets.all(20),
                                  hintText: "Enter your Queries here",
                                  hintStyle: GlobalHelper.textStyle(
                                    TextStyle(
                                      color: themeProvider.isDarkTheme
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        _pickFile(context);
                                        showToast(
                                            "Please select only one image or file.");
                                      },
                                      icon: const Icon(Icons.attachment_rounded,
                                          color:
                                              Color.fromRGBO(15, 117, 188, 1))),
                                  filled: true,
                                  fillColor: themeProvider.isDarkTheme
                                      ? const Color.fromRGBO(16, 18, 33, 1)
                                      : const Color.fromRGBO(243, 241, 239, 1),
                                ),
                                style: GlobalHelper.textStyle(
                                  TextStyle(
                                    color: themeProvider.isDarkTheme
                                        ? Colors.white
                                        : const Color.fromRGBO(
                                            117, 117, 117, 1),
                                  ),
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        if (selectedFiles.isNotEmpty)
                          ScaleTransition(
                            scale: animation,
                            child: Container(
                              height: MediaQuery.of(context).size.width * 0.06,
                              width: MediaQuery.of(context).size.width * 0.11,
                              decoration: BoxDecoration(
                                  color: themeProvider.isDarkTheme
                                      ? const Color.fromRGBO(16, 18, 33, 1)
                                      : const Color.fromRGBO(243, 241, 239, 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0))),
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: selectedFiles.length,
                                itemBuilder: (context, index) {
                                  final file = selectedFiles[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      decoration: BoxDecoration(
                                          color: themeProvider.isDarkTheme
                                              ? Colors.black
                                              : Colors.white,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15.0))),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          getIconImage(context, file),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              file.name,
                                              style: GlobalHelper.textStyle(
                                                  TextStyle(
                                                color: themeProvider.isDarkTheme
                                                    ? Colors.white
                                                    : Colors.black,
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 10,
                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                Help help = Help(
                                    emailId: user.user!.email.toString(),
                                    queries: queriesController.text.toString(),
                                    image: imagePicked?.name);
                                await raiseHelp(help, themeProvider);

                                Future.delayed(
                                    const Duration(milliseconds: 500), () {
                                  setState(() {
                                    queriesController.clear();
                                    selectedFiles.clear();
                                  });
                                });
                              } else {
                                return;
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(15, 117, 188, 1),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                            child: Text(
                              "Submit",
                              style: GlobalHelper.textStyle(const TextStyle(
                                color: Colors.white,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              )),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget displayFAQ(
      {required String questionText, required String answerText}) {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        child: ExpansionTile(
          title: Text(
            questionText,
            style: GlobalHelper.textStyle(
              TextStyle(
                color:
                    themeProvider.isDarkTheme ? Colors.white70 : Colors.black45,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          maintainState: true,
          backgroundColor: themeProvider.isDarkTheme
              ? const Color.fromRGBO(16, 18, 33, 1)
              : const Color.fromRGBO(243, 241, 239, 1),
          collapsedBackgroundColor: themeProvider.isDarkTheme
              ? const Color.fromRGBO(16, 18, 33, 1)
              : const Color.fromRGBO(243, 241, 239, 1),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          collapsedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          iconColor: themeProvider.isDarkTheme ? Colors.white : Colors.black,
          collapsedIconColor:
              themeProvider.isDarkTheme ? Colors.white : Colors.black,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                answerText,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: GlobalHelper.textStyle(
                  TextStyle(
                    color:
                        themeProvider.isDarkTheme ? Colors.white : Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _pickFile(context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null) {
      if (result.files.length <= 2) {
        imagePicked = result.files.first;
        setState(() {
          selectedFiles = result.files;
          imagePicked = selectedFiles.first;
        });
      } else {
        log("Please select exactly two files.");
      }
    } else {
      return;
    }
  }

  getIconImage(context, PlatformFile file) {
    String extension = file.extension ?? '';

    if (extension.toLowerCase() == 'pdf' || extension.toLowerCase() == 'doc') {
      return const Icon(Icons.picture_as_pdf, color: Colors.black);
    } else if (extension.toLowerCase() == 'jpg' ||
        extension.toLowerCase() == 'jpeg' ||
        extension.toLowerCase() == 'png') {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.05,
        child: Image.memory(
          file.bytes!,
        ),
      );
    } else {
      return;
    }
  }

  Future<void> raiseHelp(Help help, BoolProvider boolProviders) async {
    await AddUpdateDetailsManagerWithImage(
      data: help,
      image: imagePicked,
      apiURL: 'help/helpSection',
    ).addUpdateDetailsWithImages(boolProviders);
  }
}
