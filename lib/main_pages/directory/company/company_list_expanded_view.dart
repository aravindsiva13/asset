import 'package:asset_management_local/models/directory_model/company_model/company_details.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../global/global_variables.dart';
import '../../../global/user_interaction_timer.dart';
import '../../../helpers/global_helper.dart';
import '../../../helpers/http_helper.dart';
import '../../../helpers/ui_components.dart';
import 'package:collection/collection.dart';
import '../../../models/directory_model/company_model/company.dart';
import 'package:asset_management_local/provider/main_providers/asset_provider.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';


class CompanyListExpandedView extends StatefulWidget
{
  const CompanyListExpandedView({super.key, required this.company});
  final CompanyDetails company;

  @override
  State<CompanyListExpandedView> createState() =>
      _CompanyListExpandedViewState();
}

class _CompanyListExpandedViewState extends State<CompanyListExpandedView> {
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

  PlatformFile? imagePicked;

  String selectedImageName = 'Image';

  int currentCompanyStep = 0;
  StepperType stepperType = StepperType.horizontal;

  @override
  void initState() {
    super.initState();
    Provider.of<AssetProvider>(context, listen: false).fetchCompanyDetails();
  }

  @override
  Widget build(BuildContext context) {


    return Consumer2<AssetProvider, BoolProvider>(
        builder: (context, companyProvider, themeProvider, child) {
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
                            "Company",
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
                                              '$websiteURL/images/${widget.company.image}',
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
                                                return Image.asset(themeProvider
                                                    .isDarkTheme
                                                    ? 'assets/images/riota_logo.png'
                                                    : 'assets/images/riota_logo2.png');
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
                                                        title: 'Company ID'),
                                                    getTicketStatusTitleContentUI(
                                                        title: 'Phone No'),
                                                    getTicketStatusTitleContentUI(
                                                        title: 'Website'),
                                                    getTicketStatusTitleContentUI(
                                                        title:
                                                        'Contact Person Phone No'),
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
                                                          .company.displayId
                                                          .toString(),
                                                      color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                    getTicketStatusContentUI(
                                                      content: widget
                                                          .company.phoneNumber
                                                          .toString(),
                                                      color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                    getTicketStatusContentUI(
                                                      content: widget
                                                          .company.website
                                                          .toString(),
                                                      color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                    getTicketStatusContentUI(
                                                      content: widget.company
                                                          .contactPersonPhoneNumber
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
                                                        title: 'Name'),
                                                    getTicketStatusTitleContentUI(
                                                        title: 'Email ID'),
                                                    getTicketStatusTitleContentUI(
                                                        title:
                                                        'Contact Person Name'),
                                                    getTicketStatusTitleContentUI(
                                                        title:
                                                        'Contact Person Email ID'),
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
                                                      content: widget.company.name
                                                          .toString(),
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.1,
                                                      color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                    getTicketStatusContentUI(
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.1,
                                                      content: widget.company.email
                                                          .toString(),
                                                      color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                    getTicketStatusContentUI(
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.1,
                                                      content: widget
                                                          .company.contactPersonName
                                                          .toString(),
                                                      color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                    getTicketStatusContentUI(
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.1,
                                                      content: widget.company
                                                          .contactPersonEmail
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
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        getTicketStatusTitleContentUI(
                                            title: 'Address'),
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Wrap(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: themeProvider.isDarkTheme
                                                        ? const Color.fromRGBO(
                                                        16, 18, 33, 1)
                                                        : const Color(0xfff3f1ef),
                                                    borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(15))),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.15,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Text(
                                                    "${widget.company.address?.address!}, ${widget.company.address?.city!}, ${widget.company.address?.state!}, ${widget.company.address?.country!}, ${widget.company.address?.pinCode!}",
                                                    style: GoogleFonts.ubuntu(
                                                        textStyle: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.bold,
                                                          color:
                                                          themeProvider.isDarkTheme
                                                              ? Colors.white
                                                              : Colors.black,
                                                        )),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        getTicketStatusTitleContentUI(
                                            title: 'Departments'),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: themeProvider.isDarkTheme
                                                  ? const Color.fromRGBO(
                                                  16, 18, 33, 1)
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
                                                children: buildDepartmentWidgets(
                                                    widget.company.departments,
                                                    themeProvider),
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
                              if(companyProvider.userRole.companyWriteFlag)...[
                                getElevatedButtonIcon(
                                    onPressed: () {
                                      nameController.text = widget.company.name!;
                                      addressController.text =
                                      widget.company.address!.address!;
                                      cityController.text =
                                      widget.company.address!.city!;
                                      stateController.text =
                                      widget.company.address!.state!;
                                      countryController.text =
                                      widget.company.address!.country!;
                                      landmarkController.text =
                                      widget.company.address!.landMark!;
                                      codeController.text =
                                          widget.company.address!.pinCode!.toString();
                                      contactEmailController.text =
                                      widget.company.email!;
                                      contactPhoneNumberController.text =
                                          widget.company.phoneNumber!.toString();
                                      websiteController.text =
                                      widget.company.website!;
                                      contactPersonNameController.text =
                                      widget.company.contactPersonName!;
                                      contactPersonEmailController.text =
                                      widget.company.contactPersonEmail!;
                                      contactPersonPhoneNumberController.text = widget
                                          .company.contactPersonPhoneNumber!
                                          .toString();
                                      departmentList =
                                          List.from(widget.company.departments!);
                                      tagList = List.from(widget.company.tag!);

                                      showLargeScreenUpdateCompany(
                                          context, companyProvider);
                                    },
                                    text: 'Edit'),
                                const SizedBox(
                                  width: 15,
                                ),
                              ],
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

  List<Widget> buildDepartmentWidgets(
      List<String>? departments, BoolProvider themeProvider) {
    if (departments == null || departments.isEmpty) return [];

    List<Widget> widgets = [];

    for (int i = 0; i < departments.length; i++) {
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
                    text: departments[i],
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

  Future<void> showLargeScreenUpdateCompany(
      BuildContext context, AssetProvider companyProvider) async {
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

  TextEditingController contactEmailController = TextEditingController();
  TextEditingController contactPhoneNumberController = TextEditingController();

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

  TextEditingController contactPersonNameController = TextEditingController();
  TextEditingController contactPersonEmailController = TextEditingController();
  TextEditingController contactPersonPhoneNumberController =
  TextEditingController();

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

  Widget getImageWidget() {
    BoolProvider themeProvider =
    Provider.of<BoolProvider>(context, listen: false);

    if (imagePicked != null) {
      return Image.memory(imagePicked!.bytes!, fit: BoxFit.cover);
    } else {
      return Image.network(
        '$websiteURL/images/${widget.company.image}',
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
    if (widget.company.name == nameController.text &&
        widget.company.address!.address == addressController.text &&
        widget.company.address!.city == cityController.text &&
        widget.company.address!.state == stateController.text &&
        widget.company.address!.landMark == landmarkController.text &&
        widget.company.address!.country == countryController.text &&
        widget.company.address!.pinCode.toString() == codeController.text &&
        widget.company.email == contactEmailController.text &&
        widget.company.phoneNumber.toString() ==
            contactPhoneNumberController.text &&
        widget.company.website == websiteController.text &&
        widget.company.contactPersonName == contactPersonNameController.text &&
        widget.company.contactPersonEmail ==
            contactPersonEmailController.text &&
        widget.company.contactPersonPhoneNumber.toString() ==
            contactPersonPhoneNumberController.text &&
        eq(widget.company.departments, departmentList) &&
        eq(widget.company.tag, tagList)) {
      return false;
    } else {
      return true;
    }
  }

  _onTapEditButton() async {
    AssetProvider companyProvider =
    Provider.of<AssetProvider>(context, listen: false);

    BoolProvider boolProvider =
    Provider.of<BoolProvider>(context, listen: false);

    final result = checkCompanyDetailsEditedOrNot();
    if (result || imagePicked != null) {
      /// User Updated the Company Details and use to change in the DB
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
        sId: widget.company.sId,
      );
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
}
