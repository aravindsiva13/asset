import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asset_management_local/models/asset_model/asset_template_model/asset_template_details.dart';
import 'package:asset_management_local/provider/main_providers/asset_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../global/global_variables.dart';
import '../../../global/user_interaction_timer.dart';
import '../../../helpers/global_helper.dart';
import '../../../helpers/http_helper.dart';
import '../../../helpers/ui_components.dart';
import '../../../models/asset_model/asset_template_model/asset_template.dart';
import '../../../models/directory_model/company_model/company_details.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';

class TemplateListExpandedView extends StatefulWidget {
  const TemplateListExpandedView({super.key, required this.template});
  final AssetTemplateDetails template;

  @override
  State<TemplateListExpandedView> createState() =>
      _TemplateListExpandedViewState();
}

class _TemplateListExpandedViewState extends State<TemplateListExpandedView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<String> parameter = [];
  List<String> parameterList = [];

  List<CompanyDetails> completeCompanyList = [];
  CompanyDetails? selectedCompany;

  List<CompanyDetails> completeDepartmentList = [];
  List<String> selectedDepartmentList = [];

  List<String> tag = [];
  List<String> tagList = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController parameterController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController tagController = TextEditingController();

  double position = 0.0;

  String selectedImageName = 'Image';

  PlatformFile? imagePicked;

  @override
  void initState() {
    super.initState();
    Provider.of<AssetProvider>(context, listen: false).fetchTemplateDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BoolProvider,AssetProvider>(builder: (context, themeProvider,roleProvider, child) {

      final userRole = roleProvider.userRole;

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
                        "Asset Template",
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
                                          '$websiteURL/images/${widget.template.image}',
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
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: getTicketStatusTitleContentUI(
                                              title: 'Template ID'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: getTicketStatusContentUI(
                                              content: widget.template.displayId
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: getTicketStatusTitleContentUI(
                                              title: 'Name'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: getTicketStatusContentUI(
                                            content:
                                                widget.template.name.toString(),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                            color: themeProvider.isDarkTheme
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
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
                                          padding: const EdgeInsets.all(5),
                                          child: Wrap(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                decoration: BoxDecoration(
                                                    color: themeProvider
                                                            .isDarkTheme
                                                        ? const Color.fromRGBO(
                                                            16, 18, 33, 1)
                                                        : const Color(
                                                            0xfff3f1ef),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Center(
                                                    child: Text(
                                                      widget.template.company
                                                          .toString(),
                                                      style: GlobalHelper
                                                          .textStyle(TextStyle(
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
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        getTicketStatusTitleContentUI(
                                            title: 'Departments'),
                                        Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Wrap(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: themeProvider
                                                            .isDarkTheme
                                                        ? const Color.fromRGBO(
                                                            16, 18, 33, 1)
                                                        : const Color(
                                                            0xfff3f1ef),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Center(
                                                    child: Text(
                                                      fetchTemplate(widget
                                                          .template
                                                          .department!),
                                                      style: GoogleFonts.ubuntu(
                                                          textStyle: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: themeProvider
                                                                .isDarkTheme
                                                            ? Colors.white
                                                            : Colors.black,
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                getTicketStatusTitleContentUI(
                                    title: 'Parameter'),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: themeProvider.isDarkTheme
                                          ? const Color.fromRGBO(16, 18, 33, 1)
                                          : const Color(0xfff3f1ef),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        runAlignment: WrapAlignment.center,
                                        children: buildParameterWidgets(
                                            widget.template.parameters,
                                            themeProvider),
                                      ),
                                    ),
                                  ),
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
                          if(userRole.assetTemplateWriteFlag)...[
                            getElevatedButtonIcon(
                                onPressed: () async {
                                  AssetProvider companyProvider =
                                  Provider.of<AssetProvider>(context,
                                      listen: false);
                                  AssetProvider templateProvider =
                                  Provider.of<AssetProvider>(context,
                                      listen: false);
                                  await companyProvider.fetchCompanyDetails();
                                  await templateProvider.fetchTemplateDetails();

                                  nameController.text = widget.template.name!;
                                  selectedCompany = companyProvider
                                      .companyDetailsList
                                      .firstWhereOrNull((companyDetails) => widget
                                      .template.company!
                                      .contains(companyDetails.name ?? ""));

                                  final concatenatedText = selectedCompany?.name;

                                  companyController.text = concatenatedText!;

                                  selectedDepartmentList =
                                      List.from(widget.template.department!);
                                  parameterList =
                                      List.from(widget.template.parameters!);
                                  tagList = List.from(widget.template.tag!);
                                  if (mounted) {
                                    showLargeUpdateTemplate(context);
                                  }
                                },
                                text: 'Edit'),
                            const SizedBox(
                              width: 15,
                            )
                          ],
                          getElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              text: 'Close'),
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

  List<Widget> buildParameterWidgets(
      List<String>? parameters, BoolProvider themeProvider) {
    if (parameters == null || parameters.isEmpty) return [];

    List<Widget> widgets = [];

    for (int i = 0; i < parameters.length; i++) {
      if (i > 0 && i % 10 != 0) {
        widgets.add(
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            child: const VerticalDivider(
              thickness: 1,
              color: Color(0xffbdbdbd),
            ),
          ),
        );
      }
      if (i > 0 && i % 10 == 0) {
        widgets.add(const SizedBox(width: double.infinity));
      }

      widgets.add(
        Column(
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: parameters[i],
                    style: GlobalHelper.textStyle(
                      TextStyle(
                        color: themeProvider.isDarkTheme
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return widgets;
  }

  String fetchTemplate(List<String> template) {
    if (template.isEmpty) {
      return "";
    } else if (template.length == 1) {
      return template[0];
    } else {
      return template.join(', ');
    }
  }

  Future<void> showLargeUpdateTemplate(BuildContext context) async {
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
                                        child: getImageWidget(),
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
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 8, 0, 8),
                                                  child: getDialogWithoutIconContentsUI(
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
                                                      dialogSetState: setState),
                                                ),
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
                                                _onTapEditButton();
                                                Navigator.of(context).pop();
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

  Widget getImageWidget() {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    if (imagePicked != null) {
      return Image.memory(imagePicked!.bytes!, fit: BoxFit.cover);
    } else {
      return Image.network(
        '$websiteURL/images/${widget.template.image}',
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

  bool checkTemplateDetailsEditedOrNot() {
    Function eq = const ListEquality().equals;
    if (widget.template.name == nameController.text &&
        widget.template.company == selectedCompany?.name &&
        eq(widget.template.department, selectedDepartmentList) &&
        eq(widget.template.parameters, parameterList) &&
        eq(widget.template.tag, tagList)) {
      return false;
    } else {
      return true;
    }
  }

  _onTapEditButton() async {
    AssetProvider templateProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider boolProvider =
        Provider.of<BoolProvider>(context, listen: false);

    final result = checkTemplateDetailsEditedOrNot();
    if (result || imagePicked != null) {
      AssetTemplate template = AssetTemplate(
          name: nameController.text.toString(),
          parameters: parameterList,
          department: selectedDepartmentList,
          image: imagePicked?.name,
          companyRefId: selectedCompany?.sId,
          tag: tagList,
          sId: widget.template.sId);

      await updateTemplate(template, boolProvider, templateProvider);
    } else {
      /// User not changed anything...
    }
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
}
