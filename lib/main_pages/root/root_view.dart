import 'dart:async';
import 'package:asset_management_local/global/user_interaction_timer.dart';
import 'package:asset_management_local/main_pages/asset/asset_model/model_list_page.dart';
import 'package:asset_management_local/main_pages/asset/asset_stock/stock_list_page.dart';
import 'package:asset_management_local/main_pages/asset/category/category_list_page.dart';
import 'package:asset_management_local/main_pages/asset/sub_category/sub_category_details.dart';
import 'package:asset_management_local/main_pages/asset/type/type_list_page.dart';
import 'package:asset_management_local/main_pages/login_screen/login_screen.dart';
import 'package:asset_management_local/main_pages/ticket/ticket_list_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';
import '../../global/global_variables.dart';
import '../../helpers/csv_file_handler.dart';
import '../../helpers/global_helper.dart';
import '../../models/user_management_model/user_model/user_details.dart';
import '../../provider/main_providers/asset_provider.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';
import '../asset/asset_template/template_list_page.dart';
import '../dashboard/home_page.dart';
import '../directory/company/company_list_page.dart';
import '../directory/location/location_list_page.dart';
import '../directory/vendor/vendor_list_page.dart';
import '../help_section/bot.dart';
import '../help_section/help_section.dart';
import '../user_management/Role/assign_role.dart';
import '../user_management/user/user_list_expanded_view.dart';
import '../user_management/user/user_list_page.dart';

class AssetManagement extends StatefulWidget {
  const AssetManagement({Key? key}) : super(key: key);

  @override
  State<AssetManagement> createState() => _AssetManagementState();
}

class _AssetManagementState extends State<AssetManagement> {
  final controller = SidebarXController(selectedIndex: 0, extended: true);

  final key = GlobalKey<ScaffoldState>();

  Widget selectedDirectoryPage = const CompanyList();
  Widget selectedUserPage = const UserListPage();
  Widget selectedAssetPage = const StockList();
  Widget selectedTicketPage = const TicketList();
  Widget selectedHomePage = const HomePage();

  int currentPageIndex = 0;

  bool isApiCallInProgress = false;

  List<Map<String, dynamic>> searchedData = [];

  @override
  void initState() {
    super.initState();
    UserInteractionTimer.startTimer(context);
    setDefaultAssetPage();
    setDefaultUserPage();
    setDefaultDirectoryPage();
  }

  @override
  void dispose() {
    UserInteractionTimer.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Builder(builder: (context) {
        final isSmallScreen = MediaQuery.of(context).size.width < 600;
        return Consumer<BoolProvider>(builder: (context, themeProvider, child) {
          return Scaffold(
            backgroundColor:
                themeProvider.isDarkTheme ? Colors.black : Colors.white,
            key: key,
            appBar: isSmallScreen
                ? AppBar(
                    title: const Text('Asset Management'),
                    leading: IconButton(
                      onPressed: () {
                        key.currentState?.openDrawer();
                      },
                      icon: const Icon(Icons.menu),
                    ),
                  )
                : null,
            drawer: Listener(
                onPointerHover: (event) {
                  UserInteractionTimer.resetTimer(context);
                },
                onPointerDown: (event) {
                  UserInteractionTimer.resetTimer(context);
                },
                child: SideMenu(
                  controller: controller,
                  onPageChanged: (pageIndex) {
                    setState(() {
                      currentPageIndex = pageIndex;
                    });
                  },
                )),
            body: Row(
              children: [
                if (!isSmallScreen)
                  SideMenu(
                    controller: controller,
                    onPageChanged: (pageIndex) {
                      setState(() {
                        currentPageIndex = pageIndex;
                      });
                    },
                  ),
                Expanded(
                    child: Center(
                  child: AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        return getCurrentPage();
                      }),
                ))
              ],
            ),
          );
        });
      }),
    );
  }

  Widget getCurrentPage() {
    final roleProvider = Provider.of<AssetProvider>(context, listen: false);
    final userRole = roleProvider.userRole;

    final assetAccess = userRole.assetStockWriteFlag ||
        userRole.assetModelWriteFlag ||
        userRole.assetTemplateWriteFlag ||
        userRole.assetSubCategoryWriteFlag ||
        userRole.assetCategoryWriteFlag ||
        userRole.assetTypeWriteFlag ||
        userRole.assetStockReadFlag ||
        userRole.assetModelReadFlag ||
        userRole.assetTemplateReadFlag ||
        userRole.assetSubCategoryReadFlag ||
        userRole.assetCategoryReadFlag ||
        userRole.assetTypeReadFlag;

    final userManagementAccess = userRole.userWriteFlag ||
        userRole.assignRoleWriteFlag ||
        userRole.userReadFlag ||
        userRole.assignRoleReadFlag;

    final directoryAccess = userRole.companyWriteFlag ||
        userRole.vendorWriteFlag ||
        userRole.locationWriteFlag ||
        userRole.companyReadFlag ||
        userRole.vendorReadFlag ||
        userRole.locationReadFlag;

    switch (currentPageIndex) {
      case 0:
        key.currentState?.closeDrawer();
        return Consumer<BoolProvider>(builder: (context, boolProvider, child) {
          return Listener(
            onPointerHover: (event) {
              UserInteractionTimer.resetTimer(context);
            },
            onPointerDown: (event) {
              UserInteractionTimer.resetTimer(context);
            },
            child: Stack(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        color: boolProvider.isDarkTheme
                            ? const Color.fromRGBO(16, 18, 33, 1)
                            : const Color(0xfff3f1ef),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    child: SingleChildScrollView(
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 50),
                                    child: Text(
                                      "All Locations",
                                      style: GoogleFonts.ubuntu(
                                          textStyle: TextStyle(
                                        fontSize: 25,
                                        color: boolProvider.isDarkTheme
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      )),
                                    ),
                                  ),
                                  searchButton()
                                ]),
                          ),
                          selectedHomePage,
                        ],
                      ),
                    )),
              ],
            ),
          );
        });
      case 1:
        key.currentState?.closeDrawer();
        return Consumer<BoolProvider>(builder: (context, boolProvider, child) {
          return Listener(
            onPointerHover: (event) {
              UserInteractionTimer.resetTimer(context);
            },
            onPointerDown: (event) {
              UserInteractionTimer.resetTimer(context);
            },
            child: Stack(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        color: boolProvider.isDarkTheme
                            ? const Color.fromRGBO(16, 18, 33, 1)
                            : const Color(0xfff3f1ef),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    child: SingleChildScrollView(
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Assets",
                                      style: GoogleFonts.ubuntu(
                                          textStyle: TextStyle(
                                        fontSize: 25,
                                        color: boolProvider.isDarkTheme
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      )),
                                    ),
                                  ),
                                  searchButton()
                                ]),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: buildAssetPageOptions()),
                          selectedAssetPage,
                        ],
                      ),
                    )),
                if (assetAccess && directoryAccess && userManagementAccess)
                  _shouldShowDownloadButton(
                          selectedAssetPage, boolProvider, StockList)
                      ? downloadButton(onPressed: () {
                          generateCsvReportAsset();
                        })
                      : const SizedBox(),
                if (assetAccess && directoryAccess && userManagementAccess)
                  deleteButton(
                    boolProvider.deleteVisible,
                    onPressed: () {
                      boolProvider.setDialogVisibility(true);
                    },
                  )
              ],
            ),
          );
        });
      case 2:
        key.currentState?.closeDrawer();
        return Consumer<BoolProvider>(builder: (context, boolProvider, child) {
          return Stack(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: boolProvider.isDarkTheme
                          ? const Color.fromRGBO(16, 18, 33, 1)
                          : const Color(0xfff3f1ef),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15))),
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "User Management",
                                    style: GoogleFonts.ubuntu(
                                        textStyle: TextStyle(
                                      fontSize: 25,
                                      color: boolProvider.isDarkTheme
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )),
                                  ),
                                ),
                                searchButton()
                              ]),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: buildUserPageOptions()),
                        selectedUserPage,
                      ],
                    ),
                  )),
              if (userRole.userWriteFlag) ...[
                _shouldShowDownloadButton(
                        selectedUserPage, boolProvider, UserListPage)
                    ? downloadButton(onPressed: () {
                        generateCsvUserReport();
                      })
                    : const SizedBox(),
              ],
              deleteButton(
                boolProvider.deleteVisible,
                onPressed: () {
                  boolProvider.setDialogVisibility(true);
                },
              )
            ],
          );
        });
      case 3:
        key.currentState?.closeDrawer();
        return Consumer<BoolProvider>(builder: (context, boolProvider, child) {
          return Stack(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: boolProvider.isDarkTheme
                          ? const Color.fromRGBO(16, 18, 33, 1)
                          : const Color(0xfff3f1ef),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15))),
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Tickets",
                                    style: GoogleFonts.ubuntu(
                                        textStyle: TextStyle(
                                      fontSize: 25,
                                      color: boolProvider.isDarkTheme
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )),
                                  ),
                                ),
                                searchButton()
                              ]),
                        ),
                        selectedTicketPage,
                      ],
                    ),
                  )),
            ],
          );
        });
      case 4:
        key.currentState?.closeDrawer();
        return Consumer<BoolProvider>(builder: (context, boolProvider, child) {
          return Stack(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: boolProvider.isDarkTheme
                          ? const Color.fromRGBO(16, 18, 33, 1)
                          : const Color(0xfff3f1ef),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15))),
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Directory",
                                    style: GoogleFonts.ubuntu(
                                        textStyle: TextStyle(
                                      fontSize: 25,
                                      color: boolProvider.isDarkTheme
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )),
                                  ),
                                ),
                                searchButton()
                              ]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: buildDirectoryPageOptions(),
                        ),
                        selectedDirectoryPage,
                      ],
                    ),
                  )),
              deleteButton(
                boolProvider.deleteVisible,
                onPressed: () {
                  boolProvider.setDialogVisibility(true);
                },
              )
            ],
          );
        });
      case 5:
        key.currentState?.closeDrawer();
        return Consumer<BoolProvider>(builder: (context, boolProvider, child) {
          return Scaffold(
            backgroundColor:
                boolProvider.isDarkTheme ? Colors.black : Colors.white,
            body: Container(
                decoration: BoxDecoration(
                    color: boolProvider.isDarkTheme
                        ? const Color.fromRGBO(16, 18, 33, 1)
                        : const Color(0xfff3f1ef),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15))),
                child: const HelpSection()),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                    barrierColor: Colors.transparent,
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return const Dialog(
                        backgroundColor: Colors.transparent,
                        surfaceTintColor: Colors.transparent,
                        child: BotHelper(),
                      );
                    });
              },
              backgroundColor: const Color.fromRGBO(15, 117, 188, 1),
              elevation: 10,
              autofocus: true,
              child: Icon(
                Icons.chat,
                color: boolProvider.isDarkTheme ? Colors.white : Colors.black,
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        });
      default:
        return const Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15))),
            child: Center(child: Text("ITAM")));
    }
  }

  List<Widget> buildAssetPageOptions() {
    final roleProvider = Provider.of<AssetProvider>(context, listen: false);
    final userRole = roleProvider.userRole;

    List<Widget> assetButtons = [];

    if (userRole.assetStockReadFlag && !userRole.assetStockWriteFlag) {
      assetButtons.add(buildAssetButton("My Assets", const StockList()));
    }

    if (userRole.assetStockWriteFlag) {
      assetButtons.add(buildAssetButton("Stock", const StockList()));
    }

    if (userRole.assetModelReadFlag || userRole.assetModelWriteFlag) {
      assetButtons.add(buildAssetButton("Model", const ModelList()));
    }

    if (userRole.assetTemplateReadFlag || userRole.assetTemplateWriteFlag) {
      assetButtons.add(buildAssetButton("Template", const TemplateList()));
    }

    if (userRole.assetSubCategoryReadFlag ||
        userRole.assetSubCategoryWriteFlag) {
      assetButtons
          .add(buildAssetButton("Sub-Category", const SubCategoryList()));
    }

    if (userRole.assetCategoryReadFlag || userRole.assetCategoryWriteFlag) {
      assetButtons.add(buildAssetButton("Category", const CategoryList()));
    }

    if (userRole.assetTypeReadFlag || userRole.assetTypeWriteFlag) {
      assetButtons.add(buildAssetButton("Type", const TypeList()));
    }

    return assetButtons;
  }

  void setDefaultAssetPage() {
    final roleProvider = Provider.of<AssetProvider>(context, listen: false);
    final userRole = roleProvider.userRole;

    if (userRole.assetStockWriteFlag) {
      selectedAssetPage = const StockList();
    } else if (userRole.assetStockReadFlag) {
      selectedAssetPage = const StockList();
    } else if (userRole.assetModelReadFlag || userRole.assetModelWriteFlag) {
      selectedAssetPage = const ModelList();
    } else if (userRole.assetTemplateReadFlag ||
        userRole.assetTemplateWriteFlag) {
      selectedAssetPage = const TemplateList();
    } else if (userRole.assetSubCategoryReadFlag ||
        userRole.assetSubCategoryWriteFlag) {
      selectedAssetPage = const SubCategoryList();
    } else if (userRole.assetCategoryReadFlag ||
        userRole.assetCategoryWriteFlag) {
      selectedAssetPage = const CategoryList();
    } else if (userRole.assetTypeReadFlag || userRole.assetTypeWriteFlag) {
      selectedAssetPage = const TypeList();
    } else {
      selectedAssetPage = const Center(
        child: Text("No Access to Asset Pages"),
      );
    }
  }

  List<Widget> buildUserPageOptions() {
    final roleProvider = Provider.of<AssetProvider>(context, listen: false);
    final userRole = roleProvider.userRole;

    List<Widget> userButtons = [];

    if (userRole.userReadFlag || userRole.userWriteFlag) {
      userButtons.add(buildUserButton("User", const UserListPage()));
    }

    if (userRole.assignRoleWriteFlag || userRole.assignRoleReadFlag) {
      userButtons.add(buildUserButton("Roles", const AssignRole()));
    }

    return userButtons;
  }

  void setDefaultUserPage() {
    final roleProvider = Provider.of<AssetProvider>(context, listen: false);
    final userRole = roleProvider.userRole;

    if (userRole.userReadFlag || userRole.userWriteFlag) {
      selectedUserPage = const UserListPage();
    } else if (userRole.assignRoleReadFlag || userRole.assignRoleWriteFlag) {
      selectedUserPage = const AssignRole();
    } else {
      selectedUserPage = const Center(
        child: Text("No Access to User Pages"),
      );
    }
  }

  List<Widget> buildDirectoryPageOptions() {
    final roleProvider = Provider.of<AssetProvider>(context, listen: false);
    final userRole = roleProvider.userRole;

    List<Widget> directoryButtons = [];

    if (userRole.companyReadFlag || userRole.companyWriteFlag) {
      directoryButtons
          .add(buildDirectoryButton("Company", const CompanyList()));
    }

    if (userRole.vendorReadFlag || userRole.vendorWriteFlag) {
      directoryButtons.add(buildDirectoryButton("Vendor", const VendorList()));
    }

    if (userRole.locationReadFlag || userRole.locationWriteFlag) {
      directoryButtons
          .add(buildDirectoryButton("Location", const LocationList()));
    }

    return directoryButtons;
  }

  void setDefaultDirectoryPage() {
    final roleProvider = Provider.of<AssetProvider>(context, listen: false);
    final userRole = roleProvider.userRole;

    if (userRole.companyReadFlag || userRole.companyWriteFlag) {
      selectedDirectoryPage = const CompanyList();
    } else if (userRole.vendorReadFlag || userRole.vendorWriteFlag) {
      selectedDirectoryPage = const VendorList();
    } else if (userRole.locationReadFlag || userRole.locationWriteFlag) {
      selectedDirectoryPage = const LocationList();
    } else {
      selectedDirectoryPage =
          const Center(child: Text("No Access to Directory Pages"));
    }
  }

  bool _shouldShowDownloadButton(
      Widget selectedPage, BoolProvider boolProvider, page) {
    return selectedPage.runtimeType == page && !boolProvider.deleteVisible;
  }

  Widget searchButton() {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 1.98,
          height: MediaQuery.of(context).size.width * 0.031,
          decoration: const BoxDecoration(
              color: Color.fromRGBO(189, 189, 189, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22),
                  bottomLeft: Radius.circular(22))),
          child: const Padding(
            padding: EdgeInsets.fromLTRB(18.0, 0, 2, 5),
            child: TextField(
              decoration: InputDecoration(
                  hintText: " Search",
                  hintStyle: TextStyle(color: Colors.black45),
                  border: InputBorder.none),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 25),
          child: Container(
            width: MediaQuery.of(context).size.width / 18,
            height: MediaQuery.of(context).size.width * 0.031,
            decoration: const BoxDecoration(
                color: Color.fromRGBO(117, 117, 117, 1),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            child: IconButton(
              icon: Icon(Icons.search,
                  size: MediaQuery.of(context).size.height * 0.03),
              color: Colors.white,
              onPressed: () {},
            ),
          ),
        )
      ],
    );
  }

  Widget buildDirectoryButton(String label, Widget page) {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextButton(
        onPressed: () {
          setState(() {
            selectedDirectoryPage = page;
          });
        },
        child: Text(
          label,
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
              fontSize: 20,
              color: selectedDirectoryPage == page
                  ? Colors.blue
                  : themeProvider.isDarkTheme
                      ? Colors.white
                      : Colors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUserButton(String label, Widget page) {
    return Consumer<BoolProvider>(builder: (context, themeProvider, child) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: TextButton(
          onPressed: () {
            setState(() {
              selectedUserPage = page;
            });
          },
          child: Text(
            label,
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 20,
                color: selectedUserPage == page
                    ? Colors.blue
                    : themeProvider.isDarkTheme
                        ? Colors.white
                        : Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget buildAssetButton(String label, Widget page) {
    return Consumer<BoolProvider>(builder: (context, themeProvider, child) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: TextButton(
          onPressed: () {
            setState(() {
              selectedAssetPage = page;
            });
          },
          child: Text(
            label,
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 20,
                color: selectedAssetPage == page
                    ? Colors.blue
                    : themeProvider.isDarkTheme
                        ? Colors.white
                        : Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget buildTicketButton(String label, Widget page) {
    return Consumer<BoolProvider>(builder: (context, themeProvider, child) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: TextButton(
          onPressed: () {
            setState(() {
              selectedTicketPage = page;
            });
          },
          child: Text(
            label,
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 20,
                color: selectedTicketPage == page
                    ? Colors.blue
                    : themeProvider.isDarkTheme
                        ? Colors.white
                        : Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget deleteButton(bool visible, {required onPressed}) {
    return Visibility(
      visible: visible,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton.extended(
            onPressed: onPressed,
            label: Text(
              "Delete",
              style: GoogleFonts.ubuntu(
                  textStyle: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              )),
            ),
            icon: const Icon(Icons.delete_rounded, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget downloadButton({required onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton.extended(
          onPressed: onPressed,
          label: Text(
            "Download",
            style: GoogleFonts.ubuntu(
                textStyle: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            )),
          ),
          icon: const Icon(Icons.download_rounded, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> generateCsvUserReport() async {
    AssetProvider userProvider =
        Provider.of<AssetProvider>(context, listen: false);

    List<Map<String, dynamic>> userList = userProvider.userDetailsList
        .map((assetStockDetails) => assetStockDetails.toJson())
        .toList();

    List<List<dynamic>> rows = [];

    var keys = userList.first.keys
        .where((key) =>
            key != '_id' &&
            key != '__v' &&
            key != 'image' &&
            key != 'password' &&
            key != 'assetStockRefId' &&
            key != 'reportManagerRefId' &&
            key != 'tag' &&
            key != 'companyRefId' &&
            key != "assignRoleRefIds")
        .toList();
    rows.add(['Serial Number', ...keys]);

    for (int i = 0; i < userList.length; i++) {
      List<dynamic> dataRow = [i + 1];
      for (var key in keys) {
        if (key != '_id' &&
            key != '__v' &&
            key != 'image' &&
            key != 'password' &&
            key != 'assetStockRefId' &&
            key != 'reportManagerRefId' &&
            key != 'tag' &&
            key != 'companyRefId' &&
            key != "assignRoleRefIds") {
          dataRow.add(userList[i][key]);
        }
      }
      rows.add(dataRow);
    }
    await CsvFileHandler.convertToCSV(rows, "user");
  }

  void generateCsvReportAsset() async {
    AssetProvider stockProvider =
        Provider.of<AssetProvider>(context, listen: false);

    List<Map<String, dynamic>> stockList = (filteredStockList.isEmpty
            ? stockProvider.stockDetailsList
            : filteredStockList)
        .map((assetStockDetails) => assetStockDetails.toJson())
        .toList();

    List<List<dynamic>> rows = [];

    var keys = stockList.first.keys
        .where((key) =>
            key != '_id' &&
            key != '__v' &&
            key != 'image' &&
            key != 'tag' &&
            key != 'parameters' &&
            key != 'checkListDetails' &&
            key != 'warrantyDetails' &&
            key != 'specifications' &&
            key != 'ticketName' &&
            key != 'assetRefId' &&
            key != "vendorRefId" &&
            key != "ticketRefId" &&
            key != "locationRefId" &&
            key != "userRefId" &&
            key != "specRefId" &&
            key != "warrantyRefIds")
        .toList();
    rows.add(['Serial Number', ...keys]);

    for (int i = 0; i < stockList.length; i++) {
      List<dynamic> dataRow = [i + 1];
      for (var key in keys) {
        if (key != '_id' &&
            key != '__v' &&
            key != 'image' &&
            key != 'tag' &&
            key != 'parameters' &&
            key != 'checkListDetails' &&
            key != 'warrantyDetails' &&
            key != 'specifications' &&
            key != 'ticketName' &&
            key != 'assetRefId' &&
            key != "vendorRefId" &&
            key != "ticketRefId" &&
            key != "locationRefId" &&
            key != "userRefId" &&
            key != "specRefId" &&
            key != "warrantyRefIds") {
          dataRow.add(stockList[i][key]);
        }
      }
      rows.add(dataRow);
    }
    await CsvFileHandler.convertToCSV(rows, "asset");
  }
}

class SideMenu extends StatefulWidget {
  final SidebarXController controller;
  final Function(int) onPageChanged;

  const SideMenu({
    Key? key,
    required this.controller,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late int initialPageIndex;

  @override
  void initState() {
    super.initState();
    initialPageIndex = getInitialPageIndex(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onPageChanged(initialPageIndex);
    });
  }

  String getInitials(String userFullName) {
    List<String> nameParts = userFullName.split(" ");
    String firstNameInitial = firstOrNull(nameParts)?.isNotEmpty == true
        ? nameParts.first[0].toUpperCase()
        : "";
    String lastNameInitial = lastOrNull(nameParts)?.isNotEmpty == true
        ? nameParts.last[0].toUpperCase()
        : "";
    return firstNameInitial + lastNameInitial;
  }

  int getInitialPageIndex(BuildContext context) {
    final roleProvider = Provider.of<AssetProvider>(context, listen: false);
    final userRole = roleProvider.userRole;

    final assetAccess = userRole.assetStockWriteFlag ||
        userRole.assetModelWriteFlag ||
        userRole.assetTemplateWriteFlag ||
        userRole.assetSubCategoryWriteFlag ||
        userRole.assetCategoryWriteFlag ||
        userRole.assetTypeWriteFlag ||
        userRole.assetStockReadFlag ||
        userRole.assetModelReadFlag ||
        userRole.assetTemplateReadFlag ||
        userRole.assetSubCategoryReadFlag ||
        userRole.assetCategoryReadFlag ||
        userRole.assetTypeReadFlag;

    final userManagementAccess = userRole.userWriteFlag ||
        userRole.assignRoleWriteFlag ||
        userRole.userReadFlag ||
        userRole.assignRoleReadFlag;

    final directoryAccess = userRole.companyWriteFlag ||
        userRole.vendorWriteFlag ||
        userRole.locationWriteFlag ||
        userRole.companyReadFlag ||
        userRole.vendorReadFlag ||
        userRole.locationReadFlag;

    if (assetAccess && userManagementAccess && directoryAccess) {
      return 0;
    } else if (assetAccess) {
      return 1;
    } else if (userManagementAccess) {
      return 2;
    } else if (directoryAccess) {
      return 4;
    }
    return 5;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BoolProvider>(builder: (context, themeProvider, child) {
      return SidebarX(
          controller: widget.controller,
          showToggleButton: true,
          theme: SidebarXTheme(
            decoration: BoxDecoration(
              color: themeProvider.isDarkTheme ? Colors.black : Colors.white,
            ),
            iconTheme: const IconThemeData(
              color: Color(0xff006eb9),
            ),
            selectedTextStyle: GoogleFonts.ubuntu(
                textStyle: TextStyle(
              fontSize: 15,
              color: themeProvider.isDarkTheme
                  ? const Color.fromRGBO(200, 200, 200, 1)
                  : const Color.fromRGBO(117, 117, 117, 1),
              fontWeight: FontWeight.bold,
            )),
            selectedItemDecoration: BoxDecoration(
                color: themeProvider.isDarkTheme
                    ? const Color.fromRGBO(16, 18, 33, 1)
                    : const Color(0xfff3f1ef),
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            itemTextPadding: const EdgeInsets.only(left: 15),
            selectedItemTextPadding: const EdgeInsets.only(left: 15),
            textStyle: GoogleFonts.ubuntu(
                textStyle: TextStyle(
              fontSize: 15,
              color: themeProvider.isDarkTheme
                  ? const Color.fromRGBO(200, 200, 200, 1)
                  : const Color.fromRGBO(117, 117, 117, 1),
              fontWeight: FontWeight.bold,
            )),
          ),
          extendedTheme: const SidebarXTheme(width: 250),
          items: getSideBarContents(context),
          headerBuilder: (context, extended) {
            return Consumer2<BoolProvider, AssetProvider>(
                builder: (context, themeProvider, user, child) {
              return Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "ITAM",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GlobalHelper.textStyle(TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.isDarkTheme
                            ? Colors.white
                            : Colors.black)),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  GestureDetector(
                    onTap: () {
                      user.fetchOwnUserDetails(
                        userId: user.user!.sId.toString(),
                      );

                      Future.delayed(const Duration(seconds: 1), () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return UserListExpandedView(
                                user: UserDetails(
                                    image: user.user!.image.toString(),
                                    name: user.ownUserDetailsList
                                        .map((e) => e.name.toString())
                                        .join(', '),
                                    employeeId: user.ownUserDetailsList
                                        .map((e) => e.employeeId.toString())
                                        .join(', '),
                                    designation: user.ownUserDetailsList
                                        .map((e) => e.designation.toString())
                                        .join(', '),
                                    dateOfJoining: user.ownUserDetailsList
                                        .map((e) => e.dateOfJoining.toString())
                                        .join(', '),
                                    email: user.ownUserDetailsList
                                        .map((e) => e.email.toString())
                                        .join(', '),
                                    phoneNumber: int.parse(
                                        user.user!.phoneNumber.toString()),
                                    company: user.ownUserDetailsList
                                        .expand((user) => user.company!)
                                        .toList(),
                                    department: user.ownUserDetailsList
                                        .expand((user) => user.department!)
                                        .toList(),
                                    assignedRoles:
                                        user.ownUserDetailsList.expand((user) => user.assignedRoles!).toList(),
                                    managerName: user.ownUserDetailsList.map((e) => e.managerName.toString()).join(', ')),
                                editButtonVisible: false);
                          },
                        );
                      });
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: themeProvider.isDarkTheme
                          ? const Color.fromRGBO(16, 18, 33, 1)
                          : const Color(0xfff3f1ef),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: ClipOval(
                          child: Image.network(
                            '$websiteURL/images/${user.user!.image}',
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                            errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) {
                              return Image.asset(
                                themeProvider.isDarkTheme
                                    ? 'assets/images/riota_logo.png'
                                    : 'assets/images/riota_logo2.png',
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible: extended,
                    child: Text(
                      user.user!.name.toString(),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: GlobalHelper.textStyle(TextStyle(
                          fontSize: 15,
                          color: themeProvider.isDarkTheme
                              ? Colors.white
                              : Colors.black)),
                    ),
                  ),
                  Visibility(
                    visible: !extended,
                    child: Text(
                      getInitials(user.user!.name),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: GlobalHelper.textStyle(TextStyle(
                          fontSize: 15,
                          color: themeProvider.isDarkTheme
                              ? Colors.white
                              : Colors.black)),
                    ),
                  ),
                  Visibility(
                    visible: extended,
                    child: Text(user.user!.designation.toString(),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: GlobalHelper.textStyle(TextStyle(
                            fontSize: 13,
                            color: themeProvider.isDarkTheme
                                ? const Color.fromRGBO(200, 200, 200, 1)
                                : const Color.fromRGBO(117, 117, 117, 1)))),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              );
            });
          },
          toggleButtonBuilder: (BuildContext context, bool isSidebarOpen) {
            return IconButton(
              icon: isSidebarOpen
                  ? const Icon(
                      Icons.arrow_back_ios,
                      color: Color.fromRGBO(0, 110, 185, 1),
                    )
                  : const Icon(
                      Icons.arrow_forward_ios,
                      color: Color.fromRGBO(0, 110, 185, 1),
                    ),
              onPressed: () {
                if (isSidebarOpen) {
                  /// It will Close the Side Bar
                  widget.controller.setExtended(false);
                } else {
                  /// It will Open the Side Bar
                  widget.controller.setExtended(true);
                }
              },
            );
          },
          footerBuilder: (context, extended) {
            return Consumer<BoolProvider>(
              builder: (context, themeProvider, child) {
                return Visibility(
                  visible: extended,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: themeProvider.isDarkTheme
                          ? const Color.fromRGBO(16, 18, 33, 1)
                          : const Color(0xfff3f1ef),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextButton.icon(
                            onPressed: () {
                              logout();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginInScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.logout_rounded),
                            label: Text(
                              "Log Out                                ",
                              style: GlobalHelper.textStyle(
                                TextStyle(
                                    fontSize: 12,
                                    color: themeProvider.isDarkTheme
                                        ? const Color.fromRGBO(200, 200, 200, 1)
                                        : const Color.fromRGBO(
                                            117, 117, 117, 1)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextButton.icon(
                            onPressed: () {
                              themeProvider.toogleTheme();
                              if (themeProvider.isDarkTheme) {
                                isDark = true;
                              } else {
                                isDark = false;
                              }
                            },
                            icon: Icon(themeProvider.isDarkTheme
                                ? Icons.nightlight_round_rounded
                                : Icons.sunny),
                            label: Text(
                              themeProvider.isDarkTheme
                                  ? "Dark Theme                         "
                                  : "Light Theme                         ",
                              style: GlobalHelper.textStyle(
                                TextStyle(
                                    fontSize: 12,
                                    color: themeProvider.isDarkTheme
                                        ? const Color.fromRGBO(200, 200, 200, 1)
                                        : const Color.fromRGBO(
                                            117, 117, 117, 1)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextButton.icon(
                            onPressed: () {},
                            icon: Image.asset(
                              "assets/images/version.png",
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            label: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "v$version $buildNumber",
                                  style: GlobalHelper.textStyle(
                                    TextStyle(
                                        fontSize: 10,
                                        color: themeProvider.isDarkTheme
                                            ? const Color.fromRGBO(
                                                200, 200, 200, 1)
                                            : const Color.fromRGBO(
                                                117, 117, 117, 1)),
                                  ),
                                ),
                                Text(
                                  "© RIOTA Private Limited 2024",
                                  style: GlobalHelper.textStyle(
                                    TextStyle(
                                        fontSize: 10,
                                        color: themeProvider.isDarkTheme
                                            ? const Color.fromRGBO(
                                                200, 200, 200, 1)
                                            : const Color.fromRGBO(
                                                117, 117, 117, 1)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          });
    });
  }

  List<SidebarXItem> getSideBarContents(BuildContext context) {
    final roleProvider = Provider.of<AssetProvider>(context, listen: false);
    final userRole = roleProvider.userRole;

    final assetAccess = userRole.assetStockWriteFlag ||
        userRole.assetModelWriteFlag ||
        userRole.assetTemplateWriteFlag ||
        userRole.assetSubCategoryWriteFlag ||
        userRole.assetCategoryWriteFlag ||
        userRole.assetTypeWriteFlag ||
        userRole.assetStockReadFlag ||
        userRole.assetModelReadFlag ||
        userRole.assetTemplateReadFlag ||
        userRole.assetSubCategoryReadFlag ||
        userRole.assetCategoryReadFlag ||
        userRole.assetTypeReadFlag;

    final userManagementAccess = userRole.userWriteFlag ||
        userRole.assignRoleWriteFlag ||
        userRole.userReadFlag ||
        userRole.assignRoleReadFlag;

    final directoryAccess = userRole.companyWriteFlag ||
        userRole.vendorWriteFlag ||
        userRole.locationWriteFlag ||
        userRole.companyReadFlag ||
        userRole.vendorReadFlag ||
        userRole.locationReadFlag;

    return [
      if (assetAccess && userManagementAccess && directoryAccess)
        SidebarXItem(
            icon: Icons.home_rounded,
            label: 'Home',
            onTap: () {
              widget.onPageChanged(0);
            }),
      if (assetAccess)
        SidebarXItem(
            icon: Icons.widgets_rounded,
            label: 'Assets',
            onTap: () {
              widget.onPageChanged(1);
            }),
      if (userManagementAccess)
        SidebarXItem(
            icon: Icons.person_rounded,
            label: 'User Management',
            onTap: () {
              widget.onPageChanged(2);
            }),
      SidebarXItem(
          icon: Icons.airplane_ticket_rounded,
          label: 'Tickets',
          onTap: () {
            widget.onPageChanged(3);
          }),
      if (directoryAccess)
        SidebarXItem(
            icon: Icons.store_mall_directory_rounded,
            label: 'Directory',
            onTap: () {
              widget.onPageChanged(4);
            }),
      SidebarXItem(
          icon: Icons.help_center_rounded,
          label: 'Help',
          onTap: () {
            widget.onPageChanged(5);
          }),
    ];
  }
}

T? firstOrNull<T>(Iterable<T> iterable) {
  return iterable.isEmpty ? null : iterable.first;
}

T? lastOrNull<T>(Iterable<T> iterable) {
  return iterable.isEmpty ? null : iterable.last;
}
