import 'package:asset_management_local/models/user_management_model/role_model/assign_role_details.dart';
import 'package:asset_management_local/models/directory_model/company_model/company_details.dart';
import 'package:asset_management_local/models/user_management_model/user_model/user_details.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../global/global_variables.dart';
import '../../../global/user_interaction_timer.dart';
import '../../../helpers/global_helper.dart';
import '../../../helpers/http_helper.dart';
import '../../../helpers/ui_components.dart';
import '../../../models/user_management_model/user_model/user_model.dart';
import 'package:asset_management_local/provider/main_providers/asset_provider.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';

class UserListExpandedView extends StatefulWidget {
   const UserListExpandedView({super.key, required this.user,required this.editButtonVisible});
  final UserDetails user;
  final bool editButtonVisible;

  @override
  State<UserListExpandedView> createState() => _UserListExpandedViewState();
}

class _UserListExpandedViewState extends State<UserListExpandedView> {
  List<String> tag = [];
  List<String> tagList = [];

  PlatformFile? imagePicked;

  String selectedImageName = 'Image';

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

  String? passwordError;

  String? userName;

  String? role;
  String? currentRole;

  @override
  void initState() {
    super.initState();
    Provider.of<AssetProvider>(context, listen: false).fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AssetProvider, BoolProvider>(
        builder: (context, userProvider, themeProvider, child) {
      return Center(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                color: themeProvider.isDarkTheme
                    ? const Color.fromRGBO(16, 18, 33, 1)
                    : const Color(0xfff3f1ef),
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            width: MediaQuery.of(context).size.width * 0.55,
            child: Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
                      child: Text(
                        "User",
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
                    Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 10, 40, 20),
                          child: Container(
                            decoration: BoxDecoration(
                                color: themeProvider.isDarkTheme
                                    ? Colors.black
                                    : Colors.white,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15))),
                            width: MediaQuery.of(context).size.width * 0.50,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: themeProvider.isDarkTheme
                                        ? const Color.fromRGBO(16, 18, 33, 1)
                                        : const Color(0xfff3f1ef),
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: ClipOval(
                                        child: Image.network(
                                          '$websiteURL/images/${widget.user.image}',
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
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                getTicketStatusTitleContentUI(
                                                    title: 'Name'),
                                                getTicketStatusTitleContentUI(
                                                    title: 'Designation'),
                                                getTicketStatusTitleContentUI(
                                                    title: 'E-Mail ID'),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                getTicketStatusContentUI(
                                                  content: widget.user.name
                                                      .toString(),
                                                  color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                                getTicketStatusContentUI(
                                                  content: widget
                                                      .user.designation
                                                      .toString(),
                                                  color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                                getTicketStatusContentUI(
                                                  content: widget.user.email
                                                      .toString(),
                                                  color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                getTicketStatusTitleContentUI(
                                                    title: 'Employee ID'),
                                                getTicketStatusTitleContentUI(
                                                    title: 'Date of Joining'),
                                                getTicketStatusTitleContentUI(
                                                    title: 'Phone No'),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                getTicketStatusContentUI(
                                                  content: widget
                                                      .user.employeeId
                                                      .toString(),
                                                  color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                                getTicketStatusContentUI(
                                                  content: widget
                                                      .user.dateOfJoining
                                                      .toString(),
                                                  color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                                getTicketStatusContentUI(
                                                  content: widget
                                                      .user.phoneNumber
                                                      .toString(),
                                                  color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        getTicketStatusTitleContentUI(
                                            title: 'Company'),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 0, 15, 15),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            decoration: BoxDecoration(
                                                color: themeProvider.isDarkTheme
                                                    ? const Color.fromRGBO(
                                                        16, 18, 33, 1)
                                                    : const Color(0xfff3f1ef),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(15))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Center(
                                                child: Text(
                                                  fetchLess(
                                                      widget.user.company!),
                                                  style: GlobalHelper.textStyle(
                                                      TextStyle(
                                                    color: themeProvider
                                                            .isDarkTheme
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  )),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        getTicketStatusTitleContentUI(
                                            title: 'Department'),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 0, 15, 15),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            decoration: BoxDecoration(
                                                color: themeProvider.isDarkTheme
                                                    ? const Color.fromRGBO(
                                                        16, 18, 33, 1)
                                                    : const Color(0xfff3f1ef),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(15))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Center(
                                                child: Text(
                                                  fetchLess(
                                                      widget.user.department!),
                                                  style: GlobalHelper.textStyle(
                                                      TextStyle(
                                                    color: themeProvider
                                                            .isDarkTheme
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  )),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                widget.user.managerName != null &&
                                        widget.user.managerName != "null"
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              getTicketStatusTitleContentUI(
                                                  title: 'Role'),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 0, 15, 15),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  decoration: BoxDecoration(
                                                      color: themeProvider
                                                              .isDarkTheme
                                                          ? const Color
                                                              .fromRGBO(
                                                              16, 18, 33, 1)
                                                          : const Color(
                                                              0xfff3f1ef),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  15))),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Center(
                                                      child: Text(
                                                        fetchLess(widget.user
                                                            .assignedRoles!),
                                                        style: GlobalHelper
                                                            .textStyle(
                                                                TextStyle(
                                                          color: themeProvider
                                                                  .isDarkTheme
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              getTicketStatusTitleContentUI(
                                                  title: 'Reporting Manager'),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 0, 15, 15),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  decoration: BoxDecoration(
                                                      color: themeProvider
                                                              .isDarkTheme
                                                          ? const Color
                                                              .fromRGBO(
                                                              16, 18, 33, 1)
                                                          : const Color(
                                                              0xfff3f1ef),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  15))),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Center(
                                                      child: Text(
                                                        widget
                                                            .user.managerName!,
                                                        style: GlobalHelper
                                                            .textStyle(
                                                                TextStyle(
                                                          color: themeProvider
                                                                  .isDarkTheme
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Role'),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 0, 15, 15),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              decoration: BoxDecoration(
                                                  color: themeProvider
                                                          .isDarkTheme
                                                      ? const Color.fromRGBO(
                                                          16, 18, 33, 1)
                                                      : const Color(0xfff3f1ef),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(15))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Center(
                                                  child: Text(
                                                    fetchLess(widget
                                                        .user.assignedRoles!),
                                                    style:
                                                        GlobalHelper.textStyle(
                                                            TextStyle(
                                                      color: themeProvider
                                                              .isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    )),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 50, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Visibility(
                            visible: widget.editButtonVisible,
                            child: getElevatedButtonIcon(
                                onPressed: () async {
                                  AssetProvider companyProvider =
                                      Provider.of<AssetProvider>(context,
                                          listen: false);

                                  AssetProvider assignRoleProvider =
                                      Provider.of<AssetProvider>(context,
                                          listen: false);

                                  await companyProvider.fetchCompanyDetails();
                                  await assignRoleProvider.fetchRoleDetails();

                                  userName = widget.user.name.toString();

                                  nameController.text =
                                      widget.user.name.toString();
                                  employeeController.text =
                                      widget.user.employeeId.toString();
                                  emailController.text =
                                      widget.user.email.toString();
                                  designationController.text =
                                      widget.user.designation.toString();
                                  phoneController.text =
                                      widget.user.phoneNumber.toString();
                                  dateController.text =
                                      widget.user.dateOfJoining.toString();
                                  selectedDepartmentList =
                                      List.from(widget.user.department!);

                                  selectedCompany = companyProvider
                                      .companyDetailsList
                                      .firstWhereOrNull((companyDetails) =>
                                          widget.user.company!.contains(
                                              companyDetails.name ?? ""));

                                  final concatenatedText =
                                      selectedCompany?.name;

                                  companyController.text =
                                      concatenatedText ?? "";

                                  selectedManager = userProvider.userDetailsList
                                      .firstWhereOrNull((userDetails) =>
                                          userDetails.managerName != null &&
                                          widget.user.managerName != null &&
                                          widget.user.managerName!.contains(
                                              userDetails.managerName!));

                                  final concatenatedUserText =
                                      selectedManager?.managerName;

                                  userController.text =
                                      concatenatedUserText ?? "";

                                  selectedRoleList = assignRoleProvider
                                      .fetchedRoleDetailsList
                                      .where((assignRoleDetails) {
                                    return widget.user.assignedRoles!
                                        .contains(assignRoleDetails.roleTitle);
                                  }).toList();

                                  currentRole = selectedRoleList.isNotEmpty
                                      ? selectedRoleList[0].roleTitle
                                      : "";

                                  tagList = List.from(widget.user.tag!);

                                  if (mounted) {
                                    passwordController.clear();
                                    showLargeUpdateUser(context);
                                  }
                                },
                                text: 'Edit'),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          getElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              text: 'Close')
                        ],
                      ),
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
      );
    });
  }

  String fetchLess(List<String> user) {
    if (user.isEmpty) {
      return "";
    } else if (user.length == 1) {
      return user[0];
    } else {
      return user.join(', ');
    }
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

  String? companyValidators(value) {
    if (selectedCompany == null) {
      return 'Dropdown Should be not Empty';
    } else {
      return null;
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
          if (isDropDownUserList[0] && completeCompanyList.isNotEmpty)
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
                isDropDownUserList[1] = true;
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

  Future<void> showLargeUpdateUser(BuildContext context) async {
    AssetProvider companyProvider =
        Provider.of<AssetProvider>(context, listen: false);
    AssetProvider assignRoleProvider =
        Provider.of<AssetProvider>(context, listen: false);
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          completeCompanyList = companyProvider.companyDetailsList;
          completeRoleList = assignRoleProvider.fetchedRoleDetailsList;
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
                              child: ClipOval(child: getImageWidget()),
                            ),
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
                                                onPressed: () {
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
                                                      _onTapEditButton();
                                                      Navigator.of(context)
                                                          .pop();
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

  validatePassword(String value) {
    setState(() {
      passwordError = updatePasswordValidator(value);
    });
  }

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

  Widget getImageWidget() {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    if (imagePicked != null) {
      return Image.memory(imagePicked!.bytes!, fit: BoxFit.cover);
    } else {
      return Image.network(
        '$websiteURL/images/${widget.user.image}',
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
            themeProvider.isDarkTheme
                ? 'assets/images/riota_logo.png'
                : 'assets/images/riota_logo2.png',
          );
        },
      );
    }
  }

  /// It will check the Existing Details of the Company and Edited or Not
  bool checkCompanyDetailsEditedOrNot() {
    Function eq = const ListEquality().equals;
    if (widget.user.name == nameController.text &&
        widget.user.employeeId == employeeController.text &&
        widget.user.email == emailController.text &&
        widget.user.password == passwordController.text &&
        widget.user.phoneNumber.toString() == phoneController.text &&
        widget.user.designation == designationController.text &&
        widget.user.dateOfJoining == dateController.text &&
        eq(widget.user.company, selectedCompany) &&
        eq(widget.user.department, selectedDepartmentList) &&
        eq(widget.user.assignedRoles, selectedRoleList) &&
        widget.user.managerName == userController.text &&
        eq(widget.user.tag, tagList)) {
      return false;
    } else {
      return true;
    }
  }

  _onTapEditButton() async {
    AssetProvider userProvider =
        Provider.of<AssetProvider>(context, listen: false);

    AssetProvider particularUserProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider boolProvider =
        Provider.of<BoolProvider>(context, listen: false);

    var userId = particularUserProvider.user!.sId.toString();

    final result = checkCompanyDetailsEditedOrNot();
    if (result || imagePicked != null) {
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
            assignRoleRefIds: selectedRoleList.map((e) => e.sId).toList(),
            companyRefId: selectedCompany?.sId,
            tag: tagList,
            sId: widget.user.sId.toString(),
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
            assignRoleRefIds: selectedRoleList.map((e) => e.sId).toList(),
            companyRefId: selectedCompany?.sId,
            tag: tagList,
            sId: widget.user.sId.toString(),
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
}
