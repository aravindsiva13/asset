import 'package:asset_management_local/main_pages/ticket/raise_ticket.dart';
import 'package:asset_management_local/main_pages/ticket/ticket_list_expanded_view.dart';
import 'package:asset_management_local/main_pages/ticket/update_ticket.dart';
import 'package:asset_management_local/models/ticket_model/ticket_details.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../global/global_variables.dart';
import '../../helpers/global_helper.dart';
import '../../helpers/http_helper.dart';
import '../../helpers/ui_components.dart';
import '../../provider/main_providers/asset_provider.dart';

class TicketList extends StatefulWidget {
  const TicketList({super.key});

  @override
  State<TicketList> createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> with TickerProviderStateMixin {
  String? dropDownValueTicket;

  int selectedIndex = 0;
  int listPerPage = 5;
  int currentPage = 0;

  late AnimationController controller;
  late TableBorder startBorder;
  late TableBorder endBorder;
  late TableBorder currentBorder;

  List<TicketDetails> filteredList = [];

  List<TicketDetails> getPaginatedData() {
    AssetProvider ticketProvider =
        Provider.of<AssetProvider>(context, listen: false);

    AssetProvider userProvider =
        Provider.of<AssetProvider>(context, listen: false);

    var assignedUserId = userProvider.user!.sId.toString();

    var userId = userProvider.user!.sId.toString();

    if (ticketProvider.userRole.ticketMainFlag) {
      filteredList = (dropDownValueTicket == "All")
          ? ticketProvider.ticketDetailsList
          : ticketProvider.ticketDetailsList.where((ticket) {
              if (dropDownValueTicket == "Assigned To Me") {
                return ticket.assignedRefId == assignedUserId;
              } else {
                return ticket.type == dropDownValueTicket;
              }
            }).toList();

      final startIndex = currentPage * listPerPage;
      final endIndex = (startIndex + listPerPage).clamp(0, filteredList.length);
      return filteredList.sublist(startIndex, endIndex);
    } else {
      filteredList = (dropDownValueTicket == "All")
          ? ticketProvider.ticketDetailsList
          : ticketProvider.ticketDetailsList.where((ticket) {
              if (dropDownValueTicket == "My Ticket") {
                return ticket.userRefId == userId;
              } else {
                return ticket.type == dropDownValueTicket;
              }
            }).toList();

      final startIndex = currentPage * listPerPage;
      final endIndex = (startIndex + listPerPage).clamp(0, filteredList.length);
      return filteredList.sublist(startIndex, endIndex).reversed.toList();
    }
  }

  String getDisplayedRange() {
    AssetProvider ticketProvider =
        Provider.of<AssetProvider>(context, listen: false);

    AssetProvider userProvider =
        Provider.of<AssetProvider>(context, listen: false);

    var assignedUserId = userProvider.user!.sId.toString();

    var userId = userProvider.user!.sId.toString();

    if (ticketProvider.userRole.ticketMainFlag) {
      filteredList = (dropDownValueTicket == "All")
          ? ticketProvider.ticketDetailsList
          : ticketProvider.ticketDetailsList.where((ticket) {
              if (dropDownValueTicket == "Assigned To Me") {
                return ticket.assignedRefId == assignedUserId;
              } else {
                return ticket.type == dropDownValueTicket;
              }
            }).toList();

      final displayedListLength = filteredList.length;
      final startIndex = currentPage * listPerPage + 1;
      final endIndex =
          (startIndex + listPerPage - 1).clamp(0, displayedListLength);

      return '$startIndex-$endIndex of $displayedListLength';
    } else {
      filteredList = (dropDownValueTicket == "All")
          ? ticketProvider.ticketDetailsList
          : ticketProvider.ticketDetailsList.where((ticket) {
              if (dropDownValueTicket == "My Ticket") {
                return ticket.userRefId == userId;
              } else {
                return ticket.type == dropDownValueTicket;
              }
            }).toList();

      final displayedListLength = filteredList.length;
      final startIndex = currentPage * listPerPage + 1;
      final endIndex =
          (startIndex + listPerPage - 1).clamp(0, displayedListLength);

      return '$startIndex-$endIndex of $displayedListLength';
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<AssetProvider>(context, listen: false).fetchTicketDetails();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showLoader = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final roleProvider = Provider.of<AssetProvider>(context, listen: false);
    final userRole = roleProvider.userRole;
    dropDownValueTicket =
        userRole.ticketMainFlag ? "Assigned To Me" : "My Ticket";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BoolProvider, AssetProvider>(
        builder: (context, boolProvider, ticketProvider, child) {
      final themeProvider = Provider.of<BoolProvider>(context, listen: false);
      final isDarkTheme = themeProvider.isDarkTheme;

      final borderColor = isDarkTheme
          ? const Color.fromRGBO(16, 18, 33, 1)
          : const Color(0xfff3f1ef);

      startBorder = TableBorder(
        borderRadius: BorderRadius.circular(15),
        horizontalInside: BorderSide(color: borderColor, width: 5.0),
        left: BorderSide(color: borderColor, width: 5.0),
        right: BorderSide(color: borderColor, width: 5.0),
      );
      endBorder = TableBorder(
        borderRadius: BorderRadius.circular(15),
        horizontalInside: BorderSide(color: borderColor, width: 5.0),
        left: BorderSide(color: borderColor, width: 5.0),
        right: BorderSide(color: borderColor, width: 5.0),
      );

      currentBorder = startBorder;

      controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      );

      controller.addListener(() {
        setState(() {
          currentBorder =
              TableBorder.lerp(startBorder, endBorder, controller.value)!;
        });
      });
      return Center(
          child: Stack(children: [
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: boolProvider.isDarkTheme
                    ? const Color.fromRGBO(16, 18, 33, 1)
                    : const Color(0xfff3f1ef),
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            child: Wrap(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Row(
                        children: [
                          Text(
                            "Ticket List",
                            style: GoogleFonts.ubuntu(
                                textStyle: TextStyle(
                              fontSize: 20,
                              color: boolProvider.isDarkTheme
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                          ),
                          IconButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(builder:
                                        (context, StateSetter dialogSetState) {
                                      return const RaiseTicket();
                                    });
                                  },
                                );
                              },
                              icon: const Icon(Icons.add_circle),
                              color: const Color.fromRGBO(15, 117, 188, 1))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Row(
                        children: [
                          Text(
                            "Type",
                            style: GoogleFonts.ubuntu(
                                textStyle: TextStyle(
                              fontSize: 17,
                              color: boolProvider.isDarkTheme
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                          ),
                          getTypeDropDownContentUI(),
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                      child: RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: getPaginatedData().length.toString(),
                            style: GoogleFonts.ubuntu(
                                textStyle: const TextStyle(
                              fontSize: 20,
                              color: Color.fromRGBO(15, 117, 188, 1),
                            )),
                          ),
                          TextSpan(
                            text: " Tickets",
                            style: GoogleFonts.ubuntu(
                                textStyle: TextStyle(
                              fontSize: 20,
                              color: boolProvider.isDarkTheme
                                  ? Colors.white
                                  : Colors.black,
                            )),
                          )
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            child: Row(
                              children: [
                                Text(
                                  "Entries Per Page: ",
                                  style: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                    fontSize: 17,
                                    color: boolProvider.isDarkTheme
                                        ? Colors.white
                                        : Colors.black,
                                  )),
                                ),
                                getPageDropDownContentUI(),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            child: Text(
                              getDisplayedRange(),
                              style: GoogleFonts.ubuntu(
                                  textStyle: TextStyle(
                                fontSize: 13,
                                color: boolProvider.isDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                              )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_circle_left_rounded),
                              disabledColor: Colors.grey,
                              onPressed: currentPage > 0
                                  ? () => setState(() => currentPage--)
                                  : null,
                              color: Colors.blue,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            child: IconButton(
                              icon:
                                  const Icon(Icons.arrow_circle_right_rounded),
                              color: Colors.blue,
                              disabledColor: Colors.grey,
                              onPressed: (currentPage + 1) * listPerPage <
                                      filteredList.length
                                  ? () {
                                      setState(() => currentPage++);
                                    }
                                  : null,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                isApiCallInProgress
                    ? Center(
                        child: Lottie.asset("assets/lottie/loader.json",
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.4))
                    : filteredList.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ticketProvider.userRole.ticketMainFlag
                                ? Table(
                                    border: currentBorder,
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    children: [
                                      TableRow(children: [
                                        getTitleText(
                                          text: "      ",
                                        ),
                                        getTitleText(
                                          text: "ID",
                                        ),
                                        getTitleText(
                                          text: "Type",
                                        ),
                                        getTitleText(
                                          text: "Priority",
                                        ),
                                        getTitleText(
                                          text: "Status",
                                        ),
                                        getTitleText(
                                          text: "Estimated Date",
                                        ),
                                        getTitleText(
                                          text: "Assigned To",
                                        ),
                                        getTitleText(
                                          text: "Actions",
                                        ),
                                      ]),
                                      ...getPaginatedData()
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        TicketDetails ticket = entry.value;

                                        return TableRow(
                                            decoration: BoxDecoration(
                                                color: boolProvider.isDarkTheme
                                                    ? Colors.black
                                                    : Colors.white,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20))),
                                            children: [
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 20),
                                                  child: CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor:
                                                        themeProvider
                                                                .isDarkTheme
                                                            ? const Color
                                                                .fromRGBO(
                                                                16, 18, 33, 1)
                                                            : const Color(
                                                                0xfff3f1ef),
                                                    child: SizedBox(
                                                      width: 100,
                                                      height: 100,
                                                      child: ClipOval(
                                                          child: Image.asset(
                                                              'assets/images/riota_logo.png')),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              getContentText(
                                                  text: ticket.displayId
                                                      .toString(),
                                                  maxLines: 1,
                                                  color: themeProvider
                                                          .isDarkTheme
                                                      ? const Color.fromRGBO(
                                                          200, 200, 200, 1)
                                                      : const Color.fromRGBO(
                                                          117, 117, 117, 1)),
                                              getContentText(
                                                  text: ticket.type.toString(),
                                                  maxLines: 1,
                                                  color: themeProvider
                                                          .isDarkTheme
                                                      ? const Color.fromRGBO(
                                                          200, 200, 200, 1)
                                                      : const Color.fromRGBO(
                                                          117, 117, 117, 1)),
                                              ticket.priority == "null" ||
                                                      ticket.priority == null
                                                  ? getContentText(
                                                      text: "-",
                                                      maxLines: 1,
                                                      color: themeProvider
                                                              .isDarkTheme
                                                          ? const Color.fromRGBO(
                                                              200, 200, 200, 1)
                                                          : const Color.fromRGBO(
                                                              117, 117, 117, 1))
                                                  : getContentText(
                                                      text: ticket.priority
                                                          .toString(),
                                                      maxLines: 1,
                                                      color: themeProvider
                                                              .isDarkTheme
                                                          ? const Color.fromRGBO(
                                                              200, 200, 200, 1)
                                                          : const Color
                                                              .fromRGBO(117,
                                                              117, 117, 1)),
                                              ticket.status == "null" ||
                                                      ticket.status == null
                                                  ? Center(
                                                      child: getContentText(
                                                          text: "-",
                                                          maxLines: 1,
                                                          color: themeProvider
                                                                  .isDarkTheme
                                                              ? const Color.fromRGBO(
                                                                  200, 200, 200, 1)
                                                              : const Color.fromRGBO(
                                                                  117,
                                                                  117,
                                                                  117,
                                                                  1)))
                                                  : getContentText(
                                                      text: ticket.status
                                                          .toString(),
                                                      maxLines: 1,
                                                      color: themeProvider
                                                              .isDarkTheme
                                                          ? const Color.fromRGBO(
                                                              200, 200, 200, 1)
                                                          : const Color.fromRGBO(
                                                              117, 117, 117, 1)),
                                              ticket.estimatedTime == "null" ||
                                                      ticket.estimatedTime ==
                                                          null
                                                  ? getContentText(
                                                      text: "-",
                                                      maxLines: 1,
                                                      color: themeProvider
                                                              .isDarkTheme
                                                          ? const Color.fromRGBO(
                                                              200, 200, 200, 1)
                                                          : const Color.fromRGBO(
                                                              117, 117, 117, 1))
                                                  : getContentText(
                                                      text: ticket.estimatedTime
                                                          .toString(),
                                                      maxLines: 1,
                                                      color: themeProvider
                                                              .isDarkTheme
                                                          ? const Color.fromRGBO(
                                                              200, 200, 200, 1)
                                                          : const Color.fromRGBO(
                                                              117,
                                                              117,
                                                              117,
                                                              1)),
                                              ticket.assignedName == "null" ||
                                                      ticket.assignedName ==
                                                          null
                                                  ? getContentText(
                                                      text: "-",
                                                      maxLines: 1,
                                                      color: themeProvider
                                                              .isDarkTheme
                                                          ? const Color.fromRGBO(
                                                              200, 200, 200, 1)
                                                          : const Color.fromRGBO(
                                                              117, 117, 117, 1))
                                                  : getContentText(
                                                      text: ticket.assignedName
                                                          .toString(),
                                                      maxLines: 1,
                                                      color: themeProvider
                                                              .isDarkTheme
                                                          ? const Color.fromRGBO(
                                                              200, 200, 200, 1)
                                                          : const Color.fromRGBO(
                                                              117,
                                                              117,
                                                              117,
                                                              1)),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  CustomActionIcon(
                                                      message: "View More",
                                                      preferBelow: false,
                                                      iconImage: Image.asset(
                                                          'assets/images/expand.png'),
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return TicketListExpandedView(
                                                                ticket: ticket);
                                                          },
                                                        );
                                                      }),
                                                  ticket.status ==
                                                              "Completed" ||
                                                          ticket.status ==
                                                              "Rejected"
                                                      ? const Text(
                                                          "",
                                                        )
                                                      : CustomActionIcon(
                                                          message: "Edit",
                                                          preferBelow: true,
                                                          iconImage: const Icon(
                                                              Icons
                                                                  .edit_rounded),
                                                          color: const Color
                                                              .fromRGBO(
                                                              15, 117, 188, 1),
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return UpdateTicket(
                                                                    ticket:
                                                                        ticket);
                                                              },
                                                            );
                                                          }),
                                                  ticketProvider.userRole
                                                          .ticketMainFlag
                                                      ? (ticket.status ==
                                                              "Rejected"
                                                          ? CustomActionIcon(
                                                              message: "Delete",
                                                              preferBelow:
                                                                  false,
                                                              iconImage:
                                                                  const Icon(Icons
                                                                      .delete_rounded),
                                                              color: Colors.red,
                                                              onPressed: () {
                                                                showAlertDialog(
                                                                    context,
                                                                    ticketId: ticket
                                                                        .displayId
                                                                        .toString(),
                                                                    color: boolProvider.isDarkTheme
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                    containerColor: boolProvider.isDarkTheme
                                                                        ? Colors
                                                                            .black
                                                                        : Colors
                                                                            .white,
                                                                    onPressed:
                                                                        () async {
                                                                  String?
                                                                      ticketIdDelete =
                                                                      ticket.sId
                                                                          .toString();

                                                                  if (mounted) {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  }

                                                                  await deleteTicket(
                                                                      ticketIdDelete,
                                                                      themeProvider,
                                                                      ticketProvider);
                                                                });
                                                              },
                                                            )
                                                          : const Text(""))
                                                      : const Text(""),
                                                ],
                                              ),
                                            ]);
                                      }).toList(),
                                    ],
                                  )
                                : Table(
                                    border: currentBorder,
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    children: [
                                      TableRow(children: [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Text(
                                              "      ",
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: const TextStyle(
                                                fontSize: 15,
                                                color: Color.fromRGBO(
                                                    117, 117, 117, 1),
                                              )),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Text(
                                              "ID",
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: const TextStyle(
                                                fontSize: 15,
                                                color: Color.fromRGBO(
                                                    117, 117, 117, 1),
                                              )),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Text(
                                              "Type",
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: const TextStyle(
                                                fontSize: 15,
                                                color: Color.fromRGBO(
                                                    117, 117, 117, 1),
                                              )),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Text(
                                              "Priority",
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: const TextStyle(
                                                fontSize: 15,
                                                color: Color.fromRGBO(
                                                    117, 117, 117, 1),
                                              )),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Text(
                                              "Expected Date",
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: const TextStyle(
                                                fontSize: 15,
                                                color: Color.fromRGBO(
                                                    117, 117, 117, 1),
                                              )),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Text(
                                              "Actions",
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: const TextStyle(
                                                fontSize: 15,
                                                color: Color.fromRGBO(
                                                    117, 117, 117, 1),
                                              )),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      ...getPaginatedData()
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        TicketDetails ticket = entry.value;
                                        return TableRow(
                                            decoration: BoxDecoration(
                                                color: boolProvider.isDarkTheme
                                                    ? Colors.black
                                                    : Colors.white,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20))),
                                            children: [
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 20),
                                                  child: CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor:
                                                        themeProvider
                                                                .isDarkTheme
                                                            ? const Color
                                                                .fromRGBO(
                                                                16, 18, 33, 1)
                                                            : const Color(
                                                                0xfff3f1ef),
                                                    child: SizedBox(
                                                      width: 100,
                                                      height: 100,
                                                      child: ClipOval(
                                                          child: Image.asset(
                                                              'assets/images/riota_logo.png')),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                  ticket.displayId.toString(),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.ubuntu(
                                                      textStyle:
                                                          const TextStyle(
                                                    fontSize: 13,
                                                    color: Color.fromRGBO(
                                                        117, 117, 117, 1),
                                                  )),
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                  ticket.type.toString(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.ubuntu(
                                                      textStyle:
                                                          const TextStyle(
                                                    fontSize: 13,
                                                    color: Color.fromRGBO(
                                                        117, 117, 117, 1),
                                                  )),
                                                ),
                                              ),
                                              ticket.priority == "null" ||
                                                      ticket.priority == null
                                                  ? Center(
                                                      child: Text(
                                                        "-",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                                textStyle:
                                                                    const TextStyle(
                                                          fontSize: 13,
                                                          color: Color.fromRGBO(
                                                              117, 117, 117, 1),
                                                        )),
                                                      ),
                                                    )
                                                  : Center(
                                                      child: Text(
                                                        ticket.priority
                                                            .toString(),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                                textStyle:
                                                                    const TextStyle(
                                                          fontSize: 13,
                                                          color: Color.fromRGBO(
                                                              117, 117, 117, 1),
                                                        )),
                                                      ),
                                                    ),
                                              ticket.expectedTime == "null" ||
                                                      ticket.expectedTime ==
                                                          null ||
                                                      ticket.expectedTime == ""
                                                  ? Center(
                                                      child: Text(
                                                        "-",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                                textStyle:
                                                                    const TextStyle(
                                                          fontSize: 13,
                                                          color: Color.fromRGBO(
                                                              117, 117, 117, 1),
                                                        )),
                                                      ),
                                                    )
                                                  : Center(
                                                      child: Text(
                                                        ticket.expectedTime
                                                            .toString(),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                                textStyle:
                                                                    const TextStyle(
                                                          fontSize: 13,
                                                          color: Color.fromRGBO(
                                                              117, 117, 117, 1),
                                                        )),
                                                      ),
                                                    ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  CustomActionIcon(
                                                      message: "View More",
                                                      preferBelow: false,
                                                      iconImage: Image.asset(
                                                          'assets/images/expand.png'),
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return TicketListExpandedView(
                                                                ticket: ticket);
                                                          },
                                                        );
                                                      }),
                                                ],
                                              ),
                                            ]);
                                      }).toList(),
                                    ],
                                  ),
                          )
                        : showLoader
                            ? Center(
                                child: Lottie.asset(
                                  "assets/lottie/loader.json",
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                ),
                              )
                            : Center(
                                child: Lottie.asset(
                                  "assets/lottie/data_not_found.json",
                                  repeat: false,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                ),
                              ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        )
      ]));
    });
  }

  showAlertDialog(BuildContext context,
      {required onPressed,
      required color,
      required containerColor,
      required ticketId}) {
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: GlobalHelper.textStyle(const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w400,
          fontSize: 15,
        )),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget yesButton = TextButton(
        onPressed: onPressed,
        child: Text(
          "Confirm",
          style: GlobalHelper.textStyle(const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w400,
            fontSize: 15,
          )),
        ));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: containerColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          "Delete Ticket",
          style: GlobalHelper.textStyle(TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          )),
        ),
      ),
      content: getTableDeleteForSingleId(id: ticketId, color: color),
      actions: [
        cancelButton,
        yesButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget getTypeDropDownContentUI() {
    AssetProvider ticketProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    AssetProvider userProvider =
        Provider.of<AssetProvider>(context, listen: false);

    var assignedUserId = userProvider.user!.sId.toString();

    List<String> dropdownItems = ticketProvider.userRole.ticketMainFlag
        ? ["Assigned To Me", "All"]
        : ["My Ticket"];
    if (ticketProvider.userRole.ticketMainFlag) {
      dropdownItems.addAll(ticketProvider.ticketDetailsList
          .where((ticket) => ticket.assignedRefId == assignedUserId)
          .map((ticket) => ticket.type ?? "")
          .toSet());
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton(
        elevation: 1,
        iconDisabledColor: Colors.blue,
        iconEnabledColor: Colors.blue,
        dropdownColor: themeProvider.isDarkTheme
            ? const Color.fromRGBO(16, 18, 33, 1)
            : const Color(0xfff3f1ef),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        value: dropDownValueTicket,
        items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                value,
                style: GoogleFonts.ubuntu(
                  textStyle: const TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            dropDownValueTicket = value!;
            currentPage = 0;
          });
        },
      ),
    );
  }

  Widget getPageDropDownContentUI() {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        elevation: 1,
        iconDisabledColor: Colors.blue,
        iconEnabledColor: Colors.blue,
        dropdownColor: themeProvider.isDarkTheme
            ? const Color.fromRGBO(16, 18, 33, 1)
            : const Color(0xfff3f1ef),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        value: listPerPage,
        items: <int>[5, 10, 15].map((value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                '$value',
                style: GoogleFonts.ubuntu(
                    textStyle: const TextStyle(
                  fontSize: 17,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                )),
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            listPerPage = value!;
            currentPage = 0;
          });
        },
      ),
    );
  }

  Future<void> deleteTicket(String ticketId, BoolProvider boolProviders,
      AssetProvider ticketProvider) async {
    await DeleteDetailsManager(
      apiURL: 'ticket/deleteTicket',
      id: ticketId,
    ).deleteDetails(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("Ticket Deleted Successfully");
        ticketProvider.fetchTicketDetails();
      });
    } else {
      setState(() {
        showToast("Unable to delete the ticket");
      });
    }
  }
}
