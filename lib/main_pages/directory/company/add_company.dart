import 'package:asset_management_local/provider/other_providers/bool_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../global/global_variables.dart';
import '../../../helpers/global_helper.dart';
import '../../../helpers/http_helper.dart';
import '../../../helpers/ui_components.dart';
import '../../../models/directory_model/company_model/company.dart';
import 'package:asset_management_local/provider/main_providers/asset_provider.dart';

class AddCompany extends StatefulWidget {
  const AddCompany({super.key});

  @override
  State<AddCompany> createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  TextEditingController contactPersonNameController = TextEditingController();
  TextEditingController contactPersonEmailController = TextEditingController();
  TextEditingController contactPersonPhoneNumberController =
      TextEditingController();
  TextEditingController contactEmailController = TextEditingController();
  TextEditingController contactPhoneNumberController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController departmentController = TextEditingController();

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

  int currentCompanyStep = 0;
  StepperType stepperType = StepperType.horizontal;

  String selectedImageName = 'Image';

  PlatformFile? imagePicked;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AssetProvider, BoolProvider>(
        builder: (context, companyProvider, themeProvider, child) {
      return Dialog(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                color: themeProvider.isDarkTheme
                    ? const Color.fromRGBO(16, 18, 33, 1)
                    : const Color(0xfff3f1ef),
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            width: MediaQuery.of(context).size.width * 0.47,
            height: MediaQuery.of(context).size.height * 0.88,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "ADD COMPANY",
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
                    backgroundColor:
                        themeProvider.isDarkTheme ? Colors.black : Colors.white,
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: ClipOval(
                          child: imagePicked != null
                              ? Image.memory(imagePicked!.bytes!,
                                  fit: BoxFit.cover)
                              : Image.asset(
                                  'assets/images/riota_logo.png',
                                )),
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
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.050,
                                width:
                                    MediaQuery.of(context).size.width * 0.075,
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)))),
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
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.050,
                                      width: MediaQuery.of(context).size.width *
                                          0.075,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              currentCompanyStep -= 1;
                                            });
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
                                            "Previous",
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
                                      const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.050,
                                    width: MediaQuery.of(context).size.width *
                                        0.075,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            isApiCallInProgress = true;
                                          });
                                          final steps = getStepsCompanyDialog(
                                              setState,
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              colors: themeProvider.isDarkTheme
                                                  ? Colors.black
                                                  : Colors.white,
                                              borderColor: themeProvider
                                                      .isDarkTheme
                                                  ? Colors.black
                                                  : Colors.white,
                                              textColor:
                                                  themeProvider.isDarkTheme
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

                                          if (formKeyStepCompany[
                                                  currentCompanyStep]
                                              .currentState!
                                              .validate()) {
                                            if (currentCompanyStep ==
                                                steps.length - 1) {
                                              if (mounted) {
                                                Navigator.of(context).pop();
                                              }

                                              Company company = Company(
                                                  name: nameController.text
                                                      .toString(),
                                                  address: {
                                                    "address": addressController
                                                        .text
                                                        .toString(),
                                                    "city": cityController.text
                                                        .toString(),
                                                    "state": stateController
                                                        .text
                                                        .toString(),
                                                    "country": countryController
                                                        .text
                                                        .toString(),
                                                    "landMark":
                                                        landmarkController.text
                                                            .toString(),
                                                    "pinCode": int.tryParse(
                                                        codeController.text
                                                            .toString()),
                                                  },
                                                  email: contactEmailController
                                                      .text
                                                      .toString(),
                                                  phoneNumber:
                                                      contactPhoneNumberController.text
                                                          .toString(),
                                                  website: websiteController
                                                      .text
                                                      .toString(),
                                                  contactPersonName:
                                                      contactPersonNameController
                                                          .text
                                                          .toString(),
                                                  contactPersonPhoneNumber:
                                                      contactPersonPhoneNumberController
                                                          .text
                                                          .toString(),
                                                  contactPersonEmail:
                                                      contactPersonEmailController
                                                          .text
                                                          .toString(),
                                                  departments: departmentList,
                                                  image: imagePicked?.name,
                                                  tag: tagList);

                                              await addCompany(
                                                  company,
                                                  themeProvider,
                                                  companyProvider);
                                            } else {
                                              setState(() {
                                                currentCompanyStep++;
                                              });
                                            }
                                          } else {
                                            return;
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)))),
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
          ),
        ),
      );
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

  Future<void> addCompany(Company company, BoolProvider boolProviders,
      AssetProvider companyProvider) async {
    await AddUpdateDetailsManagerWithImage(
      data: company,
      image: imagePicked,
      apiURL: 'company/addCompany',
    ).addUpdateDetailsWithImages(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("Company Added Successfully");
        companyProvider.fetchCompanyDetails();
      });
    } else {
      setState(() {
        showToast("Unable to add the company");
      });
    }
  }
}
