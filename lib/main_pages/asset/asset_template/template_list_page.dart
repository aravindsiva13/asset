import 'dart:developer';
import 'package:asset_management_local/main_pages/asset/asset_template/add_template.dart';
import 'package:asset_management_local/main_pages/asset/asset_template/template_list_expanded_view.dart';
import 'package:asset_management_local/models/asset_model/asset_template_model/asset_template_details.dart';
import 'package:asset_management_local/provider/main_providers/asset_provider.dart';
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
import '../../../models/asset_model/asset_template_model/asset_template.dart';
import '../../../models/directory_model/company_model/company_details.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';

class TemplateList extends StatefulWidget {
  const TemplateList({super.key});

  @override
  State<TemplateList> createState() => _TemplateListState();
}

class _TemplateListState extends State<TemplateList>
    with TickerProviderStateMixin {
  String? dropDownValueCompany = "All";

  int selectedIndex = 0;
  int listPerPage = 5;
  int currentPage = 0;

  late AnimationController controller;
  late TableBorder startBorder;
  late TableBorder endBorder;
  late TableBorder currentBorder;

  bool selectAllCheckBox = false;

  late String image;
  late String templateId;

  TextEditingController nameController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController parameterController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController tagController = TextEditingController();

  List<String> tag = [];
  List<String> tagList = [];

  List<String> parameter = [];
  List<String> parameterList = [];

  List<CompanyDetails> completeCompanyList = [];
  CompanyDetails? selectedCompany;

  List<CompanyDetails> completeDepartmentList = [];
  List<String> selectedDepartmentList = [];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  double position = 0.0;

  String selectedImageName = 'Image';

  PlatformFile? imagePicked;

  List<AssetTemplateDetails> filteredList = [];

  List<AssetTemplateDetails> getPaginatedData() {
    AssetProvider templateProvider =
        Provider.of<AssetProvider>(context, listen: false);

    filteredList = (dropDownValueCompany == "All")
        ? templateProvider.templateDetailsList
        : templateProvider.templateDetailsList
            .where((template) =>
                template.company!.contains(dropDownValueCompany ?? ''))
            .toList();

    final startIndex = currentPage * listPerPage;
    final endIndex = (startIndex + listPerPage).clamp(0, filteredList.length);
    return filteredList.sublist(startIndex, endIndex);
  }

  String getDisplayedRange() {
    AssetProvider templateProvider =
        Provider.of<AssetProvider>(context, listen: false);

    filteredList = (dropDownValueCompany == "All")
        ? templateProvider.templateDetailsList
        : templateProvider.templateDetailsList
            .where((template) =>
                template.company!.contains(dropDownValueCompany ?? ''))
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

    Provider.of<AssetProvider>(context, listen: false).fetchTemplateDetails();
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

     final userRole = assetProvider.userRole;

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
                                "Template List",
                                style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                  fontSize: 20,
                                  color: boolProvider.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                              ),
                              if (userRole.assetTemplateWriteFlag) ...[
                                const DialogRoot(dialog: AddTemplate())
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
                                text: " Template",
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
                        : assetProvider.templateDetailsList.isNotEmpty
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
                                                      assetProvider
                                                              .selectedTemplates =
                                                          List.generate(
                                                              assetProvider
                                                                  .selectedTemplates
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
                                          if (assetAccess &&
                                              directoryAccess &&
                                              userManagementAccess) ...[
                                            Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    boolProviders.setVisibility(
                                                        !boolProvider
                                                            .isVisible);
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
                                        text: "Parameters",
                                      ),
                                      getTitleText(
                                        text: "Company",
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
                                      AssetTemplateDetails template =
                                          entry.value;

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
                                                        value: assetProvider
                                                                .selectedTemplates
                                                                .isNotEmpty
                                                            ? assetProvider
                                                                    .selectedTemplates[
                                                                index]
                                                            : false,
                                                        onChanged:
                                                            (bool? value) {
                                                          setState(() {
                                                            assetProvider
                                                                        .selectedTemplates[
                                                                    index] =
                                                                value ?? false;
                                                            selectAllCheckBox =
                                                                assetProvider
                                                                    .selectedTemplates
                                                                    .every(
                                                                        (item) =>
                                                                            item);
                                                          });

                                                          bool showDelete =
                                                              assetProvider
                                                                  .selectedTemplates
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
                                                            '$websiteURL/images/${template.image}',
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
                                                text: template.displayId
                                                    .toString(),
                                                maxLines: 1,
                                                color: themeProvider.isDarkTheme
                                                    ? const Color.fromRGBO(
                                                        200, 200, 200, 1)
                                                    : const Color.fromRGBO(
                                                        117, 117, 117, 1)),
                                            getContentText(
                                                text: template.name.toString(),
                                                maxLines: 1,
                                                color: themeProvider.isDarkTheme
                                                    ? const Color.fromRGBO(
                                                        200, 200, 200, 1)
                                                    : const Color.fromRGBO(
                                                        117, 117, 117, 1)),
                                            getContentText(
                                                text: fetchTemplate(
                                                    template.parameters!),
                                                maxLines: 2,
                                                color: themeProvider.isDarkTheme
                                                    ? const Color.fromRGBO(
                                                        200, 200, 200, 1)
                                                    : const Color.fromRGBO(
                                                        117, 117, 117, 1)),
                                            getContentText(
                                                text:
                                                    template.company.toString(),
                                                maxLines: 1,
                                                color: themeProvider.isDarkTheme
                                                    ? const Color.fromRGBO(
                                                        200, 200, 200, 1)
                                                    : const Color.fromRGBO(
                                                        117, 117, 117, 1)),
                                            getContentText(
                                                text: fetchTemplate(
                                                    template.department!),
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
                                                        TemplateListExpandedView(
                                                            template:
                                                                template)),
                                                if (userRole
                                                    .assetTemplateWriteFlag) ...[
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

                                                      AssetTemplateDetails
                                                          assetTemplate =
                                                          filteredList[
                                                              actualIndex];

                                                      templateId =
                                                          assetTemplate.sId ??
                                                              "";
                                                      image =
                                                          assetTemplate.image ??
                                                              '';
                                                      nameController.text =
                                                          assetTemplate.name!;
                                                      parameterList = List.from(
                                                          assetTemplate
                                                              .parameters!);
                                                      selectedDepartmentList =
                                                          List.from(
                                                              assetTemplate
                                                                  .department!);
                                                      tagList = List.from(
                                                          assetTemplate.tag!);

                                                      selectedCompany = assetProvider
                                                          .companyDetailsList
                                                          .firstWhereOrNull(
                                                              (companyDetails) =>
                                                                  assetTemplate
                                                                      .company!
                                                                      .contains(
                                                                          companyDetails.name ??
                                                                              ""));

                                                      final concatenatedText =
                                                          selectedCompany?.name;

                                                      companyController.text =
                                                          concatenatedText!;

                                                      showLargeUpdateTemplate(
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
                                                          templateId: template
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
                                                                  : Colors
                                                                      .white,
                                                          onPressed: () async {
                                                        String?
                                                            templateIdDelete =
                                                            template.sId
                                                                .toString();

                                                        if (mounted) {
                                                          Navigator.of(context)
                                                              .pop();
                                                        }

                                                        await deleteTemplate(
                                                            templateIdDelete,
                                                            themeProvider,
                                                            assetProvider);
                                                      });
                                                    },
                                                  )
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
                          List<AssetTemplateDetails> selectedTemplateList =
                              getSelectedTemplates();

                          List<TableRow> tableRows = [];

                          tableRows.add(getTableDeleteForMultipleId(
                              title: "S.NO", content: "ID"));

                          for (int index = 0;
                              index < selectedTemplateList.length;
                              index++) {
                            AssetTemplateDetails template =
                                selectedTemplateList[index];
                            tableRows.add(
                              getTableDeleteForMultipleId(
                                  title: (index + 1).toString(),
                                  content: template.displayId.toString()),
                            );
                          }

                          return AlertDialog(
                            backgroundColor: boolProvider.isDarkTheme
                                ? Colors.black
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Text(
                              "Delete the Selected Template",
                              style: GlobalHelper.textStyle(TextStyle(
                                color: boolProvider.isDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              )),
                            ),
                            content: Text(
                              "Are you sure want to delete?",
                              style: GlobalHelper.textStyle(TextStyle(
                                color: boolProvider.isDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              )),
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

  String fetchTemplate(List<String> template) {
    if (template.isEmpty) {
      return "";
    } else if (template.length == 1) {
      return template[0];
    } else if (template.length > 1) {
      return "${template.first}...";
    } else {
      return template.join(', ');
    }
  }

  showAlertDialog(BuildContext context,
      {required onPressed,
      required color,
      required containerColor,
      required templateId}) {
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
          "Delete Template",
          style: GlobalHelper.textStyle(TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          )),
        ),
      ),
      content: getTableDeleteForSingleId(id: templateId, color: color),
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

  List<AssetTemplateDetails> getSelectedTemplates() {
    AssetProvider templateProvider =
        Provider.of<AssetProvider>(context, listen: false);

    List<AssetTemplateDetails> selectedTemplatesList = [];
    for (int i = 0; i < templateProvider.templateDetailsList.length; i++) {
      if (templateProvider.selectedTemplates[i]) {
        selectedTemplatesList.add(templateProvider.templateDetailsList[i]);
      }
    }
    return selectedTemplatesList;
  }

  Future<void> showLargeUpdateTemplate(BuildContext context, int index) async {
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
                        width: MediaQuery.of(context).size.width * 0.47,
                        child: Wrap(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    "UPDATE TEMPLATES",
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
                                              return Image.memory(
                                                  imagePicked!.bytes!,
                                                  fit: BoxFit.cover);
                                            } else {
                                              return Image.network(
                                                '$websiteURL/images/$image',
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  } else {
                                                    return const CircularProgressIndicator();
                                                  }
                                                },
                                                errorBuilder: (BuildContext
                                                        context,
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
                                  height: 15,
                                ),
                                Wrap(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        margin: const EdgeInsets.all(2.0),
                                        decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                67, 66, 66, 0.060),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 8, 0, 8),
                                                    child:
                                                        getDialogWithoutIconContentsUI(
                                                      hintText: 'Name',
                                                      controllers:
                                                          nameController,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.20,
                                                      type: TextInputType.none,
                                                      validators:
                                                          commonValidator,
                                                      dialogSetState: setState,
                                                      color: themeProvider
                                                              .isDarkTheme
                                                          ? Colors.black
                                                          : Colors.white,
                                                      borderColor: themeProvider
                                                              .isDarkTheme
                                                          ? Colors.black
                                                          : Colors.white,
                                                      textColor: themeProvider
                                                              .isDarkTheme
                                                          ? Colors.white
                                                          : const Color
                                                              .fromRGBO(
                                                              117, 117, 117, 1),
                                                    )),
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          8, 16, 8, 0),
                                                      child: getDialogDropDownCompanyContentsUI(
                                                          dialogSetState:
                                                              setState,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.20,
                                                          validators:
                                                              commonValidator,
                                                          dropdownType: 0),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(8, 8, 8, 0),
                                                      child: getDialogDropDownDepartmentContentsUI(
                                                          dialogSetState:
                                                              setState,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.20,
                                                          validators:
                                                              departmentValidators),
                                                    ),
                                                    if (selectedDepartmentList
                                                        .isNotEmpty)
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                              height: 30,
                                                              child:
                                                                  VerticalDivider(
                                                                thickness: 3.5,
                                                                color: themeProvider
                                                                        .isDarkTheme
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white,
                                                              )),
                                                        ],
                                                      ),
                                                    getDepartmentListDialogContentsUI(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.20,
                                                      dialogSetState: setState,
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    getDialogParameterContentsUI(
                                                        hintText: 'Parameter',
                                                        controllers:
                                                            parameterController,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.20,
                                                        dialogSetState:
                                                            setState,
                                                        type:
                                                            TextInputType.text,
                                                        validators:
                                                            parameterValidators),
                                                    if (parameterList
                                                        .isNotEmpty)
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                              height: 30,
                                                              child:
                                                                  VerticalDivider(
                                                                thickness: 3.5,
                                                                color: themeProvider
                                                                        .isDarkTheme
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white,
                                                              )),
                                                        ],
                                                      ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(8, 0, 8, 8),
                                                      child:
                                                          getParameterListDialogContentsUI(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.20,
                                                        dialogSetState:
                                                            setState,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 8, 8, 0),
                                                  child: getDialogTagContentsUI(
                                                      hintText: 'Tag',
                                                      controllers:
                                                          tagController,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.20,
                                                      dialogSetState: setState,
                                                      type: TextInputType.text,
                                                      tags: tag,
                                                      onPressed: () {
                                                        final tagExtraText =
                                                            tagController.text;
                                                        if (tagExtraText
                                                            .isNotEmpty) {
                                                          setState(() {
                                                            tagList.add(
                                                                tagExtraText);
                                                            tagController
                                                                .clear();
                                                          });
                                                        } else {
                                                          return;
                                                        }
                                                      },
                                                      borderColor: themeProvider
                                                              .isDarkTheme
                                                          ? Colors.black
                                                          : Colors.white,
                                                      textColor: themeProvider
                                                              .isDarkTheme
                                                          ? Colors.white
                                                          : const Color
                                                              .fromRGBO(
                                                              117, 117, 117, 1),
                                                      fillColor: themeProvider
                                                              .isDarkTheme
                                                          ? Colors.black
                                                          : Colors.white,
                                                      containerColor:
                                                          themeProvider
                                                                  .isDarkTheme
                                                              ? Colors.black
                                                              : Colors.white,
                                                      list: tagList),
                                                ),
                                                if (tagList.isNotEmpty)
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                          height: 30,
                                                          child:
                                                              VerticalDivider(
                                                            thickness: 3.5,
                                                            color: themeProvider
                                                                    .isDarkTheme
                                                                ? Colors.black
                                                                : Colors.white,
                                                          )),
                                                    ],
                                                  ),
                                                getTagListDialogContentsUI(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.20,
                                                    dialogSetState: setState,
                                                    tag: tagList,
                                                    textColor: themeProvider
                                                            .isDarkTheme
                                                        ? Colors.white
                                                        : const Color.fromRGBO(
                                                            117, 117, 117, 1),
                                                    color: themeProvider
                                                            .isDarkTheme
                                                        ? Colors.black
                                                        : Colors.white),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                                const SizedBox(
                                  height: 20,
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15),
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
                                              "Cancel",
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
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.050,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.075,
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                _onTapEditButton(index);
                                                Navigator.of(context).pop();
                                              } else {
                                                return;
                                              }
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
                                              "Save",
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

  /// It Contains the CompanyList Dropdown in dialog
  Widget getDialogDropDownCompanyContentsUI(
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
                        selectedCompany = null;
                        selectedCompany = completeCompanyList[index];
                        onDropdownTap(
                            dropdownType,
                            completeCompanyList[index].name.toString(),
                            dialogSetState);
                        var companyIds = [completeCompanyList[index].sId ?? ""];
                        companyProvider.fetchParticularCompanyDetails(
                            companyIds: companyIds);
                        // companyIds.clear();
                        // departmentController.clear();
                        // selectedDepartmentList.clear();
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

  Widget getDialogDropDownDepartmentContentsUI(
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
    } else {
      return;
    }
  }

  /// It Contain the Dropdown of the Parameter List
  Widget getDialogParameterContentsUI(
      {required String hintText,
      required TextEditingController controllers,
      required double width,
      required validators,
      required StateSetter dialogSetState,
      required TextInputType type}) {
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
              keyboardType: type,
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
                      color: themeProvider.isDarkTheme
                          ? Colors.black
                          : Colors.white),
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
                    final parameterExtraText = parameterController.text;
                    if (parameterExtraText.isNotEmpty) {
                      dialogSetState(() {
                        parameterList.add(parameterExtraText);
                        parameterController.clear();
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
            if (isDropDownOpenAssetList[7] && parameter.isNotEmpty)
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
                    itemCount: parameter.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          parameter[index],
                          style: GlobalHelper.textStyle(TextStyle(
                              color: themeProvider.isDarkTheme
                                  ? Colors.white
                                  : const Color.fromRGBO(117, 117, 117, 1))),
                        ),
                        onTap: () {
                          dialogSetState(() {
                            parameterList.add(parameter[index]);
                            parameterController.clear();
                            isDropDownOpenAssetList[7] = false;
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

  /// It contains What are the parameter selecting in the dropdown
  Widget getParameterListDialogContentsUI(
      {required double width, required StateSetter dialogSetState}) {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    return AnimatedContainer(
        width: width,
        curve: Curves.fastLinearToSlowEaseIn,
        decoration: BoxDecoration(
            color: themeProvider.isDarkTheme ? Colors.black : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        duration: const Duration(seconds: 10),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: parameterList.length,
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
                        parameterList[index],
                        style: GlobalHelper.textStyle(TextStyle(
                          color: themeProvider.isDarkTheme
                              ? Colors.white
                              : const Color.fromRGBO(117, 117, 117, 1),
                          fontSize: 15,
                        )),
                      ),
                    ),
                    Row(children: [
                      IconButton(
                          onPressed: () {
                            _moveListUp(index, dialogSetState);
                          },
                          icon: const Icon(
                            Icons.arrow_drop_up_outlined,
                            color: Color.fromRGBO(15, 117, 188, 1),
                          )),
                      IconButton(
                          onPressed: () {
                            _moveListDown(index, dialogSetState);
                          },
                          icon: const Icon(
                            Icons.arrow_drop_down_outlined,
                            color: Color.fromRGBO(15, 117, 188, 1),
                          )),
                      IconButton(
                          onPressed: () {
                            dialogSetState(() {
                              parameterList.removeAt(index);
                            });
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Color.fromRGBO(15, 117, 188, 1),
                          )),
                    ])
                  ],
                ),
              ],
            );
          },
        ));
  }

  /// It used to move the list up in the container
  _moveListDown(int index, StateSetter dialogSetState) {
    if (index < parameterList.length - 1) {
      dialogSetState(() {
        final item = parameterList.removeAt(index);
        parameterList.insert(index + 1, item);
        position += 100.0;
        log(position.toString());
      });
    }
  }

  /// It used to move the list down in the container
  _moveListUp(int index, StateSetter dialogSetState) {
    if (index > 0) {
      dialogSetState(() {
        final item = parameterList.removeAt(index);
        parameterList.insert(index - 1, item);
        position -= 100.0;
        log(position.toString());
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

  String? parameterValidators(value) {
    if (parameterList.isEmpty) {
      return 'Dropdown Should be not Empty';
    } else {
      return null;
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

  bool checkTemplateDetailsEditedOrNot(int index) {
    AssetProvider templateProvider =
        Provider.of<AssetProvider>(context, listen: false);

    Function eq = const ListEquality().equals;
    if (templateProvider.templateDetailsList[index].name ==
            nameController.text &&
        templateProvider.templateDetailsList[index].company ==
            selectedCompany?.name &&
        eq(templateProvider.templateDetailsList[index].department,
            selectedDepartmentList) &&
        eq(templateProvider.templateDetailsList[index].parameters,
            parameterList) &&
        eq(templateProvider.templateDetailsList[index].tag, tagList)) {
      return false;
    } else {
      return true;
    }
  }

  _onTapEditButton(int index) async {
    AssetProvider templateProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider boolProvider =
        Provider.of<BoolProvider>(context, listen: false);

    final result = checkTemplateDetailsEditedOrNot(index);
    if (result || imagePicked != null) {
      AssetTemplate template = AssetTemplate(
          name: nameController.text.toString(),
          parameters: parameterList,
          department: selectedDepartmentList,
          image: imagePicked?.name,
          companyRefId: selectedCompany?.sId,
          tag: tagList,
          sId: templateId);
      await updateTemplate(template, boolProvider, templateProvider);
      await templateProvider.fetchTemplateDetails();
    } else {
      /// User not changed anything...
    }
  }

  void getDelete() async {
    AssetProvider templateProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider boolProvider =
        Provider.of<BoolProvider>(context, listen: false);

    List<String> idsToDelete = [];
    for (int i = 0; i < templateProvider.selectedTemplates.length; i++) {
      if (templateProvider.selectedTemplates[i]) {
        idsToDelete.add(templateProvider.templateDetailsList[i].sId.toString());
      }
    }

    for (String templateId in idsToDelete) {
      await deleteTemplate(templateId, boolProvider, templateProvider);
    }

    setState(() {
      templateProvider.templateDetailsList.removeWhere(
          (template) => idsToDelete.contains(template.sId.toString()));
      selectAllCheckBox = false;
    });
  }

  Widget getCompanyDropDownContentUI() {
    AssetProvider templateProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    List<String> dropdownItems = ["All"];
    dropdownItems.addAll(templateProvider.templateDetailsList
        .expand((template) => [template.company!])
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

  Future<void> updateTemplate(AssetTemplate template,
      BoolProvider boolProviders, AssetProvider templateProvider) async {
    await AddUpdateDetailsManagerWithImage(
      data: template,
      image: imagePicked,
      apiURL: 'template/updateTemplate',
    ).addUpdateDetailsWithImages(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("Template Updated Successfully");
        templateProvider.fetchTemplateDetails();
      });
    } else {
      setState(() {
        showToast("Unable to update the template");
      });
    }
  }

  Future<void> deleteTemplate(String templateId, BoolProvider boolProviders,
      AssetProvider templateProvider) async {
    await DeleteDetailsManager(
      apiURL: 'template/deleteTemplate',
      id: templateId,
    ).deleteDetails(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("Template Deleted Successfully");
        templateProvider.fetchTemplateDetails();
      });
    } else {
      setState(() {
        showToast("Unable to delete the template");
      });
    }
  }
}
