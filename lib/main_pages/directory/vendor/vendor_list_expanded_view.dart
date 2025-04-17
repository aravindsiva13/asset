import 'dart:developer';
import 'package:asset_management_local/models/directory_model/vendor_model/vendor.dart';
import 'package:asset_management_local/models/directory_model/vendor_model/vendor_details.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../global/global_variables.dart';
import '../../../global/user_interaction_timer.dart';
import '../../../helpers/global_helper.dart';
import '../../../helpers/http_helper.dart';
import '../../../helpers/ui_components.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'package:asset_management_local/provider/main_providers/asset_provider.dart';

class VendorListExpandedView extends StatefulWidget {
  const VendorListExpandedView({super.key, required this.vendor});
  final VendorDetails vendor;

  @override
  State<VendorListExpandedView> createState() => _VendorListExpandedViewState();
}

class _VendorListExpandedViewState extends State<VendorListExpandedView> {
  List<String> departments = ["IOT", "Digital Marketing", "Admin", "RND"];

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

  String selectedFileName = 'Vendor Agreement';

  String selectedImageName = 'Image';

  List<String> tag = [];
  List<String> tagList = [];

  PlatformFile? selectedFile;

  PlatformFile? filePicked;
  PlatformFile? imagePicked;

  List<GlobalKey<FormState>> formKeyStepVendor = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  int currentVendorStep = 0;
  StepperType stepperType = StepperType.horizontal;

  @override
  void initState() {
    super.initState();
    Provider.of<AssetProvider>(context, listen: false).fetchVendorDetails();
  }

  @override
  Widget build(BuildContext context) {


    return Consumer2<AssetProvider, BoolProvider>(
        builder: (context, vendorProvider, themeProvider, child) {
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
                        "Vendor",
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
                                          '$websiteURL/images/${widget.vendor.image}',
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
                                                    title: 'Vendor ID'),
                                                getTicketStatusTitleContentUI(
                                                    title:
                                                        'Contact Person Name'),
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
                                                      .vendor.displayId
                                                      .toString(),
                                                  color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                                getTicketStatusContentUI(
                                                  content: widget
                                                      .vendor.vendorName
                                                      .toString(),
                                                  color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                                getTicketStatusContentUI(
                                                  content: widget
                                                      .vendor.phoneNumber
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
                                                    title: "GSTIN"),
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
                                                  content: widget.vendor.name
                                                      .toString(),
                                                  color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                                getTicketStatusContentUI(
                                                  content: widget.vendor.email
                                                      .toString(),
                                                  color:
                                                      themeProvider.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                                getTicketStatusContentUI(
                                                  content: widget.vendor.gstIn
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
                                                "${widget.vendor.address?.address!.toString()}, ${widget.vendor.address?.city!.toString()}, ${widget.vendor.address?.state!.toString()}, ${widget.vendor.address?.country!.toString()}, ${widget.vendor.address?.pinCode!.toString()}",
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
                                    getTicketStatusTitleContentUI(
                                        title: 'Agreement'),
                                    GestureDetector(
                                      onTap: () {
                                        if (kIsWeb) {
                                          js.context.callMethod('open', [
                                            '$websiteURL/images/${widget.vendor.contractDocument}'
                                          ]);
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child:
                                            getDialogFileContentsUIForAgreement(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          dialogSetState: setState,
                                          text: selectedFileName,
                                          icon: Icons.picture_as_pdf_rounded,
                                          textColor: themeProvider.isDarkTheme
                                              ? Colors.white
                                              : const Color.fromRGBO(
                                                  117, 117, 117, 1),
                                          containerColor:
                                              themeProvider.isDarkTheme
                                                  ? const Color.fromRGBO(
                                                      16, 18, 33, 1)
                                                  : const Color(0xfff3f1ef),
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
                          if(vendorProvider.userRole.vendorWriteFlag)...[
                            getElevatedButtonIcon(
                                onPressed: () {
                                  nameController.text = widget.vendor.name!;
                                  addressController.text =
                                      widget.vendor.address!.address!.toString();
                                  cityController.text =
                                      widget.vendor.address!.city!.toString();
                                  stateController.text =
                                      widget.vendor.address!.state!.toString();
                                  countryController.text =
                                      widget.vendor.address!.country!.toString();
                                  landmarkController.text =
                                      widget.vendor.address!.landMark!.toString();
                                  codeController.text =
                                      widget.vendor.address!.pinCode!.toString();
                                  contactPersonNameController.text =
                                      widget.vendor.vendorName!.toString();
                                  contactPersonEmailController.text =
                                      widget.vendor.email!.toString();
                                  contactPersonPhoneNumberController.text =
                                      widget.vendor.phoneNumber!.toString();
                                  gstController.text = widget.vendor.gstIn!;
                                  tagList = List.from(widget.vendor.tag!);
                                  showLargeScreenUpdateVendor(context);
                                },
                                text: 'Edit'),
                            const SizedBox(
                              width: 15
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

  Future<void> showLargeScreenUpdateVendor(BuildContext context) async {
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
                            "UPDATE VENDOR",
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
                            backgroundColor: Colors.white,
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
                              currentStep: currentVendorStep,
                              onStepTapped: (step) {
                                if (formKeyStepVendor[currentVendorStep]
                                    .currentState!
                                    .validate()) {
                                  setState(() {
                                    currentVendorStep = step;
                                  });
                                }
                              },
                              steps: getStepsVendorDialog(setState,
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
                                        if (currentVendorStep != 0)
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
                                                      currentVendorStep -= 1;
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
                                                  final steps = getStepsVendorDialog(
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

                                                  if (currentVendorStep <
                                                      steps.length - 1) {
                                                    if (formKeyStepVendor[
                                                            currentVendorStep]
                                                        .currentState!
                                                        .validate()) {
                                                      setState(() {
                                                        currentVendorStep++;
                                                      });
                                                    } else {
                                                      return;
                                                    }
                                                  } else {
                                                    if (formKeyStepVendor[
                                                            currentVendorStep]
                                                        .currentState!
                                                        .validate()) {
                                                      _onTapEditButton();
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .pop();
                                                      if (isToastMessage == true) {
                                                        setState(() {
                                                          showToast(
                                                              "Vendor Updated Successfully");
                                                        });
                                                      } else if (isToastMessage == false) {
                                                        setState(() {
                                                          showToast(
                                                              "Unable to update the vendor");
                                                        });
                                                      }
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
                                                  currentVendorStep == 2
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

  List<Step> getStepsVendorDialog(StateSetter setState,
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
            'Vendor Details',
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Form(
            key: formKeyStepVendor[0],
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
                                    hintText: 'Name',
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
                                        dialogSetState: setState,
                                        textColor: textColor,
                                        color: colors,
                                        borderColor: borderColor),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  type: TextInputType.text,
                                  validators: commonValidator,
                                  dialogSetState: setState,
                                  textColor: textColor,
                                  color: colors,
                                  borderColor: borderColor),
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
          state: currentVendorStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentVendorStep == 0,
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
            key: formKeyStepVendor[1],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Wrap(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(2.0),
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(67, 66, 66, 0.060),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: getDialogExtraContentsUI(
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      hintText: "Contact Person Name",
                                      controllers: contactPersonNameController,
                                      type: TextInputType.name,
                                      dialogSetState: setState,
                                      validators: commonValidator,
                                      textColor: textColor,
                                      color: colors,
                                      borderColor: borderColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: getDialogContentsUI(
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      hintText: "Email ID",
                                      suffixIcon: Icons.mail,
                                      iconColor: const Color.fromRGBO(
                                          117, 117, 117, 1),
                                      controllers: contactPersonEmailController,
                                      type: TextInputType.emailAddress,
                                      dialogSetState: setState,
                                      validators: emailValidator,
                                      textColor: textColor,
                                      color: colors,
                                      borderColor: borderColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 15),
                                    child:
                                        getDialogContentsUILargeScreenPhoneNumber(
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      hintText: "Phone Number",
                                      suffixIcon: Icons.phone,
                                      iconColor: const Color.fromRGBO(
                                          117, 117, 117, 1),
                                      controllers:
                                          contactPersonPhoneNumberController,
                                      type: TextInputType.phone,
                                      dialogSetState: setState,
                                      validators: mobileValidator,
                                      textColor: textColor,
                                      color: colors,
                                      borderColor: borderColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 140,
                )
              ],
            ),
          ),
          state: currentVendorStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentVendorStep == 1,
        ),
        Step(
          title: Text(
            'Additional Details',
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Form(
            key: formKeyStepVendor[2],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Wrap(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(2.0),
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(67, 66, 66, 0.060),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: getDialogExtraContentsUI(
                                      hintText: 'GST IN',
                                      controllers: gstController,
                                      validators: validateGST,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      type: TextInputType.text,
                                      dialogSetState: setState,
                                      textColor: textColor,
                                      color: colors,
                                      borderColor: borderColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
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
                                height: 10,
                              ),
                              Column(
                                children: [
                                  getDialogTagContentsUI(
                                      hintText: 'Tag',
                                      controllers: tagController,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      dialogSetState: setState,
                                      type: TextInputType.text,
                                      tags: tag,
                                      borderColor: borderColor,
                                      textColor: textColor,
                                      containerColor: containerColor,
                                      fillColor: fillColor,
                                      onPressed: () {
                                        final tagExtraText = tagController.text;
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
                                ],
                              ),
                              if (tagList.isNotEmpty)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                width: MediaQuery.of(context).size.width * 0.20,
                                dialogSetState: setState,
                                tag: tagList,
                                color: colors,
                                textColor: textColor,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 135,
                )
              ],
            ),
          ),
          state: currentVendorStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentVendorStep == 2,
        ),
      ];

  Widget getImageWidget() {
    if (imagePicked != null) {
      return Image.memory(imagePicked!.bytes!, fit: BoxFit.cover);
    } else {
      return Image.network(
        '$websiteURL/images/${widget.vendor.image}',
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

  String? addressValidator(value) {
    if (addressController.text.isEmpty ||
        cityController.text.isEmpty ||
        stateController.text.isEmpty ||
        countryController.text.isEmpty ||
        landmarkController.text.isEmpty ||
        codeController.text.isEmpty) {
      return 'Fields should not be Empty';
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

  /// It will check the Existing Details of the Company and Edited or Not
  bool checkVendorDetailsEditedOrNot() {
    Function eq = const ListEquality().equals;
    if (widget.vendor.vendorName == contactPersonNameController.text &&
        widget.vendor.address!.address == addressController.text &&
        widget.vendor.address!.city == cityController.text &&
        widget.vendor.address!.state == stateController.text &&
        widget.vendor.address!.landMark == landmarkController.text &&
        widget.vendor.address!.country == countryController.text &&
        widget.vendor.address!.pinCode.toString() == codeController.text &&
        widget.vendor.gstIn == gstController.text &&
        widget.vendor.name == nameController.text &&
        widget.vendor.email == contactPersonEmailController.text &&
        widget.vendor.phoneNumber.toString() ==
            contactPersonPhoneNumberController.text &&
        eq(widget.vendor.tag, tagList)) {
      return false;
    } else {
      return true;
    }
  }

  _onTapEditButton() async {
    AssetProvider vendorProvider =
        Provider.of<AssetProvider>(context, listen: false);

    final result = checkVendorDetailsEditedOrNot();
    if (result || filePicked != null || imagePicked != null) {
      Vendor vendor = Vendor(
          name: nameController.text.toString(),
          vendorName: contactPersonNameController.text.toString(),
          email: contactPersonEmailController.text.toString(),
          phoneNumber: contactPersonPhoneNumberController.text.toString(),
          address: {
            "address": addressController.text.toString(),
            "city": cityController.text.toString(),
            "state": stateController.text.toString(),
            "country": countryController.text.toString(),
            "landMark": landmarkController.text.toString(),
            "pinCode": int.tryParse(codeController.text.toString()),
          },
          tag: tagList,
          gstIn: gstController.text.toString(),
          contractDocument: filePicked?.name,
          image: imagePicked?.name,
          sId: widget.vendor.sId);
      await updateVendor(vendor);
      await vendorProvider.fetchVendorDetails();
    } else {}
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

  /// It used to pick the pdf and doc file
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

  Future<void> updateVendor(Vendor vendor) async {
    var headers = await getHeadersForFormData();
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('$websiteURL/vendor/updateVendor'));

      request.fields['jsonData'] = json.encode(vendor.toMap());

      request.headers.addAll(headers);

      if (filePicked != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'contractDocument',
            filePicked!.bytes!,
            filename: filePicked?.name,
          ),
        );
      }

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
        setState(() {
          isToastMessage = true;
        });
        log(await response.stream.bytesToString());
      } else {
        setState(() {
          isToastMessage = false;
        });
        log(response.reasonPhrase.toString());
      }
    } catch (e) {
      log('Error: $e');
    }
  }
}
