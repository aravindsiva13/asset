import 'package:asset_management_local/models/asset_model/asset_model_model/asset_model_details.dart';
import 'package:asset_management_local/models/asset_model/asset_stock_model/asset_stock_details.dart';
import 'package:asset_management_local/models/directory_model/location_model/location_details.dart';
import 'package:asset_management_local/models/directory_model/vendor_model/vendor_details.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../global/global_variables.dart';
import '../../helpers/global_helper.dart';
import '../../helpers/http_helper.dart';
import '../../helpers/ui_components.dart';
import '../../models/ticket_model/add_ticket.dart';
import '../../models/user_management_model/user_model/user_details.dart';
import '../../provider/main_providers/asset_provider.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';

class RaiseTicket extends StatefulWidget {
  const RaiseTicket({super.key});

  @override
  State<RaiseTicket> createState() => _RaiseTicketState();
}

class _RaiseTicketState extends State<RaiseTicket> {
  List<String> masterType = [
    "Asset Procurement",
    "User Assignment",
    "Asset Return",
    "Service Request"
  ];
  List<String> typeList = [];
  List<String> type = [];
  String? selectedType;

  List<String> userMasterType = ["Request New Asset", "Service Requests"];

  List<String> userTypeList = [];
  List<String> userType = [];
  String? userSelectedType;

  double sizedBoxHeight = 10.0;

  Map<String, double> height = {
    'Asset Procurement': 130.0,
    'User Assignment': 205.0,
    'Asset Return': 205.0,
    'Service Request': 210.0
  };

  Map<String, double> userTypeHeight = {
    'Request New Asset': 210.0,
    'Service Requests': 140.0
  };

  int currentStep = 0;
  StepperType stepperType = StepperType.horizontal;

  String selectedFileName = 'Attachment';

  String selectedImageName = 'Image';

  PlatformFile? filePicked;

  List<GlobalKey<FormState>> formKeyStepTicket = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  TextEditingController typeController = TextEditingController();
  TextEditingController userTypeController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  TextEditingController vendorController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController etaDateController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController descriptionsController = TextEditingController();
  TextEditingController assignController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  TextEditingController stockController = TextEditingController();

  List<String> masterPriority = ["High", "Medium", "Low"];
  List<String> priorityList = [];
  List<String> priority = [];
  String? selectedPriority;

  List<String> tag = [];
  List<String> tagList = [];

  List<VendorDetails> completeVendorList = [];
  VendorDetails? selectedVendor;

  List<AssetModelDetails> completeModelList = [];
  AssetModelDetails? selectedModel;

  List<UserDetails> completeUserList = [];
  UserDetails? selectedUser;
  UserDetails? selectedAssignedUser;

  List<LocationDetails> completeLocationList = [];
  LocationDetails? selectedLocation;

  List<AssetStockDetails> completeStockList = [];
  AssetStockDetails? selectedStock;

  List<String> warrantyAttachments = [];

  List<String> masterStatus = [
    "In Progress",
    "Waiting For Approval",
    "Approved",
  ];
  List<String> statusList = [];
  List<String> status = [];
  String? selectedStatus;

  late DateTime selectedDate;

  PlatformFile? imagePicked;

  @override
  void initState() {
    super.initState();
    Provider.of<AssetProvider>(context, listen: false).fetchVendorDetails();
    Provider.of<AssetProvider>(context, listen: false).fetchModelDetails();
    Provider.of<AssetProvider>(context, listen: false).fetchStockDetails();
    Provider.of<AssetProvider>(context, listen: false).fetchUserDetails();
    Provider.of<AssetProvider>(context, listen: false).fetchVendorDetails();
    Provider.of<AssetProvider>(context, listen: false).fetchLocationDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BoolProvider, AssetProvider>(
        builder: (context, themeProvider, assetProvider, child) {
          return Dialog(
          child: SingleChildScrollView(
        child: Wrap(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: themeProvider.isDarkTheme
                      ? const Color.fromRGBO(16, 18, 33, 1)
                      : const Color(0xfff3f1ef),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              width: MediaQuery.of(context).size.width * 0.47,
              height: MediaQuery.of(context).size.height * 0.82,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "RAISE TICKET",
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
                  assetProvider.userRole.ticketMainFlag
                      ? Expanded(
                          child: Theme(
                          data: ThemeData(
                              canvasColor: themeProvider.isDarkTheme
                                  ? const Color.fromRGBO(16, 18, 33, 1)
                                  : const Color(0xfff3f1ef)),
                          child: Stepper(
                            type: stepperType,
                            currentStep: currentStep,
                            elevation: 0,
                            onStepTapped: (step) {
                              if (formKeyStepTicket[currentStep]
                                  .currentState!
                                  .validate()) {
                                setState(() {
                                  currentStep = step;
                                });
                              }
                            },
                            steps: getStepsTicketDialog(setState,
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
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 8, 8, 0),
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
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 8, 0),
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
                                                setState(() {
                                                  isApiCallInProgress = true;
                                                });

                                                final steps = getStepsTicketDialog(
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

                                                if (formKeyStepTicket[
                                                        currentStep]
                                                    .currentState!
                                                    .validate()) {
                                                  if (currentStep ==
                                                      steps.length - 1) {
                                                    AssetProvider userProvider =
                                                        Provider.of<
                                                                AssetProvider>(
                                                            context,
                                                            listen: false);

                                                    var userId = userProvider
                                                        .user!.sId
                                                        .toString();

                                                    AddTicket ticket = AddTicket(
                                                        type: selectedType
                                                            .toString(),
                                                        priority: selectedPriority
                                                            .toString(),
                                                        vendorRefId:
                                                            selectedVendor?.sId
                                                                .toString(),
                                                        modelRefId:
                                                            selectedModel?.sId
                                                                .toString(),
                                                        expectedTime:
                                                            dateController.text
                                                                .toString(),
                                                        description:
                                                            descriptionsController
                                                                .text
                                                                .toString(),
                                                        userRefId: selectedUser?.sId
                                                            .toString(),
                                                        stockRefId:
                                                            selectedStock?.sId
                                                                .toString(),
                                                        assignedRefId:
                                                            selectedAssignedUser
                                                                ?.sId
                                                                .toString(),
                                                        status: selectedStatus
                                                            .toString(),
                                                        locationRefId:
                                                            selectedLocation?.sId
                                                                .toString(),
                                                        estimatedTime:
                                                            etaDateController.text
                                                                .toString(),
                                                        remarks: remarksController
                                                            .text
                                                            .toString(),
                                                        attachment: filePicked?.name,
                                                        createdBy: userId);

                                                    await addTicket(
                                                        ticket,
                                                        themeProvider,
                                                        assetProvider);

                                                    if (mounted) {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  } else {
                                                    setState(() {
                                                      currentStep++;
                                                    });
                                                  }
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
                                                                  Radius
                                                                      .circular(
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
                        ))
                      : Expanded(
                          child: Theme(
                          data: ThemeData(
                              canvasColor: themeProvider.isDarkTheme
                                  ? const Color.fromRGBO(16, 18, 33, 1)
                                  : const Color(0xfff3f1ef)),
                          child: Stepper(
                            type: stepperType,
                            currentStep: currentStep,
                            elevation: 0,
                            onStepTapped: (step) {
                              if (formKeyStepTicket[currentStep]
                                  .currentState!
                                  .validate()) {
                                setState(() {
                                  currentStep = step;
                                });
                              }
                            },
                            steps: getStepsTicketDialogForUser(setState,
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
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 8, 8, 0),
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
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 8, 0),
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
                                                setState(() {
                                                  isApiCallInProgress = true;
                                                });

                                                final steps = getStepsTicketDialogForUser(
                                                    setState,
                                                    color: themeProvider.isDarkTheme
                                                        ? Colors.white
                                                        : Colors.black,
                                                    colors:
                                                        themeProvider.isDarkTheme
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

                                                if (formKeyStepTicket[
                                                        currentStep]
                                                    .currentState!
                                                    .validate()) {
                                                  if (currentStep ==
                                                      steps.length - 1) {
                                                    AssetProvider userProvider =
                                                        Provider.of<
                                                                AssetProvider>(
                                                            context,
                                                            listen: false);

                                                    var userId = userProvider
                                                        .user!.sId
                                                        .toString();

                                                    AddTicket ticket = AddTicket(
                                                        type: userSelectedType
                                                            .toString(),
                                                        priority:
                                                            selectedPriority
                                                                .toString(),
                                                        expectedTime:
                                                            dateController.text
                                                                .toString(),
                                                        description:
                                                            descriptionsController
                                                                .text
                                                                .toString(),
                                                        stockRefId:
                                                            selectedStock?.sId
                                                                .toString(),
                                                        remarks:
                                                            remarksController
                                                                .text
                                                                .toString(),
                                                        createdBy: userId,
                                                        userRefId: userId);

                                                    await addTicket(
                                                        ticket,
                                                        themeProvider,
                                                        assetProvider);

                                                    if (mounted) {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  } else {
                                                    setState(() {
                                                      currentStep++;
                                                    });
                                                  }
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
                                                                  Radius
                                                                      .circular(
                                                                          10)))),
                                              child: Text(
                                                currentStep == 1
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
                        ))
                ],
              ),
            )
          ],
        ),
      ));
    });
  }

  List<Step> getStepsTicketDialog(StateSetter dialogSetState,
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
            'Type',
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Form(
            key: formKeyStepTicket[0],
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
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              getDialogDropDownContentsUI(
                                hintText: 'Type',
                                controllers: typeController,
                                width: MediaQuery.of(context).size.width * 0.20,
                                type: TextInputType.none,
                                dropdownList: typeList,
                                dropdownType: 0,
                                validators: commonValidator,
                                dialogSetState: dialogSetState,
                                onTapTextField: () {
                                  dialogSetState(() {
                                    typeList = masterType
                                        .where((item) => item
                                            .toLowerCase()
                                            .contains(typeController.text
                                                .toLowerCase()))
                                        .toList();
                                    typeList = typeList
                                        .where((item) => !type.contains(item))
                                        .toList();
                                    isDropDownOpenTicketList[0] = true;
                                  });
                                },
                                onChangedTextField: (val) {
                                  dialogSetState(() {
                                    typeList = masterType
                                        .where((item) => item
                                            .toLowerCase()
                                            .contains(typeController.text
                                                .toLowerCase()))
                                        .toList();
                                    typeList = typeList
                                        .where((item) => !type.contains(item))
                                        .toList();
                                  });
                                },
                                borderColor: borderColor,
                                fillColor: fillColor,
                                textColor: textColor,
                              ),
                              const SizedBox(
                                height: 15,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 275,
                )
              ],
            ),
          ),
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 0,
        ),
        Step(
          title: Text(
            'Ticket Details',
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Form(
            key: formKeyStepTicket[1],
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
                          child: buildSelectedTypeUI(setState,
                              color: color,
                              colors: colors,
                              borderColor: borderColor,
                              textColor: textColor,
                              fillColor: fillColor,
                              containerColor: containerColor,
                              dividerColor: dividerColor),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: sizedBoxHeight,
                )
              ],
            ),
          ),
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 1,
        ),
        Step(
          title: Text(
            'Tracker',
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Form(
            key: formKeyStepTicket[2],
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
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getDialogDropDownContentsAssignUI(
                                      hintText: 'Assigned To',
                                      controllers: assignController,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      type: TextInputType.none,
                                      validators: commonValidator,
                                      dropdownType: 4,
                                      dialogSetState: dialogSetState),
                                  getDialogDropDownContentsUI(
                                    hintText: 'Status',
                                    controllers: statusController,
                                    width: MediaQuery.of(context).size.width *
                                        0.20,
                                    type: TextInputType.none,
                                    dropdownList: statusList,
                                    dropdownType: 5,
                                    validators: commonValidator,
                                    dialogSetState: dialogSetState,
                                    onTapTextField: () {
                                      dialogSetState(() {
                                        statusList = masterStatus
                                            .where((item) => item
                                                .toLowerCase()
                                                .contains(statusController.text
                                                    .toLowerCase()))
                                            .toList();
                                        statusList = statusList
                                            .where((item) =>
                                                !status.contains(item))
                                            .toList();
                                        isDropDownOpenTicketList[5] = true;
                                      });
                                    },
                                    onChangedTextField: (val) {
                                      dialogSetState(() {
                                        statusList = masterStatus
                                            .where((item) => item
                                                .toLowerCase()
                                                .contains(statusController.text
                                                    .toLowerCase()))
                                            .toList();
                                        statusList = statusList
                                            .where((item) =>
                                                !status.contains(item))
                                            .toList();
                                      });
                                    },
                                    borderColor: borderColor,
                                    fillColor: fillColor,
                                    textColor: textColor,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getDialogDropDownContentsLocationUI(
                                      hintText: 'Location',
                                      controllers: locationController,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      type: TextInputType.none,
                                      validators: commonValidator,
                                      dropdownType: 6,
                                      dialogSetState: dialogSetState),
                                  getDialogIconButtonContentsUI(
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      hintText: "Estimated Time for Resolution",
                                      suffixIcon: Icons.calendar_today_rounded,
                                      iconColor:
                                          const Color.fromRGBO(15, 117, 188, 1),
                                      controllers: etaDateController,
                                      type: TextInputType.datetime,
                                      dialogSetState: setState,
                                      validators: dateValidator,
                                      onPressed: () {
                                        setState(() {
                                          selectedDate = DateTime.now();
                                          _selectDate(context, setState,
                                              dateControllers:
                                                  etaDateController);
                                        });
                                      },
                                      borderColor: borderColor,
                                      textColor: textColor,
                                      fillColor: fillColor),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getDialogContentsUI(
                                      hintText: 'Remarks',
                                      controllers: remarksController,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      type: TextInputType.text,
                                      dialogSetState: setState,
                                      borderColor: borderColor,
                                      textColor: textColor,
                                      color: fillColor),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, right: 5),
                                    child: getDialogFileContentsUI(
                                        secondaryWidth:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        dialogSetState: setState,
                                        text: selectedFileName,
                                        onPressed: () {
                                          setState(() {
                                            pickFile(context, setState,
                                                allowedExtension: [
                                                  'pdf',
                                                  'doc'
                                                ]);
                                          });
                                        },
                                        icon: Icons.attachment_rounded,
                                        borderColor: borderColor,
                                        textColor: textColor,
                                        containerColor: containerColor),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 130,
                )
              ],
            ),
          ),
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 2,
        ),
      ];

  List<Step> getStepsTicketDialogForUser(StateSetter dialogSetState,
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
            'Type',
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Form(
            key: formKeyStepTicket[0],
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
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              getDialogDropDownContentsUIForUser(
                                hintText: 'Type',
                                controllers: userTypeController,
                                width: MediaQuery.of(context).size.width * 0.20,
                                type: TextInputType.none,
                                dropdownList: userTypeList,
                                dropdownType: 0,
                                validators: commonValidator,
                                dialogSetState: dialogSetState,
                                onTapTextField: () {
                                  dialogSetState(() {
                                    userTypeList = userMasterType
                                        .where((item) => item
                                            .toLowerCase()
                                            .contains(userTypeController.text
                                                .toLowerCase()))
                                        .toList();
                                    userTypeList = userTypeList
                                        .where(
                                            (item) => !userType.contains(item))
                                        .toList();

                                    isDropDownOpenTicketListForUser[0] = true;
                                  });
                                },
                                onChangedTextField: (val) {
                                  dialogSetState(() {
                                    userTypeList = userMasterType
                                        .where((item) => item
                                            .toLowerCase()
                                            .contains(userTypeController.text
                                                .toLowerCase()))
                                        .toList();
                                    userTypeList = userTypeList
                                        .where(
                                            (item) => !userType.contains(item))
                                        .toList();
                                  });
                                },
                                borderColor: borderColor,
                                fillColor: fillColor,
                                textColor: textColor,
                              ),
                              const SizedBox(
                                height: 15,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 275,
                )
              ],
            ),
          ),
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 0,
        ),
        Step(
          title: Text(
            'Ticket Details',
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Form(
            key: formKeyStepTicket[1],
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
                          child: buildSelectedTypeUIForUser(setState,
                              color: color,
                              colors: colors,
                              borderColor: borderColor,
                              textColor: textColor,
                              fillColor: fillColor,
                              containerColor: containerColor,
                              dividerColor: dividerColor),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: sizedBoxHeight,
                )
              ],
            ),
          ),
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 1,
        ),
      ];

  Widget buildSelectedTypeUI(StateSetter dialogSetState,
      {required color,
      required colors,
      required borderColor,
      required textColor,
      required fillColor,
      required containerColor,
      required dividerColor}) {
    if (selectedType == "Asset Procurement") {
      return Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getDialogDropDownContentsVendorUI(
                  hintText: 'Vendor',
                  controllers: vendorController,
                  width: MediaQuery.of(context).size.width * 0.20,
                  type: TextInputType.none,
                  validators: commonValidator,
                  dropdownType: 2,
                  dialogSetState: dialogSetState),
              getDialogDropDownContentsUI(
                hintText: 'Priority',
                controllers: priorityController,
                width: MediaQuery.of(context).size.width * 0.20,
                type: TextInputType.none,
                dropdownList: priorityList,
                dropdownType: 1,
                validators: commonValidator,
                dialogSetState: dialogSetState,
                onTapTextField: () {
                  dialogSetState(() {
                    priorityList = masterPriority
                        .where((item) => item
                            .toLowerCase()
                            .contains(priorityController.text.toLowerCase()))
                        .toList();
                    priorityList = priorityList
                        .where((item) => !priority.contains(item))
                        .toList();
                    isDropDownOpenTicketList[1] = true;
                  });
                },
                onChangedTextField: (val) {
                  dialogSetState(() {
                    priorityList = masterPriority
                        .where((item) => item
                            .toLowerCase()
                            .contains(priorityController.text.toLowerCase()))
                        .toList();
                    priorityList = priorityList
                        .where((item) => !priority.contains(item))
                        .toList();
                  });
                },
                borderColor: borderColor,
                fillColor: fillColor,
                textColor: textColor,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getDialogDropDownContentsModelUI(
                  hintText: 'Model',
                  controllers: modelController,
                  width: MediaQuery.of(context).size.width * 0.20,
                  type: TextInputType.none,
                  validators: commonValidator,
                  dropdownType: 3,
                  dialogSetState: dialogSetState),
              getDialogIconButtonContentsUI(
                  width: MediaQuery.of(context).size.width * 0.20,
                  hintText: "Expected Time for Resolution",
                  suffixIcon: Icons.calendar_today_rounded,
                  iconColor: const Color.fromRGBO(15, 117, 188, 1),
                  controllers: dateController,
                  type: TextInputType.datetime,
                  dialogSetState: dialogSetState,
                  validators: dateValidator,
                  onPressed: () {
                    dialogSetState(() {
                      selectedDate = DateTime.now();
                      _selectDate(context, dialogSetState,
                          dateControllers: dateController);
                    });
                  },
                  borderColor: borderColor,
                  textColor: textColor,
                  fillColor: fillColor),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          getDialogContentsUI(
              hintText: 'Description',
              controllers: descriptionsController,
              width: MediaQuery.of(context).size.width * 0.20,
              type: TextInputType.text,
              dialogSetState: setState,
              borderColor: borderColor,
              textColor: textColor,
              color: fillColor),
          const SizedBox(
            height: 15,
          ),
        ],
      );
    } else if (selectedType == "User Assignment") {
      return Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getDialogDropDownContentsParticularUserUI(
                  hintText: 'User',
                  controllers: userController,
                  width: MediaQuery.of(context).size.width * 0.20,
                  type: TextInputType.none,
                  validators: commonValidator,
                  dropdownType: 7,
                  dialogSetState: dialogSetState),
              getDialogDropDownContentsStockUI(
                  hintText: 'Stock',
                  controllers: stockController,
                  width: MediaQuery.of(context).size.width * 0.20,
                  type: TextInputType.none,
                  dropdownType: 8,
                  dialogSetState: dialogSetState),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          getDialogContentsUI(
              hintText: 'Description',
              controllers: descriptionsController,
              width: MediaQuery.of(context).size.width * 0.20,
              type: TextInputType.text,
              dialogSetState: setState,
              borderColor: borderColor,
              textColor: textColor,
              color: fillColor),
          const SizedBox(
            height: 15,
          ),
        ],
      );
    } else if (selectedType == "Asset Return") {
      return Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getDialogDropDownContentsParticularUserUI(
                  hintText: 'User',
                  controllers: userController,
                  width: MediaQuery.of(context).size.width * 0.20,
                  type: TextInputType.none,
                  validators: commonValidator,
                  dropdownType: 7,
                  dialogSetState: dialogSetState),
              getDialogDropDownContentsParticularStockUI(
                  hintText: 'Stock',
                  controllers: stockController,
                  width: MediaQuery.of(context).size.width * 0.20,
                  type: TextInputType.none,
                  validators: commonValidator,
                  dropdownType: 8,
                  dialogSetState: dialogSetState),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          getDialogContentsUI(
              hintText: 'Description',
              controllers: descriptionsController,
              width: MediaQuery.of(context).size.width * 0.20,
              type: TextInputType.text,
              dialogSetState: setState,
              borderColor: borderColor,
              textColor: textColor,
              color: fillColor),
          const SizedBox(
            height: 15,
          ),
        ],
      );
    } else if (selectedType == "Service Request") {
      return Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getDialogDropDownContentsParticularUserUI(
                  hintText: 'User',
                  controllers: userController,
                  width: MediaQuery.of(context).size.width * 0.20,
                  type: TextInputType.none,
                  dropdownType: 7,
                  dialogSetState: dialogSetState),
              getDialogDropDownContentsParticularStockForAdminServiceUI(
                  hintText: 'Stock',
                  controllers: stockController,
                  width: MediaQuery.of(context).size.width * 0.20,
                  type: TextInputType.none,
                  validators: commonValidator,
                  dropdownType: 8,
                  dialogSetState: dialogSetState),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          getDialogContentsUI(
              hintText: 'Description',
              controllers: descriptionsController,
              width: MediaQuery.of(context).size.width * 0.20,
              type: TextInputType.text,
              dialogSetState: setState,
              borderColor: borderColor,
              textColor: textColor,
              color: fillColor),
          const SizedBox(
            height: 15,
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget buildSelectedTypeUIForUser(StateSetter dialogSetState,
      {required color,
      required colors,
      required borderColor,
      required textColor,
      required fillColor,
      required containerColor,
      required dividerColor}) {
    if (userSelectedType == "Request New Asset") {
      return Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getDialogContentsUI(
                  hintText: 'Description',
                  controllers: descriptionsController,
                  width: MediaQuery.of(context).size.width * 0.20,
                  type: TextInputType.text,
                  validators: commonValidator,
                  dialogSetState: setState,
                  borderColor: borderColor,
                  textColor: textColor,
                  color: fillColor),
              getDialogDropDownContentsUI(
                hintText: 'Priority',
                controllers: priorityController,
                width: MediaQuery.of(context).size.width * 0.20,
                type: TextInputType.none,
                dropdownList: priorityList,
                dropdownType: 1,
                validators: commonValidator,
                dialogSetState: dialogSetState,
                onTapTextField: () {
                  dialogSetState(() {
                    priorityList = masterPriority
                        .where((item) => item
                            .toLowerCase()
                            .contains(priorityController.text.toLowerCase()))
                        .toList();
                    priorityList = priorityList
                        .where((item) => !priority.contains(item))
                        .toList();
                    isDropDownOpenTicketList[1] = true;
                  });
                },
                onChangedTextField: (val) {
                  dialogSetState(() {
                    priorityList = masterPriority
                        .where((item) => item
                            .toLowerCase()
                            .contains(priorityController.text.toLowerCase()))
                        .toList();
                    priorityList = priorityList
                        .where((item) => !priority.contains(item))
                        .toList();
                  });
                },
                borderColor: borderColor,
                fillColor: fillColor,
                textColor: textColor,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              getDialogContentsUI(
                  hintText: 'Remarks',
                  controllers: remarksController,
                  width: MediaQuery.of(context).size.width * 0.20,
                  type: TextInputType.text,
                  dialogSetState: setState,
                  borderColor: borderColor,
                  textColor: textColor,
                  color: fillColor),
              getDialogIconButtonContentsUI(
                  width: MediaQuery.of(context).size.width * 0.20,
                  hintText: "Expected Time for Resolution",
                  suffixIcon: Icons.calendar_today_rounded,
                  iconColor: const Color.fromRGBO(15, 117, 188, 1),
                  controllers: dateController,
                  type: TextInputType.datetime,
                  dialogSetState: dialogSetState,
                  validators: dateValidator,
                  onPressed: () {
                    dialogSetState(() {
                      selectedDate = DateTime.now();
                      _selectDate(context, dialogSetState,
                          dateControllers: dateController);
                    });
                  },
                  borderColor: borderColor,
                  textColor: textColor,
                  fillColor: fillColor),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      );
    } else if (userSelectedType == "Service Requests") {
      return Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          getDialogDropDownContentsParticularStockUI(
              hintText: 'Asset',
              controllers: stockController,
              width: MediaQuery.of(context).size.width * 0.20,
              type: TextInputType.none,
              dropdownType: 8,
              dialogSetState: dialogSetState,
              validators: commonValidator),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getDialogContentsUI(
                  hintText: 'Description',
                  controllers: descriptionsController,
                  width: MediaQuery.of(context).size.width * 0.20,
                  type: TextInputType.text,
                  validators: commonValidator,
                  dialogSetState: setState,
                  borderColor: borderColor,
                  textColor: textColor,
                  color: fillColor),
              getDialogDropDownContentsUI(
                hintText: 'Priority',
                controllers: priorityController,
                width: MediaQuery.of(context).size.width * 0.20,
                type: TextInputType.none,
                dropdownList: priorityList,
                dropdownType: 1,
                validators: commonValidator,
                dialogSetState: dialogSetState,
                onTapTextField: () {
                  dialogSetState(() {
                    priorityList = masterPriority
                        .where((item) => item
                            .toLowerCase()
                            .contains(priorityController.text.toLowerCase()))
                        .toList();
                    priorityList = priorityList
                        .where((item) => !priority.contains(item))
                        .toList();
                    isDropDownOpenTicketList[1] = true;
                  });
                },
                onChangedTextField: (val) {
                  dialogSetState(() {
                    priorityList = masterPriority
                        .where((item) => item
                            .toLowerCase()
                            .contains(priorityController.text.toLowerCase()))
                        .toList();
                    priorityList = priorityList
                        .where((item) => !priority.contains(item))
                        .toList();
                  });
                },
                borderColor: borderColor,
                fillColor: fillColor,
                textColor: textColor,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getDialogContentsUI(
                  hintText: 'Remarks',
                  controllers: remarksController,
                  width: MediaQuery.of(context).size.width * 0.20,
                  type: TextInputType.text,
                  dialogSetState: setState,
                  borderColor: borderColor,
                  textColor: textColor,
                  color: fillColor),
              getDialogIconButtonContentsUI(
                  width: MediaQuery.of(context).size.width * 0.20,
                  hintText: "Expected Time for Resolution",
                  suffixIcon: Icons.calendar_today_rounded,
                  iconColor: const Color.fromRGBO(15, 117, 188, 1),
                  controllers: dateController,
                  type: TextInputType.datetime,
                  dialogSetState: dialogSetState,
                  validators: dateValidator,
                  onPressed: () {
                    dialogSetState(() {
                      selectedDate = DateTime.now();
                      _selectDate(context, dialogSetState,
                          dateControllers: dateController);
                    });
                  },
                  borderColor: borderColor,
                  textColor: textColor,
                  fillColor: fillColor),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget getDialogDropDownContentsUI({
    required String hintText,
    required TextEditingController controllers,
    required double width,
    required onTapTextField,
    required onChangedTextField,
    required TextInputType type,
    required List<String> dropdownList,
    required int dropdownType,
    required validators,
    required StateSetter dialogSetState,
    borderColor,
    textColor,
    fillColor,
  }) {
    typeList = masterType;
    priorityList = masterPriority;
    statusList = masterStatus;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
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
                suffixIcon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromRGBO(15, 117, 188, 1),
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
              onTap: onTapTextField,
              onChanged: onChangedTextField,
            ),
            if (isDropDownOpenTicketList[dropdownType])
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: fillColor,
                  ),
                  margin: const EdgeInsets.only(top: 50),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: dropdownList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(
                            dropdownList[index],
                            style: GlobalHelper.textStyle(
                                TextStyle(color: textColor)),
                          ),
                          onTap: () {
                            onDropdownTap(dropdownType, dropdownList[index],
                                dialogSetState);
                          });
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget getDialogDropDownContentsUIForUser({
    required String hintText,
    required TextEditingController controllers,
    required double width,
    required onTapTextField,
    required onChangedTextField,
    required TextInputType type,
    required List<String> dropdownList,
    required int dropdownType,
    required validators,
    required StateSetter dialogSetState,
    borderColor,
    textColor,
    fillColor,
  }) {
    userTypeList = userMasterType;

    AssetProvider stockProvider =
        Provider.of<AssetProvider>(context, listen: false);

    AssetProvider userProviders =
        Provider.of<AssetProvider>(context, listen: false);

    var userStockId = userProviders.user!.assetStockRefIds;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
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
                suffixIcon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromRGBO(15, 117, 188, 1),
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
              onTap: onTapTextField,
              onChanged: onChangedTextField,
            ),
            if (isDropDownOpenTicketListForUser[dropdownType])
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: fillColor,
                  ),
                  margin: const EdgeInsets.only(top: 50),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: dropdownList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(
                            dropdownList[index],
                            style: GlobalHelper.textStyle(
                                TextStyle(color: textColor)),
                          ),
                          onTap: () {
                            onDropdownTapUser(dropdownType, dropdownList[index],
                                dialogSetState);
                            stockProvider.fetchParticularStockDetails(
                              assetStockId: userStockId,
                            );
                          });
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget getDialogDropDownContentsVendorUI(
      {required String hintText,
      required TextEditingController controllers,
      required double width,
      required TextInputType type,
      required validators,
      required int dropdownType,
      required StateSetter dialogSetState}) {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    AssetProvider vendorProvider =
        Provider.of<AssetProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
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
                      : const Color.fromRGBO(117, 117, 117, 1)),
              onTap: () {
                dialogSetState(() {
                  completeVendorList = vendorProvider.vendorDetailsList
                      .where((item) =>
                          item.name
                              ?.toLowerCase()
                              .contains(vendorController.text.toLowerCase()) ==
                          true)
                      .toList();
                  isDropDownOpenTicketList[2] = true;
                });
                setState(() {});
              },
              onChanged: (value) {
                dialogSetState(() {
                  completeVendorList = vendorProvider.vendorDetailsList
                      .where((item) =>
                          item.name
                              ?.toLowerCase()
                              .contains(vendorController.text.toLowerCase()) ==
                          true)
                      .toList();
                });
              },
            ),
            if (isDropDownOpenTicketList[dropdownType])
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
                    itemCount: completeVendorList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(
                            completeVendorList[index].name.toString(),
                            style: GlobalHelper.textStyle(TextStyle(
                                color: themeProvider.isDarkTheme
                                    ? Colors.white
                                    : const Color.fromRGBO(117, 117, 117, 1))),
                          ),
                          onTap: () {
                            selectedVendor = null;
                            selectedVendor = completeVendorList[index];
                            onDropdownTap(
                                dropdownType,
                                completeVendorList[index].name.toString(),
                                dialogSetState);
                          });
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget getDialogDropDownContentsModelUI(
      {required String hintText,
      required TextEditingController controllers,
      required double width,
      required TextInputType type,
      required validators,
      required int dropdownType,
      required StateSetter dialogSetState}) {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    AssetProvider modelProvider =
        Provider.of<AssetProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
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
                      : const Color.fromRGBO(117, 117, 117, 1)),
              onTap: () {
                dialogSetState(() {
                  completeModelList = modelProvider.modelDetailsList
                      .where((item) =>
                          modelController.text.isEmpty ||
                          (item.assetName?.toLowerCase().contains(
                                  modelController.text.toLowerCase()) ==
                              true))
                      .toList();
                  isDropDownOpenTicketList[3] = true;
                });
              },
              onChanged: (value) {
                dialogSetState(() {
                  completeModelList = modelProvider.modelDetailsList
                      .where((item) =>
                          modelController.text.isEmpty ||
                          (item.assetName?.toLowerCase().contains(
                                  modelController.text.toLowerCase()) ==
                              true))
                      .toList();
                });
              },
            ),
            if (isDropDownOpenTicketList[dropdownType])
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:
                        themeProvider.isDarkTheme ? Colors.black : Colors.white,
                  ),
                  margin: const EdgeInsets.only(top: 50),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: completeModelList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(
                            completeModelList[index].assetName.toString(),
                            style: GlobalHelper.textStyle(TextStyle(
                                color: themeProvider.isDarkTheme
                                    ? Colors.white
                                    : const Color.fromRGBO(117, 117, 117, 1))),
                          ),
                          onTap: () {
                            selectedModel = null;
                            selectedModel = completeModelList[index];
                            onDropdownTap(
                                dropdownType,
                                completeModelList[index].assetName.toString(),
                                dialogSetState);
                          });
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget getDialogDropDownContentsAssignUI(
      {required String hintText,
      required TextEditingController controllers,
      required double width,
      required TextInputType type,
      required validators,
      required int dropdownType,
      required StateSetter dialogSetState}) {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    AssetProvider userProvider =
        Provider.of<AssetProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
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
                      : const Color.fromRGBO(117, 117, 117, 1)),
              onTap: () {
                dialogSetState(() {
                  completeUserList = userProvider.userDetailsList
                      .where((item) =>
                          item.name
                              ?.toLowerCase()
                              .contains(assignController.text.toLowerCase()) ==
                          true)
                      .toList();
                  isDropDownOpenTicketList[4] = true;
                });
              },
              onChanged: (value) {
                dialogSetState(() {
                  completeUserList = userProvider.userDetailsList
                      .where((item) =>
                          item.name
                              ?.toLowerCase()
                              .contains(assignController.text.toLowerCase()) ==
                          true)
                      .toList();
                });
              },
            ),
            if (isDropDownOpenTicketList[dropdownType])
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: themeProvider.isDarkTheme
                          ? Colors.black
                          : Colors.white,
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
                                      : const Color.fromRGBO(
                                          117, 117, 117, 1))),
                            ),
                            onTap: () {
                              selectedAssignedUser = null;
                              selectedAssignedUser = completeUserList[index];
                              onDropdownTap(
                                  dropdownType,
                                  completeUserList[index].name.toString(),
                                  dialogSetState);
                            });
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget getDialogDropDownContentsLocationUI(
      {required String hintText,
      required TextEditingController controllers,
      required double width,
      required TextInputType type,
      required validators,
      required int dropdownType,
      required StateSetter dialogSetState}) {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    AssetProvider locationProvider =
        Provider.of<AssetProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
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
                      : const Color.fromRGBO(117, 117, 117, 1)),
              onTap: () {
                dialogSetState(() {
                  completeLocationList = locationProvider.locationDetailsList
                      .where((item) =>
                          item.name?.toLowerCase().contains(
                              locationController.text.toLowerCase()) ==
                          true)
                      .toList();
                  isDropDownOpenTicketList[6] = true;
                });
              },
              onChanged: (value) {
                dialogSetState(() {
                  completeLocationList = locationProvider.locationDetailsList
                      .where((item) =>
                          item.name?.toLowerCase().contains(
                              locationController.text.toLowerCase()) ==
                          true)
                      .toList();
                  isDropDownOpenTicketList[6] = true;
                });
              },
            ),
            if (isDropDownOpenTicketList[dropdownType])
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
                    itemCount: completeLocationList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(
                            completeLocationList[index].name.toString(),
                            style: GlobalHelper.textStyle(TextStyle(
                                color: themeProvider.isDarkTheme
                                    ? Colors.white
                                    : const Color.fromRGBO(117, 117, 117, 1))),
                          ),
                          onTap: () {
                            selectedLocation = null;
                            selectedLocation = completeLocationList[index];
                            onDropdownTap(
                                dropdownType,
                                completeLocationList[index].name.toString(),
                                dialogSetState);
                          });
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget getDialogDropDownContentsStockUI(
      {required String hintText,
      required TextEditingController controllers,
      required double width,
      required TextInputType type,
      validators,
      required int dropdownType,
      required StateSetter dialogSetState}) {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    AssetProvider stockProvider =
        Provider.of<AssetProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
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
                      : const Color.fromRGBO(117, 117, 117, 1)),
              onTap: () {
                dialogSetState(() {
                  completeStockList = stockProvider.stockDetailsList
                      .where((item) =>
                          (item.assignedTo == null &&
                              item.overAllStatus == "Functional") &&
                          (stockController.text.isEmpty ||
                              "${item.assetName} (${item.displayId})"
                                      .toLowerCase()
                                      .contains(
                                          stockController.text.toLowerCase()) ==
                                  true))
                      .toList();
                  isDropDownOpenTicketList[8] = true;
                });
              },
              onChanged: (value) {
                dialogSetState(() {
                  completeStockList = stockProvider.stockDetailsList
                      .where((item) =>
                          (item.assignedTo == null &&
                              item.overAllStatus == "Functional") &&
                          (stockController.text.isEmpty ||
                              "${item.assetName} (${item.displayId})"
                                      .toLowerCase()
                                      .contains(
                                          stockController.text.toLowerCase()) ==
                                  true))
                      .toList();
                });
              },
            ),
            if (isDropDownOpenTicketList[dropdownType])
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
                    itemCount: completeStockList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(
                            "${completeStockList[index].assetName.toString()} (${completeStockList[index].displayId.toString()})",
                            style: GlobalHelper.textStyle(TextStyle(
                                color: themeProvider.isDarkTheme
                                    ? Colors.white
                                    : const Color.fromRGBO(117, 117, 117, 1))),
                          ),
                          onTap: () {
                            selectedStock = null;
                            selectedStock = completeStockList[index];
                            onDropdownTap(
                                dropdownType,
                                "${completeStockList[index].assetName.toString()} (${completeStockList[index].displayId.toString()})",
                                dialogSetState);
                          });
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget getDialogDropDownContentsParticularUserUI(
      {required String hintText,
      required TextEditingController controllers,
      required double width,
      required TextInputType type,
      validators,
      required int dropdownType,
      required StateSetter dialogSetState}) {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    AssetProvider userProvider =
        Provider.of<AssetProvider>(context, listen: false);

    AssetProvider stockProvider =
        Provider.of<AssetProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
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
                      : const Color.fromRGBO(117, 117, 117, 1)),
              onTap: () {
                dialogSetState(() {
                  stockController.clear();
                  completeUserList = userProvider.userDetailsList
                      .where((item) =>
                          item.name
                              ?.toLowerCase()
                              .contains(userController.text.toLowerCase()) ==
                          true)
                      .toList();
                  isDropDownOpenTicketList[7] = true;
                  isDropDownOpenTicketList[8] = false;
                });
              },
              onChanged: (value) {
                dialogSetState(() {
                  completeUserList = userProvider.userDetailsList
                      .where((item) =>
                          item.name
                              ?.toLowerCase()
                              .contains(userController.text.toLowerCase()) ==
                          true)
                      .toList();
                  stockController.clear();
                });
              },
            ),
            if (isDropDownOpenTicketList[dropdownType])
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.32,
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
                          onTap: () async {
                            selectedUser = null;
                            selectedUser = completeUserList[index];
                            userController.text = selectedUser!.name.toString();
                            onDropdownTap(dropdownType,
                                selectedUser!.name.toString(), dialogSetState);
                            var assetStockId = selectedUser?.assetStockRefId;
                            stockProvider.fetchParticularStockDetails(
                              assetStockId: assetStockId,
                            );
                          });
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget getDialogDropDownContentsParticularStockForAdminServiceUI(
      {required String hintText,
      required TextEditingController controllers,
      required double width,
      required TextInputType type,
      required validators,
      required int dropdownType,
      required StateSetter dialogSetState}) {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    AssetProvider stockProvider =
        Provider.of<AssetProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
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
                      : const Color.fromRGBO(117, 117, 117, 1)),
              onTap: () {
                dialogSetState(() {
                  if (userController.text.isNotEmpty) {
                    completeStockList = stockProvider.particularStockDetailsList
                        .where((item) =>
                            stockController.text.isEmpty ||
                            ("${item.assetName} (${item.displayId})"
                                    .toLowerCase()
                                    .contains(
                                        stockController.text.toLowerCase()) ==
                                true))
                        .toList();

                    isDropDownOpenTicketList[8] = true;
                    isDropDownOpenTicketList[7] = false;
                  } else {
                    completeStockList = stockProvider.stockDetailsList
                        .where((item) =>
                            (item.assignedTo == null) &&
                            (stockController.text.isEmpty ||
                                "${item.assetName} (${item.displayId})"
                                        .toLowerCase()
                                        .contains(stockController.text
                                            .toLowerCase()) ==
                                    true))
                        .toList();

                    isDropDownOpenTicketList[8] = true;
                    isDropDownOpenTicketList[7] = false;
                  }
                });
              },
              onChanged: (value) {
                dialogSetState(() {
                  if (userController.text.isNotEmpty) {
                    completeStockList = stockProvider.particularStockDetailsList
                        .where((item) =>
                            stockController.text.isEmpty ||
                            ("${item.assetName} (${item.displayId})"
                                    .toLowerCase()
                                    .contains(
                                        stockController.text.toLowerCase()) ==
                                true))
                        .toList();

                    isDropDownOpenTicketList[8] = true;
                  } else {
                    completeStockList = stockProvider.stockDetailsList
                        .where((item) =>
                            (item.assignedTo == null) &&
                            (stockController.text.isEmpty ||
                                "${item.assetName} (${item.displayId})"
                                        .toLowerCase()
                                        .contains(stockController.text
                                            .toLowerCase()) ==
                                    true))
                        .toList();

                    isDropDownOpenTicketList[8] = true;
                  }
                });
              },
            ),
            if (isDropDownOpenTicketList[dropdownType])
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
                    itemCount: completeStockList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(
                            "${completeStockList[index].assetName.toString()} (${completeStockList[index].displayId.toString()})",
                            style: GlobalHelper.textStyle(TextStyle(
                                color: themeProvider.isDarkTheme
                                    ? Colors.white
                                    : const Color.fromRGBO(117, 117, 117, 1))),
                          ),
                          onTap: () {
                            selectedStock = null;
                            selectedStock = completeStockList[index];
                            onDropdownTap(
                                dropdownType,
                                "${completeStockList[index].assetName.toString()} (${completeStockList[index].displayId.toString()})",
                                dialogSetState);
                          });
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget getDialogDropDownContentsParticularStockUI(
      {required String hintText,
      required TextEditingController controllers,
      required double width,
      required TextInputType type,
      required validators,
      required int dropdownType,
      required StateSetter dialogSetState}) {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    AssetProvider stockProvider =
        Provider.of<AssetProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
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
                      : const Color.fromRGBO(117, 117, 117, 1)),
              onTap: () {
                dialogSetState(() {
                  completeStockList = stockProvider.particularStockDetailsList
                      .where((item) =>
                          stockController.text.isEmpty ||
                          ("${item.assetName} (${item.displayId})"
                                  .toLowerCase()
                                  .contains(
                                      stockController.text.toLowerCase()) ==
                              true))
                      .toList();

                  isDropDownOpenTicketList[8] = true;
                });
              },
              onChanged: (value) {
                dialogSetState(() {
                  completeStockList = stockProvider.particularStockDetailsList
                      .where((item) =>
                          stockController.text.isEmpty ||
                          ("${item.assetName} (${item.displayId})"
                                  .toLowerCase()
                                  .contains(
                                      stockController.text.toLowerCase()) ==
                              true))
                      .toList();
                });
              },
            ),
            if (isDropDownOpenTicketList[dropdownType])
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
                    itemCount: completeStockList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(
                            "${completeStockList[index].assetName.toString()} (${completeStockList[index].displayId.toString()})",
                            style: GlobalHelper.textStyle(TextStyle(
                                color: themeProvider.isDarkTheme
                                    ? Colors.white
                                    : const Color.fromRGBO(117, 117, 117, 1))),
                          ),
                          onTap: () {
                            selectedStock = null;
                            selectedStock = completeStockList[index];
                            onDropdownTap(
                                dropdownType,
                                "${completeStockList[index].assetName.toString()} (${completeStockList[index].displayId.toString()})",
                                dialogSetState);
                          });
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  onDropdownTap(int dropdownType, String selectedOption, StateSetter setState) {
    if (dropdownType == 0) {
      setState(() {
        typeController.text = selectedOption;
        isDropDownOpenTicketList[0] = false;
        selectedType = typeController.text;
        sizedBoxHeight = height[selectedType]!;
      });
    } else if (dropdownType == 1) {
      setState(() {
        priorityController.text = selectedOption;
        isDropDownOpenTicketList[1] = false;
        selectedPriority = priorityController.text;
      });
    } else if (dropdownType == 2) {
      setState(() {
        vendorController.text = selectedOption;
        isDropDownOpenTicketList[2] = false;
      });
    } else if (dropdownType == 3) {
      setState(() {
        modelController.text = selectedOption;
        isDropDownOpenTicketList[3] = false;
      });
    } else if (dropdownType == 4) {
      setState(() {
        assignController.text = selectedOption;
        isDropDownOpenTicketList[4] = false;
      });
    } else if (dropdownType == 5) {
      setState(() {
        statusController.text = selectedOption;
        isDropDownOpenTicketList[5] = false;
        selectedStatus = statusController.text;
      });
    } else if (dropdownType == 6) {
      setState(() {
        locationController.text = selectedOption;
        isDropDownOpenTicketList[6] = false;
      });
    } else if (dropdownType == 7) {
      setState(() {
        userController.text = selectedOption;
        isDropDownOpenTicketList[7] = false;
      });
    } else if (dropdownType == 8) {
      setState(() {
        stockController.text = selectedOption;
        isDropDownOpenTicketList[8] = false;
      });
    } else if (dropdownType == 0) {
      setState(() {
        userTypeController.text = selectedOption;
        isDropDownOpenTicketListForUser[0] = false;
        userSelectedType = userTypeController.text;
        sizedBoxHeight = userTypeHeight[userSelectedType]!;
      });
    } else {
      return;
    }
  }

  onDropdownTapUser(
      int dropdownType, String selectedOption, StateSetter setState) {
    if (dropdownType == 0) {
      setState(() {
        userTypeController.text = selectedOption;
        isDropDownOpenTicketListForUser[0] = false;
        userSelectedType = userTypeController.text;
        sizedBoxHeight = userTypeHeight[userSelectedType]!;
      });
    } else {
      return;
    }
  }

  /// It used to select the date in dialog
  _selectDate(context, StateSetter dialogSetState,
      {required dateControllers}) async {
    final DateTime? picked = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 100)),
        initialDate: selectedDate);

    if (picked != null) {
      String formatDate = DateFormat('dd/MM/yyyy').format(picked);
      dialogSetState(() {
        dateControllers.text = formatDate;
      });
    }
  }

  Future<void> pickFile(context, StateSetter dialogSetState,
      {required List<String> allowedExtension}) async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: allowedExtension);

    if (file != null) {
      filePicked = file.files.first;
      String fileName = file.files.first.name;
      dialogSetState(() {
        selectedFileName = fileName;
      });
    } else {
      return;
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

  Future<void> addTicket(AddTicket ticket, BoolProvider boolProviders,
      AssetProvider ticketProvider) async {
    await AddUpdateDetailsManagerWithFile(
      data: ticket,
      file: filePicked,
      apiURL: 'ticket/addTicket',
    ).addUpdateDetailsWithFile(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("Ticket Added Successfully");
        ticketProvider.fetchTicketDetails();
      });
    } else {
      setState(() {
        showToast("Unable to add the ticket");
      });
    }
  }
}
