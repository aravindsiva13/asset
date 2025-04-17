import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../global/global_variables.dart';
import '../../../global/user_interaction_timer.dart';
import '../../../helpers/global_helper.dart';
import '../../../helpers/http_helper.dart';
import '../../../helpers/ui_components.dart';
import '../../../models/directory_model/location_model/location_details.dart';
import '../../../models/directory_model/location_model/locations.dart';
import 'package:asset_management_local/provider/main_providers/asset_provider.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';
import 'location_list_expanded_view.dart';

class LocationList extends StatefulWidget {
  const LocationList({super.key});

  @override
  State<LocationList> createState() => _LocationListState();
}

class _LocationListState extends State<LocationList>
    with TickerProviderStateMixin {
  int selectedIndex = 0;
  int listPerPage = 5;
  int currentPage = 0;

  late AnimationController controller;
  late TableBorder startBorder;
  late TableBorder endBorder;
  late TableBorder currentBorder;

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

  List<LocationDetails> getPaginatedData() {
    AssetProvider locationProvider =
        Provider.of<AssetProvider>(context, listen: false);

    final startIndex = currentPage * listPerPage;
    final endIndex = (startIndex + listPerPage)
        .clamp(0, locationProvider.locationDetailsList.length);
    return locationProvider.locationDetailsList.sublist(startIndex, endIndex);
  }

  String getDisplayedRange() {
    AssetProvider locationProvider =
        Provider.of<AssetProvider>(context, listen: false);
    final startIndex = currentPage * listPerPage + 1;
    final endIndex = (startIndex + listPerPage - 1)
        .clamp(0, locationProvider.locationDetailsList.length);
    return '$startIndex-$endIndex of ${locationProvider.locationDetailsList.length}';
  }

  @override
  void initState() {
    super.initState();
    Provider.of<AssetProvider>(context, listen: false).fetchLocationDetails();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AssetProvider, BoolProvider>(
        builder: (context, locationProvider, boolProvider, child) {
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



      return Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: boolProvider.isDarkTheme
                      ? const Color.fromRGBO(16, 18, 33, 1)
                      : const Color(0xfff3f1ef),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              width: MediaQuery.of(context).size.width,
              child: Wrap(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                            child: Row(
                              children: [
                                Text(
                                  "Location Lists",
                                  style: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                    fontSize: 20,
                                    color: boolProvider.isDarkTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  )),
                                ),
                                if(locationProvider.userRole.locationWriteFlag)...[IconButton(
                                    onPressed: () async {
                                      nameController.clear();
                                      latitudeController.clear();
                                      longitudeController.clear();
                                      addressController.clear();
                                      stateController.clear();
                                      cityController.clear();
                                      countryController.clear();
                                      landmarkController.clear();
                                      codeController.clear();
                                      plusCodeController.clear();
                                      tagController.clear();
                                      tagList.clear();
                                      showLargeAddLocation(context);
                                      await locationProvider
                                          .fetchLocationDetails();
                                    },
                                    icon: const Icon(Icons.add_circle),
                                    color:
                                    const Color.fromRGBO(15, 117, 188, 1))]

                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 0, 15),
                                child: RichText(
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                      text: locationProvider
                                          .locationDetailsList.length
                                          .toString(),
                                      style: GoogleFonts.ubuntu(
                                          textStyle: const TextStyle(
                                        fontSize: 20,
                                        color: Color.fromRGBO(15, 117, 188, 1),
                                      )),
                                    ),
                                    TextSpan(
                                      text: " Locations",
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
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 25, 15),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                  child: IconButton(
                                    icon: const Icon(
                                        Icons.arrow_circle_left_rounded),
                                    color: Colors.blue,
                                    disabledColor: Colors.grey,
                                    onPressed: currentPage > 0
                                        ? () => setState(() => currentPage--)
                                        : null,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.arrow_circle_right_rounded,
                                    ),
                                    color: Colors.blue,
                                    disabledColor: Colors.grey,
                                    onPressed: (currentPage + 1) * listPerPage <
                                            locationProvider
                                                .locationDetailsList.length
                                        ? () => setState(() => currentPage++)
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      isApiCallInProgress
                          ? Center(
                              child: Lottie.asset("assets/lottie/loader.json",
                                  repeat: false,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4))
                          : locationProvider.locationDetailsList.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Table(
                                    border: currentBorder,
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    children: [
                                      TableRow(children: [
                                        getTitleText(
                                          text: "ID",
                                        ),
                                        getTitleText(
                                          text: "Name",
                                        ),
                                        getTitleText(
                                          text: "Latitude",
                                        ),
                                        getTitleText(
                                          text: "Longitude",
                                        ),
                                        getTitleText(
                                          text: "Address",
                                        ),
                                        getTitleText(
                                          text: "Plus Code",
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
                                        LocationDetails location = entry.value;
                                        return TableRow(
                                            decoration: BoxDecoration(
                                                color: boolProvider.isDarkTheme
                                                    ? Colors.black
                                                    : Colors.white,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20))),
                                            children: [
                                              getContentText(
                                                  text: location.displayId
                                                      .toString(),
                                                  maxLines: 1,
                                                  color: themeProvider
                                                          .isDarkTheme
                                                      ? const Color.fromRGBO(
                                                          200, 200, 200, 1)
                                                      : const Color.fromRGBO(
                                                          117, 117, 117, 1)),
                                              getContentText(
                                                  text:
                                                      location.name.toString(),
                                                  maxLines: 2,
                                                  color: themeProvider
                                                          .isDarkTheme
                                                      ? const Color.fromRGBO(
                                                          200, 200, 200, 1)
                                                      : const Color.fromRGBO(
                                                          117, 117, 117, 1)),
                                              getContentText(
                                                  text: location.latitude
                                                      .toString(),
                                                  maxLines: 2,
                                                  color: themeProvider
                                                          .isDarkTheme
                                                      ? const Color.fromRGBO(
                                                          200, 200, 200, 1)
                                                      : const Color.fromRGBO(
                                                          117, 117, 117, 1)),
                                              getContentText(
                                                  text: location.longitude
                                                      .toString(),
                                                  maxLines: 2,
                                                  color: themeProvider
                                                          .isDarkTheme
                                                      ? const Color.fromRGBO(
                                                          200, 200, 200, 1)
                                                      : const Color.fromRGBO(
                                                          117, 117, 117, 1)),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 8, 0, 8),
                                                child: Column(
                                                  children: [
                                                    getContentText(
                                                        text:
                                                            "${location.address?.address!}",
                                                        maxLines: 1,
                                                        color: themeProvider
                                                                .isDarkTheme
                                                            ? const Color
                                                                .fromRGBO(200,
                                                                200, 200, 1)
                                                            : const Color
                                                                .fromRGBO(117,
                                                                117, 117, 1)),
                                                    getContentText(
                                                        text:
                                                            "${location.address?.city!}",
                                                        maxLines: 1,
                                                        color: themeProvider
                                                                .isDarkTheme
                                                            ? const Color
                                                                .fromRGBO(200,
                                                                200, 200, 1)
                                                            : const Color
                                                                .fromRGBO(117,
                                                                117, 117, 1)),
                                                    getContentText(
                                                        text:
                                                            "${location.address?.state!}",
                                                        maxLines: 1,
                                                        color: themeProvider
                                                                .isDarkTheme
                                                            ? const Color
                                                                .fromRGBO(200,
                                                                200, 200, 1)
                                                            : const Color
                                                                .fromRGBO(117,
                                                                117, 117, 1)),
                                                  ],
                                                ),
                                              ),
                                              getContentText(
                                                  text: location.plusCode
                                                      .toString(),
                                                  maxLines: 2,
                                                  color: themeProvider
                                                          .isDarkTheme
                                                      ? const Color.fromRGBO(
                                                          200, 200, 200, 1)
                                                      : const Color.fromRGBO(
                                                          117, 117, 117, 1)),
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    ExpandedDialogsDialogRoot(
                                                        dialog:
                                                            LocationListExpandedView(
                                                                location:
                                                                    location)),
                                                    if(locationProvider.userRole.locationWriteFlag)...
                                                    [
                                                      CustomActionIcon(
                                                        message: "Edit",
                                                        preferBelow: true,
                                                        iconImage: const Icon(
                                                            Icons.edit_rounded),
                                                        color:
                                                        const Color.fromRGBO(
                                                            15, 117, 188, 1),
                                                        onPressed: () {
                                                          selectedIndex = index;

                                                          int actualIndex =
                                                              (currentPage *
                                                                  listPerPage) +
                                                                  index;

                                                          nameController.text =
                                                              location.name
                                                                  .toString();
                                                          latitudeController
                                                              .text =
                                                              location.latitude
                                                                  .toString();
                                                          longitudeController
                                                              .text =
                                                              location.longitude
                                                                  .toString();
                                                          addressController.text =
                                                              location.address!
                                                                  .address
                                                                  .toString();
                                                          cityController.text =
                                                              location
                                                                  .address!.city
                                                                  .toString();
                                                          stateController.text =
                                                              location
                                                                  .address!.state
                                                                  .toString();
                                                          countryController.text =
                                                              location.address!
                                                                  .country
                                                                  .toString();
                                                          landmarkController
                                                              .text =
                                                              location.address!
                                                                  .landMark
                                                                  .toString();
                                                          codeController.text =
                                                              location.address!
                                                                  .pinCode
                                                                  .toString();
                                                          plusCodeController
                                                              .text =
                                                              location.plusCode
                                                                  .toString();
                                                          tagList = List.from(
                                                              location.tag!);
                                                          showLargeUpdateLocation(
                                                              context,
                                                              actualIndex);
                                                        },
                                                      ),
                                                      CustomActionIcon(
                                                        message: "Delete",
                                                        preferBelow: false,
                                                        iconImage: const Icon(
                                                            Icons.delete_rounded),
                                                        color: Colors.red,
                                                        onPressed: () async {
                                                          showAlertDialog(context,
                                                              locationId: location
                                                                  .displayId
                                                                  .toString(),
                                                              color: boolProvider
                                                                  .isDarkTheme
                                                                  ? Colors.white
                                                                  : Colors.black,
                                                              containerColor:
                                                              boolProvider
                                                                  .isDarkTheme
                                                                  ? Colors
                                                                  .black
                                                                  : Colors
                                                                  .white,
                                                              onPressed:
                                                                  () async {
                                                                String?
                                                                locationIdDelete =
                                                                location.sId
                                                                    .toString();

                                                                if (mounted) {
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop();
                                                                }

                                                                await deleteLocation(
                                                                    locationIdDelete,
                                                                    boolProvider,
                                                                    locationProvider);
                                                              });
                                                        },
                                                      )
                                                    ]

                                                  ],
                                                ),
                                              ),
                                            ]);
                                      }).toList(),
                                    ],
                                  ),
                                )
                              : Center(
                                  child: Lottie.asset(
                                      "assets/lottie/data_not_found.json",
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4),
                                )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  showAlertDialog(BuildContext context,
      {required onPressed,
      required color,
      required containerColor,
      required locationId}) {
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
          "Delete Location",
          style: GlobalHelper.textStyle(TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          )),
        ),
      ),
      content: getTableDeleteForSingleId(id: locationId, color: color),
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

  Future<void> showLargeAddLocation(BuildContext context) async {
    AssetProvider locationProvider =
        Provider.of<AssetProvider>(context, listen: false);

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
                  child: Container(
                    decoration: BoxDecoration(
                        color: themeProvider.isDarkTheme
                            ? const Color.fromRGBO(16, 18, 33, 1)
                            : const Color(0xfff3f1ef),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    width: MediaQuery.of(context).size.width * 0.47,
                    height: MediaQuery.of(context).size.height * 0.86,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "ADD LOCATION",
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
                                                onPressed: () async {
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

                                                  if (formKeyStep[currentStep]
                                                      .currentState!
                                                      .validate()) {
                                                    if (currentStep ==
                                                        steps.length - 1) {
                                                      if (mounted) {
                                                        Navigator.of(context)
                                                            .pop();
                                                      }

                                                      AddLocations location =
                                                          AddLocations(
                                                              name: nameController
                                                                  .text
                                                                  .toString(),
                                                              latitude:
                                                                  latitudeController
                                                                      .text
                                                                      .toString(),
                                                              longitude:
                                                                  longitudeController
                                                                      .text
                                                                      .toString(),
                                                              address: {
                                                                "address":
                                                                    addressController
                                                                        .text
                                                                        .toString(),
                                                                "city": cityController
                                                                    .text
                                                                    .toString(),
                                                                "state":
                                                                    stateController
                                                                        .text
                                                                        .toString(),
                                                                "country":
                                                                    countryController
                                                                        .text
                                                                        .toString(),
                                                                "landMark":
                                                                    landmarkController
                                                                        .text
                                                                        .toString(),
                                                                "pinCode": int.tryParse(
                                                                    codeController
                                                                        .text
                                                                        .toString()),
                                                              },
                                                              plusCode:
                                                                  plusCodeController
                                                                      .text
                                                                      .toString(),
                                                              tag: tagList);

                                                      await addLocation(
                                                          location,
                                                          themeProvider,
                                                          locationProvider);
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

  Future<void> showLargeUpdateLocation(BuildContext context, int index) async {
    currentStep = 0;
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
                  child: Container(
                    decoration: BoxDecoration(
                        color: themeProvider.isDarkTheme
                            ? const Color.fromRGBO(16, 18, 33, 1)
                            : const Color(0xfff3f1ef),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    width: MediaQuery.of(context).size.width * 0.47,
                    height: MediaQuery.of(context).size.height * 0.86,
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
                              onStepTapped: (step) {
                                if (formKeyStep[currentStep]
                                    .currentState!
                                    .validate()) {
                                  setState(() {
                                    currentStep = step;
                                  });
                                }
                              },
                              elevation: 0,
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

    AssetProvider locationProvider =
        Provider.of<AssetProvider>(context, listen: false);

    LocationDetails locationDetails =
        locationProvider.sortedLocationDetailsList[selectedIndex];

    if (locationDetails.name == nameController.text &&
        locationDetails.latitude == latitudeController.text &&
        locationDetails.longitude == longitudeController.text &&
        locationDetails.address!.address == addressController.text &&
        locationDetails.address!.city == cityController.text &&
        locationDetails.address!.state == stateController.text &&
        locationDetails.address!.landMark == landmarkController.text &&
        locationDetails.address!.country == countryController.text &&
        locationDetails.address!.pinCode.toString() == codeController.text &&
        locationDetails.plusCode.toString() == plusCodeController.text &&
        eq(locationDetails.tag, tagList)) {
      return false;
    } else {
      return true;
    }
  }

  _onTapEditButton(int index) async {
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
          sId: locationProvider.locationDetailsList[index].sId.toString());
      await updateLocation(location, boolProvider, locationProvider);
    } else {
      /// User not changed anything...
    }
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

  Future<void> addLocation(AddLocations location, BoolProvider boolProviders,
      AssetProvider locationProvider) async {
    await AddUpdateDetailsManager(
      data: location,
      apiURL: 'location/addLocation',
    ).addUpdateDetails(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("Location Added Successfully");
        locationProvider.fetchLocationDetails();
      });
    } else {
      setState(() {
        showToast("Unable to add the location");
      });
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

  Future<void> deleteLocation(String locationId, BoolProvider boolProviders,
      AssetProvider locationProvider) async {
    await DeleteDetailsManager(
      apiURL: 'location/deleteLocation',
      id: locationId,
    ).deleteDetails(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("Location Deleted Successfully");
        locationProvider.fetchLocationDetails();
      });
    } else {
      setState(() {
        showToast("Unable to delete the location");
      });
    }
  }
}
