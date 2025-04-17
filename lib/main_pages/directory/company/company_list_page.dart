import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../global/global_variables.dart';
import '../../../global/user_interaction_timer.dart';
import '../../../helpers/global_helper.dart';
import '../../../helpers/http_helper.dart';
import '../../../helpers/ui_components.dart';
import '../../../models/directory_model/company_model/company.dart';
import '../../../models/directory_model/company_model/company_details.dart';
import 'package:asset_management_local/provider/main_providers/asset_provider.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';
import 'add_company.dart';
import 'company_list_expanded_view.dart';

class CompanyList extends StatefulWidget {
  const CompanyList({super.key});

  @override
  State<CompanyList> createState() => _CompanyListState();
}

class _CompanyListState extends State<CompanyList>
    with TickerProviderStateMixin {
  String? dropDownValueCompany = "All";

  int selectedIndex = 0;
  int listPerPage = 5;
  int currentPage = 0;

  late AnimationController controller;
  late TableBorder startBorder;
  late TableBorder endBorder;
  late TableBorder currentBorder;

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController documentController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  TextEditingController contactEmailController = TextEditingController();
  TextEditingController contactPhoneNumberController = TextEditingController();
  TextEditingController contactPersonNameController = TextEditingController();
  TextEditingController contactPersonEmailController = TextEditingController();
  TextEditingController contactPersonPhoneNumberController =
      TextEditingController();

  List<String> department = [];
  List<String> departmentList = [];

  List<String> tag = [];
  List<String> tagList = [];

  List<GlobalKey<FormState>> formKeyStepCompany = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  PlatformFile? imagePicked;

  String selectedImageName = 'Image';

  int currentCompanyStep = 0;
  StepperType stepperType = StepperType.horizontal;

  bool selectAllCheckBox = false;

  late String image;
  late String companyId;

  List<CompanyDetails> filteredList = [];

  List<CompanyDetails> getPaginatedData() {
    AssetProvider companyProvider =
        Provider.of<AssetProvider>(context, listen: false);

    filteredList = (dropDownValueCompany == "All")
        ? companyProvider.companyDetailsList
        : companyProvider.companyDetailsList
            .where((company) => company.name == dropDownValueCompany)
            .toList();

    final startIndex = currentPage * listPerPage;
    final endIndex = (startIndex + listPerPage).clamp(0, filteredList.length);

    return filteredList.sublist(startIndex, endIndex);
  }

  String getDisplayedRange() {
    AssetProvider companyProvider =
        Provider.of<AssetProvider>(context, listen: false);

    filteredList = (dropDownValueCompany == "All")
        ? companyProvider.companyDetailsList
        : companyProvider.companyDetailsList
            .where((company) => company.name == dropDownValueCompany)
            .toList();

    final displayedListLength = filteredList.length;
    final startIndex = currentPage * listPerPage + 1;
    final endIndex =
        (startIndex + listPerPage - 1).clamp(0, displayedListLength);

    return '$startIndex-$endIndex of $displayedListLength';
  }

  @override
  void initState() {
    super.initState();
    Provider.of<AssetProvider>(context, listen: false).fetchCompanyDetails();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BoolProvider boolProviders = Provider.of<BoolProvider>(context);

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


    return Consumer2<BoolProvider, AssetProvider>(
        builder: (context, boolProvider, companyProvider, child) {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                          child: Row(
                            children: [
                              Text(
                                "Company List",
                                style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                  fontSize: 20,
                                  color: boolProvider.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                              ),
                              if(companyProvider.userRole.companyWriteFlag)...[ const DialogRoot(dialog: AddCompany())]

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
                                text: " Company",
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
                                  icon: const Icon(
                                      Icons.arrow_circle_left_rounded),
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
                                  icon: const Icon(
                                      Icons.arrow_circle_right_rounded),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.4))
                        : companyProvider.companyDetailsList.isNotEmpty
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
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Checkbox(
                                                  side: MaterialStateBorderSide
                                                      .resolveWith(
                                                    (states) =>
                                                        const BorderSide(
                                                            width: 1.0,
                                                            color: Colors.blue),
                                                  ),
                                                  value: selectAllCheckBox,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      selectAllCheckBox =
                                                          value ?? false;
                                                      companyProvider
                                                              .selectedCompanies =
                                                          List.generate(
                                                              companyProvider
                                                                  .selectedCompanies
                                                                  .length,
                                                              (index) =>
                                                                  selectAllCheckBox);
                                                    });
                                                    if (selectAllCheckBox) {
                                                      boolProviders
                                                          .setDeleteVisibility(
                                                              true);
                                                    } else {
                                                      boolProviders
                                                          .setDeleteVisibility(
                                                              false);
                                                    }
                                                  }),
                                            ),
                                          ),
                                          if(companyProvider.userRole.companyWriteFlag)...[
                                            Center(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    boolProviders.setVisibility(
                                                        !boolProvider.isVisible);
                                                  },
                                                  child: Text(
                                                    "Select",
                                                    style: GoogleFonts.ubuntu(
                                                        textStyle:
                                                        const TextStyle(
                                                          fontSize: 15,
                                                          color: Color.fromRGBO(
                                                              117, 117, 117, 1),
                                                        )),
                                                  ),
                                                ),
                                              ),
                                            )
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
                                        text: "Address",
                                      ),
                                      getTitleText(
                                        text: "Contact",
                                      ),
                                      getTitleText(
                                        text: "Contact Person",
                                      ),
                                      getTitleText(
                                        text: "Departments",
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
                                      CompanyDetails company = entry.value;

                                      return TableRow(
                                          decoration: BoxDecoration(
                                              color: boolProvider.isDarkTheme
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
                                                  visible:
                                                      boolProvider.isVisible,
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
                                                                  color: Colors
                                                                      .blue),
                                                        ),
                                                        value: companyProvider
                                                                .selectedCompanies
                                                                .isNotEmpty
                                                            ? companyProvider
                                                                    .selectedCompanies[
                                                                index]
                                                            : false,
                                                        onChanged:
                                                            (bool? value) {
                                                          setState(() {
                                                            companyProvider
                                                                        .selectedCompanies[
                                                                    index] =
                                                                value ?? false;
                                                            selectAllCheckBox =
                                                                companyProvider
                                                                    .selectedCompanies
                                                                    .every(
                                                                        (item) =>
                                                                            item);
                                                          });

                                                          bool showDelete =
                                                              companyProvider
                                                                  .selectedCompanies
                                                                  .any((item) =>
                                                                      item);
                                                          boolProviders
                                                              .setDeleteVisibility(
                                                                  showDelete);
                                                        }),
                                                  ),
                                                ),
                                                Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 20),
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
                                                          child: Image.network(
                                                            '$websiteURL/images/${company.image}',
                                                            loadingBuilder:
                                                                (BuildContext
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
                                                            errorBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    Object
                                                                        error,
                                                                    StackTrace?
                                                                        stackTrace) {
                                                              return Image.asset(
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
                                                text: company.displayId
                                                    .toString(),
                                                maxLines: 1,
                                                color: themeProvider.isDarkTheme
                                                    ? const Color.fromRGBO(
                                                        200, 200, 200, 1)
                                                    : const Color.fromRGBO(
                                                        117, 117, 117, 1)),
                                            getContentText(
                                                text: company.name.toString(),
                                                maxLines: 1,
                                                color: themeProvider.isDarkTheme
                                                    ? const Color.fromRGBO(
                                                        200, 200, 200, 1)
                                                    : const Color.fromRGBO(
                                                        117, 117, 117, 1)),
                                            Column(
                                              children: [
                                                getContentText(
                                                    text:
                                                        "${company.address?.address!}",
                                                    maxLines: 1,
                                                    color: themeProvider
                                                            .isDarkTheme
                                                        ? const Color.fromRGBO(
                                                            200, 200, 200, 1)
                                                        : const Color.fromRGBO(
                                                            117, 117, 117, 1)),
                                                getContentText(
                                                    text:
                                                        "${company.address?.city!}",
                                                    maxLines: 1,
                                                    color: themeProvider
                                                            .isDarkTheme
                                                        ? const Color.fromRGBO(
                                                            200, 200, 200, 1)
                                                        : const Color.fromRGBO(
                                                            117, 117, 117, 1)),
                                                getContentText(
                                                    text:
                                                        "${company.address?.state!}",
                                                    maxLines: 1,
                                                    color: themeProvider
                                                            .isDarkTheme
                                                        ? const Color.fromRGBO(
                                                            200, 200, 200, 1)
                                                        : const Color.fromRGBO(
                                                            117, 117, 117, 1)),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  getContentText(
                                                      text: company.phoneNumber
                                                          .toString(),
                                                      maxLines: 1,
                                                      color: themeProvider
                                                              .isDarkTheme
                                                          ? const Color
                                                              .fromRGBO(
                                                              200, 200, 200, 1)
                                                          : const Color
                                                              .fromRGBO(117,
                                                              117, 117, 1)),
                                                  getContentText(
                                                      text: company.email
                                                          .toString(),
                                                      maxLines: 1,
                                                      color: themeProvider
                                                              .isDarkTheme
                                                          ? const Color
                                                              .fromRGBO(
                                                              200, 200, 200, 1)
                                                          : const Color
                                                              .fromRGBO(117,
                                                              117, 117, 1)),
                                                  getContentText(
                                                      text: company.website
                                                          .toString(),
                                                      maxLines: 1,
                                                      color: themeProvider
                                                              .isDarkTheme
                                                          ? const Color
                                                              .fromRGBO(
                                                              200, 200, 200, 1)
                                                          : const Color
                                                              .fromRGBO(117,
                                                              117, 117, 1)),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                getContentText(
                                                    text: company
                                                        .contactPersonName
                                                        .toString(),
                                                    maxLines: 1,
                                                    color: themeProvider
                                                            .isDarkTheme
                                                        ? const Color.fromRGBO(
                                                            200, 200, 200, 1)
                                                        : const Color.fromRGBO(
                                                            117, 117, 117, 1)),
                                                getContentText(
                                                    text: company
                                                        .contactPersonPhoneNumber
                                                        .toString(),
                                                    maxLines: 1,
                                                    color: themeProvider
                                                            .isDarkTheme
                                                        ? const Color.fromRGBO(
                                                            200, 200, 200, 1)
                                                        : const Color.fromRGBO(
                                                            117, 117, 117, 1)),
                                                getContentText(
                                                    text: company
                                                        .contactPersonEmail
                                                        .toString(),
                                                    maxLines: 1,
                                                    color: themeProvider
                                                            .isDarkTheme
                                                        ? const Color.fromRGBO(
                                                            200, 200, 200, 1)
                                                        : const Color.fromRGBO(
                                                            117, 117, 117, 1)),
                                              ],
                                            ),
                                            getContentText(
                                                text: fetchDepartment(
                                                    company.departments!),
                                                maxLines: 1,
                                                color: themeProvider.isDarkTheme
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
                                                        CompanyListExpandedView(
                                                            company: company)),
                                                if(companyProvider.userRole.companyWriteFlag)...[
                                                  CustomActionIcon(
                                                    message: "Edit",
                                                    preferBelow: true,
                                                    iconImage: const Icon(
                                                        Icons.edit_rounded),
                                                    color: const Color.fromRGBO(
                                                        15, 117, 188, 1),
                                                    onPressed: () {
                                                      int actualIndex =
                                                          (currentPage *
                                                              listPerPage) +
                                                              index;

                                                      CompanyDetails company =
                                                      filteredList[
                                                      actualIndex];

                                                      companyId =
                                                          company.sId ?? "";
                                                      image = company.image ?? '';
                                                      nameController.text =
                                                      company.name!;

                                                      addressController.text =
                                                      company
                                                          .address!.address!;
                                                      cityController.text =
                                                      company.address!.city!;
                                                      stateController.text =
                                                      company.address!.state!;
                                                      countryController.text =
                                                      company
                                                          .address!.country!;
                                                      landmarkController.text =
                                                      company
                                                          .address!.landMark!;
                                                      codeController.text =
                                                          company
                                                              .address!.pinCode!
                                                              .toString();
                                                      contactEmailController
                                                          .text = company.email!;
                                                      contactPhoneNumberController
                                                          .text =
                                                          company.phoneNumber!
                                                              .toString();
                                                      websiteController.text =
                                                      company.website!;
                                                      contactPersonNameController
                                                          .text =
                                                      company
                                                          .contactPersonName!;
                                                      contactPersonEmailController
                                                          .text =
                                                      company
                                                          .contactPersonEmail!;
                                                      contactPersonPhoneNumberController
                                                          .text =
                                                          company
                                                              .contactPersonPhoneNumber!
                                                              .toString();
                                                      departmentList = List.from(
                                                          company.departments!);
                                                      tagList =
                                                          List.from(company.tag!);

                                                      showLargeScreenUpdateCompany(
                                                          context, actualIndex);
                                                    },
                                                  ),
                                                  CustomActionIcon(
                                                    message: "Delete",
                                                    preferBelow: false,
                                                    iconImage: const Icon(
                                                        Icons.delete_rounded),
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      showAlertDialog(context,
                                                          companyId: company
                                                              .displayId
                                                              .toString(),
                                                          color: boolProvider
                                                              .isDarkTheme
                                                              ? Colors.white
                                                              : Colors.black,
                                                          containerColor:
                                                          boolProvider
                                                              .isDarkTheme
                                                              ? Colors.black
                                                              : Colors.white,
                                                          onPressed: () async {
                                                            String? companyIdDelete =
                                                            company.sId
                                                                .toString();

                                                            if (mounted) {
                                                              Navigator.of(context)
                                                                  .pop();
                                                            }

                                                            await deleteCompany(
                                                                companyIdDelete,
                                                                themeProvider,
                                                                companyProvider);
                                                          });
                                                    },
                                                  ),
                                                ]

                                              ],
                                            ),
                                          ]);
                                    }).toList(),
                                  ],
                                ),
                              )
                            : Center(
                                child: Lottie.asset(
                                    "assets/lottie/data_not_found.json",
                                    repeat: false,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height *
                                        0.4),
                              ),
                    const SizedBox(
                      height: 15,
                    ),
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
                          List<CompanyDetails> selectedCompaniesList =
                              getSelectedCompany();

                          List<TableRow> tableRows = [];

                          tableRows.add(getTableDeleteForMultipleId(
                              title: "S.NO", content: "ID"));

                          for (int index = 0;
                              index < selectedCompaniesList.length;
                              index++) {
                            CompanyDetails company =
                                selectedCompaniesList[index];
                            tableRows.add(
                              getTableDeleteForMultipleId(
                                  title: (index + 1).toString(),
                                  content: company.displayId.toString()),
                            );
                          }

                          return AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "Delete the Selected Company",
                                style: GlobalHelper.textStyle(const TextStyle(
                                  color: Colors.black,
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

  showAlertDialog(BuildContext context,
      {required onPressed,
      required color,
      required containerColor,
      required companyId}) {
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
          "Delete Company",
          style: GlobalHelper.textStyle(TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          )),
        ),
      ),
      content: getTableDeleteForSingleId(id: companyId, color: color),
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
    AssetProvider companyProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider boolProvider =
        Provider.of<BoolProvider>(context, listen: false);

    List<String> idsToDelete = [];
    for (int i = 0; i < companyProvider.selectedCompanies.length; i++) {
      if (companyProvider.selectedCompanies[i]) {
        idsToDelete.add(companyProvider.companyDetailsList[i].sId.toString());
      }
    }

    for (String companyId in idsToDelete) {
      await deleteCompany(companyId, boolProvider, companyProvider);
    }

    setState(() {
      companyProvider.companyDetailsList.removeWhere(
          (company) => idsToDelete.contains(company.sId.toString()));
      selectAllCheckBox = false;
    });
  }

  List<CompanyDetails> getSelectedCompany() {
    AssetProvider companyProvider =
        Provider.of<AssetProvider>(context, listen: false);

    List<CompanyDetails> selectedCompaniesList = [];
    for (int i = 0; i < companyProvider.companyDetailsList.length; i++) {
      if (companyProvider.selectedCompanies[i]) {
        selectedCompaniesList.add(companyProvider.companyDetailsList[i]);
      }
    }
    return selectedCompaniesList;
  }

  Future<void> showLargeScreenUpdateCompany(
      BuildContext context, int index) async {
    currentCompanyStep = 0;
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
                  backgroundColor: const Color(0xfff3f1ef),
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
                    height: MediaQuery.of(context).size.height * 0.88,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "UPDATE COMPANY",
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
                                            ImageChunkEvent? loadingProgress) {
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
                              ),
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
                              currentStep: currentCompanyStep,
                              elevation: 0,
                              onStepTapped: (step) {
                                if (formKeyStepCompany[currentCompanyStep]
                                    .currentState!
                                    .validate()) {
                                  setState(() {
                                    currentCompanyStep = step;
                                  });
                                }
                              },
                              steps: getStepsCompanyDialog(setState,
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
                                        if (currentCompanyStep != 0)
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
                                                      currentCompanyStep -= 1;
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
                                                  final steps = getStepsCompanyDialog(
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

                                                  if (currentCompanyStep <
                                                      steps.length - 1) {
                                                    if (formKeyStepCompany[
                                                            currentCompanyStep]
                                                        .currentState!
                                                        .validate()) {
                                                      setState(() {
                                                        currentCompanyStep++;
                                                      });
                                                    } else {
                                                      return;
                                                    }
                                                  } else {
                                                    if (formKeyStepCompany[
                                                            currentCompanyStep]
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
                                                  currentCompanyStep == 3
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
                        )
                      ],
                    ),
                  )),
            );
          });
        });
  }

  List<Step> getStepsCompanyDialog(StateSetter setState,
          {required color,
          required colors,
          required borderColor,
          required textColor,
          required fillColor,
          required containerColor,
          required dividerColor}) =>
      [
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
            key: formKeyStepCompany[0],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    margin: const EdgeInsets.all(2.0),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(67, 66, 66, 0.060),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    height: MediaQuery.of(context).size.height * 0.39,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getDialogExtraContentsUI(
                                    hintText: 'Company Name',
                                    controllers: nameController,
                                    width: MediaQuery.of(context).size.width *
                                        0.20,
                                    type: TextInputType.name,
                                    validators: commonValidator,
                                    dialogSetState: setState,
                                    textColor: textColor,
                                    color: colors,
                                    borderColor: borderColor),
                                Column(
                                  children: [
                                    getDialogExtraContentsUI(
                                        hintText: 'City / Town',
                                        controllers: cityController,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        type: TextInputType.text,
                                        validators: commonValidator,
                                        textColor: textColor,
                                        color: colors,
                                        borderColor: borderColor,
                                        dialogSetState: setState),
                                  ],
                                ),
                              ]),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getDialogAddressUI(
                                hintText: 'Address',
                                controllers: addressController,
                                width: MediaQuery.of(context).size.width * 0.20,
                                type: TextInputType.text,
                                validators: commonValidator,
                                textColor: textColor,
                                color: colors,
                                borderColor: borderColor,
                                dialogSetState: setState,
                              ),
                              Column(
                                children: [
                                  getDialogExtraContentsUI(
                                      hintText: 'State',
                                      controllers: stateController,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      type: TextInputType.text,
                                      validators: commonValidator,
                                      textColor: textColor,
                                      color: colors,
                                      borderColor: borderColor,
                                      dialogSetState: setState),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  getDialogExtraContentsUI(
                                      hintText: 'Country',
                                      controllers: countryController,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      type: TextInputType.text,
                                      validators: commonValidator,
                                      textColor: textColor,
                                      color: colors,
                                      borderColor: borderColor,
                                      dialogSetState: setState),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getDialogExtraContentsUI(
                                  hintText: 'Land Mark',
                                  controllers: landmarkController,
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  type: TextInputType.text,
                                  validators: commonValidator,
                                  textColor: textColor,
                                  color: colors,
                                  borderColor: borderColor,
                                  dialogSetState: setState),
                              getDialogExtraContentsUI(
                                  hintText: 'Pin Code',
                                  controllers: codeController,
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  type: TextInputType.number,
                                  validators: commonValidator,
                                  textColor: textColor,
                                  color: colors,
                                  borderColor: borderColor,
                                  dialogSetState: setState),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
          state:
              currentCompanyStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentCompanyStep == 0,
        ),
        Step(
          title: Text(
            'Contact Details',
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Form(
            key: formKeyStepCompany[1],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    margin: const EdgeInsets.all(2.0),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(67, 66, 66, 0.060),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    height: MediaQuery.of(context).size.height * 0.21,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getDialogContentsUILargeScreenPhoneNumber(
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  hintText: "Phone Number",
                                  suffixIcon: Icons.phone,
                                  iconColor:
                                      const Color.fromRGBO(117, 117, 117, 1),
                                  controllers: contactPhoneNumberController,
                                  type: TextInputType.phone,
                                  dialogSetState: setState,
                                  textColor: textColor,
                                  color: colors,
                                  borderColor: borderColor,
                                  validators: mobileValidator),
                              getDialogContentsUILargeScreen(
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  hintText: "Email ID",
                                  suffixIcon: Icons.mail,
                                  iconColor:
                                      const Color.fromRGBO(117, 117, 117, 1),
                                  controllers: contactEmailController,
                                  type: TextInputType.emailAddress,
                                  dialogSetState: setState,
                                  textColor: textColor,
                                  color: colors,
                                  borderColor: borderColor,
                                  validators: emailValidator),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: getDialogExtraContentsUI(
                                hintText: 'Website',
                                controllers: websiteController,
                                width: MediaQuery.of(context).size.width * 0.20,
                                type: TextInputType.url,
                                dialogSetState: setState,
                                textColor: textColor,
                                color: colors,
                                borderColor: borderColor,
                                validators: commonValidator),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 140,
                ),
              ],
            ),
          ),
          state:
              currentCompanyStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentCompanyStep == 1,
        ),
        Step(
          title: Text(
            'Contact Person',
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Form(
            key: formKeyStepCompany[2],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    margin: const EdgeInsets.all(2.0),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(67, 66, 66, 0.060),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    height: MediaQuery.of(context).size.height * 0.21,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getDialogExtraContentsUI(
                                  hintText: 'Name',
                                  controllers: contactPersonNameController,
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  type: TextInputType.name,
                                  dialogSetState: setState,
                                  textColor: textColor,
                                  color: colors,
                                  borderColor: borderColor,
                                  validators: commonValidator),
                              getDialogContentsUILargeScreenPhoneNumber(
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  hintText: "Phone Number",
                                  suffixIcon: Icons.phone,
                                  iconColor:
                                      const Color.fromRGBO(117, 117, 117, 1),
                                  controllers:
                                      contactPersonPhoneNumberController,
                                  type: TextInputType.phone,
                                  textColor: textColor,
                                  color: colors,
                                  borderColor: borderColor,
                                  dialogSetState: setState,
                                  validators: mobileValidator),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          getDialogContentsUILargeScreen(
                              width: MediaQuery.of(context).size.width * 0.20,
                              hintText: "Email ID",
                              suffixIcon: Icons.mail,
                              iconColor: const Color.fromRGBO(117, 117, 117, 1),
                              controllers: contactPersonEmailController,
                              type: TextInputType.emailAddress,
                              dialogSetState: setState,
                              textColor: textColor,
                              color: colors,
                              borderColor: borderColor,
                              validators: emailValidator),
                          const SizedBox(
                            height: 35,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 140,
                )
              ],
            ),
          ),
          state:
              currentCompanyStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentCompanyStep == 2,
        ),
        Step(
          title: Text(
            'Department',
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Form(
            key: formKeyStepCompany[3],
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
                        children: [
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
                                            0, 10, 0, 0),
                                        child:
                                            getDialogDropDownDepartmentContentsUI(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.20,
                                          validators: dropDownValidators,
                                          dialogSetState: setState,
                                        ),
                                      ),
                                      if (departmentList.isNotEmpty)
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
                                        dialogSetState: setState,
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
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 18, 0, 0),
                                        child: getDialogTagContentsUI(
                                          hintText: 'Tag',
                                          controllers: tagController,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.20,
                                          dialogSetState: setState,
                                          type: TextInputType.text,
                                          borderColor: borderColor,
                                          textColor: textColor,
                                          containerColor: containerColor,
                                          fillColor: fillColor,
                                        ),
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        dialogSetState: setState,
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
                  height: 35,
                )
              ],
            ),
          ),
          state:
              currentCompanyStep > 3 ? StepState.complete : StepState.indexed,
          isActive: currentCompanyStep == 3,
        ),
      ];

  String? addressValidator(value) {
    if (addressController.text.isEmpty ||
        cityController.text.isEmpty ||
        stateController.text.isEmpty ||
        countryController.text.isEmpty ||
        landmarkController.text.isEmpty ||
        codeController.text.isEmpty) {
      return 'Field should not be Empty';
    } else {
      return null;
    }
  }

  String? contactValidator(value) {
    if (websiteController.text.isEmpty ||
        contactEmailController.text.isEmpty ||
        contactPhoneNumberController.text.isEmpty) {
      return 'Field should not be Empty';
    } else {
      return null;
    }
  }

  String? contactPersonValidator(value) {
    if (contactPersonNameController.text.isEmpty ||
        contactPersonEmailController.text.isEmpty ||
        contactPersonPhoneNumberController.text.isEmpty) {
      return 'Field should not be Empty';
    } else {
      return null;
    }
  }

  /// It contain the Address Details of the field
  Widget getAddressUIContent() {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.045),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 30,
                  child: IntrinsicHeight(
                    child: VerticalDivider(
                      thickness: 3.5,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
        getDialogAddressUI(
            hintText: 'Address',
            controllers: addressController,
            width: MediaQuery.of(context).size.width * 0.20,
            type: TextInputType.text,
            dialogSetState: setState),
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.045),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 30,
                  child: IntrinsicHeight(
                    child: VerticalDivider(
                      thickness: 3.5,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
        getDialogExtraContentsUI(
            hintText: 'City / Town',
            controllers: cityController,
            width: MediaQuery.of(context).size.width * 0.20,
            type: TextInputType.text,
            dialogSetState: setState),
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.045),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 30,
                  child: IntrinsicHeight(
                    child: VerticalDivider(
                      thickness: 3.5,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
        getDialogExtraContentsUI(
            hintText: 'State',
            controllers: stateController,
            width: MediaQuery.of(context).size.width * 0.20,
            type: TextInputType.text,
            dialogSetState: setState),
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.045),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 30,
                  child: IntrinsicHeight(
                    child: VerticalDivider(
                      thickness: 3.5,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
        getDialogExtraContentsUI(
            hintText: 'Country',
            controllers: countryController,
            width: MediaQuery.of(context).size.width * 0.20,
            type: TextInputType.text,
            dialogSetState: setState),
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.045),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 30,
                  child: IntrinsicHeight(
                    child: VerticalDivider(
                      thickness: 3.5,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
        getDialogExtraContentsUI(
            hintText: 'Land Mark',
            controllers: landmarkController,
            width: MediaQuery.of(context).size.width * 0.20,
            type: TextInputType.text,
            dialogSetState: setState),
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.045),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 30,
                  child: IntrinsicHeight(
                    child: VerticalDivider(
                      thickness: 3.5,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
        getDialogExtraContentsUI(
            hintText: 'Pin Code',
            controllers: codeController,
            width: MediaQuery.of(context).size.width * 0.20,
            type: TextInputType.number,
            validators: pinCodeValidator,
            dialogSetState: setState),
      ],
    );
  }

  /// It contain the Contact Details of the field
  Widget getContactUIContent() {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.045),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 30,
                  child: IntrinsicHeight(
                    child: VerticalDivider(
                      thickness: 3.5,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
        getDialogExtraContentsUI(
            hintText: 'Phone Number',
            controllers: contactPhoneNumberController,
            width: MediaQuery.of(context).size.width * 0.20,
            type: TextInputType.text,
            validators: mobileValidator,
            dialogSetState: setState),
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.045),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 30,
                  child: IntrinsicHeight(
                    child: VerticalDivider(
                      thickness: 3.5,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
        getDialogExtraContentsUI(
            hintText: 'E-Mail ID',
            controllers: contactEmailController,
            width: MediaQuery.of(context).size.width * 0.20,
            type: TextInputType.text,
            validators: emailValidator,
            dialogSetState: setState),
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.045),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 30,
                  child: IntrinsicHeight(
                    child: VerticalDivider(
                      thickness: 3.5,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
        getDialogExtraContentsUI(
            hintText: 'Website',
            controllers: websiteController,
            width: MediaQuery.of(context).size.width * 0.20,
            type: TextInputType.url,
            dialogSetState: setState),
      ],
    );
  }

  /// It contain the Contact Person Details of the field
  Widget getContactPersonUIContent() {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.045),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 30,
                  child: IntrinsicHeight(
                    child: VerticalDivider(
                      thickness: 3.5,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
        getDialogExtraContentsUI(
            hintText: 'Name',
            controllers: contactPersonNameController,
            width: MediaQuery.of(context).size.width * 0.20,
            type: TextInputType.text,
            dialogSetState: setState),
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.045),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 30,
                  child: IntrinsicHeight(
                    child: VerticalDivider(
                      thickness: 3.5,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
        getDialogExtraContentsUI(
            hintText: 'E-Mail ID',
            controllers: contactPersonEmailController,
            width: MediaQuery.of(context).size.width * 0.20,
            type: TextInputType.text,
            validators: emailValidator,
            dialogSetState: setState),
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.045),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 30,
                  child: IntrinsicHeight(
                    child: VerticalDivider(
                      thickness: 3.5,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
        getDialogExtraContentsUI(
            hintText: 'Phone Number',
            controllers: contactPersonPhoneNumberController,
            width: MediaQuery.of(context).size.width * 0.20,
            type: TextInputType.number,
            validators: mobileValidator,
            dialogSetState: setState),
      ],
    );
  }

  /// It contain the Dropdown of the Department List
  Widget getDialogDropDownDepartmentContentsUI(
      {required StateSetter dialogSetState,
      required double width,
      required validators}) {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
      child: SizedBox(
        width: width,
        child: Stack(
          children: [
            TextFormField(
              controller: departmentController,
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
                suffixIcon: IconButton(
                  color: const Color.fromRGBO(15, 117, 188, 1),
                  onPressed: () {
                    final departmentExtraText = departmentController.text;
                    if (departmentExtraText.isNotEmpty) {
                      dialogSetState(() {
                        departmentList.add(departmentExtraText);
                        departmentController.clear();
                      });
                    } else {
                      return;
                    }
                  },
                  icon: const Icon(Icons.add_circle),
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
            ),
            if (isExpansionDirectoryList[3] && department.isNotEmpty)
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
                    itemCount: department.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          department[index],
                          style: GlobalHelper.textStyle(TextStyle(
                              color: themeProvider.isDarkTheme
                                  ? Colors.white
                                  : const Color.fromRGBO(117, 117, 117, 1))),
                        ),
                        onTap: () {
                          dialogSetState(() {
                            departmentList.add(department[index]);
                            departmentController.clear();
                            isExpansionDirectoryList[3] = false;
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

  /// It contain only container with expand the content
  Widget getDialogExpansionContentsUI(
      {required double width,
      required StateSetter dialogSetState,
      required onPressed,
      required IconData icon,
      required String text}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
      child: Container(
        width: width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
              child: Text(
                text,
                style: GlobalHelper.textStyle(
                  const TextStyle(
                    color: Color.fromRGBO(117, 117, 117, 1),
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: onPressed,
                icon: Icon(
                  icon,
                  color: const Color.fromRGBO(15, 117, 188, 1),
                ))
          ],
        ),
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
          itemCount: departmentList.length,
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
                        departmentList[index],
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
                            departmentList.removeAt(index);
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

  Widget getDialogTagContentsUI({
    required String hintText,
    required TextEditingController controllers,
    required double width,
    required StateSetter dialogSetState,
    required TextInputType type,
    borderColor,
    textColor,
    fillColor,
    containerColor,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: SizedBox(
        width: width,
        child: Stack(
          children: [
            TextFormField(
              controller: controllers,
              keyboardType: type,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                contentPadding: const EdgeInsets.all(15),
                suffixIcon: IconButton(
                  color: const Color.fromRGBO(15, 117, 188, 1),
                  onPressed: () {
                    final tagExtraText = tagController.text;
                    if (tagExtraText.isNotEmpty) {
                      dialogSetState(() {
                        tagList.add(tagExtraText);
                        tagController.clear();
                      });
                    } else {
                      return;
                    }
                  },
                  icon: const Icon(Icons.add_circle),
                ),
                hintText: hintText,
                hintStyle: GlobalHelper.textStyle(
                  TextStyle(
                    color: textColor,
                    fontSize: 15,
                  ),
                ),
                fillColor: fillColor,
                filled: true,
              ),
              style: TextStyle(color: textColor),
            ),
            if (isExpansionDirectoryList[6] && tag.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: containerColor,
                  ),
                  margin: const EdgeInsets.only(top: 50),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: tag.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          tag[index],
                          style: GlobalHelper.textStyle(
                              TextStyle(color: textColor)),
                        ),
                        onTap: () {
                          dialogSetState(() {
                            tagList.add(tag[index]);
                            tagController.clear();
                            isExpansionDirectoryList[6] = false;
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

  Widget getTagListDialogContentsUI(
      {required double width,
      required StateSetter dialogSetState,
      color,
      textColor}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Container(
        width: width,
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: tagList.length,
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
                        tagList[index],
                        style: GlobalHelper.textStyle(TextStyle(
                          color: textColor,
                          fontSize: 15,
                        )),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          dialogSetState(() {
                            tagList.removeAt(index);
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

  String? dropDownValidators(value) {
    if (departmentList.isEmpty) {
      return 'Dropdown Should be not Empty';
    } else {
      return null;
    }
  }

  Widget getImageWidget(int index) {
    AssetProvider companyProvider =
        Provider.of<AssetProvider>(context, listen: false);

    if (imagePicked != null) {
      return Image.memory(imagePicked!.bytes!, fit: BoxFit.cover);
    } else {
      return Image.network(
        '$websiteURL/images/${companyProvider.companyDetailsList[index].image}',
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
  bool checkCompanyDetailsEditedOrNot(int index) {
    AssetProvider companyProvider =
        Provider.of<AssetProvider>(context, listen: false);

    Function eq = const ListEquality().equals;
    if (companyProvider.companyDetailsList[index].name == nameController.text &&
        companyProvider.companyDetailsList[index].address!.address ==
            addressController.text &&
        companyProvider.companyDetailsList[index].address!.city ==
            cityController.text &&
        companyProvider.companyDetailsList[index].address!.state ==
            stateController.text &&
        companyProvider.companyDetailsList[index].address!.landMark ==
            landmarkController.text &&
        companyProvider.companyDetailsList[index].address!.country ==
            countryController.text &&
        companyProvider.companyDetailsList[index].address!.pinCode.toString() ==
            codeController.text &&
        companyProvider.companyDetailsList[index].email ==
            contactEmailController.text &&
        companyProvider.companyDetailsList[index].phoneNumber.toString() ==
            contactPhoneNumberController.text &&
        companyProvider.companyDetailsList[index].website ==
            websiteController.text &&
        companyProvider.companyDetailsList[index].contactPersonName ==
            contactPersonNameController.text &&
        companyProvider.companyDetailsList[index].contactPersonEmail ==
            contactPersonEmailController.text &&
        companyProvider.companyDetailsList[index].contactPersonPhoneNumber
                .toString() ==
            contactPersonPhoneNumberController.text &&
        eq(companyProvider.companyDetailsList[index].departments,
            departmentList) &&
        eq(companyProvider.companyDetailsList[index].tag, tagList)) {
      return false;
    } else {
      return true;
    }
  }

  _onTapEditButton(int index) async {
    AssetProvider companyProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider boolProvider =
        Provider.of<BoolProvider>(context, listen: false);

    final result = checkCompanyDetailsEditedOrNot(index);
    if (result || imagePicked != null) {
      Company company = Company(
          name: nameController.text.toString(),
          address: {
            "address": addressController.text.toString(),
            "city": cityController.text.toString(),
            "state": stateController.text.toString(),
            "country": countryController.text.toString(),
            "landMark": landmarkController.text.toString(),
            "pinCode": int.tryParse(codeController.text.toString()),
          },
          email: contactEmailController.text.toString(),
          phoneNumber: contactPhoneNumberController.text.toString(),
          website: websiteController.text.toString(),
          contactPersonName: contactPersonNameController.text.toString(),
          contactPersonPhoneNumber:
              contactPersonPhoneNumberController.text.toString(),
          contactPersonEmail: contactPersonEmailController.text.toString(),
          departments: departmentList,
          image: imagePicked?.name,
          tag: tagList,
          sId: companyId);
      await updateCompany(company, boolProvider, companyProvider);
    } else {
      /// User not changed anything...
    }
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

  String fetchDepartment(List<String> departments) {
    if (departments.isEmpty) {
      return "";
    } else if (departments.length == 1) {
      return departments[0];
    } else if (departments.length > 1) {
      return "${departments.first}...";
    } else {
      return departments.join(', ');
    }
  }

  Widget getCompanyDropDownContentUI() {
    AssetProvider companyProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    List<String> dropdownItems = ["All"];
    dropdownItems.addAll(companyProvider.companyDetailsList
        .map((company) => company.name!)
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
                )),
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

  Future<void> updateCompany(Company company, BoolProvider boolProviders,
      AssetProvider companyProvider) async {
    await AddUpdateDetailsManagerWithImage(
      data: company,
      image: imagePicked,
      apiURL: 'company/updateCompany',
    ).addUpdateDetailsWithImages(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("Company Updated Successfully");
        companyProvider.fetchCompanyDetails();
      });
    } else {
      setState(() {
        showToast("Unable to update the company");
      });
    }
  }

  Future<void> deleteCompany(String companyId, BoolProvider boolProviders,
      AssetProvider companyProvider) async {
    await DeleteDetailsManager(
      apiURL: 'company/deleteCompany',
      id: companyId,
    ).deleteDetails(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("Company Deleted Successfully");
        companyProvider.fetchCompanyDetails();
      });
    } else {
      setState(() {
        showToast("Unable to delete the company");
      });
    }
  }
}
