import 'dart:async';
import 'dart:developer';
import 'package:asset_management_local/main_pages/asset/asset_stock/add_stock.dart';
import 'package:asset_management_local/main_pages/asset/asset_stock/stock_list_expanded_view.dart';
import 'package:asset_management_local/models/asset_model/asset_stock_model/asset_stock.dart';
import 'package:asset_management_local/models/asset_model/asset_stock_model/asset_stock_details.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../global/global_variables.dart';
import '../../../helpers/global_helper.dart';
import '../../../helpers/http_helper.dart';
import '../../../helpers/ui_components.dart';
import '../../../models/asset_model/asset_model_model/asset_model_details.dart';
import '../../../models/asset_model/asset_stock_model/add_warranty.dart';
import 'package:asset_management_local/provider/main_providers/asset_provider.dart';

class StockList extends StatefulWidget {
  const StockList({super.key});

  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> with TickerProviderStateMixin {
  String? dropDownValueType = "My Assets";

  int selectedIndex = 0;
  int listPerPage = 5;
  int currentPage = 0;

  PlatformFile? filePicked;

  List<String> warrantyAttachments = [];

  late AnimationController controller;
  late TableBorder startBorder;
  late TableBorder endBorder;
  late TableBorder currentBorder;

  String selectedImageName = 'Image';

  PlatformFile? imagePicked;

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
  List<TextEditingController>? checkListRemarksController;

  List<String> tag = [];
  List<String> tagList = [];

  late DateTime selectedDate;
  late DateTime selectDate;
  late DateTime selectedPurchaseDate;
  late TimeOfDay selectedTime;

  late String stockId;
  late String assetRefId;
  late String locationRefId;
  late String vendorRefId;
  late String userRefId;
  late String stockRefId;
  late String warrantyExpiry;

  late String image;

  List<WarrantyDetails>? warranty = [];

  int currentStockStep = 0;
  StepperType stepperType = StepperType.horizontal;

  List<GlobalKey<FormState>> formKeyStepStock = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  List<AssetStockDetails> getPaginatedData() {
    AssetProvider stockProvider =
        Provider.of<AssetProvider>(context, listen: false);

    AssetProvider userProvider =
        Provider.of<AssetProvider>(context, listen: false);

    var userId = userProvider.user!.sId.toString();
    filteredStockList = (dropDownValueType == "All")
        ? stockProvider.stockDetailsList
        : stockProvider.stockDetailsList.where((stock) {
            if (dropDownValueType == "My Assets") {
              return stock.userRefId == userId;
            } else {
              return stock.assetName == dropDownValueType;
            }
          }).toList();

    final startIndex = currentPage * listPerPage;
    final endIndex =
        (startIndex + listPerPage).clamp(0, filteredStockList.length);

    return filteredStockList.sublist(startIndex, endIndex);
  }

  String getDisplayedRange() {
    AssetProvider stockProvider =
        Provider.of<AssetProvider>(context, listen: false);

    AssetProvider userProvider =
        Provider.of<AssetProvider>(context, listen: false);

    var userId = userProvider.user!.sId.toString();

    filteredStockList = (dropDownValueType == "All")
        ? stockProvider.stockDetailsList
        : stockProvider.stockDetailsList.where((stock) {
            if (dropDownValueType == "My Assets") {
              return stock.userRefId == userId;
            } else {
              return stock.assetName == dropDownValueType;
            }
          }).toList();

    final displayedListLength = filteredStockList.length;
    final startIndex = currentPage * listPerPage + 1;
    final endIndex =
        (startIndex + listPerPage - 1).clamp(0, displayedListLength);

    return '$startIndex-$endIndex of $displayedListLength';
  }

  @override
  void initState() {
    super.initState();
    Provider.of<AssetProvider>(context, listen: false).fetchStockDetails();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BoolProvider, AssetProvider>(
        builder: (context, boolProvider, stockProvider, child) {
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
                                stockProvider.userRole.assetStockWriteFlag
                                    ? "Stock List"
                                    : "Asset List",
                                style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                  fontSize: 20,
                                  color: boolProvider.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                              ),
                              if (stockProvider
                                  .userRole.assetStockWriteFlag) ...[
                                const DialogRoot(dialog: AddStock())
                              ]
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 40, 0),
                          child: Row(
                            children: [
                              Text(
                                "Asset",
                                style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                  fontSize: 17,
                                  color: boolProvider.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                              ),
                              getAssetDropDownContentUI(),
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
                                text: stockProvider.userRole.assetStockWriteFlag
                                    ? " Stock"
                                    : " Asset",
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
                                          filteredStockList.length
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
                        : filteredStockList.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Table(
                                  border: currentBorder,
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  children: [
                                    TableRow(children: [
                                      getTitleText(
                                        text: "      ",
                                      ),
                                      getTitleText(
                                        text: "ID",
                                      ),
                                      getTitleText(
                                        text: "Assets",
                                      ),
                                      getTitleText(
                                        text: "Serial No",
                                      ),
                                      getTitleText(
                                        text: "Assigned To",
                                      ),
                                      getTitleText(
                                        text: "Issued Date & Time",
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
                                      AssetStockDetails stock = entry.value;

                                      return TableRow(
                                          decoration: BoxDecoration(
                                              color: boolProvider.isDarkTheme
                                                  ? Colors.black
                                                  : Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20))),
                                          children: [
                                            Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 20),
                                                child: CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor: themeProvider
                                                          .isDarkTheme
                                                      ? const Color.fromRGBO(
                                                          16, 18, 33, 1)
                                                      : const Color(0xfff3f1ef),
                                                  child: SizedBox(
                                                    width: 100,
                                                    height: 100,
                                                    child: ClipOval(
                                                      child: Image.network(
                                                        '$websiteURL/images/${stock.image}',
                                                        loadingBuilder:
                                                            (BuildContext
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
                                                            (BuildContext
                                                                    context,
                                                                Object error,
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
                                            getContentText(
                                                text:
                                                    stock.displayId.toString(),
                                                maxLines: 1,
                                                color: themeProvider.isDarkTheme
                                                    ? const Color.fromRGBO(
                                                        200, 200, 200, 1)
                                                    : const Color.fromRGBO(
                                                        117, 117, 117, 1)),
                                            getContentText(
                                                text:
                                                    stock.assetName.toString(),
                                                maxLines: 1,
                                                color: themeProvider.isDarkTheme
                                                    ? const Color.fromRGBO(
                                                        200, 200, 200, 1)
                                                    : const Color.fromRGBO(
                                                        117, 117, 117, 1)),
                                            getContentText(
                                                text: stock.serialNo.toString(),
                                                maxLines: 1,
                                                color: themeProvider.isDarkTheme
                                                    ? const Color.fromRGBO(
                                                        200, 200, 200, 1)
                                                    : const Color.fromRGBO(
                                                        117, 117, 117, 1)),
                                            stock.assignedTo == null
                                                ? getContentText(
                                                    text: "-",
                                                    maxLines: 1,
                                                    color: themeProvider
                                                            .isDarkTheme
                                                        ? const Color.fromRGBO(
                                                            200, 200, 200, 1)
                                                        : const Color.fromRGBO(
                                                            117, 117, 117, 1))
                                                : getContentText(
                                                    text: stock.assignedTo
                                                        .toString(),
                                                    maxLines: 1,
                                                    color: themeProvider
                                                            .isDarkTheme
                                                        ? const Color.fromRGBO(
                                                            200, 200, 200, 1)
                                                        : const Color.fromRGBO(
                                                            117, 117, 117, 1)),
                                            getContentText(
                                                text: stock.issuedDateTime
                                                    .toString(),
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
                                                  dialog: StockListExpandedView(
                                                      stock: stock),
                                                ),
                                                if (stockProvider.userRole
                                                    .assetStockWriteFlag) ...[
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

                                                      AssetStockDetails
                                                          assetStock =
                                                          filteredStockList[
                                                              actualIndex];

                                                      List<String>
                                                          warrantyPeriodParts =
                                                          assetStock
                                                              .warrantyPeriod!
                                                              .split(', ');

                                                      int days = 0;
                                                      int months = 0;
                                                      int years = 0;

                                                      for (String part
                                                          in warrantyPeriodParts) {
                                                        if (part
                                                            .contains('Days')) {
                                                          days = int.tryParse(
                                                                  part.split(
                                                                          ' ')[
                                                                      0]) ??
                                                              0;
                                                        } else if (part
                                                            .contains(
                                                                'Months')) {
                                                          months = int.tryParse(
                                                                  part.split(
                                                                          ' ')[
                                                                      0]) ??
                                                              0;
                                                        } else if (part
                                                            .contains(
                                                                'Years')) {
                                                          years = int.tryParse(
                                                                  part.split(
                                                                          ' ')[
                                                                      0]) ??
                                                              0;
                                                        }
                                                      }

                                                      warranty = List.from(
                                                          assetStock
                                                              .warrantyDetails!);

                                                      stockId =
                                                          assetStock.sId ?? "";
                                                      image =
                                                          assetStock.image ??
                                                              '';
                                                      dateTimeController
                                                          .text = assetStock
                                                              .issuedDateTime ??
                                                          "";
                                                      expiryDateController
                                                          .text = assetStock
                                                              .warrantyExpiry ??
                                                          "";
                                                      serialController.text =
                                                          assetStock.serialNo ??
                                                              "";
                                                      remarksController.text =
                                                          assetStock.remarks ??
                                                              "";
                                                      assetRefId = assetStock
                                                              .assetRefId ??
                                                          "";
                                                      locationRefId = assetStock
                                                              .locationRefId ??
                                                          "";
                                                      vendorRefId = assetStock
                                                              .vendorRefId ??
                                                          "";
                                                      userRefId = assetStock
                                                              .userRefId ??
                                                          "";
                                                      purchaseDateController
                                                          .text = assetStock
                                                              .purchaseDate ??
                                                          "";
                                                      warrantyDaysController
                                                              .text =
                                                          days.toString();
                                                      warrantyMonthsController
                                                              .text =
                                                          months.toString();
                                                      warrantyYearsController
                                                              .text =
                                                          years.toString();
                                                      tagList = List.from(
                                                          assetStock.tag!);

                                                      showLargeUpdateStock(
                                                          context, actualIndex);
                                                    },
                                                  )
                                                ],
                                                stockProvider.userRole
                                                        .assetStockWriteFlag
                                                    ? (stock.assignedTo != null
                                                        ? const Text("")
                                                        : CustomActionIcon(
                                                            message: "Delete",
                                                            preferBelow: false,
                                                            iconImage:
                                                                const Icon(Icons
                                                                    .delete_rounded),
                                                            color: Colors.red,
                                                            onPressed: () {
                                                              showAlertDialog(
                                                                  context,
                                                                  stockId: stock
                                                                      .displayId
                                                                      .toString(),
                                                                  color: boolProvider
                                                                          .isDarkTheme
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                  containerColor: boolProvider
                                                                          .isDarkTheme
                                                                      ? Colors
                                                                          .black
                                                                      : Colors
                                                                          .white,
                                                                  onPressed:
                                                                      () async {
                                                                String?
                                                                    stockIdDelete =
                                                                    stock.sId
                                                                        .toString();

                                                                if (mounted) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                }

                                                                await deleteStock(
                                                                    stockIdDelete,
                                                                    themeProvider,
                                                                    stockProvider);
                                                              });
                                                            }))
                                                    : const Text(""),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  showAlertDialog(BuildContext context,
      {required onPressed,
      required color,
      required containerColor,
      required stockId}) {
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
          "Delete Stock",
          style: GlobalHelper.textStyle(TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          )),
        ),
      ),
      content: getTableDeleteForSingleId(id: stockId, color: color),
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

  List<AssetStockDetails> getSelectedStock() {
    AssetProvider stockProvider =
        Provider.of<AssetProvider>(context, listen: false);

    List<AssetStockDetails> selectedStocksList = [];
    for (int i = 0; i < stockProvider.stockDetailsList.length; i++) {
      if (stockProvider.selectedStocks[i]) {
        selectedStocksList.add(stockProvider.stockDetailsList[i]);
      }
    }
    return selectedStocksList;
  }

  Future<void> showLargeUpdateStock(BuildContext context, int index) async {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    AssetProvider stockProvider =
        Provider.of<AssetProvider>(context, listen: false);

    currentStockStep = 0;
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
                                                          _onTapEditButton(
                                                              index);

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
                                                                        stockRefId,
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
                                                                        stockRefId,
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

  bool checkStockDetailsEditedOrNot(int index) {
    AssetProvider stockProvider =
        Provider.of<AssetProvider>(context, listen: false);

    Function eq = const ListEquality().equals;

    String warrantyPeriod =
        "${warrantyDaysController.text.toString()} Days, ${warrantyMonthsController.text.toString()} Months, ${warrantyYearsController.text.toString()} Years";

    if (stockProvider.stockDetailsList[index].serialNo ==
            serialController.text &&
        stockProvider.stockDetailsList[index].remarks ==
            remarksController.text &&
        stockProvider.stockDetailsList[index].issuedDateTime ==
            dateTimeController.text &&
        stockProvider.stockDetailsList[index].warrantyExpiry ==
            expiryDateController.text &&
        stockProvider.stockDetailsList[index].purchaseDate ==
            purchaseDateController.text &&
        stockProvider.stockDetailsList[index].warrantyPeriod ==
            warrantyPeriod &&
        eq(stockProvider.stockDetailsList[index].tag, tagList)) {
      return false;
    } else {
      return true;
    }
  }

  _onTapEditButton(int index) async {
    AssetProvider stockProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider boolProvider =
        Provider.of<BoolProvider>(context, listen: false);

    final result = checkStockDetailsEditedOrNot(index);

    stockRefId = stockId;

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
            sId: stockId);
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
            sId: stockId);
      }

      await updateStock(stock, boolProvider, stockProvider);
    } else {
      /// User not changed anything...
    }
  }

  Widget getAssetDropDownContentUI() {
    AssetProvider stockProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    AssetProvider userProvider =
        Provider.of<AssetProvider>(context, listen: false);

    var userId = userProvider.user!.sId.toString();

    List<String> dropdownItems = stockProvider.userRole.assetStockWriteFlag
        ? ["My Assets", "All"]
        : ['My Assets'];
    if (stockProvider.userRole.assetStockWriteFlag) {
      dropdownItems.addAll(stockProvider.stockDetailsList
          .where((stock) => stock.userRefId == userId)
          .map((stock) => stock.assetName!)
          .toSet());
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton(
        elevation: 1,
        iconDisabledColor: Colors.blue,
        iconEnabledColor: Colors.blue,
        dropdownColor: themeProvider.isDarkTheme
            ? const Color.fromRGBO(16, 18, 33, 1)
            : const Color(0xfff3f1ef),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        value: dropDownValueType,
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
                )),
              ),
            ),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            dropDownValueType = value!;
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

  Future<void> deleteStock(String stockId, BoolProvider boolProviders,
      AssetProvider stockProvider) async {
    await DeleteDetailsManager(
      apiURL: 'stock/deleteStock',
      id: stockId,
    ).deleteDetails(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("Stock Deleted Successfully");
        stockProvider.fetchStockDetails();
      });
    } else {
      setState(() {
        showToast("Unable to delete the stock");
      });
    }
  }
}
