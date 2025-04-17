import 'dart:convert';
import 'dart:developer';
import 'package:asset_management_local/models/user_management_model/role_model/assign_role_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../global/global_variables.dart';
import '../../../global/user_interaction_timer.dart';
import '../../../helpers/global_helper.dart';
import '../../../helpers/http_helper.dart';
import '../../../helpers/ui_components.dart';
import 'package:asset_management_local/provider/main_providers/asset_provider.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';

class AssignRole extends StatefulWidget {
  const AssignRole({super.key});

  @override
  State<AssignRole> createState() => _AssignRoleState();
}

class _AssignRoleState extends State<AssignRole> with TickerProviderStateMixin {
  List<String> roles = [];

  TextEditingController roleController = TextEditingController();

  String? dropDownValueRole = "All";

  int selectedIndex = 0;
  int listPerPage = 5;
  int currentPage = 0;

  late AnimationController controller;
  late TableBorder startBorder;
  late TableBorder endBorder;
  late TableBorder currentBorder;

  late String roleId;

  bool? locationMainFlag = false;

  bool locationReadFlag = false;
  bool locationWriteFlag = false;

  bool? userMainFlag = false;

  bool userReadFlag = false;
  bool userWriteFlag = false;

  bool? companyMainFlag = false;

  bool companyReadFlag = false;
  bool companyWriteFlag = false;

  bool? vendorMainFlag = false;

  bool vendorReadFlag = false;
  bool vendorWriteFlag = false;

  bool? ticketMainFlag = false;

  bool ticketReadFlag = false;
  bool ticketWriteFlag = false;

  bool? assetTemplateMainFlag = false;

  bool assetTemplateReadFlag = false;
  bool assetTemplateWriteFlag = false;

  bool? assetStockMainFlag = false;

  bool assetStockReadFlag = false;
  bool assetStockWriteFlag = false;

  bool? assetModelMainFlag = false;

  bool assetModelReadFlag = false;
  bool assetModelWriteFlag = false;

  bool? assignRoleMainFlag = false;

  bool assignRoleReadFlag = false;
  bool assignRoleWriteFlag = false;

  bool? assetTypeMainFlag = false;

  bool assetTypeReadFlag = false;
  bool assetTypeWriteFlag = false;

  bool? assetCategoryMainFlag = false;

  bool assetCategoryReadFlag = false;
  bool assetCategoryWriteFlag = false;

  bool? assetSubCategoryMainFlag = false;

  bool assetSubCategoryReadFlag = false;
  bool assetSubCategoryWriteFlag = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<AssignRoleDetails> getPaginatedData() {
    AssetProvider assignRoleProvider =
        Provider.of<AssetProvider>(context, listen: false);

    List<AssignRoleDetails> filteredList = (dropDownValueRole == "All")
        ? assignRoleProvider.fetchedRoleDetailsList
        : assignRoleProvider.fetchedRoleDetailsList
            .where((role) => role.roleTitle == dropDownValueRole)
            .toList();

    final startIndex = currentPage * listPerPage;
    final endIndex = (startIndex + listPerPage).clamp(0, filteredList.length);

    return filteredList.sublist(startIndex, endIndex);
  }

  String getDisplayedRange() {
    AssetProvider assignRoleProvider =
        Provider.of<AssetProvider>(context, listen: false);

    final displayedList = (dropDownValueRole == "All")
        ? assignRoleProvider.fetchedRoleDetailsList
        : assignRoleProvider.fetchedRoleDetailsList
            .where((role) => role.roleTitle == dropDownValueRole)
            .toList();

    final displayedListLength = displayedList.length;
    final startIndex = currentPage * listPerPage + 1;
    final endIndex =
        (startIndex + listPerPage - 1).clamp(0, displayedListLength);

    return '$startIndex-$endIndex of $displayedListLength';
  }

  @override
  void initState() {
    super.initState();
    Provider.of<AssetProvider>(context, listen: false).fetchRoleDetails();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AssetProvider, BoolProvider>(
        builder: (context, assignRoleProvider, themeProvider, child) {
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
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: themeProvider.isDarkTheme
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
                            "Create Roles",
                            style: GoogleFonts.ubuntu(
                                textStyle: TextStyle(
                              fontSize: 20,
                              color: themeProvider.isDarkTheme
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                          ),
                          if (assignRoleProvider
                              .userRole.assignRoleWriteFlag) ...[
                            IconButton(
                                onPressed: () {
                                  addRoles(context);
                                },
                                icon: const Icon(Icons.add_circle),
                                color: const Color.fromRGBO(15, 117, 188, 1))
                          ]
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 40, 0),
                      child: Row(
                        children: [
                          Text(
                            "Role",
                            style: GoogleFonts.ubuntu(
                                textStyle: TextStyle(
                              fontSize: 17,
                              color: themeProvider.isDarkTheme
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                          ),
                          getRoleDropDownContentUI(),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                                text: " Roles",
                                style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                  fontSize: 20,
                                  color: themeProvider.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                )),
                              )
                            ]),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 25, 15),
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
                                    color: themeProvider.isDarkTheme
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
                                color: themeProvider.isDarkTheme
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
                                      assignRoleProvider
                                          .fetchedRoleDetailsList.length
                                  ? () {
                                      final displayedList =
                                          (dropDownValueRole == "All")
                                              ? assignRoleProvider
                                                  .fetchedRoleDetailsList
                                              : assignRoleProvider
                                                  .fetchedRoleDetailsList
                                                  .where((role) =>
                                                      role.roleTitle ==
                                                      dropDownValueRole)
                                                  .toList();

                                      if (displayedList.isNotEmpty &&
                                          (currentPage + 1) * listPerPage <
                                              displayedList.length) {
                                        setState(() => currentPage++);
                                      }
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
                    : assignRoleProvider.fetchedRoleDetailsList.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Table(
                              border: currentBorder,
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              children: [
                                TableRow(children: [
                                  getTitleText(
                                    text: "ID",
                                  ),
                                  getTitleText(
                                    text: "Role",
                                  ),
                                  getTitleText(
                                    text: "Access Control",
                                  ),
                                  getTitleText(
                                    text: "Delete",
                                  ),
                                ]),
                                ...getPaginatedData()
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  int index = entry.key;
                                  AssignRoleDetails role = entry.value;

                                  return TableRow(
                                      decoration: BoxDecoration(
                                          color: themeProvider.isDarkTheme
                                              ? Colors.black
                                              : Colors.white,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              (index + 1).toString(),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: const TextStyle(
                                                fontSize: 13,
                                                color: Color.fromRGBO(
                                                    117, 117, 117, 1),
                                              )),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              role.roleTitle.toString(),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: TextStyle(
                                                fontSize: 13,
                                                color: themeProvider.isDarkTheme
                                                    ? const Color.fromRGBO(
                                                        200, 200, 200, 1)
                                                    : const Color.fromRGBO(
                                                        117, 117, 117, 1),
                                              )),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: !assignRoleProvider.userRole
                                                        .assignRoleWriteFlag ||
                                                    role.roleTitle ==
                                                        "Super Admin"
                                                ? IconButton(
                                                    icon: const Icon(Icons
                                                        .remove_red_eye_rounded),
                                                    color: Colors.blue,
                                                    onPressed: () async {
                                                      selectedIndex = index;

                                                      AssetProvider
                                                          assignRoleProvider =
                                                          Provider.of<
                                                                  AssetProvider>(
                                                              context,
                                                              listen: false);

                                                      await assignRoleProvider
                                                          .fetchRoleDetails();

                                                      roleId =
                                                          role.sId.toString();
                                                      userReadFlag =
                                                          role.userReadFlag;
                                                      userWriteFlag =
                                                          role.userWriteFlag;
                                                      companyReadFlag =
                                                          role.companyReadFlag;
                                                      companyWriteFlag =
                                                          role.companyWriteFlag;
                                                      vendorReadFlag =
                                                          role.vendorReadFlag;
                                                      vendorWriteFlag =
                                                          role.vendorWriteFlag;
                                                      ticketWriteFlag =
                                                          role.ticketWriteFlag;
                                                      ticketReadFlag =
                                                          role.ticketReadFlag;
                                                      assetStockReadFlag = role
                                                          .assetStockReadFlag;
                                                      assetStockWriteFlag = role
                                                          .assetStockWriteFlag;
                                                      assetTemplateWriteFlag = role
                                                          .assetTemplateWriteFlag;
                                                      assetTemplateReadFlag = role
                                                          .assetTemplateReadFlag;
                                                      assetModelWriteFlag = role
                                                          .assetModelWriteFlag;
                                                      assetModelReadFlag = role
                                                          .assetModelReadFlag;
                                                      assignRoleReadFlag = role
                                                          .assignRoleReadFlag;
                                                      assignRoleWriteFlag = role
                                                          .assignRoleWriteFlag;
                                                      locationReadFlag =
                                                          role.locationReadFlag;
                                                      locationWriteFlag = role
                                                          .locationWriteFlag;
                                                      locationMainFlag =
                                                          role.locationMainFlag;
                                                      userMainFlag =
                                                          role.userMainFlag;
                                                      companyMainFlag =
                                                          role.companyMainFlag;
                                                      vendorMainFlag =
                                                          role.vendorMainFlag;
                                                      ticketMainFlag =
                                                          role.ticketMainFlag;
                                                      assetTemplateMainFlag = role
                                                          .assetTemplateMainFlag;
                                                      assetStockMainFlag = role
                                                          .assetStockMainFlag;
                                                      assetModelMainFlag = role
                                                          .assetModelMainFlag;
                                                      assignRoleMainFlag = role
                                                          .assignRoleMainFlag;
                                                      assetTypeMainFlag = role
                                                          .assetTypeMainFlag;
                                                      assetTypeWriteFlag = role
                                                          .assetTypeWriteFlag;
                                                      assetTypeReadFlag = role
                                                          .assetTypeReadFlag;
                                                      assetCategoryMainFlag = role
                                                          .assetCategoryMainFlag;
                                                      assetCategoryWriteFlag = role
                                                          .assetCategoryWriteFlag;
                                                      assetCategoryReadFlag = role
                                                          .assetCategoryReadFlag;
                                                      assetSubCategoryMainFlag =
                                                          role.assetSubCategoryMainFlag;
                                                      assetSubCategoryWriteFlag =
                                                          role.assetSubCategoryWriteFlag;
                                                      assetSubCategoryReadFlag =
                                                          role.assetSubCategoryReadFlag;

                                                      if (mounted) {
                                                        configurableRoles(context,
                                                            text: "Close",
                                                            onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        }, isDisabled: true);
                                                      }
                                                    },
                                                  )
                                                : IconButton(
                                                    icon:
                                                        const Icon(Icons.edit),
                                                    color: Colors.blue,
                                                    onPressed: () async {
                                                      selectedIndex = index;

                                                      AssetProvider
                                                          assignRoleProvider =
                                                          Provider.of<
                                                                  AssetProvider>(
                                                              context,
                                                              listen: false);

                                                      await assignRoleProvider
                                                          .fetchRoleDetails();

                                                      roleId =
                                                          role.sId.toString();
                                                      userReadFlag =
                                                          role.userReadFlag;
                                                      userWriteFlag =
                                                          role.userWriteFlag;
                                                      companyReadFlag =
                                                          role.companyReadFlag;
                                                      companyWriteFlag =
                                                          role.companyWriteFlag;
                                                      vendorReadFlag =
                                                          role.vendorReadFlag;
                                                      vendorWriteFlag =
                                                          role.vendorWriteFlag;
                                                      ticketWriteFlag =
                                                          role.ticketWriteFlag;
                                                      ticketReadFlag =
                                                          role.ticketReadFlag;
                                                      assetStockReadFlag = role
                                                          .assetStockReadFlag;
                                                      assetStockWriteFlag = role
                                                          .assetStockWriteFlag;
                                                      assetTemplateWriteFlag = role
                                                          .assetTemplateWriteFlag;
                                                      assetTemplateReadFlag = role
                                                          .assetTemplateReadFlag;
                                                      assetModelWriteFlag = role
                                                          .assetModelWriteFlag;
                                                      assetModelReadFlag = role
                                                          .assetModelReadFlag;
                                                      assignRoleReadFlag = role
                                                          .assignRoleReadFlag;
                                                      assignRoleWriteFlag = role
                                                          .assignRoleWriteFlag;
                                                      locationReadFlag =
                                                          role.locationReadFlag;
                                                      locationWriteFlag = role
                                                          .locationWriteFlag;
                                                      locationMainFlag =
                                                          role.locationMainFlag;
                                                      userMainFlag =
                                                          role.userMainFlag;
                                                      companyMainFlag =
                                                          role.companyMainFlag;
                                                      vendorMainFlag =
                                                          role.vendorMainFlag;
                                                      ticketMainFlag =
                                                          role.ticketMainFlag;
                                                      assetTemplateMainFlag = role
                                                          .assetTemplateMainFlag;
                                                      assetStockMainFlag = role
                                                          .assetStockMainFlag;
                                                      assetModelMainFlag = role
                                                          .assetModelMainFlag;
                                                      assignRoleMainFlag = role
                                                          .assignRoleMainFlag;
                                                      assetTypeMainFlag = role
                                                          .assetTypeMainFlag;
                                                      assetTypeWriteFlag = role
                                                          .assetTypeWriteFlag;
                                                      assetTypeReadFlag = role
                                                          .assetTypeReadFlag;
                                                      assetCategoryMainFlag = role
                                                          .assetCategoryMainFlag;
                                                      assetCategoryWriteFlag = role
                                                          .assetCategoryWriteFlag;
                                                      assetCategoryReadFlag = role
                                                          .assetCategoryReadFlag;
                                                      assetSubCategoryMainFlag =
                                                          role.assetSubCategoryMainFlag;
                                                      assetSubCategoryWriteFlag =
                                                          role.assetSubCategoryWriteFlag;
                                                      assetSubCategoryReadFlag =
                                                          role.assetSubCategoryReadFlag;

                                                      if (mounted) {
                                                        configurableRoles(
                                                            context,
                                                            text: "Update",
                                                            onPressed: () {
                                                          _onTapEditButton(
                                                              index);
                                                        }, isDisabled: false);
                                                      }
                                                    },
                                                  ),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: !assignRoleProvider.userRole
                                                        .assignRoleWriteFlag ||
                                                    role.roleTitle ==
                                                        "Super Admin"
                                                ? Text(
                                                    "-",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.ubuntu(
                                                        textStyle: TextStyle(
                                                      fontSize: 13,
                                                      color: themeProvider
                                                              .isDarkTheme
                                                          ? const Color
                                                              .fromRGBO(
                                                              200, 200, 200, 1)
                                                          : const Color
                                                              .fromRGBO(
                                                              117, 117, 117, 1),
                                                    )),
                                                  )
                                                : IconButton(
                                                    icon: const Icon(
                                                        Icons.delete),
                                                    color: Colors.red,
                                                    onPressed: () async {
                                                      selectedIndex = index;
                                                      String? roleIdDelete =
                                                          assignRoleProvider
                                                              .fetchedRoleDetailsList[
                                                                  index]
                                                              .sId
                                                              .toString();
                                                      await deleteRole(
                                                          roleIdDelete,
                                                          themeProvider,
                                                          assignRoleProvider);
                                                    },
                                                  ),
                                          ),
                                        ),
                                      ]);
                                }).toList()
                              ],
                            ))
                        : Center(
                            child: Lottie.asset(
                                "assets/lottie/data_not_found.json",
                                repeat: false,
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.4),
                          ),
              ],
            ),
          ),
        ),
      );
    });
  }

  /// Roles Check Boxes
  Future<void> configurableRoles(BuildContext context,
      {required text, required onPressed, required bool isDisabled}) async {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Listener(
              onPointerHover: (event) {
                UserInteractionTimer.resetTimer(context);
              },
              onPointerDown: (event) {
                UserInteractionTimer.resetTimer(context);
              },
              child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: SingleChildScrollView(
                    child: Container(
                  decoration: BoxDecoration(
                      color: themeProvider.isDarkTheme
                          ? const Color.fromRGBO(16, 18, 33, 1)
                          : const Color(0xfff3f1ef),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Wrap(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "Roles",
                              style: GoogleFonts.ubuntu(
                                  textStyle: TextStyle(
                                fontSize: 25,
                                color: themeProvider.isDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                            ),
                          ),
                          ListTile(
                            leading: IconButton(
                              icon: openRole[1]
                                  ? Image.asset('assets/icon/navigate_down.png')
                                  : const Icon(Icons.navigate_next_rounded),
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  openRole[1] = !openRole[1];
                                });
                              },
                            ),
                            title: getCheckBoxListTile(
                              value: userMainFlag,
                              tristate: true,
                              onChanged: isDisabled
                                  ? null
                                  : (bool? value) {
                                userMainFlag = value;
                                if (userMainFlag == null && (userWriteFlag || userReadFlag)) {
                                  setState(() {
                                    userReadFlag = false;
                                    userWriteFlag = false;
                                    userMainFlag = false;
                                  });
                                } else if (userMainFlag!) {
                                  setState(() {
                                    userReadFlag = true;
                                    userWriteFlag = true;
                                  });
                                }
                              },
                              title: 'Users',
                            ),
                          ),
                          if (openRole[1])
                            Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: Column(
                                children: [
                                  getCheckBoxListTile(
                                      value: userReadFlag,
                                      tristate: false,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        userReadFlag = value!;
                                        if (userReadFlag && userWriteFlag) {
                                          setState(() {
                                            userMainFlag = true;
                                          });
                                        } else if (!userReadFlag &&
                                            !userWriteFlag) {
                                          setState(() {
                                            userMainFlag = false;
                                          });
                                        } else if (value || userWriteFlag) {
                                          setState(() {
                                            userMainFlag = false;
                                          });
                                        } else {
                                          setState(() {
                                            userMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'View'),
                                  getCheckBoxListTile(
                                      value: userWriteFlag,
                                      tristate: false,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        userWriteFlag = value!;
                                        if (userReadFlag && userWriteFlag) {
                                          setState(() {
                                            userMainFlag = true;
                                          });
                                        } else if (!userReadFlag &&
                                            !userWriteFlag) {
                                          setState(() {
                                            userMainFlag = false;
                                          });
                                        } else if (value || userReadFlag) {
                                          setState(() {
                                            userMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            userMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'View & Modify'),
                                ],
                              ),
                            ),
                          ListTile(
                            leading: IconButton(
                              icon: openRole[2]
                                  ? Image.asset('assets/icon/navigate_down.png')
                                  : const Icon(Icons.navigate_next_rounded),
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  openRole[2] = !openRole[2];
                                });
                              },
                            ),
                            title: getCheckBoxListTile(
                                value: companyMainFlag,
                                tristate: true,
                                onChanged: isDisabled
                                    ? null
                                    :(bool? value) {
                                  companyMainFlag = value;
                                  if (companyMainFlag == null &&
                                      (companyReadFlag || companyWriteFlag)) {
                                    setState(() {
                                      companyReadFlag = false;
                                      companyWriteFlag = false;
                                      companyMainFlag = false;
                                    });
                                  } else if (companyMainFlag!) {
                                    setState(() {
                                      companyReadFlag = true;
                                      companyWriteFlag = true;
                                    });
                                  }
                                },
                                title: 'Companies'),
                          ),
                          if (openRole[2])
                            Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: Column(
                                children: [
                                  getCheckBoxListTile(
                                      tristate: false,
                                      value: companyReadFlag,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        companyReadFlag = value!;
                                        if (companyReadFlag &&
                                            companyWriteFlag) {
                                          setState(() {
                                            companyMainFlag = true;
                                          });
                                        } else if (!companyReadFlag &&
                                            !companyWriteFlag) {
                                          setState(() {
                                            companyMainFlag = false;
                                          });
                                        } else if (value || companyWriteFlag) {
                                          setState(() {
                                            companyMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            companyMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'View'),
                                  getCheckBoxListTile(
                                      tristate: false,
                                      value: companyWriteFlag,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        companyWriteFlag = value!;
                                        if (companyReadFlag &&
                                            companyWriteFlag) {
                                          setState(() {
                                            companyMainFlag = true;
                                          });
                                        } else if (!companyReadFlag &&
                                            !companyWriteFlag) {
                                          setState(() {
                                            companyMainFlag = false;
                                          });
                                        } else if (value || companyReadFlag) {
                                          setState(() {
                                            companyMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            companyMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'View & Modify'),
                                ],
                              ),
                            ),
                          ListTile(
                            leading: IconButton(
                              icon: openRole[3]
                                  ? Image.asset('assets/icon/navigate_down.png')
                                  : const Icon(Icons.navigate_next_rounded),
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  openRole[3] = !openRole[3];
                                });
                              },
                            ),
                            title: getCheckBoxListTile(
                                tristate: true,
                                value: vendorMainFlag,
                                onChanged: isDisabled
                                    ? null
                                    :(bool? value) {
                                  vendorMainFlag = value;
                                  if (vendorMainFlag == null &&
                                      (vendorWriteFlag || vendorReadFlag)) {
                                    setState(() {
                                      vendorReadFlag = false;
                                      vendorWriteFlag = false;
                                      vendorMainFlag = false;
                                    });
                                  } else if (vendorMainFlag!) {
                                    setState(() {
                                      vendorReadFlag = true;
                                      vendorWriteFlag = true;
                                    });
                                  }
                                },
                                title: 'Vendors'),
                          ),
                          if (openRole[3])
                            Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: Column(
                                children: [
                                  getCheckBoxListTile(
                                      tristate: false,
                                      value: vendorReadFlag,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        vendorReadFlag = value!;
                                        if (vendorReadFlag && vendorWriteFlag) {
                                          setState(() {
                                            vendorMainFlag = true;
                                          });
                                        } else if (!vendorReadFlag &&
                                            !vendorWriteFlag) {
                                          setState(() {
                                            vendorMainFlag = false;
                                          });
                                        } else if (value || vendorWriteFlag) {
                                          setState(() {
                                            vendorMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            vendorMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'View'),
                                  getCheckBoxListTile(
                                      tristate: false,
                                      value: vendorWriteFlag,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        vendorWriteFlag = value!;
                                        if (vendorReadFlag && vendorWriteFlag) {
                                          setState(() {
                                            vendorMainFlag = true;
                                          });
                                        } else if (!vendorReadFlag &&
                                            !vendorWriteFlag) {
                                          setState(() {
                                            vendorMainFlag = false;
                                          });
                                        } else if (value || vendorReadFlag) {
                                          setState(() {
                                            vendorMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            vendorMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'View & Modify'),
                                ],
                              ),
                            ),
                          ListTile(
                            leading: IconButton(
                              icon: openRole[4]
                                  ? Image.asset('assets/icon/navigate_down.png')
                                  : const Icon(Icons.navigate_next_rounded),
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  openRole[4] = !openRole[4];
                                });
                              },
                            ),
                            title: getCheckBoxListTile(
                                tristate: true,
                                value: ticketMainFlag,
                                onChanged: isDisabled
                                    ? null
                                    :(bool? value) {
                                  ticketMainFlag = value;
                                  if (ticketMainFlag == null &&
                                      (ticketWriteFlag || ticketReadFlag)) {
                                    setState(() {
                                      ticketReadFlag = false;
                                      ticketWriteFlag = false;
                                      ticketMainFlag = false;
                                    });
                                  } else if (ticketMainFlag!) {
                                    setState(() {
                                      ticketReadFlag = true;
                                      ticketWriteFlag = true;
                                    });
                                  }
                                },
                                title: 'Tickets'),
                          ),
                          if (openRole[4])
                            Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: Column(
                                children: [
                                  getCheckBoxListTile(
                                      tristate: false,
                                      value: ticketReadFlag,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        ticketReadFlag = value!;
                                        if (ticketReadFlag && ticketWriteFlag) {
                                          setState(() {
                                            ticketMainFlag = true;
                                          });
                                        } else if (!ticketReadFlag &&
                                            !ticketWriteFlag) {
                                          setState(() {
                                            ticketMainFlag = false;
                                          });
                                        } else if (value || ticketWriteFlag) {
                                          setState(() {
                                            ticketMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            ticketMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'Asset & Service Request'),
                                  getCheckBoxListTile(
                                      tristate: false,
                                      value: ticketWriteFlag,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        ticketWriteFlag = value!;
                                        if (ticketReadFlag && ticketWriteFlag) {
                                          setState(() {
                                            ticketMainFlag = true;
                                          });
                                        } else if (!ticketReadFlag &&
                                            !ticketWriteFlag) {
                                          setState(() {
                                            ticketMainFlag = false;
                                          });
                                        } else if (value || ticketReadFlag) {
                                          setState(() {
                                            ticketMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            ticketMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'All'),
                                ],
                              ),
                            ),
                          ListTile(
                            leading: IconButton(
                              icon: openRole[5]
                                  ? Image.asset('assets/icon/navigate_down.png')
                                  : const Icon(Icons.navigate_next_rounded),
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  openRole[5] = !openRole[5];
                                });
                              },
                            ),
                            title: getCheckBoxListTile(
                                tristate: true,
                                value: assetTemplateMainFlag,
                                onChanged: isDisabled
                                    ? null
                                    :(bool? value) {
                                  assetTemplateMainFlag = value;
                                  if (assetTemplateMainFlag == null &&
                                      (assetTemplateWriteFlag ||
                                          assetTemplateReadFlag)) {
                                    setState(() {
                                      assetTemplateReadFlag = false;
                                      assetTemplateWriteFlag = false;
                                      assetTemplateMainFlag = false;
                                    });
                                  } else if (assetTemplateMainFlag!) {
                                    setState(() {
                                      assetTemplateReadFlag = true;
                                      assetTemplateWriteFlag = true;
                                    });
                                  }
                                },
                                title: 'Asset Templates'),
                          ),
                          if (openRole[5])
                            Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: Column(
                                children: [
                                  getCheckBoxListTile(
                                      tristate: false,
                                      value: assetTemplateReadFlag,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        assetTemplateReadFlag = value!;
                                        if (assetTemplateReadFlag &&
                                            assetTemplateWriteFlag) {
                                          setState(() {
                                            userMainFlag = true;
                                          });
                                        } else if (!assetTemplateReadFlag &&
                                            !assetTemplateWriteFlag) {
                                          setState(() {
                                            assetTemplateMainFlag = false;
                                          });
                                        } else if (value ||
                                            assetTemplateWriteFlag) {
                                          setState(() {
                                            assetTemplateMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            assetTemplateMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'View'),
                                  getCheckBoxListTile(
                                      tristate: false,
                                      value: assetTemplateWriteFlag,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        assetTemplateWriteFlag = value!;
                                        if (assetTemplateReadFlag &&
                                            assetTemplateWriteFlag) {
                                          setState(() {
                                            assetTemplateMainFlag = true;
                                          });
                                        } else if (!assetTemplateReadFlag &&
                                            !assetTemplateWriteFlag) {
                                          setState(() {
                                            assetTemplateMainFlag = false;
                                          });
                                        } else if (value ||
                                            assetTemplateReadFlag) {
                                          setState(() {
                                            assetTemplateMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            assetTemplateMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'View & Modify'),
                                ],
                              ),
                            ),
                          ListTile(
                            leading: IconButton(
                              icon: openRole[6]
                                  ? Image.asset('assets/icon/navigate_down.png')
                                  : const Icon(Icons.navigate_next_rounded),
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  openRole[6] = !openRole[6];
                                });
                              },
                            ),
                            title: getCheckBoxListTile(
                                tristate: true,
                                value: assetStockMainFlag,
                                onChanged: isDisabled
                                    ? null
                                    :(bool? value) {
                                  assetTemplateMainFlag = value;
                                  if (assetStockMainFlag == null &&
                                      (assetStockWriteFlag ||
                                          assetStockReadFlag)) {
                                    setState(() {
                                      assetStockReadFlag = false;
                                      assetStockWriteFlag = false;
                                      assetStockMainFlag = false;
                                    });
                                  } else if (assetStockMainFlag!) {
                                    setState(() {
                                      assetStockReadFlag = true;
                                      assetStockWriteFlag = true;
                                    });
                                  }
                                },
                                title: 'Asset Stock'),
                          ),
                          if (openRole[6])
                            Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: Column(
                                children: [
                                  getCheckBoxListTile(
                                      tristate: false,
                                      value: assetStockReadFlag,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        assetStockReadFlag = value!;
                                        if (assetStockReadFlag &&
                                            assetStockWriteFlag) {
                                          setState(() {
                                            assetStockMainFlag = true;
                                          });
                                        } else if (!assetStockReadFlag &&
                                            !assetStockWriteFlag) {
                                          setState(() {
                                            assetStockMainFlag = false;
                                          });
                                        } else if (value ||
                                            assetStockWriteFlag) {
                                          setState(() {
                                            assetStockMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            assetStockMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'My Assets'),
                                  getCheckBoxListTile(
                                      tristate: false,
                                      value: assetStockWriteFlag,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        assetStockWriteFlag = value!;
                                        if (userReadFlag &&
                                            assetStockWriteFlag) {
                                          setState(() {
                                            assetStockMainFlag = true;
                                          });
                                        } else if (!assetStockReadFlag &&
                                            !assetStockWriteFlag) {
                                          setState(() {
                                            assetStockMainFlag = false;
                                          });
                                        } else if (value ||
                                            assetStockReadFlag) {
                                          setState(() {
                                            assetStockMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            assetStockMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'All Assets'),
                                ],
                              ),
                            ),
                          ListTile(
                            leading: IconButton(
                              icon: openRole[7]
                                  ? Image.asset('assets/icon/navigate_down.png')
                                  : const Icon(Icons.navigate_next_rounded),
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  openRole[7] = !openRole[7];
                                });
                              },
                            ),
                            title: getCheckBoxListTile(
                                tristate: true,
                                value: assetModelMainFlag,
                                onChanged: isDisabled
                                    ? null
                                    :(bool? value) {
                                  assetModelMainFlag = value;
                                  if (assetModelMainFlag == null &&
                                      (assetModelWriteFlag ||
                                          assetModelReadFlag)) {
                                    setState(() {
                                      assetModelReadFlag = false;
                                      assetModelWriteFlag = false;
                                      assetModelMainFlag = false;
                                    });
                                  } else if (assetModelMainFlag!) {
                                    setState(() {
                                      assetModelReadFlag = true;
                                      assetModelWriteFlag = true;
                                    });
                                  }
                                },
                                title: 'Asset Models'),
                          ),
                          if (openRole[7])
                            Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: Column(
                                children: [
                                  getCheckBoxListTile(
                                      tristate: false,
                                      value: assetModelReadFlag,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        assetModelReadFlag = value!;
                                        if (assetModelReadFlag &&
                                            assetModelWriteFlag) {
                                          setState(() {
                                            assetModelMainFlag = true;
                                          });
                                        } else if (!assetModelReadFlag &&
                                            !assetModelWriteFlag) {
                                          setState(() {
                                            assetModelMainFlag = false;
                                          });
                                        } else if (value ||
                                            assetModelWriteFlag) {
                                          setState(() {
                                            assetModelMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            assetModelMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'View'),
                                  getCheckBoxListTile(
                                      tristate: false,
                                      value: assetModelWriteFlag,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        assetModelWriteFlag = value!;
                                        if (assetModelReadFlag &&
                                            assetModelWriteFlag) {
                                          setState(() {
                                            assetModelMainFlag = true;
                                          });
                                        } else if (!assetModelReadFlag &&
                                            !assetModelWriteFlag) {
                                          setState(() {
                                            assetModelMainFlag = false;
                                          });
                                        } else if (value ||
                                            assetModelReadFlag) {
                                          setState(() {
                                            assetModelMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            assetModelMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'View & Modify'),
                                ],
                              ),
                            ),
                          ListTile(
                            leading: IconButton(
                              icon: openRole[8]
                                  ? Image.asset('assets/icon/navigate_down.png')
                                  : const Icon(Icons.navigate_next_rounded),
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  openRole[8] = !openRole[8];
                                });
                              },
                            ),
                            title: getCheckBoxListTile(
                                tristate: true,
                                value: assignRoleMainFlag,
                                onChanged: isDisabled
                                    ? null
                                    :(bool? value) {
                                  assignRoleMainFlag = value;
                                  if (assignRoleMainFlag == null &&
                                      (assignRoleWriteFlag ||
                                          assignRoleReadFlag)) {
                                    setState(() {
                                      assignRoleReadFlag = false;
                                      assignRoleWriteFlag = false;
                                      assignRoleMainFlag = false;
                                    });
                                  } else if (assignRoleMainFlag!) {
                                    setState(() {
                                      assignRoleReadFlag = true;
                                      assignRoleWriteFlag = true;
                                    });
                                  }
                                },
                                title: 'Assign Roles'),
                          ),
                          if (openRole[8])
                            Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: Column(
                                children: [
                                  getCheckBoxListTile(
                                      tristate: false,
                                      value: assignRoleReadFlag,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        assignRoleReadFlag = value!;
                                        if (assignRoleReadFlag &&
                                            assignRoleWriteFlag) {
                                          setState(() {
                                            assignRoleMainFlag = true;
                                          });
                                        } else if (!assignRoleReadFlag &&
                                            !assignRoleWriteFlag) {
                                          setState(() {
                                            assignRoleMainFlag = false;
                                          });
                                        } else if (value ||
                                            assignRoleWriteFlag) {
                                          setState(() {
                                            assignRoleMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            assignRoleMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'View'),
                                  getCheckBoxListTile(
                                      tristate: false,
                                      value: assignRoleWriteFlag,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        assignRoleWriteFlag = value!;
                                        if (assignRoleReadFlag &&
                                            assignRoleWriteFlag) {
                                          setState(() {
                                            assignRoleMainFlag = true;
                                          });
                                        } else if (!assignRoleReadFlag &&
                                            !assignRoleWriteFlag) {
                                          setState(() {
                                            assignRoleMainFlag = false;
                                          });
                                        } else if (value ||
                                            assignRoleReadFlag) {
                                          setState(() {
                                            assignRoleMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            assignRoleMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'View & Modify'),
                                ],
                              ),
                            ),
                          ListTile(
                            leading: IconButton(
                              icon: openRole[0]
                                  ? Image.asset('assets/icon/navigate_down.png')
                                  : const Icon(Icons.navigate_next_rounded),
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  openRole[0] = !openRole[0];
                                });
                              },
                            ),
                            title: getCheckBoxListTile(
                                tristate: true,
                                value: locationMainFlag,
                                onChanged: isDisabled
                                    ? null
                                    :(bool? value) {
                                  locationMainFlag = value;
                                  if (locationMainFlag == null &&
                                      (locationWriteFlag || locationReadFlag)) {
                                    setState(() {
                                      locationReadFlag = false;
                                      locationWriteFlag = false;
                                      locationMainFlag = false;
                                    });
                                  } else if (locationMainFlag!) {
                                    setState(() {
                                      locationReadFlag = true;
                                      locationWriteFlag = true;
                                    });
                                  }
                                },
                                title: 'Locations'),
                          ),
                          if (openRole[0])
                            Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: Column(
                                children: [
                                  getCheckBoxListTile(
                                      tristate: false,
                                      value: locationReadFlag,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        locationReadFlag = value!;
                                        if (locationReadFlag &&
                                            locationWriteFlag) {
                                          setState(() {
                                            locationMainFlag = true;
                                          });
                                        } else if (!locationReadFlag &&
                                            !locationWriteFlag) {
                                          setState(() {
                                            locationMainFlag = false;
                                          });
                                        } else if (value || locationWriteFlag) {
                                          setState(() {
                                            locationMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            locationMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'View'),
                                  getCheckBoxListTile(
                                      tristate: false,
                                      value: locationWriteFlag,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        locationWriteFlag = value!;
                                        if (locationReadFlag &&
                                            locationWriteFlag) {
                                          setState(() {
                                            locationMainFlag = true;
                                          });
                                        } else if (!locationReadFlag &&
                                            !locationWriteFlag) {
                                          setState(() {
                                            locationMainFlag = false;
                                          });
                                        } else if (value || locationReadFlag) {
                                          setState(() {
                                            locationMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            locationMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'View & Modify'),
                                ],
                              ),
                            ),
                          ListTile(
                            leading: IconButton(
                              icon: openRole[9]
                                  ? Image.asset('assets/icon/navigate_down.png')
                                  : const Icon(Icons.navigate_next_rounded),
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  openRole[9] = !openRole[9];
                                });
                              },
                            ),
                            title: getCheckBoxListTile(
                                tristate: true,
                                value: assetTypeMainFlag,
                                onChanged: isDisabled
                                    ? null
                                    :(bool? value) {
                                  assetTypeMainFlag = value;
                                  if (assetTypeMainFlag == null &&
                                      (assetTypeWriteFlag ||
                                          assetTypeReadFlag)) {
                                    setState(() {
                                      assetTypeReadFlag = false;
                                      assetTypeWriteFlag = false;
                                      assetTypeMainFlag = false;
                                    });
                                  } else if (assetTypeMainFlag!) {
                                    setState(() {
                                      assetTypeReadFlag = true;
                                      assetTypeWriteFlag = true;
                                    });
                                  }
                                },
                                title: 'Asset Types'),
                          ),
                          if (openRole[9])
                            Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: Column(
                                children: [
                                  getCheckBoxListTile(
                                      tristate: false,
                                      value: assetTypeReadFlag,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        assetTypeReadFlag = value!;
                                        if (assetTypeReadFlag &&
                                            assetTypeWriteFlag) {
                                          setState(() {
                                            assetTypeMainFlag = true;
                                          });
                                        } else if (!assetTypeReadFlag &&
                                            !assetTypeWriteFlag) {
                                          setState(() {
                                            assetTypeMainFlag = false;
                                          });
                                        } else if (value ||
                                            assetTypeWriteFlag) {
                                          setState(() {
                                            assetTypeMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            assetTypeMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'View'),
                                  getCheckBoxListTile(
                                      tristate: false,
                                      value: assetTypeWriteFlag,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        assetTypeWriteFlag = value!;
                                        if (assetTypeReadFlag &&
                                            assetTypeWriteFlag) {
                                          setState(() {
                                            assetTypeMainFlag = true;
                                          });
                                        } else if (!assetTypeReadFlag &&
                                            !assetTypeWriteFlag) {
                                          setState(() {
                                            assetTypeMainFlag = false;
                                          });
                                        } else if (value || assetTypeReadFlag) {
                                          setState(() {
                                            assetTypeMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            assetTypeMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'View & Modify'),
                                ],
                              ),
                            ),
                          ListTile(
                            leading: IconButton(
                              icon: openRole[10]
                                  ? Image.asset('assets/icon/navigate_down.png')
                                  : const Icon(Icons.navigate_next_rounded),
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  openRole[10] = !openRole[10];
                                });
                              },
                            ),
                            title: getCheckBoxListTile(
                                tristate: true,
                                value: assetCategoryMainFlag,
                                onChanged: isDisabled
                                    ? null
                                    :(bool? value) {
                                  assetCategoryMainFlag = value;
                                  if (assetCategoryMainFlag == null &&
                                      (assetCategoryWriteFlag ||
                                          assetCategoryReadFlag)) {
                                    setState(() {
                                      assetCategoryReadFlag = false;
                                      assetCategoryWriteFlag = false;
                                      assetCategoryMainFlag = false;
                                    });
                                  } else if (assetCategoryMainFlag!) {
                                    setState(() {
                                      assetCategoryReadFlag = true;
                                      assetCategoryWriteFlag = true;
                                    });
                                  }
                                },
                                title: 'Asset Categories'),
                          ),
                          if (openRole[10])
                            Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: Column(
                                children: [
                                  getCheckBoxListTile(
                                      tristate: false,
                                      value: assetCategoryReadFlag,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        assetCategoryReadFlag = value!;
                                        if (assetCategoryReadFlag &&
                                            assetCategoryWriteFlag) {
                                          setState(() {
                                            assetCategoryMainFlag = true;
                                          });
                                        } else if (!assetCategoryReadFlag &&
                                            !assetCategoryWriteFlag) {
                                          setState(() {
                                            assetCategoryMainFlag = false;
                                          });
                                        } else if (value ||
                                            assetCategoryWriteFlag) {
                                          setState(() {
                                            assetCategoryMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            assetCategoryMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'View'),
                                  getCheckBoxListTile(
                                      tristate: false,
                                      value: assetCategoryWriteFlag,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        assetCategoryWriteFlag = value!;
                                        if (assetCategoryReadFlag &&
                                            assetCategoryWriteFlag) {
                                          setState(() {
                                            assetCategoryMainFlag = true;
                                          });
                                        } else if (!assetCategoryReadFlag &&
                                            !assetCategoryWriteFlag) {
                                          setState(() {
                                            assetCategoryMainFlag = false;
                                          });
                                        } else if (value ||
                                            assetCategoryReadFlag) {
                                          setState(() {
                                            assetCategoryMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            assetCategoryMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'View & Modify'),
                                ],
                              ),
                            ),
                          ListTile(
                            leading: IconButton(
                              icon: openRole[11]
                                  ? Image.asset('assets/icon/navigate_down.png')
                                  : const Icon(Icons.navigate_next_rounded),
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  openRole[11] = !openRole[11];
                                });
                              },
                            ),
                            title: getCheckBoxListTile(
                                tristate: true,
                                value: assetSubCategoryMainFlag,
                                onChanged: isDisabled
                                    ? null
                                    :(bool? value) {
                                  assetSubCategoryMainFlag = value;
                                  if (assetSubCategoryMainFlag == null &&
                                      (assetSubCategoryWriteFlag ||
                                          assetSubCategoryReadFlag)) {
                                    setState(() {
                                      assetSubCategoryReadFlag = false;
                                      assetSubCategoryWriteFlag = false;
                                      assetSubCategoryMainFlag = false;
                                    });
                                  } else if (assetSubCategoryMainFlag!) {
                                    setState(() {
                                      assetSubCategoryReadFlag = true;
                                      assetSubCategoryWriteFlag = true;
                                    });
                                  }
                                },
                                title: 'Asset Sub-Categories'),
                          ),
                          if (openRole[11])
                            Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: Column(
                                children: [
                                  getCheckBoxListTile(
                                      tristate: false,
                                      value: assetSubCategoryReadFlag,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        assetSubCategoryReadFlag = value!;
                                        if (assetSubCategoryReadFlag &&
                                            assetSubCategoryWriteFlag) {
                                          setState(() {
                                            assetSubCategoryMainFlag = true;
                                          });
                                        } else if (!assetSubCategoryReadFlag &&
                                            !assetSubCategoryWriteFlag) {
                                          setState(() {
                                            assetSubCategoryMainFlag = false;
                                          });
                                        } else if (value ||
                                            assetSubCategoryWriteFlag) {
                                          setState(() {
                                            assetSubCategoryMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            assetSubCategoryMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'View'),
                                  getCheckBoxListTile(
                                      tristate: false,
                                      value: assetSubCategoryWriteFlag,
                                      onChanged: isDisabled
                                          ? null
                                          :(bool? value) {
                                        assetSubCategoryWriteFlag = value!;
                                        if (assetSubCategoryReadFlag &&
                                            assetSubCategoryWriteFlag) {
                                          setState(() {
                                            assetSubCategoryMainFlag = true;
                                          });
                                        } else if (!assetSubCategoryReadFlag &&
                                            !assetSubCategoryWriteFlag) {
                                          setState(() {
                                            assetSubCategoryMainFlag = false;
                                          });
                                        } else if (value ||
                                            assetSubCategoryReadFlag) {
                                          setState(() {
                                            assetSubCategoryMainFlag = null;
                                          });
                                        } else {
                                          setState(() {
                                            assetSubCategoryMainFlag = false;
                                          });
                                        }
                                      },
                                      title: 'View & Modify'),
                                ],
                              ),
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              getElevatedButton(
                                onPressed: onPressed,
                                text: text,
                              ),
                              const SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      )
                    ],
                  ),
                )),
              ),
            );
          });
        });
  }



  /// It will check the Existing Details of the Roles and Edited or Not
  bool checkRoleDetailsEditedOrNot() {
    AssetProvider assignRoleProvider =
        Provider.of<AssetProvider>(context, listen: false);

    if (selectedIndex >= 0 &&
        selectedIndex < assignRoleProvider.updatedRoleDetailsList.length) {
      AssignRoleDetails assignRoleDetails =
          assignRoleProvider.updatedRoleDetailsList[selectedIndex];

      if (assignRoleDetails.userReadFlag == userReadFlag &&
          assignRoleDetails.userWriteFlag == userWriteFlag &&
          assignRoleDetails.companyReadFlag == companyReadFlag &&
          assignRoleDetails.companyWriteFlag == companyWriteFlag &&
          assignRoleDetails.vendorWriteFlag == vendorWriteFlag &&
          assignRoleDetails.vendorReadFlag == vendorReadFlag &&
          assignRoleDetails.ticketWriteFlag == ticketWriteFlag &&
          assignRoleDetails.ticketReadFlag == ticketReadFlag &&
          assignRoleDetails.assetModelReadFlag == assetModelReadFlag &&
          assignRoleDetails.assetModelWriteFlag == assetModelWriteFlag &&
          assignRoleDetails.assetTemplateReadFlag == assetTemplateReadFlag &&
          assignRoleDetails.assetTemplateWriteFlag == assetTemplateWriteFlag &&
          assignRoleDetails.assetStockWriteFlag == assetStockWriteFlag &&
          assignRoleDetails.assetStockReadFlag == assetStockReadFlag &&
          assignRoleDetails.assignRoleWriteFlag == assignRoleWriteFlag &&
          assignRoleDetails.assignRoleReadFlag == assignRoleReadFlag &&
          assignRoleDetails.locationWriteFlag == locationWriteFlag &&
          assignRoleDetails.locationReadFlag == locationReadFlag &&
          assignRoleDetails.locationMainFlag == locationMainFlag &&
          assignRoleDetails.userMainFlag == userMainFlag &&
          assignRoleDetails.companyMainFlag == companyMainFlag &&
          assignRoleDetails.vendorMainFlag == vendorMainFlag &&
          assignRoleDetails.ticketMainFlag == ticketMainFlag &&
          assignRoleDetails.assetStockMainFlag == assetStockMainFlag &&
          assignRoleDetails.assetModelMainFlag == assetModelMainFlag &&
          assignRoleDetails.assetTemplateMainFlag == assetTemplateMainFlag &&
          assignRoleDetails.assignRoleMainFlag == assignRoleMainFlag &&
          assignRoleDetails.assetTypeMainFlag == assetTypeMainFlag &&
          assignRoleDetails.assetTypeWriteFlag == assetTypeWriteFlag &&
          assignRoleDetails.assetTypeReadFlag == assetTypeReadFlag &&
          assignRoleDetails.assetCategoryMainFlag == assetCategoryMainFlag &&
          assignRoleDetails.assetCategoryWriteFlag == assetCategoryWriteFlag &&
          assignRoleDetails.assetCategoryReadFlag == assetCategoryReadFlag &&
          assignRoleDetails.assetSubCategoryMainFlag ==
              assetSubCategoryMainFlag &&
          assignRoleDetails.assetSubCategoryReadFlag ==
              assetSubCategoryReadFlag &&
          assignRoleDetails.assetSubCategoryWriteFlag ==
              assetSubCategoryWriteFlag) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  _onTapEditButton(int index) {
    final result = checkRoleDetailsEditedOrNot();

    AssetProvider assignRoleProvider =
        Provider.of<AssetProvider>(context, listen: false);

    if (result) {
      /// User Updated the Company Details and use to change in the DB
      AssignRoleDetails assign = AssignRoleDetails(
          roleTitle: assignRoleProvider
              .updatedRoleDetailsList[selectedIndex].roleTitle,
          userReadFlag: userReadFlag,
          userWriteFlag: userWriteFlag,
          companyReadFlag: companyReadFlag,
          companyWriteFlag: companyWriteFlag,
          vendorReadFlag: vendorReadFlag,
          vendorWriteFlag: vendorWriteFlag,
          ticketReadFlag: ticketReadFlag,
          ticketWriteFlag: ticketWriteFlag,
          assetStockReadFlag: assetStockReadFlag,
          assetStockWriteFlag: assetStockWriteFlag,
          assetModelReadFlag: assetModelReadFlag,
          assetModelWriteFlag: assetModelWriteFlag,
          assetTemplateReadFlag: assetTemplateReadFlag,
          assetTemplateWriteFlag: assetTemplateWriteFlag,
          assignRoleReadFlag: assignRoleReadFlag,
          assignRoleWriteFlag: assignRoleWriteFlag,
          locationReadFlag: locationReadFlag,
          locationWriteFlag: locationWriteFlag,
          locationMainFlag: locationMainFlag ?? false,
          userMainFlag: userMainFlag ?? false,
          companyMainFlag: companyMainFlag ?? false,
          vendorMainFlag: vendorMainFlag ?? false,
          ticketMainFlag: ticketMainFlag ?? false,
          assetTemplateMainFlag: assetTemplateMainFlag ?? false,
          assetModelMainFlag: assetModelMainFlag ?? false,
          assetStockMainFlag: assetStockMainFlag ?? false,
          assignRoleMainFlag: assignRoleMainFlag ?? false,
          assetTypeMainFlag: assetTypeMainFlag ?? false,
          assetTypeReadFlag: assetTypeReadFlag,
          assetTypeWriteFlag: assetTypeWriteFlag,
          assetCategoryMainFlag: assetCategoryMainFlag ?? false,
          assetCategoryReadFlag: assetCategoryReadFlag,
          assetCategoryWriteFlag: assetCategoryWriteFlag,
          assetSubCategoryMainFlag: assetSubCategoryMainFlag ?? false,
          assetSubCategoryReadFlag: assetSubCategoryReadFlag,
          assetSubCategoryWriteFlag: assetSubCategoryWriteFlag,
          sId: roleId);
      updateRole(assign);
      assignRoleProvider.fetchRoleDetails();
      Navigator.of(context).pop();
    } else {
      /// User not changed anything...
    }
  }

  Future<void> assignRoles(AssignRoleDetails assign) async {
    var headers = await getHeadersForJSON();
    try {
      var request = http.Request('POST', Uri.parse('$websiteURL/user/role'));

      request.body = json.encode(assign.toJson());
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        log(await response.stream.bytesToString());
      } else {
        log(response.reasonPhrase.toString());
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  Future<void> updateRole(AssignRoleDetails assign) async {
    var headers = await getHeadersForJSON();
    try {
      var request =
          http.Request('POST', Uri.parse('$websiteURL/user/updateRole'));

      request.body = json.encode(assign.toJson());

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        log(await response.stream.bytesToString());
      } else {
        log(response.reasonPhrase.toString());
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  Future<void> deleteRole(String roleId, BoolProvider boolProviders,
      AssetProvider assignRoleProvider) async {
    await DeleteDetailsManager(
      apiURL: 'user/deleteRole',
      id: roleId,
    ).deleteDetails(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("Role Deleted Successfully");
        assignRoleProvider.fetchRoleDetails();
      });
    } else {
      setState(() {
        showToast("Unable to delete the role");
      });
    }
  }

  Widget getRoleDropDownContentUI() {
    AssetProvider assignRoleProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    List<String> dropdownItems = ["All"];
    dropdownItems.addAll(assignRoleProvider.fetchedRoleDetailsList
        .map((role) => role.roleTitle!)
        .toSet());
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        elevation: 1,
        iconDisabledColor: Colors.blue,
        iconEnabledColor: Colors.blue,
        dropdownColor: themeProvider.isDarkTheme
            ? const Color.fromRGBO(16, 18, 33, 1)
            : const Color(0xfff3f1ef),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        value: dropDownValueRole,
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
                )),
              ),
            ),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            dropDownValueRole = value!;
            currentPage = 0;
          });
        },
      ),
    );
  }

  /// Page Drop Down
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
        onChanged: (value) async {
          setState(() {
            listPerPage = value!;
            currentPage = 0;
          });
        },
      ),
    );
  }

  /// Add Roles in Dialog Box
  Future<void> addRoles(BuildContext context) async {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Listener(
              onPointerHover: (event) {
                UserInteractionTimer.resetTimer(context);
              },
              onPointerDown: (event) {
                UserInteractionTimer.resetTimer(context);
              },
              child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                            color: themeProvider.isDarkTheme
                                ? const Color.fromRGBO(16, 18, 33, 1)
                                : const Color(0xfff3f1ef),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15))),
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Wrap(
                          children: [
                            Column(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      "ADD ROLES",
                                      style: GoogleFonts.ubuntu(
                                          textStyle: TextStyle(
                                              fontSize: 15,
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: TextFormField(
                                      controller: roleController,
                                      validator: commonValidator,
                                      style: GoogleFonts.ubuntu(
                                          textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: themeProvider.isDarkTheme
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.black
                                                  : Colors.white),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.black
                                                  : Colors.white),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        filled: true,
                                        fillColor: themeProvider.isDarkTheme
                                            ? Colors.black
                                            : Colors.white,
                                        hintText: "Role",
                                        hintStyle: GlobalHelper.textStyle(
                                          TextStyle(
                                            color: themeProvider.isDarkTheme
                                                ? Colors.white
                                                : const Color.fromRGBO(
                                                    117, 117, 117, 1),
                                            fontSize: 15,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.all(15),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      getElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            Navigator.of(context).pop();
                                            roleController.clear();
                                          });
                                        },
                                        text: "Cancel",
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      getElevatedButton(
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            userMainFlag = false;
                                            companyMainFlag = false;
                                            vendorMainFlag = false;
                                            ticketMainFlag = false;
                                            assetTemplateMainFlag = false;
                                            assetStockMainFlag = false;
                                            assetTemplateMainFlag = false;
                                            assignRoleMainFlag = false;
                                            locationMainFlag = false;
                                            assetTypeMainFlag = false;
                                            assetCategoryMainFlag = false;
                                            assetSubCategoryMainFlag = false;

                                            configurableRoles(context,
                                                text: "Add", onPressed: () {
                                              AssetProvider assignRoleProvider =
                                                  Provider.of<AssetProvider>(
                                                      context,
                                                      listen: false);

                                              setState(() {
                                                String newRole =
                                                    roleController.text.trim();
                                                if (newRole.isNotEmpty) {
                                                  addRole(newRole);
                                                  AssignRoleDetails assign = AssignRoleDetails(
                                                      roleTitle: newRole,
                                                      userReadFlag:
                                                          userReadFlag,
                                                      userWriteFlag:
                                                          userWriteFlag,
                                                      companyReadFlag:
                                                          companyReadFlag,
                                                      companyWriteFlag:
                                                          companyWriteFlag,
                                                      vendorReadFlag:
                                                          vendorReadFlag,
                                                      vendorWriteFlag:
                                                          vendorWriteFlag,
                                                      ticketReadFlag:
                                                          ticketReadFlag,
                                                      ticketWriteFlag:
                                                          ticketWriteFlag,
                                                      assetStockReadFlag:
                                                          assetStockReadFlag,
                                                      assetStockWriteFlag:
                                                          assetStockWriteFlag,
                                                      assetModelReadFlag:
                                                          assetModelReadFlag,
                                                      assetModelWriteFlag:
                                                          assetModelWriteFlag,
                                                      assetTemplateReadFlag:
                                                          assetTemplateReadFlag,
                                                      assetTemplateWriteFlag:
                                                          assetTemplateWriteFlag,
                                                      assignRoleReadFlag:
                                                          assignRoleReadFlag,
                                                      assignRoleWriteFlag:
                                                          assignRoleWriteFlag,
                                                      locationReadFlag:
                                                          locationReadFlag,
                                                      locationWriteFlag:
                                                          locationWriteFlag,
                                                      locationMainFlag:
                                                          locationMainFlag ??
                                                              false,
                                                      userMainFlag:
                                                          userMainFlag ?? false,
                                                      companyMainFlag:
                                                          companyMainFlag ??
                                                              false,
                                                      vendorMainFlag: vendorMainFlag ??
                                                          false,
                                                      ticketMainFlag: ticketMainFlag ??
                                                          false,
                                                      assetTemplateMainFlag:
                                                          assetTemplateMainFlag ??
                                                              false,
                                                      assetModelMainFlag:
                                                          assetModelMainFlag ??
                                                              false,
                                                      assetStockMainFlag:
                                                          assetStockMainFlag ??
                                                              false,
                                                      assignRoleMainFlag:
                                                          assignRoleMainFlag ??
                                                              false,
                                                      assetTypeMainFlag:
                                                          assetTypeMainFlag ??
                                                              false,
                                                      assetTypeReadFlag:
                                                          assetTypeReadFlag,
                                                      assetTypeWriteFlag:
                                                          assetTypeWriteFlag,
                                                      assetCategoryMainFlag:
                                                          assetCategoryMainFlag ??
                                                              false,
                                                      assetCategoryReadFlag:
                                                          assetCategoryReadFlag,
                                                      assetCategoryWriteFlag:
                                                          assetCategoryWriteFlag,
                                                      assetSubCategoryMainFlag:
                                                          assetSubCategoryMainFlag ??
                                                              false,
                                                      assetSubCategoryReadFlag:
                                                          assetSubCategoryReadFlag,
                                                      assetSubCategoryWriteFlag: assetSubCategoryWriteFlag);
                                                  assignRoles(assign);
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context)
                                                      .popUntil((route) =>
                                                          route.isFirst);
                                                  assignRoleProvider
                                                      .fetchRoleDetails();
                                                }
                                              });
                                            }, isDisabled: false);
                                          } else {
                                            return;
                                          }
                                        },
                                        text: "Add",
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
            );
          });
        });
  }

  Widget getCheckBoxListTile({
    required value,
    required onChanged,
    required String title,
    required bool tristate,
  }) {
    return Consumer<BoolProvider>(builder: (context, themeProvider, child) {
      return CheckboxListTile(
        value: value,
        onChanged: onChanged,
        tristate: tristate,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          title,
          style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
            fontSize: 15,
            color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          )),
        ),
        side: BorderSide(
          color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
        ),
      );
    });
  }

  /// Add Roles in Table
  void addRole(String role) {
    setState(() {
      roles.add(role);
      roleController.clear();
    });
  }
}
