import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../global/global_variables.dart';
import '../../helpers/global_helper.dart';
import '../../helpers/http_helper.dart';
import '../../helpers/ui_components.dart';
import '../../models/asset_model/asset_model_model/asset_model_details.dart';
import '../../models/asset_model/asset_stock_model/add_warranty.dart';
import '../../models/asset_model/asset_stock_model/asset_stock.dart';
import '../../models/directory_model/location_model/location_details.dart';
import '../../models/directory_model/vendor_model/vendor_details.dart';
import '../../models/ticket_model/add_ticket.dart';
import '../../models/ticket_model/checklist.dart';
import '../../models/ticket_model/ticket_details.dart';
import '../../models/user_management_model/user_model/user_details.dart';
import '../../provider/main_providers/asset_provider.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';
import 'dart:convert';
import 'dart:developer';

class UpdateTicket extends StatefulWidget {
  const UpdateTicket({super.key, required this.ticket});

  final TicketDetails ticket;

  @override
  State<UpdateTicket> createState() => _UpdateTicketState();
}

class _UpdateTicketState extends State<UpdateTicket> {
  List<String> masterType = [
    "Asset Procurement",
    "User Assignment",
    "Asset Return",
    "Service Request"
  ];
  List<String> typeList = [];
  List<String> type = [];
  String? selectedType;

  List<String> masterStatus = [
    "In Progress",
    "Waiting For Approval",
    "Approved",
    "Completed",
    "Rejected"
  ];
  List<String> statusList = [];
  List<String> status = [];
  String? selectedStatus;

  List<String> parameterList = [];

  List<bool> checkedList = [];

  List<String> warrantyAttachments = [];

  String? selectedModelId;
  String? selectedStockId;
  String? selectedUserId;

  String? dropDownValueVendor;
  String? dropDownValuePriority;
  String? dropDownValueStatus;
  String? dropDownValueLocation;
  String? dropDownValueAssignedTo;

  late String id;

  late String stockId;

  late DateTime selectedDate;
  late DateTime selectDate;
  late DateTime selectedPurchaseDate;
  late TimeOfDay selectedTime;

  PlatformFile? imagePicked;

  PlatformFile? filePicked;

  String selectedImageName = 'Image';

  String selectedFileName = 'Attachment';

  bool isEstimatedDate = true;
  bool isExpectedDate = true;

  bool isTicketCompleted = false;

  List<String> masterPriority = ["High", "Medium", "Low"];
  List<String> priorityList = [];
  List<String> priority = [];
  String? selectedPriority;

  List<String> tag = [];
  List<String> tagList = [];

  VendorDetails? selectedVendorName;
  VendorDetails? selectedVendor;

  List<UserDetails> completeUserList = [];
  UserDetails? selectedAssignedUser;
  UserDetails? selectedAssignedUserName;

  List<LocationDetails> completeLocationList = [];
  LocationDetails? selectedLocationName;
  LocationDetails? selectedLocation;

  double sizedBoxHeight = 10.0;

  Map<String, double> height = {
    'Asset Procurement': 10.0,
    'User Assignment': 80.0,
    'Asset Return': 85.0,
    'Service Request': 85.0,
  };

  int currentStep = 0;
  int currentStockStep = 0;
  StepperType stepperType = StepperType.horizontal;

  List<GlobalKey<FormState>> formKeyStepTicket = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  List<GlobalKey<FormState>> formKeyStepStock = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  TextEditingController typeController = TextEditingController();
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
  TextEditingController serialController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  TextEditingController stockRemarksController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController commentsController = TextEditingController();
  TextEditingController editCommentController = TextEditingController();
  TextEditingController purchaseDateController = TextEditingController();
  TextEditingController warrantyDaysController = TextEditingController();
  TextEditingController warrantyMonthsController = TextEditingController();
  TextEditingController warrantyYearsController = TextEditingController();
  List<TextEditingController> particularExpiryDateController = [];
  List<TextEditingController> particularWarrantyNameController = [];
  late List<TextEditingController> checkListRemarksController;

  @override
  void initState() {
    super.initState();
    Provider.of<AssetProvider>(context, listen: false).fetchTicketDetails();
    Provider.of<AssetProvider>(context, listen: false).fetchVendorDetails();
    Provider.of<AssetProvider>(context, listen: false).fetchModelDetails();
    Provider.of<AssetProvider>(context, listen: false).fetchStockDetails();
    Provider.of<AssetProvider>(context, listen: false).fetchUserDetails();
    Provider.of<AssetProvider>(context, listen: false).fetchLocationDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BoolProvider, AssetProvider>(
        builder: (context, themeProvider, stockProvider, child) {
      return Dialog(
        backgroundColor: const Color(0xfff3f1ef),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                color: themeProvider.isDarkTheme
                    ? const Color.fromRGBO(16, 18, 33, 1)
                    : const Color(0xfff3f1ef),
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
                  child: Text(
                    "UPDATE TICKET",
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
                Expanded(
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
                      setState(() {
                        currentStep = step;
                        remarksController.text =
                            remarksController.text.isNotEmpty
                                ? remarksController.text
                                : widget.ticket.remarks.toString();
                        assignController.text = selectedAssignedUser == null
                            ? widget.ticket.assignedName.toString()
                            : selectedAssignedUserName!.name.toString();
                        etaDateController.text =
                            etaDateController.text.isNotEmpty
                                ? etaDateController.text
                                : widget.ticket.estimatedTime.toString();
                        statusController.text = selectedStatus == null
                            ? widget.ticket.status.toString()
                            : selectedStatus.toString();
                        selectedStockId = widget.ticket.stockRefId;
                        selectedUserId = widget.ticket.userRefId;
                        selectedType = widget.ticket.type.toString();
                        selectedModelId = widget.ticket.modelRefId.toString();
                      });
                    },
                    steps: getStepsUpdateTicketDialog(
                      setState,
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
                          : Colors.white,
                      ticketTrackerList: widget.ticket.trackers ?? List.empty(),
                    ),
                    controlsBuilder: (context, details) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.050,
                              width: MediaQuery.of(context).size.width * 0.075,
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
                                    style:
                                        GlobalHelper.textStyle(const TextStyle(
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
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.050,
                                    width: MediaQuery.of(context).size.width *
                                        0.075,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            currentStep -= 1;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)))),
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
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.050,
                                  width:
                                      MediaQuery.of(context).size.width * 0.075,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        final steps = getStepsUpdateTicketDialog(
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
                                            textColor: themeProvider.isDarkTheme
                                                ? Colors.white
                                                : const Color.fromRGBO(
                                                    117, 117, 117, 1),
                                            fillColor: themeProvider.isDarkTheme
                                                ? Colors.black
                                                : Colors.white,
                                            containerColor:
                                                themeProvider.isDarkTheme
                                                    ? Colors.black
                                                    : Colors.white,
                                            dividerColor:
                                                themeProvider.isDarkTheme
                                                    ? Colors.black
                                                    : Colors.white,
                                            ticketTrackerList:
                                                widget.ticket.trackers ??
                                                    List.empty());

                                        if (currentStep < steps.length - 1) {
                                          if (formKeyStepTicket[currentStep]
                                              .currentState!
                                              .validate()) {
                                            setState(() {
                                              currentStep++;
                                              remarksController.text =
                                                  remarksController
                                                          .text.isNotEmpty
                                                      ? remarksController.text
                                                      : widget.ticket.remarks
                                                          .toString();
                                              assignController.text =
                                                  selectedAssignedUser == null
                                                      ? widget
                                                          .ticket.assignedName
                                                          .toString()
                                                      : selectedAssignedUserName!
                                                          .name
                                                          .toString();
                                              etaDateController.text =
                                                  etaDateController
                                                          .text.isNotEmpty
                                                      ? etaDateController.text
                                                      : widget
                                                          .ticket.estimatedTime
                                                          .toString();
                                              statusController.text =
                                                  selectedStatus == null
                                                      ? widget.ticket.status
                                                          .toString()
                                                      : selectedStatus
                                                          .toString();

                                              selectedStockId =
                                                  widget.ticket.stockRefId;
                                              selectedUserId =
                                                  widget.ticket.userRefId;
                                              selectedType =
                                                  widget.ticket.type.toString();
                                              selectedModelId = widget
                                                  .ticket.modelRefId
                                                  .toString();
                                            });
                                          } else {
                                            return;
                                          }
                                        } else {
                                          if (formKeyStepTicket[currentStep]
                                              .currentState!
                                              .validate()) {
                                            await _onTapEditButton();

                                            if ((selectedType == "User Assignment" && selectedStatus != "Completed") ||
                                                (selectedType ==
                                                        "Asset Return" &&
                                                    selectedStatus !=
                                                        "Completed") ||
                                                (selectedType ==
                                                        "Service Request" &&
                                                    selectedStatus !=
                                                        "Completed") ||
                                                (selectedType ==
                                                        "Asset Procurement" &&
                                                    selectedStatus !=
                                                        "Completed")) {
                                              if (mounted) {
                                                Navigator.of(context).pop();
                                              }
                                            }

                                            if (selectedType ==
                                                    "Asset Procurement" &&
                                                selectedStatus == "Completed") {
                                              if (mounted) {
                                                showLargeStockDialogUI(context);
                                              }
                                            }

                                            if (selectedType ==
                                                    "User Assignment" &&
                                                selectedStatus == "Completed") {
                                              if (isTicketCompleted) {
                                                AssetStock stock = AssetStock(
                                                    userRefId: selectedUserId,
                                                    sId: selectedStockId);

                                                await userAssignment(
                                                    stock,
                                                    themeProvider,
                                                    stockProvider);

                                                if (mounted) {
                                                  Navigator.of(context).pop();
                                                }
                                              }
                                            }

                                            if (selectedType ==
                                                    "Asset Return" &&
                                                selectedStatus == "Completed") {
                                              if (isTicketCompleted) {
                                                AssetStock stock = AssetStock(
                                                    userRefId: selectedUserId,
                                                    sId: selectedStockId);

                                                await assetReturn(
                                                    stock,
                                                    themeProvider,
                                                    stockProvider);

                                                stockProvider
                                                    .fetchParticularStockDetails(
                                                        assetStockId:
                                                            selectedStockId);

                                                for (int i = 0;
                                                    i <
                                                        stockProvider
                                                            .particularStockDetailsList
                                                            .length;) {
                                                  var stockDetails = stockProvider
                                                      .particularStockDetailsList[i];

                                                  parameterList = List.from(
                                                      stockDetails.parameters!);

                                                  checkedList =
                                                      List<bool>.filled(
                                                          parameterList.length,
                                                          false);

                                                  checkListRemarksController =
                                                      List.generate(
                                                          parameterList.length,
                                                          (index) =>
                                                              TextEditingController());
                                                  if (mounted) {
                                                    getAssetReturnCheckListUI(
                                                        context);
                                                  }
                                                  break;
                                                }
                                              }
                                            }

                                            if (selectedType ==
                                                    "Service Request" &&
                                                selectedStatus == "Completed") {
                                              if (isTicketCompleted) {
                                                stockProvider
                                                    .fetchParticularStockDetails(
                                                        assetStockId:
                                                            selectedStockId);

                                                if (stockProvider
                                                    .particularStockDetailsList
                                                    .isNotEmpty) {
                                                  for (int i = 0;
                                                      i <
                                                          stockProvider
                                                              .particularStockDetailsList
                                                              .length;) {
                                                    var stockDetails = stockProvider
                                                        .particularStockDetailsList[i];

                                                    parameterList = List.from(
                                                        stockDetails
                                                            .parameters!);

                                                    checkedList =
                                                        List<bool>.filled(
                                                            parameterList
                                                                .length,
                                                            false);

                                                    checkListRemarksController =
                                                        List.generate(
                                                            parameterList
                                                                .length,
                                                            (index) =>
                                                                TextEditingController());

                                                    if (mounted) {
                                                      getAssetReturnCheckListUI(
                                                          context);
                                                    }
                                                    break;
                                                  }
                                                }
                                              }
                                            }
                                          } else {
                                            return;
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)))),
                                      child: Text(
                                        currentStep == 1 ? "Save" : "Next",
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
                )),
              ],
            ),
          ),
        ),
      );
    });
  }

  List<Step> getStepsUpdateTicketDialog(StateSetter setState,
          {required color,
          required colors,
          required borderColor,
          required textColor,
          required fillColor,
          required containerColor,
          required dividerColor,
          required List<TicketTracker> ticketTrackerList}) =>
      [
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
            key: formKeyStepTicket[0],
            child: getUpdateTicketUI(setState),
          ),
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 0,
        ),
        Step(
          title: Text(
            'Status',
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
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getDialogDropDownContentsAssignUI(
                                        hintText: 'Assigned To',
                                        controllers: assignController,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        type: TextInputType.none,
                                        validators: commonValidator,
                                        dropdownType: 4,
                                        dialogSetState: setState),
                                    getDialogDropDownContentsUI(
                                      hintText: 'Status',
                                      controllers: statusController,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      type: TextInputType.none,
                                      dropdownList: statusList,
                                      dropdownType: 5,
                                      validators: commonValidator,
                                      dialogSetState: setState,
                                      onTapTextField: () {
                                        setState(() {
                                          statusList = masterStatus
                                              .where((item) => item
                                                  .toLowerCase()
                                                  .contains(statusController
                                                      .text
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
                                        setState(() {
                                          statusList = masterStatus
                                              .where((item) => item
                                                  .toLowerCase()
                                                  .contains(statusController
                                                      .text
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
                                    getDialogContentsUI(
                                        hintText: 'Remarks',
                                        controllers: remarksController,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        type: TextInputType.text,
                                        dialogSetState: setState,
                                        borderColor: borderColor,
                                        textColor: textColor,
                                        color: fillColor),
                                    getDialogIconButtonContentsUI(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        hintText:
                                            "Estimated Date for Resolution",
                                        suffixIcon:
                                            Icons.calendar_today_rounded,
                                        iconColor: const Color.fromRGBO(
                                            15, 117, 188, 1),
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
                                Container(
                                  width: 3,
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  color: dividerColor,
                                ),
                                SizedBox(
                                  height: 300,
                                  width: 300,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: ticketTrackerList.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(6, 6, 6, 0),
                                                    child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.blue,
                                                      ),
                                                      alignment:
                                                          Alignment.topCenter,
                                                    ),
                                                  ),
                                                  if (index !=
                                                      ticketTrackerList.length -
                                                          1)
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(8, 8, 8, 8),
                                                      child: Container(
                                                        width: 3,
                                                        height: 100,
                                                        color: const Color(
                                                            0xffbdbdbd),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              Wrap(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    15)),
                                                        border: Border.all(
                                                            color:
                                                                dividerColor)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            ticketTrackerList[
                                                                    index]
                                                                .status
                                                                .toString()
                                                                .toUpperCase(),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            style: GoogleFonts
                                                                .ubuntu(
                                                                    textStyle:
                                                                        TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: color,
                                                            )),
                                                          ),
                                                          Text(
                                                            ticketTrackerList[
                                                                    index]
                                                                .createdAt
                                                                .toString(),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            style: GoogleFonts
                                                                .ubuntu(
                                                                    textStyle:
                                                                        TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .grey[500],
                                                            )),
                                                          ),
                                                          Text(
                                                            ticketTrackerList[
                                                                    index]
                                                                .createdBy
                                                                .toString(),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            style: GoogleFonts
                                                                .ubuntu(
                                                                    textStyle:
                                                                        TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: color,
                                                            )),
                                                          ),
                                                          Text(
                                                            ticketTrackerList[
                                                                    index]
                                                                .remarks
                                                                .toString(),
                                                            maxLines: 3,
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            style: GoogleFonts
                                                                .ubuntu(
                                                                    textStyle:
                                                                        TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: color,
                                                            )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 1,
        ),
      ];

  getUpdateTicketUI(StateSetter setState) {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    AssetProvider userProvider =
        Provider.of<AssetProvider>(context, listen: false);

    AssetProvider vendorProvider =
        Provider.of<AssetProvider>(context, listen: false);

    AssetProvider locationProvider =
        Provider.of<AssetProvider>(context, listen: false);

    if (widget.ticket.type == "Asset Procurement") {
      return Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 20),
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(67, 66, 66, 0.060),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              width: MediaQuery.of(context).size.width * 0.50,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: themeProvider.isDarkTheme
                                        ? const Color.fromRGBO(16, 18, 33, 1)
                                        : const Color(0xfff3f1ef),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15))),
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor:
                                            themeProvider.isDarkTheme
                                                ? Colors.black
                                                : Colors.white,
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: ClipOval(
                                            child: Builder(
                                              builder: (BuildContext context) {
                                                if (imagePicked != null) {
                                                  return Image.memory(
                                                      imagePicked!.bytes!,
                                                      fit: BoxFit.cover);
                                                } else {
                                                  return Image.network(
                                                    '$websiteURL/images/${widget.ticket.userImage}',
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
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
                                                        (BuildContext context,
                                                            Object error,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return Image.asset(
                                                        themeProvider
                                                                .isDarkTheme
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.12,
                                            child: Text(
                                              widget.ticket.assignedName
                                                  .toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: TextStyle(
                                                fontSize: 17,
                                                color: themeProvider.isDarkTheme
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold,
                                              )),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.12,
                                            child: Text(
                                              widget.ticket.userDesignation
                                                  .toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: TextStyle(
                                                fontSize: 15,
                                                color: themeProvider.isDarkTheme
                                                    ? Colors.white
                                                    : Colors.black,
                                              )),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.12,
                                            child: Text(
                                              widget.ticket.userEmpId
                                                  .toString(),
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: TextStyle(
                                                fontSize: 14,
                                                color: themeProvider.isDarkTheme
                                                    ? Colors.white
                                                    : Colors.black,
                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Ticket ID'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: getTicketStatusContentUI(
                                              content: widget.ticket.displayId
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Type'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 40),
                                            child: getTicketStatusContentUI(
                                              content:
                                                  widget.ticket.type.toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Vendor'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 35),
                                            child: getVendorDropDownContentUI(
                                              text: widget.ticket.vendorName
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  dropDownValueVendor = value!;
                                                  selectedVendorName =
                                                      vendorProvider
                                                          .vendorDetailsList
                                                          .firstWhereOrNull(
                                                              (vendor) =>
                                                                  vendor.name ==
                                                                  value);
                                                  if (selectedVendorName !=
                                                      null) {
                                                    selectedVendor =
                                                        selectedVendorName;
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Model'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 35),
                                            child: getTicketStatusContentUI(
                                              content: widget.ticket.modelName
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Priority'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 35),
                                            child: getPriorityDropDownContentUI(
                                              text: widget.ticket.priority
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  dropDownValuePriority =
                                                      value!;
                                                  priorityController.text =
                                                      value;
                                                  selectedPriority =
                                                      priorityController.text;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
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
                                      Row(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Expected Date'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: getTimeContentUI(
                                              content: isExpectedDate
                                                  ? widget.ticket.expectedTime
                                                      .toString()
                                                  : dateController.text,
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              onPressed: () {
                                                setState(() {
                                                  selectedDate = DateTime.now();
                                                  _selectDate(context, setState,
                                                      dateControllers:
                                                          dateController);
                                                  isExpectedDate = false;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Assigned To'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 45),
                                            child:
                                                getAssignedToDropDownContentUI(
                                              text: widget.ticket.assignedName
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  dropDownValueAssignedTo =
                                                      value!;
                                                  assignController.text = value;
                                                  selectedAssignedUserName =
                                                      userProvider
                                                          .userDetailsList
                                                          .firstWhereOrNull(
                                                              (user) =>
                                                                  user.name ==
                                                                  value);
                                                  if (selectedAssignedUserName !=
                                                      null) {
                                                    selectedAssignedUser =
                                                        selectedAssignedUserName;
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Status'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 85),
                                            child: getStatusDropDownContentUI(
                                              text: widget.ticket.status
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  dropDownValueStatus = value!;
                                                  statusController.text = value;
                                                  selectedStatus =
                                                      statusController.text;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Location'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 70),
                                            child: getLocationDropDownContentUI(
                                              text: widget.ticket.locationName
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  dropDownValueLocation =
                                                      value!;
                                                  selectedLocationName =
                                                      locationProvider
                                                          .locationDetailsList
                                                          .firstWhereOrNull(
                                                              (location) =>
                                                                  location
                                                                      .name ==
                                                                  value);
                                                  if (selectedLocationName !=
                                                      null) {
                                                    selectedLocation =
                                                        selectedLocationName;
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Estimated Date'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: getTimeContentUI(
                                              content: isEstimatedDate
                                                  ? widget.ticket.estimatedTime
                                                      .toString()
                                                  : etaDateController.text,
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              onPressed: () {
                                                setState(() {
                                                  selectedDate = DateTime.now();
                                                  _selectDate(context, setState,
                                                      dateControllers:
                                                          etaDateController);
                                                  isEstimatedDate = false;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          getDialogContentsUI(
                              hintText: 'Remarks',
                              controllers: remarksController,
                              width: MediaQuery.of(context).size.width * 0.20,
                              type: TextInputType.text,
                              dialogSetState: setState,
                              borderColor: themeProvider.isDarkTheme
                                  ? Colors.black
                                  : Colors.white,
                              textColor: themeProvider.isDarkTheme
                                  ? Colors.white
                                  : const Color.fromRGBO(117, 117, 117, 1),
                              color: themeProvider.isDarkTheme
                                  ? Colors.black
                                  : Colors.white),
                          getDialogFileContentsUI(
                              secondaryWidth:
                                  MediaQuery.of(context).size.width * 0.15,
                              width: MediaQuery.of(context).size.width * 0.20,
                              dialogSetState: setState,
                              text: selectedFileName,
                              onPressed: () {
                                setState(() {
                                  pickFile(context, setState,
                                      allowedExtension: ['pdf', 'doc']);
                                });
                              },
                              icon: Icons.attachment_rounded,
                              borderColor: themeProvider.isDarkTheme
                                  ? Colors.black
                                  : Colors.white,
                              textColor: themeProvider.isDarkTheme
                                  ? Colors.white
                                  : const Color.fromRGBO(117, 117, 117, 1),
                              containerColor: themeProvider.isDarkTheme
                                  ? Colors.black
                                  : Colors.white),
                        ]),
                    const SizedBox(
                      height: 10,
                    ),
                    getDialogContentsUI(
                      hintText: 'Description',
                      controllers: descriptionsController,
                      width: MediaQuery.of(context).size.width * 0.20,
                      type: TextInputType.text,
                      dialogSetState: setState,
                      borderColor: themeProvider.isDarkTheme
                          ? Colors.black
                          : Colors.white,
                      textColor: themeProvider.isDarkTheme
                          ? Colors.white
                          : const Color.fromRGBO(117, 117, 117, 1),
                      color: themeProvider.isDarkTheme
                          ? Colors.black
                          : Colors.white,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else if (widget.ticket.type == "User Assignment") {
      return Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 20),
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(67, 66, 66, 0.060),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              width: MediaQuery.of(context).size.width * 0.50,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: themeProvider.isDarkTheme
                                        ? const Color.fromRGBO(16, 18, 33, 1)
                                        : const Color(0xfff3f1ef),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15))),
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor:
                                            themeProvider.isDarkTheme
                                                ? Colors.black
                                                : Colors.white,
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: ClipOval(
                                            child: Builder(
                                              builder: (BuildContext context) {
                                                if (imagePicked != null) {
                                                  return Image.memory(
                                                      imagePicked!.bytes!,
                                                      fit: BoxFit.cover);
                                                } else {
                                                  return Image.network(
                                                    '$websiteURL/images/${widget.ticket.userImage}',
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
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
                                                        (BuildContext context,
                                                            Object error,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return Image.asset(
                                                        themeProvider
                                                                .isDarkTheme
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.12,
                                            child: Text(
                                              widget.ticket.assignedName
                                                  .toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: TextStyle(
                                                fontSize: 17,
                                                color: themeProvider.isDarkTheme
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold,
                                              )),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.12,
                                            child: Text(
                                              widget.ticket.userDesignation
                                                  .toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: TextStyle(
                                                fontSize: 15,
                                                color: themeProvider.isDarkTheme
                                                    ? Colors.white
                                                    : Colors.black,
                                              )),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.12,
                                            child: Text(
                                              widget.ticket.userEmpId
                                                  .toString(),
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: TextStyle(
                                                fontSize: 14,
                                                color: themeProvider.isDarkTheme
                                                    ? Colors.white
                                                    : Colors.black,
                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Ticket ID'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: getTicketStatusContentUI(
                                              content: widget.ticket.displayId
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Type'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 40),
                                            child: getTicketStatusContentUI(
                                              content:
                                                  widget.ticket.type.toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'User'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 40),
                                            child: getTicketStatusContentUI(
                                              content:
                                                  widget.ticket.userName != null
                                                      ? widget.ticket.userName
                                                          .toString()
                                                      : "Not Assigned",
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Stock'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 37),
                                            child: getTicketStatusContentUI(
                                              content: widget.ticket.stockName
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
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
                                      Row(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Assigned To'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 45),
                                            child:
                                                getAssignedToDropDownContentUI(
                                              text: widget.ticket.assignedName
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  dropDownValueAssignedTo =
                                                      value;
                                                  assignController.text =
                                                      value!;
                                                  selectedAssignedUserName =
                                                      userProvider
                                                          .userDetailsList
                                                          .firstWhereOrNull(
                                                              (user) =>
                                                                  user.name ==
                                                                  value);
                                                  if (selectedAssignedUserName !=
                                                      null) {
                                                    selectedAssignedUser =
                                                        selectedAssignedUserName;
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Status'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 85),
                                            child: getStatusDropDownContentUI(
                                              text: widget.ticket.status
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  dropDownValueStatus = value!;
                                                  statusController.text = value;
                                                  selectedStatus =
                                                      statusController.text;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Location'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 70),
                                            child: getLocationDropDownContentUI(
                                              text: widget.ticket.locationName
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  dropDownValueLocation =
                                                      value!;
                                                  selectedLocationName =
                                                      locationProvider
                                                          .locationDetailsList
                                                          .firstWhereOrNull(
                                                              (location) =>
                                                                  location
                                                                      .name ==
                                                                  value);
                                                  if (selectedLocationName !=
                                                      null) {
                                                    selectedLocation =
                                                        selectedLocationName;
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Estimated Date'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: getTimeContentUI(
                                              content: isEstimatedDate
                                                  ? widget.ticket.estimatedTime
                                                      .toString()
                                                  : etaDateController.text,
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              onPressed: () {
                                                setState(() {
                                                  selectedDate = DateTime.now();
                                                  _selectDate(context, setState,
                                                      dateControllers:
                                                          etaDateController);
                                                  isEstimatedDate = false;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          getDialogContentsUI(
                              hintText: 'Remarks',
                              controllers: remarksController,
                              width: MediaQuery.of(context).size.width * 0.20,
                              type: TextInputType.text,
                              dialogSetState: setState,
                              borderColor: themeProvider.isDarkTheme
                                  ? Colors.black
                                  : Colors.white,
                              textColor: themeProvider.isDarkTheme
                                  ? Colors.white
                                  : const Color.fromRGBO(117, 117, 117, 1),
                              color: themeProvider.isDarkTheme
                                  ? Colors.black
                                  : Colors.white),
                          getDialogFileContentsUI(
                              secondaryWidth:
                                  MediaQuery.of(context).size.width * 0.15,
                              width: MediaQuery.of(context).size.width * 0.20,
                              dialogSetState: setState,
                              text: selectedFileName,
                              onPressed: () {
                                setState(() {
                                  pickFile(context, setState,
                                      allowedExtension: ['pdf', 'doc']);
                                });
                              },
                              icon: Icons.attachment_rounded,
                              borderColor: themeProvider.isDarkTheme
                                  ? Colors.black
                                  : Colors.white,
                              textColor: themeProvider.isDarkTheme
                                  ? Colors.white
                                  : const Color.fromRGBO(117, 117, 117, 1),
                              containerColor: themeProvider.isDarkTheme
                                  ? Colors.black
                                  : Colors.white),
                        ]),
                    const SizedBox(
                      height: 10,
                    ),
                    getDialogContentsUI(
                        hintText: 'Description',
                        controllers: descriptionsController,
                        width: MediaQuery.of(context).size.width * 0.20,
                        type: TextInputType.text,
                        dialogSetState: setState,
                        borderColor: themeProvider.isDarkTheme
                            ? Colors.black
                            : Colors.white,
                        textColor: themeProvider.isDarkTheme
                            ? Colors.white
                            : const Color.fromRGBO(117, 117, 117, 1),
                        color: themeProvider.isDarkTheme
                            ? Colors.black
                            : Colors.white),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else if (widget.ticket.type == "Asset Return") {
      return Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 20),
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(67, 66, 66, 0.060),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              width: MediaQuery.of(context).size.width * 0.50,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: themeProvider.isDarkTheme
                                        ? const Color.fromRGBO(16, 18, 33, 1)
                                        : const Color(0xfff3f1ef),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15))),
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor:
                                            themeProvider.isDarkTheme
                                                ? Colors.black
                                                : Colors.white,
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: ClipOval(
                                            child: Builder(
                                              builder: (BuildContext context) {
                                                if (imagePicked != null) {
                                                  return Image.memory(
                                                      imagePicked!.bytes!,
                                                      fit: BoxFit.cover);
                                                } else {
                                                  return Image.network(
                                                    '$websiteURL/images/${widget.ticket.userImage}',
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
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
                                                        (BuildContext context,
                                                            Object error,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return Image.asset(
                                                        themeProvider
                                                                .isDarkTheme
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.12,
                                            child: Text(
                                              widget.ticket.assignedName
                                                  .toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: TextStyle(
                                                fontSize: 17,
                                                color: themeProvider.isDarkTheme
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold,
                                              )),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.12,
                                            child: Text(
                                              widget.ticket.userDesignation
                                                  .toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: TextStyle(
                                                fontSize: 15,
                                                color: themeProvider.isDarkTheme
                                                    ? Colors.white
                                                    : Colors.black,
                                              )),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.12,
                                            child: Text(
                                              widget.ticket.userEmpId
                                                  .toString(),
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: TextStyle(
                                                fontSize: 14,
                                                color: themeProvider.isDarkTheme
                                                    ? Colors.white
                                                    : Colors.black,
                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Ticket ID'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: getTicketStatusContentUI(
                                              content: widget.ticket.displayId
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Type'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 40),
                                            child: getTicketStatusContentUI(
                                              content:
                                                  widget.ticket.type.toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'User'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 40),
                                            child: getTicketStatusContentUI(
                                              content:
                                                  widget.ticket.userName != null
                                                      ? widget.ticket.userName
                                                          .toString()
                                                      : "Not Assigned",
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Stock'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 37),
                                            child: getTicketStatusContentUI(
                                              content: widget.ticket.stockName
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
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
                                      Row(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Assigned To'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 45),
                                            child:
                                                getAssignedToDropDownContentUI(
                                              text: widget.ticket.assignedName
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  dropDownValueAssignedTo =
                                                      value!;
                                                  assignController.text = value;
                                                  selectedAssignedUserName =
                                                      userProvider
                                                          .userDetailsList
                                                          .firstWhereOrNull(
                                                              (user) =>
                                                                  user.name ==
                                                                  value);
                                                  if (selectedAssignedUserName !=
                                                      null) {
                                                    selectedAssignedUser =
                                                        selectedAssignedUserName;
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Status'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 85),
                                            child: getStatusDropDownContentUI(
                                              text: widget.ticket.status
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  dropDownValueStatus = value!;
                                                  statusController.text = value;
                                                  selectedStatus =
                                                      statusController.text;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Location'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 70),
                                            child: getLocationDropDownContentUI(
                                              text: widget.ticket.locationName
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  dropDownValueLocation =
                                                      value!;
                                                  selectedLocationName =
                                                      locationProvider
                                                          .locationDetailsList
                                                          .firstWhereOrNull(
                                                              (location) =>
                                                                  location
                                                                      .name ==
                                                                  value);
                                                  if (selectedLocationName !=
                                                      null) {
                                                    selectedLocation =
                                                        selectedLocationName;
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Estimated Date'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: getTimeContentUI(
                                              content: isEstimatedDate
                                                  ? widget.ticket.estimatedTime
                                                      .toString()
                                                  : etaDateController.text,
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              onPressed: () {
                                                setState(() {
                                                  selectedDate = DateTime.now();
                                                  _selectDate(context, setState,
                                                      dateControllers:
                                                          etaDateController);
                                                  isEstimatedDate = false;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          getDialogContentsUI(
                              hintText: 'Remarks',
                              controllers: remarksController,
                              width: MediaQuery.of(context).size.width * 0.20,
                              type: TextInputType.text,
                              dialogSetState: setState,
                              borderColor: themeProvider.isDarkTheme
                                  ? Colors.black
                                  : Colors.white,
                              textColor: themeProvider.isDarkTheme
                                  ? Colors.white
                                  : const Color.fromRGBO(117, 117, 117, 1),
                              color: themeProvider.isDarkTheme
                                  ? Colors.black
                                  : Colors.white),
                          getDialogFileContentsUI(
                              secondaryWidth:
                                  MediaQuery.of(context).size.width * 0.15,
                              width: MediaQuery.of(context).size.width * 0.20,
                              dialogSetState: setState,
                              text: selectedFileName,
                              onPressed: () {
                                setState(() {
                                  pickFile(context, setState,
                                      allowedExtension: ['pdf', 'doc']);
                                });
                              },
                              icon: Icons.attachment_rounded,
                              borderColor: themeProvider.isDarkTheme
                                  ? Colors.black
                                  : Colors.white,
                              textColor: themeProvider.isDarkTheme
                                  ? Colors.white
                                  : const Color.fromRGBO(117, 117, 117, 1),
                              containerColor: themeProvider.isDarkTheme
                                  ? Colors.black
                                  : Colors.white),
                        ]),
                    const SizedBox(
                      height: 10,
                    ),
                    getDialogContentsUI(
                      hintText: 'Description',
                      controllers: descriptionsController,
                      width: MediaQuery.of(context).size.width * 0.20,
                      type: TextInputType.text,
                      dialogSetState: setState,
                      borderColor: themeProvider.isDarkTheme
                          ? Colors.black
                          : Colors.white,
                      textColor: themeProvider.isDarkTheme
                          ? Colors.white
                          : const Color.fromRGBO(117, 117, 117, 1),
                      color: themeProvider.isDarkTheme
                          ? Colors.black
                          : Colors.white,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else if (widget.ticket.type == "Service Request") {
      return Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 20),
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(67, 66, 66, 0.060),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              width: MediaQuery.of(context).size.width * 0.50,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: themeProvider.isDarkTheme
                                        ? const Color.fromRGBO(16, 18, 33, 1)
                                        : const Color(0xfff3f1ef),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15))),
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor:
                                            themeProvider.isDarkTheme
                                                ? Colors.black
                                                : Colors.white,
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: ClipOval(
                                            child: Builder(
                                              builder: (BuildContext context) {
                                                if (imagePicked != null) {
                                                  return Image.memory(
                                                      imagePicked!.bytes!,
                                                      fit: BoxFit.cover);
                                                } else {
                                                  return Image.network(
                                                    '$websiteURL/images/${widget.ticket.userImage}',
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
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
                                                        (BuildContext context,
                                                            Object error,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return Image.asset(
                                                        themeProvider
                                                                .isDarkTheme
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.12,
                                            child: Text(
                                              widget.ticket.assignedName
                                                  .toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: TextStyle(
                                                fontSize: 17,
                                                color: themeProvider.isDarkTheme
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold,
                                              )),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.12,
                                            child: Text(
                                              widget.ticket.userDesignation
                                                  .toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: TextStyle(
                                                fontSize: 15,
                                                color: themeProvider.isDarkTheme
                                                    ? Colors.white
                                                    : Colors.black,
                                              )),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.12,
                                            child: Text(
                                              widget.ticket.userEmpId
                                                  .toString(),
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: TextStyle(
                                                fontSize: 14,
                                                color: themeProvider.isDarkTheme
                                                    ? Colors.white
                                                    : Colors.black,
                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Ticket ID'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: getTicketStatusContentUI(
                                              content: widget.ticket.displayId
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Type'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 40),
                                            child: getTicketStatusContentUI(
                                              content:
                                                  widget.ticket.type.toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'User'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 40),
                                            child: getTicketStatusContentUI(
                                              content:
                                                  widget.ticket.userName != null
                                                      ? widget.ticket.userName
                                                          .toString()
                                                      : "Not Assigned",
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Stock'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 37),
                                            child: getTicketStatusContentUI(
                                              content: widget.ticket.stockName
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
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
                                      Row(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Assigned To'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 45),
                                            child:
                                                getAssignedToDropDownContentUI(
                                              text: widget.ticket.assignedName
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  dropDownValueAssignedTo =
                                                      value!;
                                                  assignController.text = value;
                                                  selectedAssignedUserName =
                                                      userProvider
                                                          .userDetailsList
                                                          .firstWhereOrNull(
                                                              (user) =>
                                                                  user.name ==
                                                                  value);
                                                  if (selectedAssignedUserName !=
                                                      null) {
                                                    selectedAssignedUser =
                                                        selectedAssignedUserName;
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Status'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 85),
                                            child: getStatusDropDownContentUI(
                                              text: widget.ticket.status
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  dropDownValueStatus = value!;
                                                  statusController.text = value;
                                                  selectedStatus =
                                                      statusController.text;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Location'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 70),
                                            child: getLocationDropDownContentUI(
                                              text: widget.ticket.locationName
                                                  .toString(),
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  dropDownValueLocation =
                                                      value!;
                                                  selectedLocationName =
                                                      locationProvider
                                                          .locationDetailsList
                                                          .firstWhereOrNull(
                                                              (location) =>
                                                                  location
                                                                      .name ==
                                                                  value);
                                                  if (selectedLocationName !=
                                                      null) {
                                                    selectedLocation =
                                                        selectedLocationName;
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          getTicketStatusTitleContentUI(
                                              title: 'Estimated Date'),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: getTimeContentUI(
                                              content: isEstimatedDate
                                                  ? widget.ticket.estimatedTime
                                                      .toString()
                                                  : etaDateController.text,
                                              color: themeProvider.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              onPressed: () {
                                                setState(() {
                                                  selectedDate = DateTime.now();
                                                  _selectDate(context, setState,
                                                      dateControllers:
                                                          etaDateController);
                                                  isEstimatedDate = false;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          getDialogContentsUI(
                              hintText: 'Remarks',
                              controllers: remarksController,
                              width: MediaQuery.of(context).size.width * 0.20,
                              type: TextInputType.text,
                              dialogSetState: setState,
                              borderColor: themeProvider.isDarkTheme
                                  ? Colors.black
                                  : Colors.white,
                              textColor: themeProvider.isDarkTheme
                                  ? Colors.white
                                  : const Color.fromRGBO(117, 117, 117, 1),
                              color: themeProvider.isDarkTheme
                                  ? Colors.black
                                  : Colors.white),
                          getDialogFileContentsUI(
                              secondaryWidth:
                                  MediaQuery.of(context).size.width * 0.15,
                              width: MediaQuery.of(context).size.width * 0.20,
                              dialogSetState: setState,
                              text: selectedFileName,
                              onPressed: () {
                                setState(() {
                                  pickFile(context, setState,
                                      allowedExtension: ['pdf', 'doc']);
                                });
                              },
                              icon: Icons.attachment_rounded,
                              borderColor: themeProvider.isDarkTheme
                                  ? Colors.black
                                  : Colors.white,
                              textColor: themeProvider.isDarkTheme
                                  ? Colors.white
                                  : const Color.fromRGBO(117, 117, 117, 1),
                              containerColor: themeProvider.isDarkTheme
                                  ? Colors.black
                                  : Colors.white),
                        ]),
                    const SizedBox(
                      height: 10,
                    ),
                    getDialogContentsUI(
                      hintText: 'Description',
                      controllers: descriptionsController,
                      width: MediaQuery.of(context).size.width * 0.20,
                      type: TextInputType.text,
                      dialogSetState: setState,
                      borderColor: themeProvider.isDarkTheme
                          ? Colors.black
                          : Colors.white,
                      textColor: themeProvider.isDarkTheme
                          ? Colors.white
                          : const Color.fromRGBO(117, 117, 117, 1),
                      color: themeProvider.isDarkTheme
                          ? Colors.black
                          : Colors.white,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else if (widget.ticket.type == "Request New Asset") {
      return Column(
        children: [
          Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(67, 66, 66, 0.060),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                    child: Column(
                      children: [
                        widget.ticket.assignedRefId != null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Wrap(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
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
                                              0.2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.black
                                                          : Colors.white,
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: ClipOval(
                                                      child: Builder(
                                                        builder: (BuildContext
                                                            context) {
                                                          if (imagePicked !=
                                                              null) {
                                                            return Image.memory(
                                                                imagePicked!
                                                                    .bytes!,
                                                                fit: BoxFit
                                                                    .cover);
                                                          } else {
                                                            return Image
                                                                .network(
                                                              '$websiteURL/images/${widget.ticket.userImage}',
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
                                                                return Image
                                                                    .asset(
                                                                  themeProvider
                                                                          .isDarkTheme
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
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.12,
                                                      child: Text(
                                                        widget
                                                            .ticket.assignedName
                                                            .toString(),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                                textStyle:
                                                                    TextStyle(
                                                          fontSize: 17,
                                                          color: themeProvider
                                                                  .isDarkTheme
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.12,
                                                      child: Text(
                                                        widget.ticket
                                                            .userDesignation
                                                            .toString(),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                                textStyle:
                                                                    TextStyle(
                                                          fontSize: 15,
                                                          color: themeProvider
                                                                  .isDarkTheme
                                                              ? Colors.white
                                                              : Colors.black,
                                                        )),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.12,
                                                      child: Text(
                                                        widget.ticket.userEmpId
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                                textStyle:
                                                                    TextStyle(
                                                          fontSize: 14,
                                                          color: themeProvider
                                                                  .isDarkTheme
                                                              ? Colors.white
                                                              : Colors.black,
                                                        )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            : const Text(""),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              getTicketStatusTitleContentUI(
                                                  title: 'Ticket ID'),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: getTicketStatusContentUI(
                                                  content: widget
                                                      .ticket.displayId
                                                      .toString(),
                                                  color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              getTicketStatusTitleContentUI(
                                                  title: 'Type'),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 40),
                                                child: getTicketStatusContentUI(
                                                  content: widget.ticket.type
                                                      .toString(),
                                                  color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
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
                                          Row(
                                            children: [
                                              getTicketStatusTitleContentUI(
                                                  title: 'Expected Date'),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15),
                                                child: getTimeContentUI(
                                                  content: isExpectedDate
                                                      ? widget
                                                          .ticket.expectedTime
                                                          .toString()
                                                      : dateController.text,
                                                  color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedDate =
                                                          DateTime.now();
                                                      _selectDate(
                                                          context, setState,
                                                          dateControllers:
                                                              dateController);
                                                      isExpectedDate = false;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              getTicketStatusTitleContentUI(
                                                  title: 'Priority'),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 35),
                                                child:
                                                    getPriorityDropDownContentUI(
                                                  text: widget.ticket.priority
                                                      .toString(),
                                                  color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      dropDownValuePriority =
                                                          value!;
                                                      priorityController.text =
                                                          value;
                                                      selectedPriority =
                                                          priorityController
                                                              .text;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              getDialogContentsUIForTicket(
                                  hintText: 'Description',
                                  controllers: descriptionsController,
                                  readOnly: true,
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  type: TextInputType.text,
                                  dialogSetState: setState,
                                  borderColor: themeProvider.isDarkTheme
                                      ? Colors.black
                                      : Colors.white,
                                  textColor: themeProvider.isDarkTheme
                                      ? Colors.white
                                      : const Color.fromRGBO(117, 117, 117, 1),
                                  color: themeProvider.isDarkTheme
                                      ? Colors.black
                                      : Colors.white),
                              getDialogContentsUIForTicket(
                                  hintText: 'Remarks',
                                  controllers: remarksController,
                                  readOnly: true,
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  type: TextInputType.text,
                                  dialogSetState: setState,
                                  borderColor: themeProvider.isDarkTheme
                                      ? Colors.black
                                      : Colors.white,
                                  textColor: themeProvider.isDarkTheme
                                      ? Colors.white
                                      : const Color.fromRGBO(117, 117, 117, 1),
                                  color: themeProvider.isDarkTheme
                                      ? Colors.black
                                      : Colors.white),
                            ]),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 150,
          ),
        ],
      );
    } else if (widget.ticket.type == "Service Requests") {
      return Column(
        children: [
          Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(67, 66, 66, 0.060),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                    child: Column(
                      children: [
                        widget.ticket.assignedRefId != null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Wrap(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
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
                                              0.2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.black
                                                          : Colors.white,
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: ClipOval(
                                                      child: Builder(
                                                        builder: (BuildContext
                                                            context) {
                                                          if (imagePicked !=
                                                              null) {
                                                            return Image.memory(
                                                                imagePicked!
                                                                    .bytes!,
                                                                fit: BoxFit
                                                                    .cover);
                                                          } else {
                                                            return Image
                                                                .network(
                                                              '$websiteURL/images/${widget.ticket.userImage}',
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
                                                                return Image
                                                                    .asset(
                                                                  themeProvider
                                                                          .isDarkTheme
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
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.12,
                                                      child: Text(
                                                        widget
                                                            .ticket.assignedName
                                                            .toString(),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                                textStyle:
                                                                    TextStyle(
                                                          fontSize: 17,
                                                          color: themeProvider
                                                                  .isDarkTheme
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.12,
                                                      child: Text(
                                                        widget.ticket
                                                            .userDesignation
                                                            .toString(),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                                textStyle:
                                                                    TextStyle(
                                                          fontSize: 15,
                                                          color: themeProvider
                                                                  .isDarkTheme
                                                              ? Colors.white
                                                              : Colors.black,
                                                        )),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.12,
                                                      child: Text(
                                                        widget.ticket.userEmpId
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                                textStyle:
                                                                    TextStyle(
                                                          fontSize: 14,
                                                          color: themeProvider
                                                                  .isDarkTheme
                                                              ? Colors.white
                                                              : Colors.black,
                                                        )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            : const Text(""),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              getTicketStatusTitleContentUI(
                                                  title: 'Ticket ID'),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: getTicketStatusContentUI(
                                                  content: widget
                                                      .ticket.displayId
                                                      .toString(),
                                                  color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              getTicketStatusTitleContentUI(
                                                  title: 'Type'),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 40),
                                                child: getTicketStatusContentUI(
                                                  content: widget.ticket.type
                                                      .toString(),
                                                  color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
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
                                          Row(
                                            children: [
                                              getTicketStatusTitleContentUI(
                                                  title: 'Expected Date'),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15),
                                                child: getTimeContentUI(
                                                  content: isExpectedDate
                                                      ? widget
                                                          .ticket.expectedTime
                                                          .toString()
                                                      : dateController.text,
                                                  color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedDate =
                                                          DateTime.now();
                                                      _selectDate(
                                                          context, setState,
                                                          dateControllers:
                                                              dateController);
                                                      isExpectedDate = false;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              getTicketStatusTitleContentUI(
                                                  title: 'Priority'),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 35),
                                                child:
                                                    getPriorityDropDownContentUI(
                                                  text: widget.ticket.priority
                                                      .toString(),
                                                  color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      dropDownValuePriority =
                                                          value!;
                                                      priorityController.text =
                                                          value;
                                                      selectedPriority =
                                                          priorityController
                                                              .text;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Column(children: [
                          getTicketStatusTitleContentUI(title: 'Asset'),
                          Wrap(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: themeProvider.isDarkTheme
                                        ? Colors.black
                                        : Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15))),
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Center(
                                    child: Text(
                                      widget.ticket.stockName.toString(),
                                      style: GoogleFonts.ubuntu(
                                          textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: themeProvider.isDarkTheme
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              getDialogContentsUIForTicket(
                                  hintText: 'Description',
                                  controllers: descriptionsController,
                                  readOnly: true,
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  type: TextInputType.text,
                                  dialogSetState: setState,
                                  borderColor: themeProvider.isDarkTheme
                                      ? Colors.black
                                      : Colors.white,
                                  textColor: themeProvider.isDarkTheme
                                      ? Colors.white
                                      : const Color.fromRGBO(117, 117, 117, 1),
                                  color: themeProvider.isDarkTheme
                                      ? Colors.black
                                      : Colors.white),
                              getDialogContentsUIForTicket(
                                  hintText: 'Remarks',
                                  controllers: remarksController,
                                  readOnly: true,
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  type: TextInputType.text,
                                  dialogSetState: setState,
                                  borderColor: themeProvider.isDarkTheme
                                      ? Colors.black
                                      : Colors.white,
                                  textColor: themeProvider.isDarkTheme
                                      ? Colors.white
                                      : const Color.fromRGBO(117, 117, 117, 1),
                                  color: themeProvider.isDarkTheme
                                      ? Colors.black
                                      : Colors.white),
                            ]),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 60,
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Future<void> showLargeStockDialogUI(BuildContext context) async {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    AssetProvider stockProvider =
        Provider.of<AssetProvider>(context, listen: false);

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
                backgroundColor: const Color(0xfff3f1ef),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: SingleChildScrollView(
                  child: Wrap(
                    children: [
                      Container(
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
                                "ADD STOCK",
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
                              height: 15,
                            ),
                            Expanded(
                              child: Theme(
                                data: ThemeData(
                                    canvasColor: themeProvider.isDarkTheme
                                        ? const Color.fromRGBO(16, 18, 33, 1)
                                        : const Color(0xfff3f1ef)),
                                child: Stepper(
                                  type: stepperType,
                                  currentStep: currentStockStep,
                                  elevation: 0,
                                  onStepTapped: (step) {
                                    if (formKeyStepStock[currentStockStep]
                                        .currentState!
                                        .validate()) {
                                      setState(() {
                                        currentStockStep = step;
                                      });
                                    }
                                  },
                                  steps: getStepsStockDialog(
                                    setState,
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
                                        : const Color.fromRGBO(
                                            117, 117, 117, 1),
                                    fillColor: themeProvider.isDarkTheme
                                        ? Colors.black
                                        : Colors.white,
                                    containerColor: themeProvider.isDarkTheme
                                        ? Colors.black
                                        : Colors.white,
                                    dividerColor: themeProvider.isDarkTheme
                                        ? Colors.black
                                        : Colors.white,
                                    backgroundColor: themeProvider.isDarkTheme
                                        ? const Color.fromRGBO(16, 18, 33, 1)
                                        : const Color.fromRGBO(
                                            243, 241, 239, 1),
                                    collapsedBackgroundColor: themeProvider
                                            .isDarkTheme
                                        ? const Color.fromRGBO(16, 18, 33, 1)
                                        : const Color.fromRGBO(
                                            243, 241, 239, 1),
                                    iconColor: themeProvider.isDarkTheme
                                        ? Colors.white
                                        : Colors.black,
                                    collapsedIconColor:
                                        themeProvider.isDarkTheme
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                  controlsBuilder: (context, details) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            if (currentStockStep != 0)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
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
                                                          currentStockStep -= 1;
                                                        });
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.blue,
                                                          shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)))),
                                                      child: Text(
                                                        "Previous",
                                                        style: GlobalHelper
                                                            .textStyle(
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
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                                        isApiCallInProgress =
                                                            true;
                                                      });

                                                      final steps =
                                                          getStepsStockDialog(
                                                        setState,
                                                        color: themeProvider
                                                                .isDarkTheme
                                                            ? Colors.white
                                                            : Colors.black,
                                                        colors: themeProvider
                                                                .isDarkTheme
                                                            ? Colors.black
                                                            : Colors.white,
                                                        borderColor:
                                                            themeProvider
                                                                    .isDarkTheme
                                                                ? Colors.black
                                                                : Colors.white,
                                                        textColor: themeProvider
                                                                .isDarkTheme
                                                            ? Colors.white
                                                            : const Color
                                                                .fromRGBO(117,
                                                                117, 117, 1),
                                                        fillColor: themeProvider
                                                                .isDarkTheme
                                                            ? Colors.black
                                                            : Colors.white,
                                                        containerColor:
                                                            themeProvider
                                                                    .isDarkTheme
                                                                ? Colors.black
                                                                : Colors.white,
                                                        dividerColor:
                                                            themeProvider
                                                                    .isDarkTheme
                                                                ? Colors.black
                                                                : Colors.white,
                                                        backgroundColor:
                                                            themeProvider
                                                                    .isDarkTheme
                                                                ? const Color
                                                                    .fromRGBO(
                                                                    16,
                                                                    18,
                                                                    33,
                                                                    1)
                                                                : const Color
                                                                    .fromRGBO(
                                                                    243,
                                                                    241,
                                                                    239,
                                                                    1),
                                                        collapsedBackgroundColor:
                                                            themeProvider
                                                                    .isDarkTheme
                                                                ? const Color
                                                                    .fromRGBO(
                                                                    16,
                                                                    18,
                                                                    33,
                                                                    1)
                                                                : const Color
                                                                    .fromRGBO(
                                                                    243,
                                                                    241,
                                                                    239,
                                                                    1),
                                                        iconColor: themeProvider
                                                                .isDarkTheme
                                                            ? Colors.white
                                                            : Colors.black,
                                                        collapsedIconColor:
                                                            themeProvider
                                                                    .isDarkTheme
                                                                ? Colors.white
                                                                : Colors.black,
                                                      );

                                                      if (formKeyStepStock[
                                                              currentStockStep]
                                                          .currentState!
                                                          .validate()) {
                                                        if (currentStockStep ==
                                                            steps.length - 1) {
                                                          AssetStock stock =
                                                              AssetStock(
                                                            userRefId:
                                                                selectedUserId,
                                                            image: imagePicked
                                                                ?.name,
                                                            assetRefId:
                                                                selectedModelId,
                                                            locationRefId: selectedLocation ==
                                                                    null
                                                                ? widget.ticket
                                                                    .locationRefId
                                                                : selectedLocation
                                                                    ?.sId
                                                                    .toString(),
                                                            vendorRefId: selectedVendor ==
                                                                    null
                                                                ? widget.ticket
                                                                    .vendorRefId
                                                                : selectedVendor
                                                                    ?.sId
                                                                    .toString(),
                                                            serialNo:
                                                                serialController
                                                                    .text
                                                                    .toString(),
                                                            remarks:
                                                                stockRemarksController
                                                                    .text
                                                                    .toString(),
                                                            issuedDateTime:
                                                                dateTimeController
                                                                    .text
                                                                    .toString(),
                                                            warrantyExpiry:
                                                                expiryDateController
                                                                    .text
                                                                    .toString(),
                                                            purchaseDate:
                                                                purchaseDateController
                                                                    .text
                                                                    .toString(),
                                                            warrantyPeriod:
                                                                "${warrantyDaysController.text.toString()} Days, ${warrantyMonthsController.text.toString()} Months, ${warrantyYearsController.text.toString()} Years",
                                                            tag: tagList,
                                                          );

                                                          await addStock(stock);

                                                          await stockProvider
                                                              .fetchStockDetails();

                                                          if (mounted) {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }

                                                          if (isToastMessage ==
                                                              true) {
                                                            showToast(
                                                                "Stock Added Successfully");

                                                            if (particularExpiryDateController
                                                                .isNotEmpty) {
                                                              List<String>
                                                                  expiryDate =
                                                                  particularExpiryDateController
                                                                      .map((controller) =>
                                                                          controller
                                                                              .text)
                                                                      .toList();

                                                              List<String>
                                                                  warrantyName =
                                                                  particularWarrantyNameController
                                                                      .map((controller) =>
                                                                          controller
                                                                              .text)
                                                                      .toList();

                                                              List<String>
                                                                  warrantyAttachment =
                                                                  warrantyAttachments;

                                                              for (int i = 0;
                                                                  i <
                                                                      expiryDate
                                                                          .length;
                                                                  i++) {
                                                                String
                                                                    currentExpiryDate =
                                                                    expiryDate[
                                                                        i];
                                                                String
                                                                    currentWarrantyName =
                                                                    warrantyName[
                                                                        i];
                                                                String
                                                                    currentWarrantyAttachment =
                                                                    warrantyAttachment.isNotEmpty &&
                                                                            i < warrantyAttachment.length
                                                                        ? warrantyAttachment[i]
                                                                        : '';

                                                                if (currentExpiryDate
                                                                        .isNotEmpty ||
                                                                    currentWarrantyAttachment
                                                                        .isNotEmpty) {
                                                                  Warranty warranty = Warranty(
                                                                      stockRefId:
                                                                          stockId,
                                                                      modelRefId:
                                                                          selectedModelId,
                                                                      warrantyExpiry:
                                                                          currentExpiryDate,
                                                                      warrantyAttachment:
                                                                          currentWarrantyAttachment,
                                                                      warrantyName:
                                                                          currentWarrantyName);

                                                                  await addWarranty(
                                                                      warranty);
                                                                }
                                                              }
                                                            }
                                                          } else if (isToastMessage ==
                                                              false) {
                                                            showToast(
                                                                "Unable to add the stock");
                                                          }
                                                        } else {
                                                          setState(() {
                                                            currentStockStep++;
                                                          });
                                                        }
                                                      } else {
                                                        return;
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
                                                      currentStockStep == 1
                                                          ? "Save"
                                                          : "Next",
                                                      style: GlobalHelper
                                                          .textStyle(
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
                      )
                    ],
                  ),
                ));
          });
        });
  }

  List<Step> getStepsStockDialog(
    StateSetter dialogSetState, {
    required color,
    required colors,
    required borderColor,
    required textColor,
    required fillColor,
    required containerColor,
    required dividerColor,
    required backgroundColor,
    required collapsedBackgroundColor,
    required iconColor,
    required collapsedIconColor,
  }) =>
      [
        Step(
          title: Text(
            'Stock Details',
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Form(
            key: formKeyStepStock[0],
            child: Column(
              children: [
                Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: const EdgeInsets.all(2.0),
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(67, 66, 66, 0.060),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  getDialogWithoutIconContentsUI(
                                      hintText: 'Serial No',
                                      controllers: serialController,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      type: TextInputType.text,
                                      dialogSetState: setState,
                                      color: colors,
                                      borderColor: borderColor,
                                      textColor: textColor,
                                      validators: commonValidator),
                                  getDialogIconButtonContentsUI(
                                    width: MediaQuery.of(context).size.width *
                                        0.20,
                                    hintText: "Issued Date & Time",
                                    suffixIcon: Icons.calendar_today_rounded,
                                    iconColor:
                                        const Color.fromRGBO(15, 117, 188, 1),
                                    controllers: dateTimeController,
                                    type: TextInputType.datetime,
                                    dialogSetState: setState,
                                    validators: dateTimeValidator,
                                    fillColor: fillColor,
                                    borderColor: borderColor,
                                    textColor: textColor,
                                    onPressed: () {
                                      setState(() {
                                        selectDate = DateTime.now();
                                        selectedTime = TimeOfDay.now();
                                        if (mounted) {
                                          _selectDateTime(context, setState);
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  getDialogWithoutIconContentsUI(
                                    hintText: 'Remarks',
                                    controllers: stockRemarksController,
                                    width: MediaQuery.of(context).size.width *
                                        0.20,
                                    type: TextInputType.text,
                                    dialogSetState: setState,
                                    color: colors,
                                    borderColor: borderColor,
                                    textColor: textColor,
                                  ),
                                  getDialogIconButtonContentsUI(
                                    width: MediaQuery.of(context).size.width *
                                        0.20,
                                    hintText: "Purchase Date",
                                    suffixIcon: Icons.calendar_today_rounded,
                                    iconColor:
                                        const Color.fromRGBO(15, 117, 188, 1),
                                    controllers: purchaseDateController,
                                    type: TextInputType.datetime,
                                    dialogSetState: setState,
                                    validators: dateValidator,
                                    fillColor: fillColor,
                                    borderColor: borderColor,
                                    textColor: textColor,
                                    onPressed: () {
                                      setState(() {
                                        selectedPurchaseDate = DateTime.now();
                                        if (mounted) {
                                          selectDateForWarrantyPeriod(
                                            context,
                                            purchaseDateController,
                                            setState,
                                            lastDate: DateTime.now(),
                                            firstDate: DateTime(
                                                selectedPurchaseDate.year - 10,
                                                selectedPurchaseDate.month,
                                                selectedPurchaseDate.day),
                                          );
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    getDialogWithoutIconContentsUI(
                                      width: MediaQuery.of(context).size.width *
                                          0.12,
                                      hintText: "Days",
                                      controllers: warrantyDaysController,
                                      type: TextInputType.datetime,
                                      dialogSetState: setState,
                                      validators: commonValidator,
                                      color: colors,
                                      borderColor: borderColor,
                                      textColor: textColor,
                                      onChanged: (value) {
                                        setState(() {
                                          calculateWarrantyExpiry();
                                        });
                                      },
                                    ),
                                    getDialogWithoutIconContentsUI(
                                      width: MediaQuery.of(context).size.width *
                                          0.12,
                                      hintText: "Months",
                                      controllers: warrantyMonthsController,
                                      type: TextInputType.datetime,
                                      dialogSetState: setState,
                                      validators: commonValidator,
                                      color: colors,
                                      borderColor: borderColor,
                                      textColor: textColor,
                                      onChanged: (value) {
                                        setState(() {
                                          calculateWarrantyExpiry();
                                        });
                                      },
                                    ),
                                    getDialogWithoutIconContentsUI(
                                      width: MediaQuery.of(context).size.width *
                                          0.12,
                                      hintText: "Years",
                                      controllers: warrantyYearsController,
                                      type: TextInputType.datetime,
                                      dialogSetState: setState,
                                      validators: commonValidator,
                                      color: colors,
                                      borderColor: borderColor,
                                      textColor: textColor,
                                      onChanged: (value) {
                                        setState(() {
                                          calculateWarrantyExpiry();
                                        });
                                      },
                                    ),
                                  ]),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getDialogIconButtonContentsUI(
                                    width: MediaQuery.of(context).size.width *
                                        0.20,
                                    hintText: "Warranty Expiry",
                                    suffixIcon: Icons.calendar_today_rounded,
                                    iconColor:
                                        const Color.fromRGBO(15, 117, 188, 1),
                                    controllers: expiryDateController,
                                    type: TextInputType.datetime,
                                    dialogSetState: setState,
                                    validators: dateValidator,
                                    fillColor: fillColor,
                                    borderColor: borderColor,
                                    textColor: textColor,
                                    onPressed: () {
                                      setState(() {
                                        selectedPurchaseDate = DateTime.now();
                                        selectDateForWarrantyPeriod(context,
                                            expiryDateController, setState,
                                            firstDate: DateTime(
                                                selectedPurchaseDate.year - 7,
                                                selectedPurchaseDate.month,
                                                selectedPurchaseDate.day),
                                            lastDate: DateTime(
                                                selectedPurchaseDate.year +
                                                    15));
                                      });
                                    },
                                  ),
                                  Column(
                                    children: [
                                      getDialogTagContentsUI(
                                          hintText: 'Tag',
                                          controllers: tagController,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.20,
                                          dialogSetState: setState,
                                          type: TextInputType.text,
                                          tags: tag,
                                          borderColor: borderColor,
                                          textColor: textColor,
                                          containerColor: containerColor,
                                          fillColor: fillColor,
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
                                      if (tagList.isNotEmpty)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                height: 30,
                                                child: VerticalDivider(
                                                    thickness: 3.5,
                                                    color: dividerColor)),
                                          ],
                                        ),
                                      getTagListDialogContentsUI(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.20,
                                          dialogSetState: setState,
                                          tag: tagList,
                                          color: colors,
                                          textColor: textColor),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          state: currentStockStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStockStep == 0,
        ),
        Step(
          title: Text(
            'Warranty Details',
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Form(
            key: formKeyStepStock[1],
            child: Column(
              children: [
                Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsets.all(2.0),
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(67, 66, 66, 0.060),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: getParticularWarrantyDetails(
                                  backgroundColor: backgroundColor,
                                  collapsedBackgroundColor:
                                      collapsedBackgroundColor,
                                  collapsedIconColor: collapsedIconColor,
                                  iconColor: iconColor,
                                  containerColor: containerColor,
                                  fillColor: fillColor,
                                  borderColor: borderColor,
                                  textColor: textColor,
                                  color: color,
                                ),
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
                  height: 70,
                ),
              ],
            ),
          ),
          state: currentStockStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStockStep == 2,
        ),
      ];

  Widget getParticularWarrantyDetails({
    backgroundColor,
    collapsedBackgroundColor,
    collapsedIconColor,
    iconColor,
    containerColor,
    fillColor,
    borderColor,
    textColor,
    color,
  }) {
    AssetProvider templateProvider =
        Provider.of<AssetProvider>(context, listen: false);

    String? modelRefId;

    modelRefId = selectedModelId;

    List<String> modelIdList;
    if (modelRefId != null) {
      modelIdList = <String>[modelRefId];
    } else {
      modelIdList = <String>[];
    }

    templateProvider.fetchParticularModelDetails(assetModelId: modelIdList);

    List<AssetModelDetails> detailsList =
        templateProvider.particularModelDetailsList;
    AssetModelDetails? modelDetails =
        detailsList.isNotEmpty ? detailsList.first : null;

    return ListView.builder(
        shrinkWrap: true,
        itemCount: ((modelDetails?.parameters?.length ?? 0) / 2).ceil(),
        itemBuilder: (context, index) {
          for (int i = 0; i < (modelDetails?.parameters?.length ?? 0); i++) {
            particularExpiryDateController.add(TextEditingController());
            particularWarrantyNameController.add(TextEditingController());
          }
          warrantyAttachments =
              List.generate(modelDetails?.parameters?.length ?? 0, (_) => '');
          int startIndex = index * 2;
          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    maintainState: true,
                    backgroundColor: backgroundColor,
                    collapsedBackgroundColor: collapsedBackgroundColor,
                    iconColor: iconColor,
                    collapsedIconColor: collapsedIconColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    collapsedShape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    title: Center(
                      child: Text(
                        (startIndex < modelDetails!.parameters!.length)
                            ? modelDetails.parameters![startIndex]
                            : "",
                        style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(
                            fontSize: 15,
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          getDialogIconButtonContentsUIForWarranty(
                            width: MediaQuery.of(context).size.width * 0.15,
                            hintText: expiryDateController.text.toString(),
                            suffixIcon: Icons.calendar_today_rounded,
                            iconColor: const Color.fromRGBO(15, 117, 188, 1),
                            controllers:
                                particularExpiryDateController[startIndex],
                            type: TextInputType.datetime,
                            dialogSetState: setState,
                            readOnly: true,
                            fillColor: fillColor,
                            borderColor: borderColor,
                            textColor: textColor,
                            onPressed: () {
                              setState(() {
                                selectedPurchaseDate = DateTime.now();
                                if (mounted) {
                                  selectDateForWarrantyPeriod(
                                      context,
                                      particularExpiryDateController[
                                          startIndex],
                                      setState,
                                      firstDate: DateTime(
                                          selectedPurchaseDate.year - 7,
                                          selectedPurchaseDate.month,
                                          selectedPurchaseDate.day),
                                      lastDate: DateTime(
                                          selectedPurchaseDate.year + 15));

                                  if (startIndex <
                                      modelDetails.parameters!.length) {
                                    particularWarrantyNameController[startIndex]
                                            .text =
                                        modelDetails.parameters![startIndex];
                                  }
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 5),
                          getDialogFileContentsUI(
                              secondaryWidth:
                                  MediaQuery.of(context).size.width * 0.10,
                              width: MediaQuery.of(context).size.width * 0.15,
                              dialogSetState: setState,
                              text: "Attachment",
                              onPressed: () {
                                setState(() {
                                  pickFileForWarranty(
                                          context, setState, startIndex,
                                          allowedExtension: ['pdf', 'doc'])
                                      .then((_) {
                                    if (warrantyAttachments[startIndex] !=
                                        "Attachment") {
                                      showToast(
                                          "Successfully ${warrantyAttachments[startIndex]} File Added");
                                      log("Filename at index $startIndex: ${warrantyAttachments[startIndex]}");
                                    }
                                  });

                                  if (startIndex <
                                      modelDetails.parameters!.length) {
                                    particularWarrantyNameController[startIndex]
                                            .text =
                                        modelDetails.parameters![startIndex];
                                  }
                                });
                              },
                              icon: Icons.attachment_rounded,
                              borderColor: borderColor,
                              textColor: textColor,
                              containerColor: containerColor),
                          const SizedBox(height: 15)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (startIndex + 1 < (modelDetails.parameters!.length))
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      maintainState: true,
                      backgroundColor: backgroundColor,
                      collapsedBackgroundColor: collapsedBackgroundColor,
                      iconColor: iconColor,
                      collapsedIconColor: collapsedIconColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      collapsedShape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      title: Center(
                        child: Text(
                          ((startIndex + 1) < modelDetails.parameters!.length)
                              ? modelDetails.parameters![startIndex + 1]
                              : "",
                          style: GoogleFonts.ubuntu(
                            textStyle: TextStyle(
                              fontSize: 15,
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            getDialogIconButtonContentsUIForWarranty(
                              width: MediaQuery.of(context).size.width * 0.15,
                              hintText: expiryDateController.text.toString(),
                              suffixIcon: Icons.calendar_today_rounded,
                              iconColor: const Color.fromRGBO(15, 117, 188, 1),
                              controllers: particularExpiryDateController[
                                  startIndex + 1],
                              type: TextInputType.datetime,
                              dialogSetState: setState,
                              readOnly: true,
                              fillColor: fillColor,
                              borderColor: borderColor,
                              textColor: textColor,
                              onPressed: () {
                                setState(() {
                                  selectedPurchaseDate = DateTime.now();
                                  if (mounted) {
                                    selectDateForWarrantyPeriod(
                                        context,
                                        particularExpiryDateController[
                                            startIndex + 1],
                                        setState,
                                        firstDate: DateTime(
                                            selectedPurchaseDate.year - 7,
                                            selectedPurchaseDate.month,
                                            selectedPurchaseDate.day),
                                        lastDate: DateTime(
                                            selectedPurchaseDate.year + 15));

                                    if ((startIndex + 1) <
                                        modelDetails.parameters!.length) {
                                      particularWarrantyNameController[
                                                  startIndex + 1]
                                              .text =
                                          modelDetails
                                              .parameters![startIndex + 1];
                                    }
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 5),
                            getDialogFileContentsUI(
                                secondaryWidth:
                                    MediaQuery.of(context).size.width * 0.10,
                                width: MediaQuery.of(context).size.width * 0.15,
                                dialogSetState: setState,
                                text: "Attachment",
                                onPressed: () {
                                  setState(() {
                                    pickFileForWarranty(
                                            context, setState, (startIndex + 1),
                                            allowedExtension: ['pdf', 'doc'])
                                        .then((_) {
                                      if (warrantyAttachments[startIndex + 1] !=
                                          "Attachment") {
                                        showToast(
                                            "Successfully ${warrantyAttachments[startIndex + 1]} File Added");
                                        log("Filename at index $startIndex: ${warrantyAttachments[startIndex + 1]}");
                                      }
                                    });

                                    if ((startIndex + 1) <
                                        modelDetails.parameters!.length) {
                                      particularWarrantyNameController[
                                                  startIndex + 1]
                                              .text =
                                          modelDetails
                                              .parameters![startIndex + 1];
                                    }
                                  });
                                },
                                icon: Icons.attachment_rounded,
                                borderColor: borderColor,
                                textColor: textColor,
                                containerColor: containerColor),
                            const SizedBox(height: 15)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        });
  }

  Future<void> getAssetReturnCheckListUI(BuildContext context) async {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: SingleChildScrollView(
                  child: Container(
                decoration: BoxDecoration(
                    color: themeProvider.isDarkTheme
                        ? const Color.fromRGBO(16, 18, 33, 1)
                        : const Color(0xfff3f1ef),
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                width: MediaQuery.of(context).size.width * 0.25,
                child: Wrap(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "Checklist",
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
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: parameterList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(67, 66, 66, 0.060),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Column(
                                  children: [
                                    ListTile(
                                      trailing: Checkbox(
                                        value: checkedList[index],
                                        side: BorderSide(
                                          color: themeProvider.isDarkTheme
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            checkedList[index] = value!;
                                          });
                                        },
                                      ),
                                      title: Text(
                                        "${parameterList[index]} - Is Working & Verified?",
                                        style: GoogleFonts.ubuntu(
                                            textStyle: TextStyle(
                                          fontSize: 15,
                                          color: themeProvider.isDarkTheme
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w600,
                                        )),
                                      ),
                                    ),
                                    getDialogContentsUI(
                                        hintText: 'Remarks',
                                        controllers:
                                            checkListRemarksController[index],
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        type: TextInputType.text,
                                        dialogSetState: setState,
                                        borderColor: themeProvider.isDarkTheme
                                            ? Colors.black
                                            : Colors.white,
                                        textColor: themeProvider.isDarkTheme
                                            ? Colors.white
                                            : const Color.fromRGBO(
                                                117, 117, 117, 1),
                                        color: themeProvider.isDarkTheme
                                            ? Colors.black
                                            : Colors.white),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            getElevatedButton(
                                text: "Done",
                                onPressed: () async {
                                  List<String> remarks =
                                      checkListRemarksController
                                          .map((controller) => controller.text)
                                          .toList();

                                  AssetCheckList checkList = AssetCheckList(
                                    entryName: parameterList,
                                    functionalFlag: checkedList,
                                    remarks: remarks,
                                    stockRefId: selectedStockId,
                                  );

                                  await addCheckList(checkList, themeProvider);

                                  if (mounted) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  }
                                }),
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
            );
          });
        });
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
          ],
        ),
      ),
    );
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
    } else {
      return;
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

  Widget getVendorDropDownContentUI({
    required String text,
    required Color color,
    required onChanged,
  }) {
    AssetProvider vendorProvider =
        Provider.of<AssetProvider>(context, listen: false);
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    List<String> dropdownItems = vendorProvider.vendorDetailsList
        .map((vendor) => vendor.name!)
        .toSet()
        .toList();

    return DropdownButtonHideUnderline(
      child: DropdownButton(
        elevation: 1,
        iconDisabledColor: Colors.blue,
        iconEnabledColor: Colors.blue,
        dropdownColor: themeProvider.isDarkTheme
            ? const Color.fromRGBO(16, 18, 33, 1)
            : const Color(0xfff3f1ef),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        value: dropDownValueVendor,
        items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
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
          );
        }).toList(),
        hint: Text(
          text,
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
                fontSize: 15, color: color, fontWeight: FontWeight.bold),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget getLocationDropDownContentUI({
    required String text,
    required Color color,
    required onChanged,
  }) {
    AssetProvider locationProvider =
        Provider.of<AssetProvider>(context, listen: false);
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    List<String> dropdownItems = locationProvider.locationDetailsList
        .map((location) => location.name!)
        .toSet()
        .toList();

    return DropdownButtonHideUnderline(
      child: DropdownButton(
        elevation: 1,
        iconDisabledColor: Colors.blue,
        iconEnabledColor: Colors.blue,
        dropdownColor: themeProvider.isDarkTheme
            ? const Color.fromRGBO(16, 18, 33, 1)
            : const Color(0xfff3f1ef),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        value: dropDownValueLocation,
        items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
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
          );
        }).toList(),
        hint: Text(
          text,
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
                fontSize: 15, color: color, fontWeight: FontWeight.bold),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget getAssignedToDropDownContentUI({
    required String text,
    required Color color,
    required onChanged,
  }) {
    AssetProvider userProvider =
        Provider.of<AssetProvider>(context, listen: false);
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    List<String> dropdownItems =
        userProvider.userDetailsList.map((user) => user.name!).toSet().toList();

    return DropdownButtonHideUnderline(
      child: DropdownButton(
        elevation: 1,
        iconDisabledColor: Colors.blue,
        iconEnabledColor: Colors.blue,
        dropdownColor: themeProvider.isDarkTheme
            ? const Color.fromRGBO(16, 18, 33, 1)
            : const Color(0xfff3f1ef),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        value: dropDownValueAssignedTo,
        items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
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
          );
        }).toList(),
        hint: Text(
          text,
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
                fontSize: 15, color: color, fontWeight: FontWeight.bold),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget getPriorityDropDownContentUI({
    required String text,
    required Color color,
    required onChanged,
  }) {
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
        value: dropDownValuePriority,
        items: <String>["High", "Medium", "Low"]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
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
          );
        }).toList(),
        hint: Text(
          text,
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
                fontSize: 15, color: color, fontWeight: FontWeight.bold),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget getStatusDropDownContentUI({
    required String text,
    required Color color,
    required onChanged,
  }) {
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
        value: dropDownValueStatus,
        items: <String>[
          "In Progress",
          "Waiting For Approval",
          "Approved",
          "Completed",
          "Rejected"
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
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
          );
        }).toList(),
        hint: Text(
          text,
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
                fontSize: 15, color: color, fontWeight: FontWeight.bold),
          ),
        ),
        onChanged: onChanged,
      ),
    );
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

  /// It used to select the date and time in dialog
  _selectDateTime(context, StateSetter dialogSetState) async {
    final DateTime? picked = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        firstDate:
            DateTime(selectDate.year - 7, selectDate.month, selectDate.day),
        lastDate: selectDate,
        initialDate: selectDate);

    if (picked != null && picked != selectDate) {
      dialogSetState(() {
        selectDate = picked;
      });
    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      dialogSetState(() {
        selectedTime = pickedTime;
      });
    }

    dateTimeController.text =
        '${DateFormat('dd/MM/yyyy').format(picked!)} ${selectedTime.format(context)}';
  }

  Future<void> selectDateForWarrantyPeriod(BuildContext context,
      TextEditingController dateController, StateSetter dialogSetState,
      {required DateTime lastDate, required DateTime firstDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDate: selectedPurchaseDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (picked != null && picked != selectedPurchaseDate) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      dialogSetState(() {
        dateController.text = formattedDate;
        if (dateController == purchaseDateController) {
          selectedPurchaseDate = picked;
          calculateWarrantyExpiry();
        } else {
          calculateWarrantyPeriod();
        }
      });
    }
  }

  calculateWarrantyExpiry() {
    if (purchaseDateController.text.isNotEmpty) {
      DateTime purchaseDate =
          DateFormat('dd/MM/yyyy').parse(purchaseDateController.text);

      int warrantyDays = int.tryParse(warrantyDaysController.text) ?? 0;
      int warrantyMonths = int.tryParse(warrantyMonthsController.text) ?? 0;
      int warrantyYears = int.tryParse(warrantyYearsController.text) ?? 0;

      DateTime warrantyExpiryDate =
          purchaseDate.add(Duration(days: warrantyDays));
      warrantyExpiryDate = DateTime(warrantyExpiryDate.year + warrantyYears,
          warrantyExpiryDate.month + warrantyMonths, warrantyExpiryDate.day);

      setState(() {
        expiryDateController.text =
            DateFormat('dd/MM/yyyy').format(warrantyExpiryDate);
      });
    }
  }

  calculateWarrantyPeriod() {
    if (purchaseDateController.text.isNotEmpty &&
        expiryDateController.text.isNotEmpty) {
      DateTime purchaseDate =
          DateFormat('dd/MM/yyyy').parse(purchaseDateController.text);
      DateTime warrantyExpiryDate =
          DateFormat('dd/MM/yyyy').parse(expiryDateController.text);

      int years = warrantyExpiryDate.year - purchaseDate.year;
      int months = warrantyExpiryDate.month - purchaseDate.month;
      int days = warrantyExpiryDate.day - purchaseDate.day;

      if (days < 0) {
        months -= 1;
        days +=
            DateTime(warrantyExpiryDate.year, warrantyExpiryDate.month, 0).day;
      }

      if (months < 0) {
        years -= 1;
        months += 12;
      }

      warrantyYearsController.text = years.toString();
      warrantyMonthsController.text = months.toString();
      warrantyDaysController.text = days.toString();
    }
  }

  Future<void> pickFileForWarranty(
      BuildContext context, StateSetter dialogSetState, int index,
      {required List<String> allowedExtension}) async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: allowedExtension);

    if (file != null) {
      filePicked = file.files.first;
      String fileName = file.files.first.name;

      if (index >= warrantyAttachments.length) {
        dialogSetState(() {
          warrantyAttachments.addAll(List<String>.filled(
              index - warrantyAttachments.length + 1, 'Attachment'));
        });
      }

      dialogSetState(() {
        warrantyAttachments[index] = fileName;
        log("Updated file name at index $index: $fileName");
      });
    } else {
      return;
    }
  }

  bool checkTicketDetailsEditedOrNot() {
    if (widget.ticket.vendorName == selectedVendor.toString() &&
        widget.ticket.priority == selectedPriority.toString() &&
        widget.ticket.expectedTime == dateController.text &&
        widget.ticket.description == descriptionsController.text.toString() &&
        widget.ticket.assignedName == selectedAssignedUser?.name &&
        widget.ticket.status == selectedStatus.toString() &&
        widget.ticket.locationName == selectedLocation?.name &&
        widget.ticket.estimatedTime == etaDateController.text &&
        widget.ticket.remarks == remarksController.text) {
      return false;
    } else {
      return true;
    }
  }

  _onTapEditButton() async {
    AssetProvider ticketProvider =
        Provider.of<AssetProvider>(context, listen: false);

    AssetProvider userProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider boolProvider =
        Provider.of<BoolProvider>(context, listen: false);

    var userId = userProvider.user!.sId.toString();

    final result = checkTicketDetailsEditedOrNot();
    if (result || filePicked != null) {
      AddTicket ticket = AddTicket(
          type: widget.ticket.type.toString(),
          priority: selectedPriority == null
              ? widget.ticket.priority.toString()
              : selectedPriority.toString(),
          vendorRefId: selectedVendor == null
              ? widget.ticket.vendorRefId.toString()
              : selectedVendor?.sId,
          modelRefId: widget.ticket.modelRefId.toString(),
          expectedTime: dateController.text.toString(),
          description: descriptionsController.text.toString(),
          userRefId: widget.ticket.userRefId?.toString(),
          stockRefId: widget.ticket.stockRefId?.toString(),
          assignedRefId: selectedAssignedUser == null
              ? widget.ticket.assignedRefId.toString()
              : selectedAssignedUser?.sId,
          locationRefId: selectedLocation == null
              ? widget.ticket.locationRefId.toString()
              : selectedLocation?.sId,
          status: selectedStatus == null
              ? statusController.text
              : selectedStatus.toString(),
          estimatedTime: etaDateController.text.toString(),
          remarks: remarksController.text.toString(),
          attachment: filePicked?.name,
          sId: widget.ticket.sId.toString(),
          createdBy: widget.ticket.createdBy.toString(),
          updatedBy: userId);

      await updateTicket(ticket, boolProvider, ticketProvider);
    } else {
      /// User not changed anything...
    }
  }

  Future<void> updateTicket(AddTicket ticket, BoolProvider boolProviders,
      AssetProvider ticketProvider) async {
    await AddUpdateDetailsManagerWithFile(
      data: ticket,
      file: filePicked,
      apiURL: 'ticket/updateTicket',
    ).addUpdateDetailsWithFile(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        isTicketCompleted = true;
        showToast("Ticket Updated Successfully");
        ticketProvider.fetchTicketDetails();
      });
    } else {
      setState(() {
        showToast("Unable to update the ticket");
      });
    }
  }

  Future<void> addStock(AssetStock stock) async {
    var headers = await getHeadersForFormData();
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('$websiteURL/stock/addStock'));

      request.fields['jsonData'] = json.encode(stock.toMap());

      request.headers.addAll(headers);

      if (imagePicked != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            imagePicked!.bytes!,
            filename: imagePicked!.name,
          ),
        );
      }

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();

        log('Response body: $responseBody');

        dynamic jsonResponse;
        try {
          jsonResponse = jsonDecode(responseBody);
        } catch (e) {
          log('Failed to parse JSON: $e');
          return;
        }

        if (jsonResponse is List<dynamic>) {
          log('List contents: $jsonResponse');

          bool foundMessage = false;

          for (var element in jsonResponse) {
            if (element is Map<String, dynamic> && element.containsKey('msg')) {
              String message = element['msg'] as String;
              log('Success message from list: $message');
              List<String> parts = message.split("Id:");

              if (parts.length > 1) {
                stockId = parts[1].trim();
                log(stockId);
              } else {
                log("ID not found in the message");
              }
              foundMessage = true;

              break;
            }
          }

          if (!foundMessage) {
            log('List does not contain expected elements with "msg" field.');
          }
        } else {
          log('Unexpected JSON structure: expected List but received ${jsonResponse.runtimeType}');
        }
        setState(() {
          isToastMessage = true;
        });
      } else {
        isToastMessage = false;
        log(response.reasonPhrase.toString());
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  Future<void> userAssignment(AssetStock stock, BoolProvider boolProviders,
      AssetProvider stockProvider) async {
    await AddUpdateDetailsManager(
      data: stock,
      apiURL: 'stock/userAssignment',
    ).addUpdateDetails(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        isTicketCompleted = true;
        showToast("Stock Updated Successfully");
        stockProvider.fetchStockDetails();
      });
    } else {
      setState(() {
        isTicketCompleted = false;
        showToast("Unable to update the stock");
      });
    }
  }

  Future<void> assetReturn(AssetStock stock, BoolProvider boolProviders,
      AssetProvider stockProvider) async {
    await AddUpdateDetailsManager(
      data: stock,
      apiURL: 'stock/assetReturn',
    ).addUpdateDetails(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        isTicketCompleted = true;
        showToast("Stock Updated Successfully");
        stockProvider.fetchStockDetails();
      });
    } else {
      setState(() {
        isTicketCompleted = false;
        showToast("Unable to update the stock");
      });
    }
  }

  Future<void> addWarranty(Warranty warranty) async {
    var headers = await getHeadersForFormData();
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('$websiteURL/stock/addWarranty'));

      request.fields['jsonData'] = json.encode(warranty.toMap());

      request.headers.addAll(headers);

      if (filePicked != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'warrantyAttachment',
            filePicked!.bytes!,
            filename: filePicked?.name,
          ),
        );
      }

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        isToastMessage = true;
        log(await response.stream.bytesToString());
      } else {
        isToastMessage = false;
        log(response.reasonPhrase.toString());
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  Future<void> addCheckList(
      AssetCheckList check, BoolProvider boolProviders) async {
    await AddUpdateDetailsManager(
      data: check,
      apiURL: 'ticket/checkList',
    ).addUpdateDetails(boolProviders);
  }
}
