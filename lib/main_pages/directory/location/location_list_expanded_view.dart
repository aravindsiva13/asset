import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../global/user_interaction_timer.dart';
import '../../../helpers/global_helper.dart';
import '../../../helpers/http_helper.dart';
import '../../../helpers/ui_components.dart';
import '../../../models/directory_model/location_model/location_details.dart';
import '../../../models/directory_model/location_model/locations.dart';
import 'package:asset_management_local/provider/main_providers/asset_provider.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';

class LocationListExpandedView extends StatefulWidget {
  const LocationListExpandedView({super.key, required this.location});
  final LocationDetails location;

  @override
  State<LocationListExpandedView> createState() =>
      _LocationListExpandedViewState();
}

class _LocationListExpandedViewState extends State<LocationListExpandedView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController plusCodeController = TextEditingController();
  TextEditingController tagController = TextEditingController();

  List<GlobalKey<FormState>> formKeyStep = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  int currentStep = 0;
  StepperType stepperType = StepperType.horizontal;

  List<String> tag = [];
  List<String> tagList = [];

  @override
  void initState() {
    super.initState();
    Provider.of<AssetProvider>(context, listen: false).fetchLocationDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AssetProvider, BoolProvider>(
      builder: (context, locationProvider, themeProvider, child) {
        return Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                  color: themeProvider.isDarkTheme
                      ? const Color.fromRGBO(16, 18, 33, 1)
                      : const Color(0xfff3f1ef),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              width: MediaQuery.of(context).size.width * 0.50,
              child: Wrap(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
                        child: Text(
                          "Location",
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
                                  const SizedBox(
                                    height: 5,
                                  ),
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
                                            child: Center(
                                              child: Text(
                                                widget.location.name.toString(),
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
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 45),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  getTicketStatusTitleContentUI(
                                                      title: 'Location ID'),
                                                  getTicketStatusTitleContentUI(
                                                      title: 'Latitude'),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  getTicketStatusContentUI(
                                                    content: widget
                                                        .location.displayId
                                                        .toString(),
                                                    color: themeProvider
                                                            .isDarkTheme
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  getTicketStatusContentUI(
                                                    content: widget
                                                        .location.latitude
                                                        .toString(),
                                                    color: themeProvider
                                                            .isDarkTheme
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
                                        padding:
                                            const EdgeInsets.only(left: 45),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  getTicketStatusTitleContentUI(
                                                      title: 'Longitude'),
                                                  getTicketStatusTitleContentUI(
                                                      title: 'Plus Code'),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  getTicketStatusContentUI(
                                                    content: widget
                                                        .location.longitude
                                                        .toString(),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                    color: themeProvider
                                                            .isDarkTheme
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  getTicketStatusContentUI(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                    content: widget
                                                        .location.latitude
                                                        .toString(),
                                                    color: themeProvider
                                                            .isDarkTheme
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
                                              "${widget.location.address?.address!}, ${widget.location.address?.city!}, ${widget.location.address?.state!}, ${widget.location.address?.country!}, ${widget.location.address?.pinCode!}",
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
                                      ],
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
                            getElevatedButtonIcon(
                                onPressed: () {
                                  nameController.text = widget.location.name!;
                                  addressController.text =
                                      widget.location.address!.address!;
                                  cityController.text =
                                      widget.location.address!.city!;
                                  stateController.text =
                                      widget.location.address!.state!;
                                  countryController.text =
                                      widget.location.address!.country!;
                                  landmarkController.text =
                                      widget.location.address!.landMark!;
                                  codeController.text = widget
                                      .location.address!.pinCode!
                                      .toString();
                                  latitudeController.text =
                                      widget.location.latitude.toString();
                                  longitudeController.text =
                                      widget.location.longitude.toString();
                                  plusCodeController.text =
                                      widget.location.plusCode.toString();
                                  tagList = List.from(widget.location.tag!);

                                  showLargeScreenUpdateLocation(
                                      context, locationProvider);
                                },
                                text: 'Edit'),
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
      },
    );
  }

  Future<void> showLargeScreenUpdateLocation(
      BuildContext context, AssetProvider locationProvider) async {
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
                            "UPDATE LOCATION",
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
                              currentStep: currentStep,
                              elevation: 0,
                              onStepTapped: (step) {
                                if (formKeyStep[currentStep]
                                    .currentState!
                                    .validate()) {
                                  setState(() {
                                    currentStep = step;
                                  });
                                }
                              },
                              steps: getStepsLocationDialog(setState,
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
                                                  final steps = getStepsLocationDialog(
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
                          ),
                        ),
                      ],
                    ),
                  )),
            );
          });
        });
  }

  getStepsLocationDialog(
    StateSetter setState, {
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
            "Address",
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
                              getDialogExtraContentsUI(
                                  hintText: 'Name',
                                  controllers: nameController,
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  type: TextInputType.text,
                                  dialogSetState: setState,
                                  textColor: textColor,
                                  color: colors,
                                  borderColor: borderColor,
                                  validators: commonValidator),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  getDialogAddressUI(
                                      hintText: 'Address',
                                      controllers: addressController,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      type: TextInputType.text,
                                      dialogSetState: setState,
                                      textColor: textColor,
                                      color: colors,
                                      borderColor: borderColor,
                                      validators: commonValidator),
                                  Column(
                                    children: [
                                      getDialogExtraContentsUI(
                                          hintText: 'City / Town',
                                          controllers: cityController,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                          hintText: 'State',
                                          controllers: stateController,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.20,
                                          type: TextInputType.text,
                                          validators: commonValidator,
                                          textColor: textColor,
                                          color: colors,
                                          borderColor: borderColor,
                                          dialogSetState: setState),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  getDialogExtraContentsUI(
                                      hintText: 'Land Mark',
                                      controllers: landmarkController,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      type: TextInputType.text,
                                      validators: commonValidator,
                                      textColor: textColor,
                                      color: colors,
                                      borderColor: borderColor,
                                      dialogSetState: setState),
                                  getDialogExtraContentsUI(
                                      hintText: 'Country',
                                      controllers: countryController,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      type: TextInputType.text,
                                      dialogSetState: setState,
                                      textColor: textColor,
                                      color: colors,
                                      borderColor: borderColor,
                                      validators: commonValidator),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
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
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 0,
        ),
        Step(
          title: Text(
            "Location",
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
                  child: Wrap(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(2.0),
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(67, 66, 66, 0.060),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  getDialogWithoutIconContentsUI(
                                      hintText: 'Latitude',
                                      controllers: latitudeController,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      type: TextInputType.text,
                                      dialogSetState: setState,
                                      textColor: textColor,
                                      color: colors,
                                      borderColor: borderColor,
                                      validators: commonValidator),
                                  getDialogWithoutIconContentsUI(
                                      hintText: 'Longitude',
                                      controllers: longitudeController,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      type: TextInputType.text,
                                      dialogSetState: setState,
                                      textColor: textColor,
                                      color: colors,
                                      borderColor: borderColor,
                                      validators: commonValidator),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      getDialogWithoutIconContentsUI(
                                          hintText: 'Plus Code',
                                          controllers: plusCodeController,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.20,
                                          type: TextInputType.text,
                                          dialogSetState: setState,
                                          textColor: textColor,
                                          color: colors,
                                          borderColor: borderColor,
                                          validators: commonValidator),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
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
                                              textColor: textColor,
                                              fillColor: fillColor,
                                              borderColor: borderColor,
                                              containerColor: containerColor,
                                              type: TextInputType.text),
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.20,
                                            dialogSetState: setState,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                )
              ],
            ),
          ),
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 1,
        )
      ];

  /// It contain only container with expand the content
  Widget getDialogExpansionContentsUI(
      {required double width,
      required StateSetter dialogSetState,
      required onPressed,
      required String text}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
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
                icon: const Icon(
                  Icons.add_circle,
                  color: Color.fromRGBO(15, 117, 188, 1),
                ))
          ],
        ),
      ),
    );
  }

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
        getDialogExtraContentsUI(
            hintText: 'Address',
            controllers: addressController,
            width: MediaQuery.of(context).size.width * 0.20,
            type: TextInputType.number,
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
            dialogSetState: setState),
      ],
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

  /// It will check the Existing Details of the Company and Edited or Not
  bool checkLocationDetailsEditedOrNot() {
    Function eq = const ListEquality().equals;

    if (widget.location.name == nameController.text &&
        widget.location.latitude == latitudeController.text &&
        widget.location.longitude == longitudeController.text &&
        widget.location.address!.address == addressController.text &&
        widget.location.address!.city == cityController.text &&
        widget.location.address!.state == stateController.text &&
        widget.location.address!.landMark == landmarkController.text &&
        widget.location.address!.country == countryController.text &&
        widget.location.address!.pinCode.toString() == codeController.text &&
        widget.location.plusCode.toString() == plusCodeController.text &&
        eq(widget.location.tag, tagList)) {
      return false;
    } else {
      return true;
    }
  }

  _onTapEditButton() async {
    AssetProvider locationProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider boolProvider =
        Provider.of<BoolProvider>(context, listen: false);

    final result = checkLocationDetailsEditedOrNot();
    if (result) {
      AddLocations location = AddLocations(
          name: nameController.text.toString(),
          latitude: latitudeController.text.toString(),
          longitude: longitudeController.text.toString(),
          address: {
            "address": addressController.text.toString(),
            "city": cityController.text.toString(),
            "state": stateController.text.toString(),
            "country": countryController.text.toString(),
            "landMark": landmarkController.text.toString(),
            "pinCode": int.tryParse(codeController.text.toString()),
          },
          plusCode: plusCodeController.text.toString(),
          tag: tagList,
          sId: widget.location.sId.toString());
      await updateLocation(location, boolProvider, locationProvider);
    } else {
      /// User not changed anything...
    }
  }

  Future<void> updateLocation(AddLocations location, BoolProvider boolProviders,
      AssetProvider locationProvider) async {
    await AddUpdateDetailsManager(
      data: location,
      apiURL: 'location/updateLocation',
    ).addUpdateDetails(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("Location Updated Successfully");
        locationProvider.fetchLocationDetails();
      });
    } else {
      setState(() {
        showToast("Unable to update the location");
      });
    }
  }
}
