import 'dart:convert';
import 'dart:developer';
import 'package:barcode_image/barcode_image.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../global/global_variables.dart';
import '../../../helpers/global_helper.dart';
import '../../../helpers/http_helper.dart';
import '../../../helpers/ui_components.dart';
import '../../../models/asset_model/asset_model_model/asset_model_details.dart';
import '../../../models/asset_model/asset_stock_model/add_warranty.dart';
import '../../../models/asset_model/asset_stock_model/asset_stock.dart';
import '../../../models/asset_model/asset_stock_model/asset_stock_details.dart';
import 'package:asset_management_local/provider/main_providers/asset_provider.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:image/image.dart' as img;
// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:js' as js;

class StockListExpandedView extends StatefulWidget {
  const StockListExpandedView({super.key, required this.stock});
  final AssetStockDetails stock;

  @override
  State<StockListExpandedView> createState() => _StockListExpandedViewState();
}

class _StockListExpandedViewState extends State<StockListExpandedView> {
  String selectedImageName = 'Image';

  PlatformFile? imagePicked;

  PlatformFile? filePicked;

  TextEditingController serialController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  TextEditingController purchaseDateController = TextEditingController();
  TextEditingController warrantyDaysController = TextEditingController();
  TextEditingController warrantyMonthsController = TextEditingController();
  TextEditingController warrantyYearsController = TextEditingController();
  List<TextEditingController> particularExpiryDateController = [];
  List<TextEditingController> particularWarrantyNameController = [];
  List<TextEditingController> particularWarrantyIdController = [];

  List<String> tag = [];
  List<String> tagList = [];

  late DateTime selectedDate;
  late DateTime selectDate;
  late DateTime selectedPurchaseDate;
  late TimeOfDay selectedTime;

  late String assetRefId;
  late String locationRefId;
  late String vendorRefId;
  late String userRefId;
  late String warrantyExpiry;

  late String image;

  List<WarrantyDetails>? warranty = [];

  int currentStockStep = 0;
  int currentEditStockStep = 0;
  StepperType stepperStockType = StepperType.horizontal;
  StepperType stepperType = StepperType.horizontal;

  String selectedFileName = 'Warranty Agreement';

  List<GlobalKey<FormState>> formKeyStepStock = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  List<String> warrantyAttachments = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BoolProvider,AssetProvider>(builder: (context, themeProvider,stockProvider, child) {
      return Center(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                color: themeProvider.isDarkTheme
                    ? const Color.fromRGBO(16, 18, 33, 1)
                    : const Color(0xfff3f1ef),
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            width: MediaQuery.of(context).size.width * 0.55,
            height: MediaQuery.of(context).size.height * 0.88,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
                  child: Text(
                    "Asset Stock",
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
                        child: Material(
                          color: Colors.transparent,
                          child: Stepper(
                            type: stepperStockType,
                            currentStep: currentStockStep,
                            elevation: 0,
                            onStepTapped: (step) {
                              setState(() {
                                currentStockStep = step;
                              });
                            },
                            steps: getStepStockListExpandedView(
                              setState,
                              color: themeProvider.isDarkTheme
                                  ? Colors.white
                                  : Colors.black,
                              colors: themeProvider.isDarkTheme
                                  ? Colors.black
                                  : Colors.white,
                              textColor: themeProvider.isDarkTheme
                                  ? Colors.white
                                  : const Color.fromRGBO(117, 117, 117, 1),
                              containerColors: themeProvider.isDarkTheme
                                  ? const Color.fromRGBO(16, 18, 33, 1)
                                  : const Color(0xfff3f1ef),
                              backgroundColor: themeProvider.isDarkTheme
                                  ? const Color.fromRGBO(16, 18, 33, 1)
                                  : const Color.fromRGBO(243, 241, 239, 1),
                              collapsedBackgroundColor:
                                  themeProvider.isDarkTheme
                                      ? const Color.fromRGBO(16, 18, 33, 1)
                                      : const Color.fromRGBO(243, 241, 239, 1),
                              iconColor: themeProvider.isDarkTheme
                                  ? Colors.white
                                  : Colors.black,
                              collapsedIconColor: themeProvider.isDarkTheme
                                  ? Colors.white
                                  : Colors.black,
                              images: themeProvider.isDarkTheme
                                  ? 'assets/images/riota_logo.png'
                                  : 'assets/images/riota_logo2.png',
                            ),
                            controlsBuilder: (context, details) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 40, 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                      child: getElevatedButton(
                                          onPressed: () {
                                            generateQrCode(context);
                                          },
                                          text: 'Generate QR Code'),
                                    ),
                                    if(stockProvider.userRole.assetStockWriteFlag)...[
                                      Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                        child: getElevatedButtonIcon(
                                            onPressed: () async {
                                              List<String>
                                              warrantyPeriodParts = widget
                                                  .stock.warrantyPeriod!
                                                  .split(', ');

                                              int days = 0;
                                              int months = 0;
                                              int years = 0;

                                              for (String part
                                              in warrantyPeriodParts) {
                                                if (part.contains('Days')) {
                                                  days = int.tryParse(part
                                                      .split(' ')[0]) ??
                                                      0;
                                                } else if (part
                                                    .contains('Months')) {
                                                  months = int.tryParse(part
                                                      .split(' ')[0]) ??
                                                      0;
                                                } else if (part
                                                    .contains('Years')) {
                                                  years = int.tryParse(part
                                                      .split(' ')[0]) ??
                                                      0;
                                                }
                                              }

                                              dateTimeController.text = widget
                                                  .stock.issuedDateTime ??
                                                  "";
                                              expiryDateController.text =
                                              widget
                                                  .stock.warrantyExpiry!;
                                              serialController.text =
                                                  widget.stock.serialNo ?? "";
                                              remarksController.text =
                                                  widget.stock.remarks ?? "";
                                              assetRefId =
                                                  widget.stock.assetRefId ??
                                                      "";
                                              locationRefId = widget
                                                  .stock.locationRefId ??
                                                  "";
                                              vendorRefId =
                                                  widget.stock.vendorRefId ??
                                                      "";
                                              userRefId =
                                                  widget.stock.userRefId ??
                                                      "";
                                              purchaseDateController.text =
                                                  widget.stock.purchaseDate ??
                                                      "";
                                              warrantyDaysController.text =
                                                  days.toString();
                                              warrantyMonthsController.text =
                                                  months.toString();
                                              warrantyYearsController.text =
                                                  years.toString();
                                              tagList = List.from(
                                                  widget.stock.tag!);
                                              warranty = List.from(widget
                                                  .stock.warrantyDetails!);

                                              showLargeUpdateStock(context);
                                            },
                                            text: 'Edit')
                                      ),
                                    ],

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if (currentStockStep != 0)
                                          Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 8, 8, 0),
                                              child: getElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      currentStockStep -= 1;
                                                    });
                                                  },
                                                  text: 'Previous')),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 8, 8, 0),
                                          child: getElevatedButton(
                                              onPressed: () {
                                                if (currentStockStep == 2) {
                                                  Navigator.of(context).pop();
                                                } else {
                                                  setState(() {
                                                    currentStockStep++;
                                                  });
                                                }
                                              },
                                              text: currentStockStep == 2
                                                  ? "Close"
                                                  : "Next"),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ))),
              ],
            ),
          ),
        ),
      );
    });
  }

  List<Step> getStepStockListExpandedView(
    StateSetter dialogSetState, {
    required color,
    required colors,
    required containerColors,
    required textColor,
    required backgroundColor,
    required collapsedBackgroundColor,
    required collapsedIconColor,
    required iconColor,
    required images,
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
          content: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 10, 40, 20),
                child: Container(
                  decoration: BoxDecoration(
                      color: colors,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: containerColors,
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: ClipOval(
                              child: Image.network(
                                '$websiteURL/images/${widget.stock.image}',
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
                                    Object error, StackTrace? stackTrace) {
                                  return Image.asset(
                                    images,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      getTicketStatusTitleContentUI(title: 'Asset'),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Wrap(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: containerColors,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    widget.stock.assetName.toString(),
                                    style: GoogleFonts.ubuntu(
                                        textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: color,
                                    )),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                                      getTicketStatusTitleContentUI(
                                          title: 'Stock ID'),
                                      getTicketStatusTitleContentUI(
                                          title: 'Issued Date & Time'),
                                      getTicketStatusTitleContentUI(
                                          title: 'Vendor'),
                                      getTicketStatusTitleContentUI(
                                          title: 'Warranty Expiry'),
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
                                        content:
                                            widget.stock.displayId.toString(),
                                        color: color,
                                      ),
                                      getTicketStatusContentUI(
                                        content: widget.stock.issuedDateTime
                                            .toString(),
                                        color: color,
                                      ),
                                      getTicketStatusContentUI(
                                        content:
                                            widget.stock.vendorName.toString(),
                                        color: color,
                                      ),
                                      getTicketStatusContentUI(
                                        content: widget.stock.warrantyPeriod
                                            .toString(),
                                        color: color,
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
                                          title: 'Location'),
                                      getTicketStatusTitleContentUI(
                                          title: 'Serial No'),
                                      getTicketStatusTitleContentUI(
                                          title: "Purchase Date"),
                                      getTicketStatusTitleContentUI(
                                          title: "Warranty Expiry"),
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
                                        content: widget.stock.locationName
                                            .toString(),
                                        color: color,
                                      ),
                                      getTicketStatusContentUI(
                                        content:
                                            widget.stock.serialNo.toString(),
                                        color: color,
                                      ),
                                      getTicketStatusContentUI(
                                        content: widget.stock.purchaseDate
                                            .toString(),
                                        color: color,
                                      ),
                                      getTicketStatusContentUI(
                                        content: widget.stock.warrantyExpiry
                                            .toString(),
                                        color: color,
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (widget.stock.remarks != null &&
                              widget.stock.remarks != "")
                            Column(
                              children: [
                                getTicketStatusTitleContentUI(title: 'Remarks'),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Wrap(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: containerColors,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15))),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Center(
                                            child: Text(
                                              widget.stock.remarks.toString(),
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: color,
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
                          if (widget.stock.assignedTo != null)
                            Column(
                              children: [
                                getTicketStatusTitleContentUI(
                                    title: 'Assigned To'),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Wrap(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: containerColors,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15))),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Center(
                                            child: Text(
                                              widget.stock.assignedTo
                                                  .toString(),
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: color,
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
                      const SizedBox(
                        height: 10,
                      ),
                      if (widget.stock.specifications != null)
                        Column(
                          children: [
                            getTicketStatusTitleContentUI(
                                title: 'Specifications'),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: containerColors,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15))),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Wrap(
                                    runSpacing:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                    spacing: MediaQuery.of(context).size.width *
                                        0.04,
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    runAlignment: WrapAlignment.center,
                                    children: widget.stock.specifications
                                            ?.map((e) {
                                          return Column(
                                            children: [
                                              RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: '${e.key}',
                                                      style: GoogleFonts.ubuntu(
                                                          textStyle:
                                                              const TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromRGBO(
                                                            117, 117, 117, 1),
                                                      )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: '${e.value}',
                                                      style: GoogleFonts.ubuntu(
                                                          textStyle: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: color,
                                                      )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList() ??
                                        [],
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
          content: Column(
            children: [
              Wrap(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: colors,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              (widget.stock.specifications?.length ?? 0) ~/ 2 +
                                  ((widget.stock.specifications?.length ?? 0) %
                                      2),
                          itemBuilder: (context, rowIndex) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (rowIndex * 2 <
                                    (widget.stock.specifications?.length ?? 0))
                                  buildWarrantyItem(context, rowIndex * 2,
                                      color: color,
                                      colors: colors,
                                      containerColors: containerColors,
                                      textColor: textColor,
                                      backgroundColor: backgroundColor,
                                      collapsedBackgroundColor:
                                          collapsedBackgroundColor,
                                      collapsedIconColor: collapsedIconColor,
                                      iconColor: iconColor),
                                const SizedBox(width: 5),
                                if (rowIndex * 2 + 1 <
                                    (widget.stock.specifications?.length ?? 0))
                                  buildWarrantyItem(context, rowIndex * 2 + 1,
                                      color: color,
                                      colors: colors,
                                      containerColors: containerColors,
                                      textColor: textColor,
                                      backgroundColor: backgroundColor,
                                      collapsedBackgroundColor:
                                          collapsedBackgroundColor,
                                      collapsedIconColor: collapsedIconColor,
                                      iconColor: iconColor),
                              ],
                            );
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
          state: currentStockStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStockStep == 1,
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
          content: Column(
            children: [
              Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: colors,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: Column(
                        children: [
                          getTicketStatusTitleContentUI(
                              title: 'Overall Status'),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Wrap(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: containerColors,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15))),
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        widget.stock.overAllStatus.toString(),
                                        style: GoogleFonts.ubuntu(
                                            textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: color,
                                        )),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (widget.stock.checkListDetails != null &&
                              widget.stock.checkListDetails!.isNotEmpty)
                            Column(
                              children: [
                                getTicketStatusTitleContentUI(
                                    title: 'Specification Status'),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: (widget.stock.checkListDetails
                                                  ?.length ??
                                              0) ~/
                                          2 +
                                      ((widget.stock.checkListDetails?.length ??
                                              0) %
                                          2),
                                  itemBuilder: (context, rowIndex) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (rowIndex * 2 <
                                            (widget.stock.checkListDetails?.length ??
                                                0))
                                          buildSpecificationStatusItem(
                                              context, rowIndex * 2,
                                              color: color,
                                              colors: colors,
                                              containerColors: containerColors,
                                              textColor: textColor,
                                              backgroundColor: backgroundColor,
                                              collapsedBackgroundColor:
                                                  collapsedBackgroundColor,
                                              collapsedIconColor:
                                                  collapsedIconColor,
                                              iconColor: iconColor),
                                        const SizedBox(width: 5),
                                        if (rowIndex * 2 + 1 <
                                            (widget.stock.checkListDetails?.length ??
                                                0))
                                          buildSpecificationStatusItem(
                                              context, rowIndex * 2 + 1,
                                              color: color,
                                              colors: colors,
                                              containerColors: containerColors,
                                              textColor: textColor,
                                              backgroundColor: backgroundColor,
                                              collapsedBackgroundColor:
                                                  collapsedBackgroundColor,
                                              collapsedIconColor:
                                                  collapsedIconColor,
                                              iconColor: iconColor),
                                      ],
                                    );
                                  },
                                ),
                                // ListView.builder(
                                //     shrinkWrap: true,
                                //     itemCount: (widget
                                //             .stock.checkListDetails?.length ??
                                //         0),
                                //     itemBuilder: (context, index) {
                                //       final checkListDetail =
                                //           widget.stock.checkListDetails?[index];
                                //       return Column(
                                //         children: [
                                //           Padding(
                                //             padding: const EdgeInsets.all(5.0),
                                //             child: SizedBox(
                                //               width: MediaQuery.of(context)
                                //                       .size
                                //                       .width *
                                //                   0.2,
                                //               child: ExpansionTile(
                                //                 initiallyExpanded: true,
                                //                 maintainState: true,
                                //                 backgroundColor:
                                //                     backgroundColor,
                                //                 collapsedBackgroundColor:
                                //                     collapsedBackgroundColor,
                                //                 iconColor: iconColor,
                                //                 collapsedIconColor:
                                //                     collapsedIconColor,
                                //                 shape:
                                //                     const RoundedRectangleBorder(
                                //                         borderRadius:
                                //                             BorderRadius.all(
                                //                                 Radius.circular(
                                //                                     15))),
                                //                 collapsedShape:
                                //                     const RoundedRectangleBorder(
                                //                         borderRadius:
                                //                             BorderRadius.all(
                                //                                 Radius.circular(
                                //                                     50))),
                                //                 title: Center(
                                //                   child: Text(
                                //                     checkListDetail?.entryName
                                //                             .toString() ??
                                //                         "",
                                //                     style: GoogleFonts.ubuntu(
                                //                       textStyle: TextStyle(
                                //                         fontSize: 15,
                                //                         color: color,
                                //                         fontWeight:
                                //                             FontWeight.bold,
                                //                       ),
                                //                     ),
                                //                   ),
                                //                 ),
                                //                 children: [
                                //                   Column(
                                //                     mainAxisAlignment:
                                //                         MainAxisAlignment
                                //                             .center,
                                //                     crossAxisAlignment:
                                //                         CrossAxisAlignment
                                //                             .center,
                                //                     children: [
                                //                       Wrap(
                                //                         children: [
                                //                           getTicketStatusTitleContentUI(
                                //                               title: 'Status'),
                                //                           Padding(
                                //                             padding:
                                //                                 const EdgeInsets
                                //                                     .all(5.0),
                                //                             child: Container(
                                //                               decoration: BoxDecoration(
                                //                                   color: colors,
                                //                                   borderRadius:
                                //                                       const BorderRadius
                                //                                           .all(
                                //                                           Radius.circular(
                                //                                               15))),
                                //                               width: MediaQuery.of(
                                //                                           context)
                                //                                       .size
                                //                                       .width *
                                //                                   0.1,
                                //                               child: Padding(
                                //                                 padding:
                                //                                     const EdgeInsets
                                //                                         .all(
                                //                                         5.0),
                                //                                 child: Center(
                                //                                   child: Text(
                                //                                     checkListDetail
                                //                                             ?.overAllStatus
                                //                                             .toString() ??
                                //                                         "",
                                //                                     style: GoogleFonts
                                //                                         .ubuntu(
                                //                                       textStyle:
                                //                                           TextStyle(
                                //                                         fontSize:
                                //                                             15,
                                //                                         color:
                                //                                             color,
                                //                                         fontWeight:
                                //                                             FontWeight.bold,
                                //                                       ),
                                //                                     ),
                                //                                   ),
                                //                                 ),
                                //                               ),
                                //                             ),
                                //                           ),
                                //                         ],
                                //                       ),
                                //                       if (checkListDetail
                                //                                   ?.remarks ==
                                //                               null ||
                                //                           checkListDetail
                                //                                   ?.remarks ==
                                //                               "")
                                //                         const SizedBox(
                                //                             height: 10),
                                //                       if (checkListDetail
                                //                                   ?.remarks !=
                                //                               null &&
                                //                           checkListDetail
                                //                                   ?.remarks !=
                                //                               "")
                                //                         Column(
                                //                           children: [
                                //                             Row(
                                //                               mainAxisAlignment:
                                //                                   MainAxisAlignment
                                //                                       .center,
                                //                               children: [
                                //                                 getTicketStatusTitleContentUI(
                                //                                     title:
                                //                                         'Remarks'),
                                //                                 Padding(
                                //                                   padding:
                                //                                       const EdgeInsets
                                //                                           .all(
                                //                                           5),
                                //                                   child: Wrap(
                                //                                     children: [
                                //                                       Container(
                                //                                         decoration: BoxDecoration(
                                //                                             color:
                                //                                                 colors,
                                //                                             borderRadius:
                                //                                                 const BorderRadius.all(Radius.circular(15))),
                                //                                         width: MediaQuery.of(context).size.width *
                                //                                             0.1,
                                //                                         child:
                                //                                             Center(
                                //                                           child:
                                //                                               Padding(
                                //                                             padding:
                                //                                                 const EdgeInsets.all(5.0),
                                //                                             child:
                                //                                                 Text(
                                //                                               checkListDetail?.remarks.toString() ?? "",
                                //                                               style: GoogleFonts.ubuntu(
                                //                                                   textStyle: TextStyle(
                                //                                                 fontSize: 15,
                                //                                                 fontWeight: FontWeight.bold,
                                //                                                 color: color,
                                //                                               )),
                                //                                             ),
                                //                                           ),
                                //                                         ),
                                //                                       ),
                                //                                     ],
                                //                                   ),
                                //                                 ),
                                //                               ],
                                //                             ),
                                //                             const SizedBox(
                                //                                 height: 10)
                                //                           ],
                                //                         ),
                                //                     ],
                                //                   ),
                                //                 ],
                                //               ),
                                //             ),
                                //           ),
                                //           const SizedBox(height: 15),
                                //         ],
                                //       );
                                //     }),
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
              const SizedBox(
                height: 250,
              ),
            ],
          ),
          state: currentStockStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStockStep == 2,
        ),
      ];

  Widget buildWarrantyItem(BuildContext context, int index,
      {color,
      colors,
      containerColors,
      textColor,
      backgroundColor,
      collapsedBackgroundColor,
      collapsedIconColor,
      iconColor}) {
    var specification = widget.stock.specifications![index];
    var correspondingWarranty =
        widget.stock.warrantyDetails?.isNotEmpty ?? false
            ? widget.stock.warrantyDetails!.firstWhere(
                (warranty) => warranty.warrantyName == specification.key,
                orElse: () => WarrantyDetails(
                  sId: '',
                  warrantyExpiry: '',
                  warrantyName: '',
                  warrantyAttachment: null,
                ),
              )
            : WarrantyDetails(
                sId: '',
                warrantyExpiry: '',
                warrantyName: '',
                warrantyAttachment: null,
              );

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            SizedBox(
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
                    specification.key.toString(),
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
                      Wrap(
                        children: [
                          getTicketStatusTitleContentUI(title: 'Expiry Date'),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: colors,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                  child: Text(
                                    correspondingWarranty.warrantyExpiry != ""
                                        ? correspondingWarranty.warrantyExpiry
                                            .toString()
                                        : widget.stock.warrantyExpiry
                                            .toString(),
                                    style: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                        fontSize: 15,
                                        color: color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      if (correspondingWarranty.warrantyAttachment != null)
                        GestureDetector(
                          onTap: () {
                            if (kIsWeb) {
                              js.context.callMethod('open', [
                                '$websiteURL/images/${correspondingWarranty.warrantyAttachment}'
                              ]);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: getDialogFileContentsUIForAgreement(
                              width: MediaQuery.of(context).size.width * 0.15,
                              dialogSetState: setState,
                              text: selectedFileName,
                              icon: Icons.picture_as_pdf_rounded,
                              textColor: textColor,
                              containerColor: colors,
                            ),
                          ),
                        ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSpecificationStatusItem(BuildContext context, int index,
      {color,
      colors,
      containerColors,
      textColor,
      backgroundColor,
      collapsedBackgroundColor,
      collapsedIconColor,
      iconColor}) {
    final checkListDetail = widget.stock.checkListDetails?[index];

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            SizedBox(
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
                    checkListDetail?.entryName.toString() ?? "",
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
                      Wrap(
                        children: [
                          getTicketStatusTitleContentUI(title: 'Status'),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: colors,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                  child: Text(
                                    checkListDetail?.overAllStatus.toString() ??
                                        "",
                                    style: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                        fontSize: 15,
                                        color: color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (checkListDetail?.remarks == null ||
                          checkListDetail?.remarks == "")
                        const SizedBox(height: 10),
                      if (checkListDetail?.remarks != null &&
                          checkListDetail?.remarks != "")
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                getTicketStatusTitleContentUI(title: 'Remarks'),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Wrap(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: colors,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15))),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              checkListDetail?.remarks
                                                      .toString() ??
                                                  "",
                                              style: GoogleFonts.ubuntu(
                                                  textStyle: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: color,
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
                            const SizedBox(height: 10)
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showLargeUpdateStock(BuildContext context) async {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    AssetProvider stockProvider =
        Provider.of<AssetProvider>(context, listen: false);

    showDialog(
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
                                "UPDATE STOCK",
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
                                  currentStep: currentEditStockStep,
                                  elevation: 0,
                                  onStepTapped: (step) {
                                    if (formKeyStepStock[currentEditStockStep]
                                        .currentState!
                                        .validate()) {
                                      setState(() {
                                        currentEditStockStep = step;
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
                                                  Navigator.of(context).pop();
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            if (currentEditStockStep != 0)
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
                                                          currentEditStockStep -=
                                                              1;
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
                                                              currentEditStockStep]
                                                          .currentState!
                                                          .validate()) {
                                                        if (currentEditStockStep ==
                                                            steps.length - 1) {
                                                          _onTapEditButton();

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
                                                                warrantyId =
                                                                particularWarrantyIdController
                                                                    .map((controller) =>
                                                                        controller
                                                                            .text)
                                                                    .toList();

                                                            List<String>
                                                                warrantyAttachment =
                                                                warrantyAttachments;

                                                            int maxLength =
                                                                expiryDate
                                                                    .length;
                                                            maxLength = maxLength >
                                                                    warrantyName
                                                                        .length
                                                                ? warrantyName
                                                                    .length
                                                                : maxLength;
                                                            maxLength = maxLength >
                                                                    warrantyId
                                                                        .length
                                                                ? warrantyId
                                                                    .length
                                                                : maxLength;

                                                            for (int i = 0;
                                                                i < maxLength;
                                                                i++) {
                                                              String
                                                                  currentExpiryDate =
                                                                  expiryDate[i];
                                                              String
                                                                  currentWarrantyName =
                                                                  warrantyName[
                                                                      i];
                                                              String
                                                                  currentWarrantyId =
                                                                  warrantyId[i];

                                                              String
                                                                  currentWarrantyAttachment =
                                                                  '';
                                                              if (i <
                                                                  warrantyAttachment
                                                                      .length) {
                                                                currentWarrantyAttachment =
                                                                    warrantyAttachment[
                                                                        i];
                                                              }

                                                              if (currentExpiryDate
                                                                      .isEmpty &&
                                                                  currentWarrantyAttachment
                                                                      .isNotEmpty) {
                                                                currentExpiryDate =
                                                                    warrantyExpiry;
                                                              }

                                                              if (currentExpiryDate
                                                                      .isNotEmpty ||
                                                                  currentWarrantyAttachment
                                                                      .isNotEmpty) {
                                                                if (currentWarrantyId ==
                                                                    "0") {
                                                                  Warranty
                                                                      warranty =
                                                                      Warranty(
                                                                    stockRefId:
                                                                        widget
                                                                            .stock
                                                                            .sId,
                                                                    modelRefId:
                                                                        assetRefId,
                                                                    warrantyExpiry:
                                                                        currentExpiryDate,
                                                                    warrantyAttachment:
                                                                        currentWarrantyAttachment,
                                                                    warrantyName:
                                                                        currentWarrantyName,
                                                                  );

                                                                  await addWarranty(
                                                                      warranty);
                                                                  await stockProvider
                                                                      .fetchStockDetails();
                                                                } else {
                                                                  Warranty
                                                                      warranty =
                                                                      Warranty(
                                                                    stockRefId:
                                                                        widget
                                                                            .stock
                                                                            .sId,
                                                                    modelRefId:
                                                                        assetRefId,
                                                                    warrantyExpiry:
                                                                        currentExpiryDate,
                                                                    warrantyAttachment:
                                                                        currentWarrantyAttachment,
                                                                    warrantyName:
                                                                        currentWarrantyName,
                                                                    sId: currentWarrantyId
                                                                        .toString(),
                                                                  );

                                                                  await updateWarranty(
                                                                      warranty);
                                                                  await stockProvider
                                                                      .fetchStockDetails();
                                                                }
                                                              }
                                                            }
                                                          }

                                                          particularExpiryDateController
                                                              .clear();

                                                          particularWarrantyIdController
                                                              .clear();

                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.of(context)
                                                              .pop();
                                                        } else {
                                                          setState(() {
                                                            currentEditStockStep++;
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
                                                      currentEditStockStep == 1
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

  List<Step> getStepsStockDialog(StateSetter dialogSetState,
          {required color,
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
          index}) =>
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
                                    controllers: remarksController,
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

    modelRefId = assetRefId;

    List<String> modelIdList;
    modelIdList = <String>[modelRefId];

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

            String parameterName = modelDetails!.parameters![i];
            WarrantyDetails? relatedWarranty;
            for (var warranty in warranty!) {
              if (warranty.warrantyName?.toLowerCase() ==
                  parameterName.toLowerCase()) {
                relatedWarranty = warranty;
                break;
              }
            }

            String warrantyId = relatedWarranty?.sId ?? "0";
            TextEditingController controller =
                TextEditingController(text: warrantyId);
            particularWarrantyIdController.add(controller);
          }
          warrantyAttachments =
              List.generate(modelDetails?.parameters?.length ?? 0, (_) => '');
          List<String> parameterNames = modelDetails!.parameters!;
          int startIndex = index * 2;

          return Row(
            children: [
              if (startIndex < parameterNames.length)
                buildWarrantyTiles(
                    parameterName: parameterNames[startIndex],
                    warrantyDetails: warranty!,
                    borderColor: borderColor,
                    textColor: textColor,
                    backgroundColor: backgroundColor,
                    collapsedBackgroundColor: collapsedBackgroundColor,
                    iconColor: iconColor,
                    collapsedIconColor: collapsedIconColor,
                    fillColor: fillColor,
                    containerColor: containerColor,
                    color: color,
                    controller: particularExpiryDateController[startIndex],
                    context: context,
                    onPressed: () {
                      setState(() {
                        selectedPurchaseDate = DateTime.now();
                        if (mounted) {
                          selectDateForWarrantyPeriod(
                              context,
                              particularExpiryDateController[startIndex],
                              setState,
                              firstDate: DateTime(
                                  selectedPurchaseDate.year - 7,
                                  selectedPurchaseDate.month,
                                  selectedPurchaseDate.day),
                              lastDate:
                                  DateTime(selectedPurchaseDate.year + 15));

                          if (startIndex < modelDetails.parameters!.length) {
                            particularWarrantyNameController[startIndex].text =
                                modelDetails.parameters![startIndex];
                          }
                        }
                      });
                    },
                    onTap: () {
                      setState(() {
                        pickFileForWarranty(context, setState, startIndex,
                            allowedExtension: ['pdf', 'doc']).then((_) {
                          if (warrantyAttachments[startIndex] != "Attachment") {
                            showToast(
                                "Successfully ${warrantyAttachments[startIndex]} File Added");
                            log("Filename at index $startIndex: ${warrantyAttachments[startIndex]}");
                          }
                        });

                        if (startIndex < modelDetails.parameters!.length) {
                          particularWarrantyNameController[startIndex].text =
                              modelDetails.parameters![startIndex];
                        }
                      });
                    }),
              if (startIndex + 1 < parameterNames.length)
                buildWarrantyTiles(
                  parameterName: parameterNames[startIndex + 1],
                  warrantyDetails: warranty!,
                  borderColor: borderColor,
                  textColor: textColor,
                  backgroundColor: backgroundColor,
                  collapsedBackgroundColor: collapsedBackgroundColor,
                  iconColor: iconColor,
                  collapsedIconColor: collapsedIconColor,
                  fillColor: fillColor,
                  containerColor: containerColor,
                  color: color,
                  controller: particularExpiryDateController[startIndex + 1],
                  context: context,
                  onPressed: () {
                    setState(() {
                      selectedPurchaseDate = DateTime.now();
                      if (mounted) {
                        selectDateForWarrantyPeriod(
                            context,
                            particularExpiryDateController[startIndex + 1],
                            setState,
                            firstDate: DateTime(
                                selectedPurchaseDate.year - 7,
                                selectedPurchaseDate.month,
                                selectedPurchaseDate.day),
                            lastDate: DateTime(selectedPurchaseDate.year + 15));

                        if ((startIndex + 1) <
                            modelDetails.parameters!.length) {
                          particularWarrantyNameController[startIndex + 1]
                              .text = modelDetails.parameters![startIndex + 1];
                        }
                      }
                    });
                  },
                  onTap: () {
                    setState(() {
                      pickFileForWarranty(context, setState, (startIndex + 1),
                          allowedExtension: ['pdf', 'doc']).then((_) {
                        if (warrantyAttachments[startIndex + 1] !=
                            "Attachment") {
                          showToast(
                              "Successfully ${warrantyAttachments[startIndex + 1]} File Added");
                          log("Filename at index $startIndex: ${warrantyAttachments[startIndex + 1]}");
                        }
                      });

                      if ((startIndex + 1) < modelDetails.parameters!.length) {
                        particularWarrantyNameController[startIndex + 1].text =
                            modelDetails.parameters![startIndex + 1];
                      }
                    });
                  },
                ),
            ],
          );
        });
  }

  Widget buildWarrantyTiles(
      {required String parameterName,
      required List<WarrantyDetails> warrantyDetails,
      required BuildContext context,
      backgroundColor,
      collapsedBackgroundColor,
      collapsedIconColor,
      iconColor,
      containerColor,
      fillColor,
      borderColor,
      textColor,
      color,
      controller,
      onPressed,
      onTap}) {
    WarrantyDetails? relatedWarranty;
    for (var warranty in warrantyDetails) {
      if (warranty.warrantyName?.toLowerCase() == parameterName.toLowerCase()) {
        relatedWarranty = warranty;
        break;
      }
    }

    warrantyExpiry = (relatedWarranty != null
        ? relatedWarranty.warrantyExpiry
        : expiryDateController.text)!;

    return Padding(
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
              parameterName,
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
                  hintText: warrantyExpiry,
                  suffixIcon: Icons.calendar_today_rounded,
                  iconColor: const Color.fromRGBO(15, 117, 188, 1),
                  controllers: controller,
                  type: TextInputType.datetime,
                  dialogSetState: setState,
                  readOnly: true,
                  fillColor: fillColor,
                  borderColor: borderColor,
                  textColor: textColor,
                  onPressed: onPressed,
                ),
                const SizedBox(height: 5),
                getDialogFileContentsUI(
                    secondaryWidth: MediaQuery.of(context).size.width * 0.10,
                    width: MediaQuery.of(context).size.width * 0.15,
                    dialogSetState: setState,
                    text: "Attachment",
                    onPressed: onTap,
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
    );
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

  Widget getImageWidget() {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    if (imagePicked != null) {
      return Image.memory(imagePicked!.bytes!, fit: BoxFit.cover);
    } else {
      return Image.network(
        '$websiteURL/images/${widget.stock.image}',
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

  Future<void> generateQrCode(BuildContext context) async {
    var screenSize = MediaQuery.of(context).size;

    String assetDetails =
        "1. Asset: ${widget.stock.assetName.toString()}, \n2. Serial No: ${widget.stock.serialNo.toString()}, \n3. Asset Id: ${widget.stock.displayId.toString()}, \n4. Warranty Expiry: ${widget.stock.warrantyExpiry.toString()}";

    List<String> specificationsDetailsList = widget.stock.specifications
            ?.map((spec) => "${spec.key}: ${spec.value}")
            .toList() ??
        [];
    String specificationsDetails = specificationsDetailsList.join(", ");

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color(0xfff3f1ef),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: Wrap(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Text(
                              "QR CODE",
                              style: GoogleFonts.ubuntu(
                                  textStyle: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                            ),
                          ),
                          Wrap(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      QrImageView(
                                        data:
                                            "$assetDetails, \n5. Specifications: [$specificationsDetails], \n6. Departments: [${fetchDepartment(widget.stock.departments!)}]",
                                        size: 250,
                                      ),
                                      Positioned(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.11,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.11,
                                        child: Image.asset(
                                          'assets/images/riota_logo5.png',
                                          width: 85,
                                          height: 85,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: SizedBox(
                                  height: screenSize.height * 0.040,
                                  width: screenSize.width * 0.08,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      downloadPng();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)))),
                                    label: Text(
                                      "PNG",
                                      style: GlobalHelper.textStyle(
                                          const TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                      )),
                                    ),
                                    icon: const Icon(
                                      Icons.download,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: SizedBox(
                                  height: screenSize.height * 0.040,
                                  width: screenSize.width * 0.08,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      downloadPdf();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)))),
                                    label: Text(
                                      "PDF",
                                      style: GlobalHelper.textStyle(
                                          const TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                      )),
                                    ),
                                    icon: const Icon(
                                      Icons.download,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: SizedBox(
                                  height: screenSize.height * 0.040,
                                  width: screenSize.width * 0.08,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      printPdf();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)))),
                                    label: Text(
                                      "Print",
                                      style: GlobalHelper.textStyle(
                                          const TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                      )),
                                    ),
                                    icon: const Icon(
                                      Icons.print,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Future<void> printPdf() async {
    String assetDetails =
        "1. Asset: ${widget.stock.assetName.toString()}, \n2. Serial No: ${widget.stock.serialNo.toString()}, \n3. Asset Id: ${widget.stock.displayId.toString()}, \n4. Warranty Expiry: ${widget.stock.warrantyExpiry.toString()}";

    List<String> specificationsDetailsList = widget.stock.specifications
            ?.map((spec) => "${spec.key}: ${spec.value}")
            .toList() ??
        [];
    String specificationsDetails = specificationsDetailsList.join(", ");

    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/riota_logo5.png'))
          .buffer
          .asUint8List(),
    );

    final doc = pw.Document();
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Wrap(children: [
            pw.Container(
                width: 750,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black),
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(15)),
                ),
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    children: [
                      pw.Column(children: [
                        pw.SizedBox(height: 20),
                        pw.Container(
                            width: 200,
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.blue),
                              borderRadius: const pw.BorderRadius.all(
                                  pw.Radius.circular(15)),
                            ),
                            child: pw.Stack(
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.fromLTRB(
                                      25, 15, 15, 15),
                                  child: pw.BarcodeWidget(
                                      barcode: pw.Barcode.qrCode(),
                                      data:
                                          "$assetDetails, \n5. Specifications: [$specificationsDetails], \n6. Departments: [${fetchDepartment(widget.stock.departments!)}]",
                                      width: 175,
                                      height: 175),
                                ),
                                pw.Positioned(
                                  top: 80,
                                  left: 70,
                                  child: pw.Image(logo,
                                      width:
                                          65), // Position the logo at the top-left corner
                                ),
                              ],
                            )),
                        pw.SizedBox(height: 20)
                      ]),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(10),
                          child: pw.Column(children: [
                            pw.Text('${widget.stock.companyName}',
                                style: pw.TextStyle(
                                    color: PdfColors.black,
                                    fontSize: 20,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 10),
                            pw.Text('${widget.stock.displayId}',
                                style: pw.TextStyle(
                                    color: PdfColors.black,
                                    fontSize: 15,
                                    fontWeight: pw.FontWeight.bold)),
                          ]))
                    ])),
          ]));
        }));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  Future<void> downloadPng() async {
    String assetDetails =
        "1. Asset: ${widget.stock.assetName.toString()}, \n2. Serial No: ${widget.stock.serialNo.toString()}, \n3. Asset Id: ${widget.stock.displayId.toString()}, \n4. Warranty Expiry: ${widget.stock.warrantyExpiry.toString()}";

    List<String> specificationsDetailsList = widget.stock.specifications
            ?.map((spec) => "${spec.key}: ${spec.value}")
            .toList() ??
        [];
    String specificationsDetails = specificationsDetailsList.join(", ");

    final image = img.Image(width: 150, height: 150);
    img.fill(image, color: img.ColorRgb8(255, 255, 255));
    drawBarcode(image, pw.Barcode.qrCode(),
        "$assetDetails, \n5. Specifications: [$specificationsDetails], \n6. Departments: [${fetchDepartment(widget.stock.departments!)}]");
    final data = img.encodePng(image);

    final path = await getSaveLocation();
    if (path != null) {
      final file = XFile.fromData(
        Uint8List.fromList(data),
        name: 'qrCode.png',
        mimeType: 'image/png',
      );
      await file.saveTo(path.path);
    }
  }

  Future<void> downloadPdf() async {
    String assetDetails =
        "1. Asset: ${widget.stock.assetName.toString()}, \n2. Serial No: ${widget.stock.serialNo.toString()}, \n3. Asset Id: ${widget.stock.displayId.toString()}, \n4. Warranty Expiry: ${widget.stock.warrantyExpiry.toString()}";

    List<String> specificationsDetailsList = widget.stock.specifications
            ?.map((spec) => "${spec.key}: ${spec.value}")
            .toList() ??
        [];
    String specificationsDetails = specificationsDetailsList.join(", ");

    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/riota_logo5.png'))
          .buffer
          .asUint8List(),
    );

    final doc = pw.Document();
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Wrap(children: [
            pw.Container(
                width: 750,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black),
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(15)),
                ),
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    children: [
                      pw.Column(children: [
                        pw.SizedBox(height: 20),
                        pw.Container(
                            width: 200,
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.blue),
                              borderRadius: const pw.BorderRadius.all(
                                  pw.Radius.circular(15)),
                            ),
                            child: pw.Stack(
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.fromLTRB(
                                      25, 15, 15, 15),
                                  child: pw.BarcodeWidget(
                                      barcode: pw.Barcode.qrCode(),
                                      data:
                                          "$assetDetails, \n5. Specifications: [$specificationsDetails], \n6. Departments: [${fetchDepartment(widget.stock.departments!)}]",
                                      width: 175,
                                      height: 175),
                                ),
                                pw.Positioned(
                                  top: 80,
                                  left: 70,
                                  child: pw.Image(logo,
                                      width:
                                          65), // Position the logo at the top-left corner
                                ),
                              ],
                            )),
                        pw.SizedBox(height: 20)
                      ]),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(10),
                          child: pw.Column(children: [
                            pw.Text('${widget.stock.companyName}',
                                style: pw.TextStyle(
                                    color: PdfColors.black,
                                    fontSize: 20,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 10),
                            pw.Text('${widget.stock.displayId}',
                                style: pw.TextStyle(
                                    color: PdfColors.black,
                                    fontSize: 15,
                                    fontWeight: pw.FontWeight.bold)),
                          ]))
                    ])),
          ]));
        }));

    final result = await getSaveLocation();
    if (result != null) {
      final XFile textFile = XFile.fromData(
        await doc.save(),
        mimeType: 'application/pdf',
        name: 'Asset QR Code',
      );
      await textFile.saveTo(result.path);
    }
  }

  String fetchDepartment(List<String> departments) {
    if (departments.isEmpty) {
      return "";
    } else if (departments.length == 1) {
      return departments[0];
    } else {
      return departments.join(', ');
    }
  }

  bool checkStockDetailsEditedOrNot() {
    Function eq = const ListEquality().equals;

    String warrantyPeriod =
        "${warrantyDaysController.text.toString()} Days, ${warrantyMonthsController.text.toString()} Months, ${warrantyYearsController.text.toString()} Years";

    if (widget.stock.serialNo == serialController.text &&
        widget.stock.remarks == remarksController.text &&
        widget.stock.issuedDateTime == dateTimeController.text &&
        widget.stock.warrantyExpiry == expiryDateController.text &&
        widget.stock.purchaseDate == purchaseDateController.text &&
        widget.stock.warrantyPeriod == warrantyPeriod &&
        eq(widget.stock.tag, tagList)) {
      return false;
    } else {
      return true;
    }
  }

  _onTapEditButton() async {
    AssetProvider stockProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider boolProvider =
        Provider.of<BoolProvider>(context, listen: false);

    final result = checkStockDetailsEditedOrNot();
    if (result || imagePicked != null) {
      AssetStock stock;
      if (userRefId.isNotEmpty) {
        stock = AssetStock(
            userRefId: userRefId,
            assetRefId: assetRefId,
            locationRefId: locationRefId,
            vendorRefId: vendorRefId,
            serialNo: serialController.text.toString(),
            remarks: remarksController.text.toString(),
            issuedDateTime: dateTimeController.text.toString(),
            warrantyExpiry: expiryDateController.text.toString(),
            purchaseDate: purchaseDateController.text.toString(),
            warrantyPeriod:
                "${warrantyDaysController.text.toString()} Days, ${warrantyMonthsController.text.toString()} Months, ${warrantyYearsController.text.toString()} Years",
            image: imagePicked?.name,
            tag: tagList,
            sId: widget.stock.sId);
      } else {
        stock = AssetStock(
            assetRefId: assetRefId,
            locationRefId: locationRefId,
            vendorRefId: vendorRefId,
            serialNo: serialController.text.toString(),
            remarks: remarksController.text.toString(),
            issuedDateTime: dateTimeController.text.toString(),
            warrantyExpiry: expiryDateController.text.toString(),
            purchaseDate: purchaseDateController.text.toString(),
            warrantyPeriod:
                "${warrantyDaysController.text.toString()} Days, ${warrantyMonthsController.text.toString()} Months, ${warrantyYearsController.text.toString()} Years",
            image: imagePicked?.name,
            tag: tagList,
            sId: widget.stock.sId);
      }

      await updateStock(stock, boolProvider, stockProvider);
    } else {
      /// User not changed anything...
    }
  }

  Future<void> updateStock(AssetStock stock, BoolProvider boolProviders,
      AssetProvider stockProvider) async {
    await AddUpdateDetailsManagerWithImage(
      data: stock,
      image: imagePicked,
      apiURL: 'stock/updateStock',
    ).addUpdateDetailsWithImages(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("Stock Updated Successfully");
        stockProvider.fetchStockDetails();
      });
    } else {
      setState(() {
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
        isToastMessage == true;

        log(await response.stream.bytesToString());
      } else {
        isToastMessage = false;

        log(response.reasonPhrase.toString());
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  Future<void> updateWarranty(Warranty warranty) async {
    var headers = await getHeadersForFormData();
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('$websiteURL/stock/updateWarranty'));

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
        setState(() {
          isToastMessage == true;
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
