import 'package:asset_management_local/main_pages/user_management/user/user_list_expanded_view.dart';
import 'package:asset_management_local/models/user_management_model/role_model/assign_role_details.dart';
import 'package:asset_management_local/models/user_management_model/user_model/user_details.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../global/global_variables.dart';
import '../../../global/user_interaction_timer.dart';
import '../../../helpers/global_helper.dart';
import '../../../helpers/http_helper.dart';
import '../../../helpers/ui_components.dart';
import '../../../models/directory_model/company_model/company_details.dart';
import '../../../models/user_management_model/user_model/user_model.dart';
import 'package:asset_management_local/provider/main_providers/asset_provider.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';
import 'add_user.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage>
    with TickerProviderStateMixin {
  String? dropDownValueCompany = "All";

  int listPerPage = 5;
  int currentPage = 0;

  late AnimationController controller;
  late TableBorder startBorder;
  late TableBorder endBorder;
  late TableBorder currentBorder;

  bool selectAllCheckBox = false;

  late String image;
  late String userManagementId;

  String? passwordError;

  String? userName;

  String? role;
  String? currentRole;

  TextEditingController nameController = TextEditingController();
  TextEditingController employeeController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  TextEditingController userController = TextEditingController();

  List<AssignRoleDetails> completeRoleList = [];
  List<AssignRoleDetails> selectedRoleList = [];

  List<CompanyDetails> completeCompanyList = [];
  CompanyDetails? selectedCompany;

  List<String> tag = [];
  List<String> tagList = [];

  List<CompanyDetails> completeDepartmentList = [];
  List<String> selectedDepartmentList = [];

  List<UserDetails> completeUserList = [];
  UserDetails? selectedManager;

  List<GlobalKey<FormState>> formKeyStep = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

  int currentStep = 0;
  StepperType stepperType = StepperType.horizontal;

  late DateTime selectedDate;

  PlatformFile? imagePicked;

  String selectedImageName = 'Image';

  List<UserDetails> getPaginatedData() {
    AssetProvider userProvider =
        Provider.of<AssetProvider>(context, listen: false);

    filteredUserList = (dropDownValueCompany == "All")
        ? userProvider.userDetailsList
        : userProvider.userDetailsList
            .where((user) => user.company!.contains(dropDownValueCompany ?? ''))
            .toList();

    final startIndex = currentPage * listPerPage;
    final endIndex =
        (startIndex + listPerPage).clamp(0, filteredUserList.length);
    return filteredUserList.sublist(startIndex, endIndex);
  }

  String getDisplayedRange() {
    AssetProvider userProvider =
        Provider.of<AssetProvider>(context, listen: false);

    filteredUserList = (dropDownValueCompany == "All")
        ? userProvider.userDetailsList
        : userProvider.userDetailsList
            .where((user) => user.company!.contains(dropDownValueCompany ?? ''))
            .toList();

    final displayedListLength = filteredUserList.length;
    final startIndex = currentPage * listPerPage + 1;
    final endIndex =
        (startIndex + listPerPage - 1).clamp(0, displayedListLength);

    return '$startIndex-$endIndex of $displayedListLength';
  }

  @override
  void initState() {
    super.initState();
    Provider.of<AssetProvider>(context, listen: false).fetchUserDetails();
    Provider.of<AssetProvider>(context, listen: false).fetchCompanyDetails();
    Provider.of<AssetProvider>(context, listen: false).fetchRoleDetails();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BoolProvider boolProviders = Provider.of<BoolProvider>(context);

    return Consumer2<BoolProvider, AssetProvider>(
        builder: (context, boolProvider, assetProvider, child) {
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
        child: Stack(
          children: [
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
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                              child: Row(
                                children: [
                                  Text(
                                    "User Lists",
                                    style: GoogleFonts.ubuntu(
                                        textStyle: TextStyle(
                                      fontSize: 20,
                                      color: boolProvider.isDarkTheme
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )),
                                  ),
                                  if (assetProvider.userRole.userWriteFlag) ...[
                                    const DialogRoot(dialog: AddUsers())
                                  ]
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 15, 40, 0),
                              child: Row(
                                children: [
                                  Text(
                                    "Company",
                                    style: GoogleFonts.ubuntu(
                                        textStyle: TextStyle(
                                      fontSize: 17,
                                      color: boolProvider.isDarkTheme
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )),
                                  ),
                                  getCompanyDropDownContentUI(),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 0, 15),
                                  child: RichText(
                                    text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                        text: getPaginatedData()
                                            .length
                                            .toString(),
                                        style: GoogleFonts.ubuntu(
                                            textStyle: const TextStyle(
                                          fontSize: 20,
                                          color:
                                              Color.fromRGBO(15, 117, 188, 1),
                                        )),
                                      ),
                                      TextSpan(
                                        text: " Users",
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
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 25, 15),
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                    child: IconButton(
                                      icon: const Icon(
                                          Icons.arrow_circle_left_rounded),
                                      color: Colors.blue,
                                      disabledColor: Colors.grey,
                                      onPressed: currentPage > 0
                                          ? () => setState(() => currentPage--)
                                          : null,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.arrow_circle_right_rounded,
                                      ),
                                      color: Colors.blue,
                                      disabledColor: Colors.grey,
                                      onPressed:
                                          (currentPage + 1) * listPerPage <
                                                  filteredUserList.length
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height *
                                        0.4))
                            : assetProvider.userDetailsList.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Table(
                                      border: currentBorder,
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      children: [
                                        TableRow(children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Visibility(
                                                visible: boolProvider.isVisible,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 15),
                                                  child: Checkbox(
                                                    side:
                                                        MaterialStateBorderSide
                                                            .resolveWith(
                                                      (states) =>
                                                          const BorderSide(
                                                              width: 1.0,
                                                              color:
                                                                  Colors.blue),
                                                    ),
                                                    value: selectAllCheckBox,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        selectAllCheckBox =
                                                            value ?? false;
                                                        for (int i = 0;
                                                            i <
                                                                assetProvider
                                                                    .selectedUsers
                                                                    .length;
                                                            i++) {
                                                          if (!assetProvider
                                                              .userDetailsList[
                                                                  i]
                                                              .assignedRoles!
                                                              .contains(
                                                                  "Super Admin")) {
                                                            assetProvider
                                                                    .selectedUsers[i] =
                                                                selectAllCheckBox;
                                                          }
                                                        }
                                                      });
                                                      boolProviders
                                                          .setDeleteVisibility(
                                                              selectAllCheckBox);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              if (assetProvider.userRole.userWriteFlag) ...[
                                                Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        boolProviders
                                                            .setVisibility(
                                                                !boolProvider
                                                                    .isVisible);
                                                      },
                                                      child: Text(
                                                        "Select",
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                                textStyle:
                                                                    const TextStyle(
                                                          fontSize: 15,
                                                          color: Color.fromRGBO(
                                                              117, 117, 117, 1),
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]
                                            ],
                                          ),
                                          getTitleText(
                                            text: "ID",
                                          ),
                                          getTitleText(
                                            text: "Name",
                                          ),
                                          getTitleText(
                                            text: "Employee Details",
                                          ),
                                          getTitleText(
                                            text: "Role",
                                          ),
                                          getTitleText(
                                            text: "Assets",
                                          ),
                                          getTitleText(
                                            text: "Company",
                                          ),
                                          getTitleText(
                                            text: "Actions",
                                          ),
                                        ]),
                                        ...getPaginatedData()
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int index = entry.key;
                                          UserDetails user = entry.value;

                                          return TableRow(
                                              decoration: BoxDecoration(
                                                  color:
                                                      boolProvider.isDarkTheme
                                                          ? Colors.black
                                                          : Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20))),
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Visibility(
                                                      visible: boolProvider
                                                          .isVisible,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 15),
                                                        child: Checkbox(
                                                          side:
                                                              MaterialStateBorderSide
                                                                  .resolveWith(
                                                            (states) =>
                                                                BorderSide(
                                                              width: 1.0,
                                                              color: user
                                                                      .assignedRoles!
                                                                      .contains(
                                                                          "Super Admin")
                                                                  ? Colors.grey
                                                                  : Colors.blue,
                                                            ),
                                                          ),
                                                          value: assetProvider
                                                                  .selectedUsers
                                                                  .isNotEmpty
                                                              ? assetProvider
                                                                      .selectedUsers[
                                                                  index]
                                                              : false,
                                                          onChanged: user
                                                                  .assignedRoles!
                                                                  .contains(
                                                                      "Super Admin")
                                                              ? null
                                                              : (bool? value) {
                                                                  setState(() {
                                                                    assetProvider
                                                                            .selectedUsers[index] =
                                                                        value ??
                                                                            false;
                                                                    selectAllCheckBox = assetProvider
                                                                        .selectedUsers
                                                                        .every((item) =>
                                                                            item);
                                                                  });

                                                                  bool showDelete = assetProvider
                                                                      .selectedUsers
                                                                      .any((item) =>
                                                                          item);
                                                                  boolProviders
                                                                      .setDeleteVisibility(
                                                                          showDelete);
                                                                },
                                                        ),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 20),
                                                        child: CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor:
                                                              themeProvider
                                                                      .isDarkTheme
                                                                  ? const Color
                                                                      .fromRGBO(
                                                                      16,
                                                                      18,
                                                                      33,
                                                                      1)
                                                                  : const Color(
                                                                      0xfff3f1ef),
                                                          child: SizedBox(
                                                            width: 100,
                                                            height: 100,
                                                            child: ClipOval(
                                                              child:
                                                                  Image.network(
                                                                '$websiteURL/images/${user.image}',
                                                                loadingBuilder: (BuildContext
                                                                        context,
                                                                    Widget
                                                                        child,
                                                                    ImageChunkEvent?
                                                                        loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null) {
                                                                    return child;
                                                                  } else {
                                                                    return const CircularProgressIndicator();
                                                                  }
                                                                },
                                                                errorBuilder: (BuildContext
                                                                        context,
                                                                    Object
                                                                        error,
                                                                    StackTrace?
                                                                        stackTrace) {
                                                                  return Image
                                                                      .asset(
                                                                          'assets/images/riota_logo.png');
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                getContentText(
                                                    text: user.displayId
                                                        .toString(),
                                                    maxLines: 1,
                                                    color: themeProvider
                                                            .isDarkTheme
                                                        ? const Color.fromRGBO(
                                                            200, 200, 200, 1)
                                                        : const Color.fromRGBO(
                                                            117, 117, 117, 1)),
                                                getContentText(
                                                    text: user.name.toString(),
                                                    maxLines: 1,
                                                    color: themeProvider
                                                            .isDarkTheme
                                                        ? const Color.fromRGBO(
                                                            200, 200, 200, 1)
                                                        : const Color.fromRGBO(
                                                            117, 117, 117, 1)),
                                                Column(
                                                  children: [
                                                    getContentText(
                                                        text: user.employeeId
                                                            .toString(),
                                                        maxLines: 1,
                                                        color: themeProvider
                                                                .isDarkTheme
                                                            ? const Color
                                                                .fromRGBO(200,
                                                                200, 200, 1)
                                                            : const Color
                                                                .fromRGBO(117,
                                                                117, 117, 1)),
                                                    getContentText(
                                                        text: user.designation
                                                            .toString(),
                                                        maxLines: 1,
                                                        color: themeProvider
                                                                .isDarkTheme
                                                            ? const Color
                                                                .fromRGBO(200,
                                                                200, 200, 1)
                                                            : const Color
                                                                .fromRGBO(117,
                                                                117, 117, 1)),
                                                  ],
                                                ),
                                                getContentText(
                                                    text: fetchRole(
                                                        user.assignedRoles!),
                                                    maxLines: 1,
                                                    color: themeProvider
                                                            .isDarkTheme
                                                        ? const Color.fromRGBO(
                                                            200, 200, 200, 1)
                                                        : const Color.fromRGBO(
                                                            117, 117, 117, 1)),
                                                user.assetName!.isNotEmpty
                                                    ? getContentText(
                                                        text: fetchAsset(
                                                            user.assetName!),
                                                        maxLines: 2,
                                                        color: themeProvider
                                                                .isDarkTheme
                                                            ? const Color.fromRGBO(
                                                                200, 200, 200, 1)
                                                            : const Color.fromRGBO(
                                                                117,
                                                                117,
                                                                117,
                                                                1))
                                                    : getContentText(
                                                        text: "-",
                                                        maxLines: 1,
                                                        color: themeProvider
                                                                .isDarkTheme
                                                            ? const Color.fromRGBO(
                                                                200, 200, 200, 1)
                                                            : const Color
                                                                .fromRGBO(117,
                                                                117, 117, 1)),
                                                getContentText(
                                                    text: fetchCompany(
                                                        user.company!),
                                                    maxLines: 1,
                                                    color: themeProvider
                                                            .isDarkTheme
                                                        ? const Color.fromRGBO(
                                                            200, 200, 200, 1)
                                                        : const Color.fromRGBO(
                                                            117, 117, 117, 1)),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    ExpandedDialogsDialogRoot(
                                                        dialog:
                                                            UserListExpandedView(
                                                                user: user,
                                                                editButtonVisible: assetProvider.userRole.userWriteFlag)),
                                                    if(assetProvider.userRole.userWriteFlag)...[
                                                      CustomActionIcon(
                                                        message: "Edit",
                                                        preferBelow: true,
                                                        iconImage: const Icon(
                                                            Icons.edit_rounded),
                                                        color:
                                                        const Color.fromRGBO(
                                                            15, 117, 188, 1),
                                                        onPressed: () {
                                                          int actualIndex =
                                                              (currentPage *
                                                                  listPerPage) +
                                                                  index;

                                                          UserDetails user =
                                                          filteredUserList[
                                                          actualIndex];

                                                          userManagementId =
                                                              user.sId ?? "";
                                                          userName =
                                                              user.name ?? "";
                                                          image =
                                                              user.image ?? '';
                                                          nameController.text =
                                                              user.name ?? "";
                                                          employeeController
                                                              .text =
                                                              user.employeeId ??
                                                                  "";
                                                          emailController.text =
                                                              user.email ?? "";
                                                          phoneController.text =
                                                              user.phoneNumber
                                                                  .toString();
                                                          designationController
                                                              .text =
                                                              user.designation ??
                                                                  "";
                                                          dateController.text =
                                                              user.dateOfJoining ??
                                                                  "";
                                                          selectedCompany = assetProvider
                                                              .companyDetailsList
                                                              .firstWhereOrNull(
                                                                  (companyDetails) => user
                                                                  .company!
                                                                  .contains(
                                                                  companyDetails.name ??
                                                                      ""));

                                                          final concatenatedText =
                                                              selectedCompany
                                                                  ?.name;

                                                          companyController.text =
                                                              concatenatedText ??
                                                                  "";

                                                          selectedManager = assetProvider
                                                              .userDetailsList
                                                              .firstWhereOrNull((userDetails) =>
                                                          userDetails
                                                              .managerName !=
                                                              null &&
                                                              user.managerName !=
                                                                  null &&
                                                              user.managerName!
                                                                  .contains(
                                                                  userDetails
                                                                      .managerName!));

                                                          final concatenatedUserText =
                                                              selectedManager
                                                                  ?.managerName;

                                                          userController.text =
                                                              concatenatedUserText ??
                                                                  "";

                                                          selectedRoleList = assetProvider
                                                              .fetchedRoleDetailsList
                                                              .where(
                                                                  (assignedRoleDetails) {
                                                                return user
                                                                    .assignedRoles!
                                                                    .contains(
                                                                    assignedRoleDetails
                                                                        .roleTitle);
                                                              }).toList();

                                                          currentRole =
                                                          selectedRoleList
                                                              .isNotEmpty
                                                              ? selectedRoleList[
                                                          0]
                                                              .roleTitle
                                                              : "";

                                                          selectedDepartmentList =
                                                              List.from(user
                                                                  .department!);
                                                          tagList = List.from(
                                                              user.tag!);
                                                          passwordController
                                                              .clear();

                                                          showLargeUpdateUser(
                                                              context,
                                                              actualIndex);
                                                        },
                                                      ),
                                                      user.assignedRoles!
                                                          .contains(
                                                          "Super Admin")
                                                          ? const Text("")
                                                          : CustomActionIcon(
                                                        message: "Delete",
                                                        preferBelow: false,
                                                        iconImage:
                                                        const Icon(Icons
                                                            .delete_rounded),
                                                        color: Colors.red,
                                                        onPressed: () {
                                                          showAlertDialog(
                                                              context,
                                                              userId: user
                                                                  .displayId
                                                                  .toString(),
                                                              color: boolProvider
                                                                  .isDarkTheme
                                                                  ? Colors
                                                                  .white
                                                                  : Colors
                                                                  .black,
                                                              containerColor: boolProvider
                                                                  .isDarkTheme
                                                                  ? Colors
                                                                  .black
                                                                  : Colors
                                                                  .white,
                                                              onPressed:
                                                                  () async {
                                                                String?
                                                                userIdDelete =
                                                                user.sId
                                                                    .toString();

                                                                if (mounted) {
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop();
                                                                }

                                                                await deleteUser(
                                                                    userIdDelete,
                                                                    themeProvider,
                                                                    assetProvider);
                                                              });
                                                        },
                                                      )
                                                    ]

                                                  ],
                                                ),
                                              ]);
                                        })
                                      ],
                                    ),
                                  )
                                : Center(
                                    child: Lottie.asset(
                                        "assets/lottie/data_not_found.json",
                                        repeat: false,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.4),
                                  ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: Consumer<BoolProvider>(
                builder: (context, dialogVisibilityProvider, child) {
                  if (dialogVisibilityProvider.isDialogVisible) {
                    Future.delayed(Duration.zero, () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          List<UserDetails> selectedUsersList =
                              getSelectedUsers();

                          List<TableRow> tableRows = [];

                          tableRows.add(getTableDeleteForMultipleId(
                              title: "S.NO", content: "ID"));

                          for (int index = 0;
                              index < selectedUsersList.length;
                              index++) {
                            UserDetails user = selectedUsersList[index];
                            tableRows.add(
                              getTableDeleteForMultipleId(
                                  title: (index + 1).toString(),
                                  content: user.displayId.toString()),
                            );
                          }

                          return AlertDialog(
                            backgroundColor: boolProvider.isDarkTheme
                                ? Colors.black
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "Delete the Selected User",
                                style: GlobalHelper.textStyle(TextStyle(
                                  color: boolProvider.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                )),
                              ),
                            ),
                            content: Table(
                              border: TableBorder.all(
                                borderRadius: BorderRadius.circular(10),
                                color: boolProvider.isDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              children: tableRows,
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                  "Cancel",
                                  style: GlobalHelper.textStyle(const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                  )),
                                ),
                                onPressed: () {
                                  boolProvider.setDialogVisibility(false);
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                  child: Text(
                                    "Yes",
                                    style:
                                        GlobalHelper.textStyle(const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    )),
                                  ),
                                  onPressed: () async {
                                    getDelete();
                                    boolProvider.setDialogVisibility(false);
                                    boolProviders.setVisibility(false);
                                    boolProviders.setDeleteVisibility(false);
                                    Navigator.of(context).pop();
                                  }),
                            ],
                          );
                        },
                      );
                    });
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  String fetchRole(List<String> roles) {
    if (roles.isEmpty) {
      return "";
    } else if (roles.length == 1) {
      return roles[0];
    } else if (roles.length > 1) {
      return "${roles.first}...";
    } else {
      return roles.join(', ');
    }
  }

  showAlertDialog(BuildContext context,
      {required onPressed,
      required color,
      required containerColor,
      required userId}) {
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

    AlertDialog alert = AlertDialog(
      backgroundColor: containerColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          "Delete User",
          style: GlobalHelper.textStyle(TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          )),
        ),
      ),
      content: getTableDeleteForSingleId(id: userId, color: color),
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

  void getDelete() async {
    AssetProvider userProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider boolProvider =
        Provider.of<BoolProvider>(context, listen: false);

    List<String> idsToDelete = [];
    for (int i = 0; i < userProvider.selectedUsers.length; i++) {
      if (userProvider.selectedUsers[i]) {
        idsToDelete.add(userProvider.userDetailsList[i].sId.toString());
      }
    }

    for (String userId in idsToDelete) {
      await deleteUser(userId, boolProvider, userProvider);
    }

    setState(() {
      userProvider.userDetailsList
          .removeWhere((user) => idsToDelete.contains(user.sId.toString()));
      selectAllCheckBox = false;
    });
  }

  List<UserDetails> getSelectedUsers() {
    AssetProvider userProvider =
        Provider.of<AssetProvider>(context, listen: false);

    List<UserDetails> selectedUsersList = [];
    for (int i = 0; i < userProvider.userDetailsList.length; i++) {
      if (userProvider.selectedUsers[i]) {
        selectedUsersList.add(userProvider.userDetailsList[i]);
      }
    }
    return selectedUsersList;
  }

  String fetchCompany(List<String> company) {
    if (company.isEmpty) {
      return "";
    } else if (company.length == 1) {
      return company[0];
    } else if (company.length > 1) {
      return "${company.first}...";
    } else {
      return company.join(', ');
    }
  }

  String fetchAsset(List<String> asset) {
    if (asset.isEmpty) {
      return "";
    } else if (asset.length == 1) {
      return asset[0];
    } else if (asset.length > 1) {
      return "${asset.first}...";
    } else {
      return asset.join(', ');
    }
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

  /// It used to select the date in dialog
  _selectDate(context, StateSetter dialogSetState) async {
    final DateTime? picked = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        firstDate: DateTime(
            selectedDate.year - 5, selectedDate.month, selectedDate.day),
        lastDate: selectedDate,
        initialDate: selectedDate);

    if (picked != null) {
      String formatDate = DateFormat('dd/MM/yyyy').format(picked);
      dialogSetState(() {
        dateController.text = formatDate;
      });
    }
  }

  String? departmentValidators(value) {
    if (selectedDepartmentList.isEmpty) {
      return 'Dropdown Should be not Empty';
    } else {
      return null;
    }
  }

  String? roleValidators(value) {
    if (selectedRoleList.isEmpty) {
      return 'Dropdown Should be not Empty';
    } else {
      return null;
    }
  }

  validatePassword(String value) {
    setState(() {
      passwordError = updatePasswordValidator(value);
    });
  }

  /// It Contains the CompanyList Dropdown in dialog
  Widget getDialogDropDownCompanyContentsUILarge(
      {required StateSetter dialogSetState,
      required double width,
      required dropdownType,
      required validators}) {
    AssetProvider companyProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    return SizedBox(
      width: width,
      child: Stack(
        children: [
          TextFormField(
            controller: companyController,
            validator: validators,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      themeProvider.isDarkTheme ? Colors.black : Colors.white,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      themeProvider.isDarkTheme ? Colors.black : Colors.white,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              contentPadding: const EdgeInsets.all(15),
              suffixIcon: const Icon(
                Icons.arrow_drop_down,
                color: Color.fromRGBO(15, 117, 188, 1),
              ),
              hintText: "Company",
              hintStyle: GlobalHelper.textStyle(
                TextStyle(
                  color: themeProvider.isDarkTheme
                      ? Colors.white
                      : const Color.fromRGBO(117, 117, 117, 1),
                  fontSize: 15,
                ),
              ),
              fillColor:
                  themeProvider.isDarkTheme ? Colors.black : Colors.white,
              filled: true,
            ),
            style: TextStyle(
                color: themeProvider.isDarkTheme
                    ? Colors.white
                    : const Color.fromRGBO(117, 117, 117, 1)),
            onTap: () {
              dialogSetState(() {
                completeCompanyList = companyProvider.companyDetailsList
                    .where((item) =>
                        companyController.text.isEmpty ||
                        (item.name?.toLowerCase().contains(
                                companyController.text.toLowerCase()) ==
                            true))
                    .toList();

                isDropDownUserList[0] = true;
              });
            },
            onChanged: (value) {
              dialogSetState(() {
                completeCompanyList = companyProvider.companyDetailsList
                    .where((item) =>
                        companyController.text.isEmpty ||
                        (item.name?.toLowerCase().contains(
                                companyController.text.toLowerCase()) ==
                            true))
                    .toList();
                departmentController.clear();
                completeDepartmentList.clear();
                selectedDepartmentList.clear();
              });
            },
          ),
          if (isDropDownUserList[dropdownType])
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:
                      themeProvider.isDarkTheme ? Colors.black : Colors.white,
                ),
                margin: const EdgeInsets.only(top: 50),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: completeCompanyList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        completeCompanyList[index].name.toString(),
                        style: GlobalHelper.textStyle(TextStyle(
                            color: themeProvider.isDarkTheme
                                ? Colors.white
                                : const Color.fromRGBO(117, 117, 117, 1))),
                      ),
                      onTap: () {
                        dialogSetState(() {
                          selectedCompany = null;
                          selectedCompany = completeCompanyList[index];
                          onDropdownTap(
                              dropdownType,
                              completeCompanyList[index].name.toString(),
                              dialogSetState);
                          var companyIds = [
                            completeCompanyList[index].sId ?? ""
                          ];
                          companyProvider.fetchParticularCompanyDetails(
                              companyIds: companyIds);
                          // companyIds.clear();
                          // departmentController.clear();
                          // selectedDepartmentList.clear();
                        });
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget getDialogDropDownDepartmentContentsUILarge(
      {required StateSetter dialogSetState,
      required double width,
      required validators}) {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    AssetProvider companyProvider =
        Provider.of<AssetProvider>(context, listen: false);

    return SizedBox(
      width: width,
      child: Stack(
        children: [
          TextFormField(
            controller: departmentController,
            validator: validators,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: themeProvider.isDarkTheme
                        ? Colors.black
                        : Colors.white),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      themeProvider.isDarkTheme ? Colors.black : Colors.white,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              contentPadding: const EdgeInsets.all(15),
              suffixIcon: const Icon(
                Icons.arrow_drop_down,
                color: Color.fromRGBO(15, 117, 188, 1),
              ),
              hintText: "Department",
              hintStyle: GlobalHelper.textStyle(
                TextStyle(
                  color: themeProvider.isDarkTheme
                      ? Colors.white
                      : const Color.fromRGBO(117, 117, 117, 1),
                  fontSize: 15,
                ),
              ),
              fillColor:
                  themeProvider.isDarkTheme ? Colors.black : Colors.white,
              filled: true,
            ),
            style: TextStyle(
                color: themeProvider.isDarkTheme
                    ? Colors.white
                    : const Color.fromRGBO(117, 117, 117, 1)),
            onTap: () {
              dialogSetState(() {
                completeDepartmentList = companyProvider
                    .particularCompanyDetailsList
                    .where((item) =>
                        departmentController.text.isEmpty ||
                        (item.departments != null &&
                            item.departments!.any((department) => department
                                .toLowerCase()
                                .contains(
                                    departmentController.text.toLowerCase()))))
                    .toList();
                completeDepartmentList = completeDepartmentList
                    .where((item) => !selectedDepartmentList.contains(item))
                    .toList();
                isDropDownUserList[1] = true;
              });
            },
            onChanged: (value) {
              dialogSetState(() {
                completeDepartmentList = companyProvider
                    .particularCompanyDetailsList
                    .where((item) =>
                        departmentController.text.isEmpty ||
                        (item.departments != null &&
                            item.departments!.any((department) => department
                                .toLowerCase()
                                .contains(
                                    departmentController.text.toLowerCase()))))
                    .toList();
                completeDepartmentList = completeDepartmentList
                    .where((item) => !selectedDepartmentList.contains(item))
                    .toList();
              });
            },
          ),
          if (isDropDownUserList[1] && completeDepartmentList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:
                      themeProvider.isDarkTheme ? Colors.black : Colors.white,
                ),
                margin: const EdgeInsets.only(top: 50),
                child: Column(
                  children: completeDepartmentList.map((companyDetails) {
                    return Column(
                      children: companyDetails.departments!.map((department) {
                        return ListTile(
                          title: Text(
                            department,
                            style: GlobalHelper.textStyle(TextStyle(
                                color: themeProvider.isDarkTheme
                                    ? Colors.white
                                    : const Color.fromRGBO(117, 117, 117, 1))),
                          ),
                          onTap: () {
                            dialogSetState(() {
                              selectedDepartmentList.add(department);
                              departmentController.clear();
                              isDropDownUserList[1] = false;
                            });
                          },
                        );
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// It contains What are the department selecting in the dropdown
  Widget getDepartmentListDialogContentsUI(
      {required double width, required StateSetter dialogSetState}) {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Container(
        width: width,
        decoration: BoxDecoration(
            color: themeProvider.isDarkTheme ? Colors.black : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: selectedDepartmentList.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                if (index > 0)
                  const Divider(
                    thickness: 1,
                    color: Color(0xffbdbdbd),
                    indent: 10,
                    endIndent: 10,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        selectedDepartmentList[index],
                        style: GlobalHelper.textStyle(TextStyle(
                          color: themeProvider.isDarkTheme
                              ? Colors.white
                              : const Color.fromRGBO(117, 117, 117, 1),
                          fontSize: 15,
                        )),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          dialogSetState(() {
                            selectedDepartmentList.removeAt(index);
                          });
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Color.fromRGBO(15, 117, 188, 1),
                        ))
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// It Contains the UserList Dropdown in dialog
  Widget getDialogDropDownUserContentsUILarge(
      {required StateSetter dialogSetState,
      required double width,
      required dropdownType,
      validators}) {
    AssetProvider userProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    AssetProvider particularUserProvider =
        Provider.of<AssetProvider>(context, listen: false);

    AssetProvider particularUserProviders =
        Provider.of<AssetProvider>(context, listen: false);

    var particularUserName =
        particularUserProviders.user?.name.toString() ?? "";

    String? userNames;

    if (particularUserName != userNames) {
      userNames = userName;
    } else {
      userNames = particularUserProvider.user!.name.toString();
    }

    return SizedBox(
      width: width,
      child: Stack(
        children: [
          TextFormField(
            controller: userController,
            validator: validators,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      themeProvider.isDarkTheme ? Colors.black : Colors.white,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      themeProvider.isDarkTheme ? Colors.black : Colors.white,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              contentPadding: const EdgeInsets.all(15),
              suffixIcon: const Icon(
                Icons.arrow_drop_down,
                color: Color.fromRGBO(15, 117, 188, 1),
              ),
              hintText: "Reporting Manager",
              hintStyle: GlobalHelper.textStyle(
                TextStyle(
                  color: themeProvider.isDarkTheme
                      ? Colors.white
                      : const Color.fromRGBO(117, 117, 117, 1),
                  fontSize: 15,
                ),
              ),
              fillColor:
                  themeProvider.isDarkTheme ? Colors.black : Colors.white,
              filled: true,
            ),
            style: TextStyle(
                color: themeProvider.isDarkTheme
                    ? Colors.white
                    : const Color.fromRGBO(117, 117, 117, 1)),
            onTap: () {
              dialogSetState(() {
                completeUserList = userProvider.userDetailsList
                    .where((item) =>
                        userController.text.isEmpty ||
                        (item.name
                                ?.toLowerCase()
                                .contains(userController.text.toLowerCase()) ==
                            true))
                    .where((item) =>
                        item.name != userNames) // Exclude current user's name
                    .toList();
                isDropDownUserList[3] = true;
              });
            },
            onChanged: (value) {
              dialogSetState(() {
                completeUserList = userProvider.userDetailsList
                    .where((item) =>
                        userController.text.isEmpty ||
                        (item.name
                                ?.toLowerCase()
                                .contains(userController.text.toLowerCase()) ==
                            true))
                    .where((item) =>
                        item.name != userNames) // Exclude current user's name
                    .toList();
              });
            },
          ),
          if (isDropDownUserList[dropdownType])
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:
                      themeProvider.isDarkTheme ? Colors.black : Colors.white,
                ),
                margin: const EdgeInsets.only(top: 50),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: completeUserList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        completeUserList[index].name.toString(),
                        style: GlobalHelper.textStyle(TextStyle(
                            color: themeProvider.isDarkTheme
                                ? Colors.white
                                : const Color.fromRGBO(117, 117, 117, 1))),
                      ),
                      onTap: () {
                        selectedManager = null;
                        selectedManager = completeUserList[index];
                        onDropdownTap(
                            dropdownType,
                            completeUserList[index].name.toString(),
                            dialogSetState);
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  onDropdownTap(int dropdownType, String selectedOption, setState) {
    if (dropdownType == 0) {
      setState(() {
        companyController.text = selectedOption;
        isDropDownUserList[0] = false;
      });
    } else if (dropdownType == 1) {
      setState(() {
        departmentController.text = selectedOption;
        isDropDownUserList[1] = false;
      });
    } else if (dropdownType == 3) {
      setState(() {
        userController.text = selectedOption;
        isDropDownUserList[3] = false;
      });
    } else {
      return;
    }
  }

  /// It Contains the RoleList Dropdown in dialog
  Widget getDialogDropDownRoleContentsUI(
      {required String hintText,
      required TextEditingController controllers,
      required double width,
      required validators,
      required StateSetter dialogSetState,
      required TextInputType type}) {
    AssetProvider assignRoleProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: SizedBox(
        width: width,
        child: Stack(
          children: [
            TextFormField(
              controller: controllers,
              validator: validators,
              keyboardType: type,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        themeProvider.isDarkTheme ? Colors.black : Colors.white,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        themeProvider.isDarkTheme ? Colors.black : Colors.white,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                contentPadding: const EdgeInsets.all(15),
                suffixIcon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromRGBO(15, 117, 188, 1),
                ),
                hintText: hintText,
                hintStyle: GlobalHelper.textStyle(
                  TextStyle(
                    color: themeProvider.isDarkTheme
                        ? Colors.white
                        : const Color.fromRGBO(117, 117, 117, 1),
                    fontSize: 15,
                  ),
                ),
                fillColor:
                    themeProvider.isDarkTheme ? Colors.black : Colors.white,
                filled: true,
              ),
              style: TextStyle(
                color: themeProvider.isDarkTheme
                    ? Colors.white
                    : const Color.fromRGBO(117, 117, 117, 1),
              ),
              onTap: () {
                dialogSetState(() {
                  completeRoleList = assignRoleProvider.fetchedRoleDetailsList
                      .where((item) =>
                          roleController.text.isEmpty ||
                          (item.roleTitle?.toLowerCase().contains(
                                  roleController.text.toLowerCase()) ==
                              true))
                      .toList();

                  completeRoleList = completeRoleList
                      .where((item) => !selectedRoleList.contains(item))
                      .toList();
                  isDropDownUserList[2] = true;
                });
              },
              onChanged: (value) {
                dialogSetState(() {
                  completeRoleList = assignRoleProvider.fetchedRoleDetailsList
                      .where((item) =>
                          roleController.text.isEmpty ||
                          (item.roleTitle?.toLowerCase().contains(
                                  roleController.text.toLowerCase()) ==
                              true))
                      .toList();

                  completeRoleList = completeRoleList
                      .where((item) => !selectedRoleList.contains(item))
                      .toList();
                  isDropDownUserList[2] = true;
                });
              },
            ),
            if (isDropDownUserList[2] && completeRoleList.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:
                        themeProvider.isDarkTheme ? Colors.black : Colors.white,
                  ),
                  margin: const EdgeInsets.only(top: 50),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: completeRoleList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          completeRoleList[index].roleTitle.toString(),
                          style: GlobalHelper.textStyle(TextStyle(
                            color: themeProvider.isDarkTheme
                                ? Colors.white
                                : const Color.fromRGBO(117, 117, 117, 1),
                          )),
                        ),
                        onTap: () {
                          dialogSetState(() {
                            if (selectedRoleList.isEmpty) {
                              selectedRoleList.add(completeRoleList[index]);
                              role = selectedRoleList
                                  .map((e) => e.roleTitle)
                                  .toList()
                                  .join(', ')
                                  .toString();
                            } else {
                              showToast("Only one role selection is allowed");
                            }

                            roleController.clear();
                            userController.clear();
                            selectedManager = null;
                            isDropDownUserList[2] = false;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// It contains What are the role selecting in the dropdown
  Widget getRoleListDialogContentsUI({
    required double width,
    required StateSetter dialogSetState,
  }) {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Container(
        width: width,
        decoration: BoxDecoration(
            color: themeProvider.isDarkTheme ? Colors.black : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: selectedRoleList.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                if (index > 0)
                  const Divider(
                    thickness: 1,
                    color: Color(0xffbdbdbd),
                    indent: 10,
                    endIndent: 10,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        selectedRoleList[index].roleTitle.toString(),
                        style: GlobalHelper.textStyle(TextStyle(
                          color: themeProvider.isDarkTheme
                              ? Colors.white
                              : const Color.fromRGBO(117, 117, 117, 1),
                          fontSize: 15,
                        )),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          dialogSetState(() {
                            selectedRoleList.removeAt(index);
                            userController.clear();
                            selectedManager = null;
                          });
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Color.fromRGBO(15, 117, 188, 1),
                        ))
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> showLargeUpdateUser(BuildContext context, int index) async {
    currentStep = 0;

    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    showDialog(
        context: context,
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
                  child: Container(
                    decoration: BoxDecoration(
                        color: themeProvider.isDarkTheme
                            ? const Color.fromRGBO(16, 18, 33, 1)
                            : const Color(0xfff3f1ef),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    width: MediaQuery.of(context).size.width * 0.47,
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "UPDATE USER",
                            style: GoogleFonts.ubuntu(
                                textStyle: TextStyle(
                              fontSize: 15,
                              color: themeProvider.isDarkTheme
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            pickImage(context, setState,
                                allowedExtension: ['png', 'jpg']);
                          },
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: themeProvider.isDarkTheme
                                ? Colors.black
                                : Colors.white,
                            child: SizedBox(
                                width: 100,
                                height: 100,
                                child: ClipOval(
                                  child: Builder(
                                    builder: (BuildContext context) {
                                      if (imagePicked != null) {
                                        return Image.memory(imagePicked!.bytes!,
                                            fit: BoxFit.cover);
                                      } else {
                                        return Image.network(
                                          '$websiteURL/images/$image',
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return const CircularProgressIndicator();
                                            }
                                          },
                                          errorBuilder: (BuildContext context,
                                              Object error,
                                              StackTrace? stackTrace) {
                                            return Image.asset(
                                              themeProvider.isDarkTheme
                                                  ? 'assets/images/riota_logo.png'
                                                  : 'assets/images/riota_logo2.png',
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Expanded(
                          child: Theme(
                            data: ThemeData(
                                canvasColor: themeProvider.isDarkTheme
                                    ? const Color.fromRGBO(16, 18, 33, 1)
                                    : const Color(0xfff3f1ef)),
                            child: Stepper(
                              type: stepperType,
                              elevation: 0,
                              currentStep: currentStep,
                              onStepTapped: (step) {
                                if (formKeyStep[currentStep]
                                    .currentState!
                                    .validate()) {
                                  setState(() {
                                    currentStep = step;
                                  });
                                }
                              },
                              steps: getStepsUserDialogLarge(setState,
                                  color: themeProvider.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  colors: themeProvider.isDarkTheme
                                      ? Colors.black
                                      : Colors.white,
                                  borderColor: themeProvider.isDarkTheme
                                      ? Colors.black
                                      : Colors.white,
                                  textColor: themeProvider.isDarkTheme
                                      ? Colors.white
                                      : const Color.fromRGBO(117, 117, 117, 1),
                                  fillColor: themeProvider.isDarkTheme
                                      ? Colors.black
                                      : Colors.white,
                                  containerColor: themeProvider.isDarkTheme
                                      ? Colors.black
                                      : Colors.white,
                                  dividerColor: themeProvider.isDarkTheme
                                      ? Colors.black
                                      : Colors.white),
                              controlsBuilder: (context, details) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.050,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.075,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)))),
                                            child: Text(
                                              "Close",
                                              style: GlobalHelper.textStyle(
                                                  const TextStyle(
                                                color: Colors.white,
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                              )),
                                            )),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if (currentStep != 0)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.050,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.075,
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      currentStep -= 1;
                                                    });
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.blue,
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)))),
                                                  child: Text(
                                                    "Previous",
                                                    style:
                                                        GlobalHelper.textStyle(
                                                            const TextStyle(
                                                      color: Colors.white,
                                                      letterSpacing: 0.5,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15,
                                                    )),
                                                  )),
                                            ),
                                          ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.050,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.075,
                                            child: ElevatedButton(
                                                onPressed: () async {
                                                  final steps = getStepsUserDialogLarge(
                                                      setState,
                                                      color: themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                      colors: themeProvider.isDarkTheme
                                                          ? Colors.black
                                                          : Colors.white,
                                                      borderColor:
                                                          themeProvider.isDarkTheme
                                                              ? Colors.black
                                                              : Colors.white,
                                                      textColor: themeProvider
                                                              .isDarkTheme
                                                          ? Colors.white
                                                          : const Color.fromRGBO(
                                                              117, 117, 117, 1),
                                                      fillColor:
                                                          themeProvider.isDarkTheme
                                                              ? Colors.black
                                                              : Colors.white,
                                                      containerColor:
                                                          themeProvider.isDarkTheme
                                                              ? Colors.black
                                                              : Colors.white,
                                                      dividerColor:
                                                          themeProvider.isDarkTheme
                                                              ? Colors.black
                                                              : Colors.white);

                                                  if (currentStep <
                                                      steps.length - 1) {
                                                    if (formKeyStep[currentStep]
                                                        .currentState!
                                                        .validate()) {
                                                      setState(() {
                                                        currentStep++;
                                                      });
                                                    } else {
                                                      return;
                                                    }
                                                  } else {
                                                    if (formKeyStep[currentStep]
                                                        .currentState!
                                                        .validate()) {
                                                      _onTapEditButton(index);
                                                      Navigator.of(context)
                                                          .pop();
                                                    } else {
                                                      return;
                                                    }
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.blue,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)))),
                                                child: Text(
                                                  currentStep == 2
                                                      ? "Save"
                                                      : "Next",
                                                  style: GlobalHelper.textStyle(
                                                      const TextStyle(
                                                    color: Colors.white,
                                                    letterSpacing: 0.5,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                  )),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  )),
            );
          });
        });
  }

  Widget getCompanyDropDownContentUI() {
    AssetProvider userProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    List<String> dropdownItems = ["All"];
    dropdownItems.addAll(
        userProvider.userDetailsList.expand((user) => user.company!).toSet());

    return DropdownButtonHideUnderline(
      child: DropdownButton(
        elevation: 1,
        iconDisabledColor: Colors.blue,
        iconEnabledColor: Colors.blue,
        dropdownColor: themeProvider.isDarkTheme
            ? const Color.fromRGBO(16, 18, 33, 1)
            : const Color(0xfff3f1ef),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        value: dropDownValueCompany,
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
            dropDownValueCompany = value!;
            currentPage = 0;
          });
        },
      ),
    );
  }

  List<Step> getStepsUserDialogLarge(
    StateSetter dialogSetState, {
    required color,
    required colors,
    required borderColor,
    required textColor,
    required fillColor,
    required containerColor,
    required dividerColor,
  }) =>
      [
        Step(
          title: Text(
            "User Details",
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Form(
            key: formKeyStep[0],
            child: Column(
              children: [
                Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        margin: const EdgeInsets.all(2.0),
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(67, 66, 66, 0.060),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    getDialogContentsUI(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        hintText: "Name",
                                        suffixIcon: Icons.person,
                                        iconColor: const Color.fromRGBO(
                                            117, 117, 117, 1),
                                        controllers: nameController,
                                        type: TextInputType.name,
                                        validators: commonValidator,
                                        dialogSetState: setState,
                                        textColor: textColor,
                                        color: colors,
                                        borderColor: borderColor),
                                    getDialogContentsUI(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        hintText: "Employee ID",
                                        suffixIcon: Icons.person,
                                        iconColor: const Color.fromRGBO(
                                            117, 117, 117, 1),
                                        controllers: employeeController,
                                        type: TextInputType.name,
                                        validators: commonValidator,
                                        dialogSetState: setState,
                                        textColor: textColor,
                                        color: colors,
                                        borderColor: borderColor),
                                  ]),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  getDialogContentsUI(
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      hintText: "Email ID",
                                      suffixIcon: Icons.mail,
                                      iconColor: const Color.fromRGBO(
                                          117, 117, 117, 1),
                                      controllers: emailController,
                                      type: TextInputType.emailAddress,
                                      dialogSetState: setState,
                                      textColor: textColor,
                                      color: colors,
                                      borderColor: borderColor,
                                      validators: emailValidator),
                                  getDialogPasswordContentsUI(
                                    width: MediaQuery.of(context).size.width *
                                        0.20,
                                    hintText: "Password",
                                    onChanged: validatePassword,
                                    suffixIcon: isHidden
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    iconColor:
                                        const Color.fromRGBO(15, 117, 188, 1),
                                    controllers: passwordController,
                                    dialogSetState: setState,
                                    obSecureText: isHidden,
                                    validators: (value) {
                                      if (passwordError != null) {
                                        return passwordError;
                                      }
                                      return null;
                                    },
                                    onPressed: () {
                                      dialogSetState(() {
                                        isHidden = !isHidden;
                                      });
                                    },
                                    textColor: textColor,
                                    color: colors,
                                    borderColor: borderColor,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  getDialogContentsUILargeScreenPhoneNumber(
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      hintText: "Phone Number",
                                      suffixIcon: Icons.phone,
                                      iconColor: const Color.fromRGBO(
                                          117, 117, 117, 1),
                                      controllers: phoneController,
                                      type: TextInputType.phone,
                                      dialogSetState: setState,
                                      textColor: textColor,
                                      color: colors,
                                      borderColor: borderColor,
                                      validators: mobileValidator),
                                  getDialogContentsUI(
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      hintText: "Designation",
                                      suffixIcon: Icons.person_pin_sharp,
                                      iconColor: const Color.fromRGBO(
                                          117, 117, 117, 1),
                                      controllers: designationController,
                                      type: TextInputType.text,
                                      dialogSetState: setState,
                                      textColor: textColor,
                                      color: colors,
                                      borderColor: borderColor,
                                      validators: commonValidator),
                                ],
                              ),
                              getDialogIconButtonContentsUI(
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  hintText: "Date of Joining (DD/MM/YYYY)",
                                  suffixIcon: Icons.calendar_today_rounded,
                                  iconColor:
                                      const Color.fromRGBO(15, 117, 188, 1),
                                  controllers: dateController,
                                  type: TextInputType.datetime,
                                  dialogSetState: setState,
                                  validators: dateValidator,
                                  onPressed: (() {
                                    setState(() {
                                      selectedDate = DateTime.now();
                                      _selectDate(context, setState);
                                    });
                                  }),
                                  borderColor: borderColor,
                                  textColor: textColor,
                                  fillColor: fillColor),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 0,
        ),
        Step(
          title: Text(
            'Company Details',
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Form(
            key: formKeyStep[1],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    margin: const EdgeInsets.all(2.0),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(67, 66, 66, 0.060),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 0, 0),
                                        child:
                                            getDialogDropDownCompanyContentsUILarge(
                                                dialogSetState: dialogSetState,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.20,
                                                dropdownType: 0,
                                                validators: commonValidator),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 0, 0),
                                        child:
                                            getDialogDropDownDepartmentContentsUILarge(
                                                dialogSetState: dialogSetState,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.20,
                                                validators:
                                                    departmentValidators),
                                      ),
                                      if (selectedDepartmentList.isNotEmpty)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                height: 30,
                                                child: VerticalDivider(
                                                  thickness: 3.5,
                                                  color: dividerColor,
                                                )),
                                          ],
                                        ),
                                      getDepartmentListDialogContentsUI(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        dialogSetState: dialogSetState,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 1,
        ),
        Step(
          title: Text(
            'Assign Role',
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Form(
            key: formKeyStep[2],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    margin: const EdgeInsets.all(2.0),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(67, 66, 66, 0.060),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 0),
                                        child: getDialogDropDownRoleContentsUI(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.20,
                                          hintText: "Assign Role",
                                          controllers: roleController,
                                          type: TextInputType.text,
                                          dialogSetState: dialogSetState,
                                          validators: roleValidators,
                                        ),
                                      ),
                                      if (selectedRoleList.isNotEmpty)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                height: 30,
                                                child: VerticalDivider(
                                                  thickness: 3.5,
                                                  color: dividerColor,
                                                )),
                                          ],
                                        ),
                                      getRoleListDialogContentsUI(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        dialogSetState: dialogSetState,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      role == "Super Admin" ||
                                              currentRole == "Super Admin"
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 18, 0, 0),
                                              child:
                                                  getDialogDropDownUserContentsUILarge(
                                                dialogSetState: dialogSetState,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.20,
                                                dropdownType: 3,
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 18, 0, 0),
                                              child:
                                                  getDialogDropDownUserContentsUILarge(
                                                      dialogSetState:
                                                          dialogSetState,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.20,
                                                      dropdownType: 3,
                                                      validators:
                                                          commonValidator),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: getDialogTagContentsUI(
                                        borderColor: borderColor,
                                        textColor: textColor,
                                        containerColor: containerColor,
                                        fillColor: fillColor,
                                        hintText: 'Tag',
                                        controllers: tagController,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        dialogSetState: setState,
                                        type: TextInputType.text,
                                        tags: tag,
                                        onPressed: () {
                                          final tagExtraText =
                                              tagController.text;
                                          if (tagExtraText.isNotEmpty) {
                                            setState(() {
                                              tagList.add(tagExtraText);
                                              tagController.clear();
                                            });
                                          } else {
                                            return;
                                          }
                                        },
                                        list: tagList),
                                  ),
                                  if (tagList.isNotEmpty)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            height: 30,
                                            child: VerticalDivider(
                                              thickness: 3.5,
                                              color: dividerColor,
                                            )),
                                      ],
                                    ),
                                  getTagListDialogContentsUI(
                                    color: colors,
                                    textColor: textColor,
                                    width: MediaQuery.of(context).size.width *
                                        0.20,
                                    dialogSetState: setState,
                                    tag: tagList,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 2,
        ),
      ];

  pickImage(context, StateSetter dialogSetState,
      {required List<String> allowedExtension}) async {
    FilePickerResult? image = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: allowedExtension);

    if (image != null) {
      imagePicked = image.files.first;
      String imageName = image.files.first.name;
      dialogSetState(() {
        selectedImageName = imageName;
      });
    } else {
      return;
    }
  }

  Widget getImageWidget(int index) {
    AssetProvider userProvider =
        Provider.of<AssetProvider>(context, listen: false);

    if (imagePicked != null) {
      return Image.memory(imagePicked!.bytes!, fit: BoxFit.cover);
    } else {
      return Image.network(
        '$websiteURL/images/${userProvider.userDetailsList[index].image}',
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return const CircularProgressIndicator();
          }
        },
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          return Image.asset(
            'assets/images/riota_logo.png',
          );
        },
      );
    }
  }

  /// It will check the Existing Details of the Company and Edited or Not
  bool checkUserDetailsEditedOrNot(int index) {
    AssetProvider userProvider =
        Provider.of<AssetProvider>(context, listen: false);

    Function eq = const ListEquality().equals;
    if (userProvider.userDetailsList[index].name == nameController.text &&
        userProvider.userDetailsList[index].employeeId ==
            employeeController.text &&
        userProvider.userDetailsList[index].email == emailController.text &&
        userProvider.userDetailsList[index].password ==
            passwordController.text &&
        userProvider.userDetailsList[index].phoneNumber.toString() ==
            phoneController.text &&
        userProvider.userDetailsList[index].designation ==
            designationController.text &&
        userProvider.userDetailsList[index].dateOfJoining ==
            dateController.text &&
        eq(userProvider.userDetailsList[index].company, selectedCompany) &&
        userProvider.userDetailsList[index].managerName ==
            userController.text &&
        eq(userProvider.userDetailsList[index].department,
            selectedDepartmentList) &&
        eq(userProvider.userDetailsList[index].assignedRoles,
            selectedRoleList) &&
        eq(userProvider.userDetailsList[index].tag, tagList)) {
      return false;
    } else {
      return true;
    }
  }

  _onTapEditButton(int index) async {
    AssetProvider userProvider =
        Provider.of<AssetProvider>(context, listen: false);

    AssetProvider particularUserProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider boolProvider =
        Provider.of<BoolProvider>(context, listen: false);

    var userId = particularUserProvider.user!.sId.toString();

    bool detailsEdited = false;
    final result = checkUserDetailsEditedOrNot(index);
    if (result || imagePicked != null) {
      detailsEdited = true;
    }

    if (detailsEdited) {
      String? updatedPassword;
      if (passwordController.text.isNotEmpty) {
        updatedPassword = passwordController.text;
      }

      Users user;
      if (updatedPassword != null && updatedPassword.isNotEmpty) {
        user = Users(
            name: nameController.text.toString(),
            employeeId: employeeController.text.toString(),
            department: selectedDepartmentList,
            designation: designationController.text.toString(),
            email: emailController.text.toString(),
            phoneNumber: phoneController.text.toString(),
            dateOfJoining: dateController.text.toString(),
            password: updatedPassword,
            image: imagePicked?.name,
            companyRefId: selectedCompany?.sId,
            assignRoleRefIds: selectedRoleList.map((e) => e.sId).toList(),
            tag: tagList,
            sId: userManagementId,
            updatedBy: userId,
            reportManagerRefId: selectedManager?.sId);
      } else {
        user = Users(
            name: nameController.text.toString(),
            employeeId: employeeController.text.toString(),
            department: selectedDepartmentList,
            designation: designationController.text.toString(),
            email: emailController.text.toString(),
            phoneNumber: phoneController.text.toString(),
            dateOfJoining: dateController.text.toString(),
            image: imagePicked?.name,
            companyRefId: selectedCompany?.sId,
            assignRoleRefIds: selectedRoleList.map((e) => e.sId).toList(),
            tag: tagList,
            sId: userManagementId,
            updatedBy: userId,
            reportManagerRefId: selectedManager?.sId);
      }
      await updateUser(user, boolProvider, userProvider);
    } else {
      /// User not changed anything...
    }
  }

  Future<void> updateUser(Users user, BoolProvider boolProviders,
      AssetProvider userProvider) async {
    await AddUpdateDetailsManagerWithImage(
      data: user,
      image: imagePicked,
      apiURL: 'user/updateUser',
    ).addUpdateDetailsWithImages(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("User Updated Successfully");
        userProvider.fetchUserDetails();
      });
    } else {
      setState(() {
        showToast("Unable to update the user");
      });
    }
  }

  Future<void> deleteUser(String userId, BoolProvider boolProviders,
      AssetProvider userProvider) async {
    await DeleteDetailsManager(
      apiURL: 'user/deleteUser',
      id: userId,
    ).deleteDetails(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("User Deleted Successfully");
        userProvider.fetchUserDetails();
      });
    } else {
      setState(() {
        showToast("Unable to delete the user");
      });
    }
  }
}
