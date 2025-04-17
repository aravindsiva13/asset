import 'package:asset_management_local/global/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../helpers/global_helper.dart';
import '../../helpers/http_helper.dart';
import '../../models/help_model/bot.dart';
import '../../provider/main_providers/asset_provider.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';


class ChatMessage {
  final String text;
  final bool isUserMessage;
  final bool isElevatedButton;

  ChatMessage(
      {required this.text,
      required this.isUserMessage,
      this.isElevatedButton = false});
}

enum BotSteps {
  botTrigger,
  askDescription,
  askName,
  askEmail,
  emailSent,
  invalidEmail,
  invalidName,
  askQuery,
  queryForSelf,
}

BotSteps currentBotStep = BotSteps.botTrigger;

class BotHelper extends StatefulWidget {
  const BotHelper({super.key});

  @override
  State<BotHelper> createState() => _BotHelperState();
}

class _BotHelperState extends State<BotHelper> {
  TextEditingController messageController = TextEditingController();

  List<ChatMessage> messages = [];

  String selectedQuery = '';

  bool isEmailValid = false;

  bool showAnimation = true;

  ScrollController scrollController = ScrollController();

  bool userTextField = true;

  String? userName;
  String? userEmail;
  String? userQuery;
  String? userDescription;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.19,
                decoration: BoxDecoration(
                  color: isDarkThemes ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              AppBar(
                                elevation: 1,
                                centerTitle: true,
                                backgroundColor: isDarkThemes
                                    ? const Color.fromRGBO(16, 18, 33, 1)
                                    : const Color.fromRGBO(243, 241, 239, 1),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                                title: Text(
                                  "Ask Dia",
                                  style: GlobalHelper.textStyle(
                                    TextStyle(
                                      color: isDarkThemes
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                leading: IconButton(
                                  icon: Icon(
                                    Icons
                                        .arrow_back, // You can use any icon you like
                                    color: isDarkThemes
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  onPressed: () {
                                    currentBotStep = BotSteps.botTrigger;
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.19,
                                height:
                                    MediaQuery.of(context).size.height * 0.58,
                                decoration: BoxDecoration(
                                  color: isDarkThemes
                                      ? Colors.black
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: showAnimation
                                    ? Column(
                                        children: [
                                          Lottie.asset(
                                            'assets/lottie/robot_say_hi.json',
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                          ),
                                          Text(
                                            "Say HI to Start the Chat:",
                                            style: GlobalHelper.textStyle(
                                              TextStyle(
                                                  color: isDarkThemes
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        ],
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        reverse: false,
                                        controller: scrollController,
                                        itemCount: messages.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final chatMessages = messages[index];
                                          return ListTile(
                                            title: Align(
                                              alignment:
                                                  chatMessages.isUserMessage
                                                      ? Alignment.centerRight
                                                      : Alignment.centerLeft,
                                              child: chatMessages
                                                      .isElevatedButton
                                                  ? ElevatedButton(
                                                      onPressed: () {
                                                        if (chatMessages.text.startsWith('Asset') ||
                                                            chatMessages.text
                                                                .startsWith(
                                                                    'Ticket') ||
                                                            chatMessages.text
                                                                .startsWith(
                                                                    'Other') ||
                                                            chatMessages.text
                                                                .startsWith(
                                                                    'Myself')) {
                                                          setState(() {
                                                            selectedQuery =
                                                                chatMessages
                                                                    .text;
                                                          });

                                                          sendMessage(
                                                              chatMessages
                                                                  .text);
                                                        }
                                                      },
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .blue),
                                                      ),
                                                      child: Text(
                                                        chatMessages.text,
                                                        style: GlobalHelper
                                                            .textStyle(
                                                          TextStyle(
                                                              color: isDarkThemes
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                              fontSize: 15),
                                                        ),
                                                      ))
                                                  : Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      decoration: BoxDecoration(
                                                          color: chatMessages
                                                                  .isUserMessage
                                                              ? isDarkThemes
                                                                  ? const Color.fromRGBO(
                                                                      1, 87, 155, 1)
                                                                  : const Color.fromRGBO(
                                                                      187, 222, 251, 1)
                                                              : isDarkThemes
                                                                  ? const Color.fromRGBO(
                                                                      16, 18, 33, 1)
                                                                  : const Color.fromRGBO(
                                                                      243,
                                                                      241,
                                                                      239,
                                                                      1),
                                                          borderRadius:
                                                              chatMessages
                                                                      .isUserMessage
                                                                  ? const BorderRadius.only(
                                                                      topLeft:
                                                                          Radius.circular(15),
                                                                      topRight: Radius.circular(15),
                                                                      bottomLeft: Radius.circular(15))
                                                                  : const BorderRadius.only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              15),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              15),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              15),
                                                                    )),
                                                      child: Text(
                                                        chatMessages.text,
                                                        style: GlobalHelper
                                                            .textStyle(
                                                          TextStyle(
                                                              color: chatMessages
                                                                      .isUserMessage
                                                                  ? isDarkThemes
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black
                                                                  : isDarkThemes
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                              fontSize: 15),
                                                        ),
                                                      )),
                                            ),
                                          );
                                        }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                      child: messageField(
                          width: MediaQuery.of(context).size.width * 0.18,
                          controllers: messageController,
                          suffixIcon: Icons.send_rounded,
                          iconColor: Colors.blue,
                          hintText: 'Type A Message Here...'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// It is used to send an message from user side
  sendMessage(String message) {
    setState(() {
      messages.add(ChatMessage(
        text: message,
        isUserMessage: true,
      ));
      showAnimation = false;
    });
    botsResponse(message);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// It is used for Bot Response and in-built questions and answers
  botsResponse(String message) async {
    AssetProvider userProviders =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider boolProvider =
        Provider.of<BoolProvider>(context, listen: false);

    var name = userProviders.user?.name.toString() ?? "";

    var email = userProviders.user?.email.toString() ?? "";

    switch (currentBotStep) {
      case BotSteps.botTrigger:
        if (message.toLowerCase().contains('hi') ||
            message.toLowerCase().contains('hello')) {
          Future.delayed(const Duration(milliseconds: 250), () {
            setState(() {
              addChatMessage("HI!!!");
            });
          });

          userTextField = false;

          Future.delayed(const Duration(milliseconds: 1000), () {
            setState(() {
              addChatMessage("Select any query here");
            });
          });
          Future.delayed(const Duration(milliseconds: 1250), () {
            addElevatedButton("Asset Issues");
          });

          Future.delayed(const Duration(milliseconds: 1500), () {
            addElevatedButton("Ticket Issues");
          });

          Future.delayed(const Duration(milliseconds: 1750), () {
            addElevatedButton("Other Issues");
          });

          currentBotStep = BotSteps.askQuery;
        } else {
          addChatMessage("Hi! Please say 'Hi' to start the chat.");
        }
        break;

      case BotSteps.askQuery:
        if (message.toLowerCase().contains('asset')) {
          selectedQuery = "Asset Issues";
        } else if (message.toLowerCase().contains('ticket')) {
          selectedQuery = "Ticket Issues";
        } else if (message.toLowerCase().contains('other')) {
          selectedQuery = "Other Issues";
        } else {
          addChatMessage("Please select a valid query.");
          break;
        }
        userQuery = selectedQuery;
        Future.delayed(const Duration(milliseconds: 250), () {
          setState(() {
            addChatMessage("Describe your $selectedQuery briefly:");
          });
        });
        userTextField = true;
        currentBotStep = BotSteps.askDescription;
        break;

      case BotSteps.askDescription:
        if (message.isEmpty) {
          Future.delayed(const Duration(milliseconds: 250), () {
            setState(() {
              addChatMessage("Please describe your $selectedQuery briefly:");
            });
          });
        } else {
          userDescription = message;
          userTextField = false;
          Future.delayed(const Duration(milliseconds: 250), () {
            setState(() {
              addChatMessage("You are raising issue for");
            });
          });
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              addElevatedButton("Myself");
            });
          });

          Future.delayed(const Duration(milliseconds: 750), () {
            setState(() {
              addElevatedButton("Others");
            });
          });

          currentBotStep = BotSteps.queryForSelf;
        }
        break;

      case BotSteps.queryForSelf:
        if (message.toLowerCase().contains('myself')) {
          userTextField = false;
          Future.delayed(const Duration(milliseconds: 250), () async {
            setState(() {
              messages.add(ChatMessage(
                  text: 'Email sent successfully!', isUserMessage: false));
            });

            setState(() {
              messages.add(ChatMessage(
                  text: 'Our Asset Manager will contact u soon',
                  isUserMessage: false));
            });
            Bot bot = Bot(
                name: name.toString(),
                emailId: email.toString(),
                issue: userQuery.toString(),
                description: userDescription.toString());

            await botHelp(bot, boolProvider);
          });
          currentBotStep = BotSteps.emailSent;
        } else if (message.toLowerCase() == 'others') {
          userTextField = true;
          addChatMessage("Enter the Name of the Person:");
          currentBotStep = BotSteps.askName;
        } else {
          addChatMessage("Please select a valid option.");
        }
        break;

      case BotSteps.askName:
        if (message.length <= 3) {
          addChatMessage(
              "Invalid Name. Please enter a name with more than 3 characters:");
        } else {
          userName = message;
          addChatMessage("Enter the Email-ID of the Person:");
          currentBotStep = BotSteps.askEmail;
        }
        break;

      case BotSteps.askEmail:
        if (message.toLowerCase().contains('@')) {
          isEmailValid = validateEmail(message);
          userEmail = message.toString();

          if (isEmailValid) {
            setState(() {
              messages
                  .add(ChatMessage(text: 'Checking....', isUserMessage: false));
            });
            await Future.delayed(const Duration(milliseconds: 250));
            setState(() {
              messages.add(ChatMessage(
                  text: 'Email sent successfully!', isUserMessage: false));
            });

            await Future.delayed(const Duration(milliseconds: 250));
            userTextField = false;

            await Future.delayed(const Duration(milliseconds: 250));
            setState(() {
              messages.add(ChatMessage(
                  text: 'Our Asset Manager will contact u soon',
                  isUserMessage: false));
            });

            currentBotStep = BotSteps.emailSent;

            Bot bot = Bot(
                name: userName.toString(),
                emailId: userEmail.toString(),
                issue: userQuery.toString(),
                description: userDescription.toString());

            await botHelp(bot, boolProvider);
          } else {
            return;
          }
        } else if (!message.toLowerCase().contains('@')) {
          isEmailValid = validateEmail(message);
          if (!isEmailValid) {
            setState(() {
              messages.add(ChatMessage(
                  text: 'Invalid Email ID. Please try again:',
                  isUserMessage: false));
            });
          } else {
            return;
          }
        }
        break;

      default:
        break;
    }

    scrollChatToBottom;
  }

  addChatMessage(String text) {
    Future.delayed(const Duration(milliseconds: 250), () {
      setState(() {
        messages.add(ChatMessage(text: text, isUserMessage: false));
      });
    });
  }

  addElevatedButton(String text) {
    Future.delayed(const Duration(milliseconds: 250), () {
      setState(() {
        messages.add(ChatMessage(
            text: text, isUserMessage: false, isElevatedButton: true));
      });
    });
  }

  scrollChatToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Email Validator for Email in the chat
  bool validateEmail(email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern as String);
    return regex.hasMatch(email);
  }

  /// It is used for entering the text in user side
  Widget messageField({
    required double width,
    required TextEditingController controllers,
    required IconData suffixIcon,
    required Color iconColor,
    required String hintText,
  }) {
    return Visibility(
      visible: userTextField,
      child: Container(
        margin: const EdgeInsets.all(2),
        width: width,
        child: TextFormField(
          controller: controllers,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: isDarkThemes ? Colors.white : Colors.black),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: isDarkThemes ? Colors.white : Colors.black),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            contentPadding: const EdgeInsets.all(15),
            suffixIcon: IconButton(
              icon: Icon(suffixIcon),
              onPressed: () {
                sendMessage(messageController.text);
                messageController.clear();
              },
              color: iconColor,
            ),
            hintText: hintText,
            hintStyle: GlobalHelper.textStyle(
              TextStyle(
                color: isDarkThemes ? Colors.white : Colors.black,
                fontSize: 15,
              ),
            ),
            fillColor: isDarkThemes ? Colors.black : Colors.white,
            filled: true,
          ),
          onFieldSubmitted: (value) {
            sendMessage(value);
            messageController.clear();
          },
          style: GlobalHelper.textStyle(
            TextStyle(
              color: isDarkThemes ? Colors.white : Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> botHelp(Bot bot, BoolProvider boolProviders) async {
    await AddUpdateDetailsManager(
      data: bot,
      apiURL: 'help/bot',
    ).addUpdateDetails(boolProviders);
  }
}
