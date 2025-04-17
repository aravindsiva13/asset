import 'dart:convert';
import 'dart:developer';
import 'package:asset_management_local/main_pages/directory/vendor/vendor_list_expanded_view.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../global/global_variables.dart';
import '../../../global/user_interaction_timer.dart';
import '../../../helpers/global_helper.dart';
import '../../../helpers/http_helper.dart';
import '../../../helpers/ui_components.dart';
import '../../../models/directory_model/vendor_model/vendor.dart';
import '../../../models/directory_model/vendor_model/vendor_details.dart';
import 'package:asset_management_local/provider/main_providers/asset_provider.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';
import 'add_vendor.dart';

class VendorList extends StatefulWidget {
  const VendorList({super.key});

  @override
  State<VendorList> createState() => _VendorListState();
}

class _VendorListState extends State<VendorList> with TickerProviderStateMixin {
  String? dropDownValueVendor = "All";

  int selectedIndex = 0;
  int listPerPage = 5;
  int currentPage = 0;

  late AnimationController controller;
  late TableBorder startBorder;
  late TableBorder endBorder;
  late TableBorder currentBorder;

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

  bool selectAllCheckBox = false;

  late String image;
  late String vendorId;

  List<VendorDetails> filteredList = [];

  List<VendorDetails> getPaginatedData() {
    AssetProvider vendorProvider =
        Provider.of<AssetProvider>(context, listen: false);

    filteredList = (dropDownValueVendor == "All")
        ? vendorProvider.vendorDetailsList
        : vendorProvider.vendorDetailsList
            .where((vendor) => vendor.name == dropDownValueVendor)
            .toList();

    final startIndex = currentPage * listPerPage;
    final endIndex = (startIndex + listPerPage).clamp(0, filteredList.length);
    return filteredList.sublist(startIndex, endIndex);
  }

  String getDisplayedRange() {
    AssetProvider vendorProvider =
        Provider.of<AssetProvider>(context, listen: false);

    filteredList = (dropDownValueVendor == "All")
        ? vendorProvider.vendorDetailsList
        : vendorProvider.vendorDetailsList
            .where((vendor) => vendor.name == dropDownValueVendor)
            .toList();

    final displayedListLength = filteredList.length;
    final startIndex = currentPage * listPerPage + 1;
    final endIndex =
        (startIndex + listPerPage - 1).clamp(0, displayedListLength);

    return '$startIndex-$endIndex of $displayedListLength';
  }

  @override
  void initState() {
    super.initState();
    Provider.of<AssetProvider>(context, listen: false).fetchVendorDetails();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BoolProvider boolProviders = Provider.of<BoolProvider>(context);

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

    return Consumer2<BoolProvider, AssetProvider>(
        builder: (context, boolProvider, vendorProvider, child) {
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
                                    "Vendor Lists",
                                    style: GoogleFonts.ubuntu(
                                        textStyle: TextStyle(
                                      fontSize: 20,
                                      color: boolProvider.isDarkTheme
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )),
                                  ),
                                  if (vendorProvider.userRole.vendorWriteFlag) ...[
                                    const DialogRoot(dialog: AddVendor())
                                  ]
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 15, 40, 0),
                              child: Row(
                                children: [
                                  Text(
                                    "Vendor",
                                    style: GoogleFonts.ubuntu(
                                        textStyle: TextStyle(
                                      fontSize: 17,
                                      color: boolProvider.isDarkTheme
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )),
                                  ),
                                  getVendorDropDownContentUI(),
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
                                    text: " Vendor",
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
                                      onPressed:
                                          (currentPage + 1) * listPerPage <
                                                  filteredList.length
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
                                child:
                                    Lottie.asset("assets/lottie/loader.json"))
                            : vendorProvider.vendorDetailsList.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Table(
                                      border: currentBorder,
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      children: [
                                        TableRow(children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Visibility(
                                                visible: boolProvider.isVisible,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 15),
                                                  child: Checkbox(
                                                      side:
                                                          MaterialStateBorderSide
                                                              .resolveWith(
                                                        (states) =>
                                                            const BorderSide(
                                                                width: 1.0,
                                                                color: Colors
                                                                    .blue),
                                                      ),
                                                      value: selectAllCheckBox,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          selectAllCheckBox =
                                                              value ?? false;
                                                          vendorProvider
                                                                  .selectedVendors =
                                                              List.generate(
                                                                  vendorProvider
                                                                      .selectedVendors
                                                                      .length,
                                                                  (index) =>
                                                                      selectAllCheckBox);
                                                        });
                                                        if (selectAllCheckBox) {
                                                          boolProviders
                                                              .setDeleteVisibility(
                                                                  true);
                                                        } else {
                                                          boolProviders
                                                              .setDeleteVisibility(
                                                                  false);
                                                        }
                                                      }),
                                                ),
                                              ),
                                              if (vendorProvider.userRole.vendorWriteFlag) ...[
                                                Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        boolProviders
                                                            .setVisibility(
                                                                !boolProvider
                                                                    .isVisible);
                                                      },
                                                      child: Text(
                                                        "Select",
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                                textStyle:
                                                                    const TextStyle(
                                                          fontSize: 15,
                                                          color: Color.fromRGBO(
                                                              117, 117, 117, 1),
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                          getTitleText(
                                            text: "ID",
                                          ),
                                          getTitleText(
                                            text: "Name",
                                          ),
                                          getTitleText(
                                            text: "Address",
                                          ),
                                          getTitleText(
                                            text: "Contact",
                                          ),
                                          getTitleText(
                                            text: "GST Number",
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
                                          VendorDetails vendor = entry.value;
                                          return TableRow(
                                              decoration: BoxDecoration(
                                                  color:
                                                      boolProvider.isDarkTheme
                                                          ? Colors.black
                                                          : Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20))),
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Visibility(
                                                      visible: boolProvider
                                                          .isVisible,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 15),
                                                        child: Checkbox(
                                                            side:
                                                                MaterialStateBorderSide
                                                                    .resolveWith(
                                                              (states) =>
                                                                  const BorderSide(
                                                                      width:
                                                                          1.0,
                                                                      color: Colors
                                                                          .blue),
                                                            ),
                                                            value: vendorProvider
                                                                    .selectedVendors
                                                                    .isNotEmpty
                                                                ? vendorProvider
                                                                        .selectedVendors[
                                                                    index]
                                                                : false,
                                                            onChanged:
                                                                (bool? value) {
                                                              setState(() {
                                                                vendorProvider
                                                                            .selectedVendors[
                                                                        index] =
                                                                    value ??
                                                                        false;
                                                                selectAllCheckBox =
                                                                    vendorProvider
                                                                        .selectedVendors
                                                                        .every((item) =>
                                                                            item);
                                                              });
                                                              bool showDelete =
                                                                  vendorProvider
                                                                      .selectedVendors
                                                                      .any((item) =>
                                                                          item);
                                                              boolProviders
                                                                  .setDeleteVisibility(
                                                                      showDelete);
                                                            }),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return VendorListExpandedView(
                                                                vendor: vendor);
                                                          },
                                                        );
                                                      },
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 20),
                                                          child: CircleAvatar(
                                                            radius: 25,
                                                            backgroundColor: themeProvider
                                                                    .isDarkTheme
                                                                ? const Color
                                                                    .fromRGBO(
                                                                    16,
                                                                    18,
                                                                    33,
                                                                    1)
                                                                : const Color(
                                                                    0xfff3f1ef),
                                                            child: SizedBox(
                                                              width: 100,
                                                              height: 100,
                                                              child: ClipOval(
                                                                child: Image
                                                                    .network(
                                                                  '$websiteURL/images/${vendor.image}',
                                                                  loadingBuilder: (BuildContext
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
                                                                  errorBuilder: (BuildContext
                                                                          context,
                                                                      Object
                                                                          error,
                                                                      StackTrace?
                                                                          stackTrace) {
                                                                    return Image
                                                                        .asset(
                                                                            'assets/images/riota_logo.png');
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                getContentText(
                                                    text: vendor.displayId
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
                                                        vendor.name.toString(),
                                                    maxLines: 1,
                                                    color: themeProvider
                                                            .isDarkTheme
                                                        ? const Color.fromRGBO(
                                                            200, 200, 200, 1)
                                                        : const Color.fromRGBO(
                                                            117, 117, 117, 1)),
                                                Column(
                                                  children: [
                                                    getContentText(
                                                        text:
                                                            "${vendor.address?.address!}",
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
                                                            "${vendor.address?.city!}",
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
                                                            "${vendor.address?.state!}",
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
                                                Column(
                                                  children: [
                                                    getContentText(
                                                        text: vendor.vendorName
                                                            .toString(),
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
                                                        text: vendor.phoneNumber
                                                            .toString(),
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
                                                        text: vendor.email
                                                            .toString(),
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
                                                getContentText(
                                                    text:
                                                        vendor.gstIn.toString(),
                                                    maxLines: 2,
                                                    color: themeProvider
                                                            .isDarkTheme
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
                                                      dialog:
                                                          VendorListExpandedView(
                                                              vendor: vendor),
                                                    ),
                                                    if (vendorProvider.userRole
                                                        .vendorWriteFlag) ...[
                                                      CustomActionIcon(
                                                        message: "Edit",
                                                        preferBelow: true,
                                                        iconImage: const Icon(
                                                            Icons.edit_rounded),
                                                        color: const Color
                                                            .fromRGBO(
                                                            15, 117, 188, 1),
                                                        onPressed: () {
                                                          int actualIndex =
                                                              (currentPage *
                                                                      listPerPage) +
                                                                  index;

                                                          VendorDetails vendor =
                                                              filteredList[
                                                                  actualIndex];

                                                          vendorId =
                                                              vendor.sId ?? "";
                                                          image =
                                                              vendor.image ??
                                                                  '';
                                                          nameController.text =
                                                              vendor.name!;
                                                          addressController
                                                                  .text =
                                                              vendor.address!
                                                                  .address!
                                                                  .toString();
                                                          cityController.text =
                                                              vendor.address!
                                                                  .city!
                                                                  .toString();
                                                          stateController.text =
                                                              vendor.address!
                                                                  .state!
                                                                  .toString();
                                                          countryController
                                                                  .text =
                                                              vendor.address!
                                                                  .country!
                                                                  .toString();
                                                          landmarkController
                                                                  .text =
                                                              vendor.address!
                                                                  .landMark!
                                                                  .toString();
                                                          codeController.text =
                                                              vendor.address!
                                                                  .pinCode!
                                                                  .toString();
                                                          contactPersonNameController
                                                                  .text =
                                                              vendor.vendorName!
                                                                  .toString();
                                                          contactPersonEmailController
                                                                  .text =
                                                              vendor.email!
                                                                  .toString();
                                                          contactPersonPhoneNumberController
                                                                  .text =
                                                              vendor
                                                                  .phoneNumber!
                                                                  .toString();
                                                          gstController.text =
                                                              vendor.gstIn!;
                                                          tagList = List.from(
                                                              vendor.tag!);
                                                          showLargeScreenUpdateVendor(
                                                              context,
                                                              actualIndex);
                                                        },
                                                      ),
                                                      CustomActionIcon(
                                                        message: "Delete",
                                                        preferBelow: false,
                                                        iconImage: const Icon(
                                                            Icons
                                                                .delete_rounded),
                                                        color: Colors.red,
                                                        onPressed: () {
                                                          showAlertDialog(
                                                              context,
                                                              vendorId: vendor
                                                                  .displayId
                                                                  .toString(),
                                                              color: boolProvider
                                                                      .isDarkTheme
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
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
                                                                vendorIdDelete =
                                                                vendor.sId
                                                                    .toString();

                                                            if (mounted) {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            }

                                                            await deleteVendor(
                                                                vendorIdDelete,
                                                                themeProvider,
                                                                vendorProvider);
                                                          });
                                                        },
                                                      )
                                                    ]
                                                  ],
                                                ),
                                              ]);
                                        }).toList(),
                                      ],
                                    ))
                                : Center(
                                    child: Lottie.asset(
                                        "assets/lottie/data_not_found.json",
                                        repeat: false,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.4),
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
            Center(
              child: Consumer<BoolProvider>(
                builder: (context, dialogVisibilityProvider, child) {
                  if (dialogVisibilityProvider.isDialogVisible) {
                    Future.delayed(Duration.zero, () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          List<VendorDetails> selectedVendorsList =
                              getSelectedUsers();

                          List<TableRow> tableRows = [];

                          tableRows.add(getTableDeleteForMultipleId(
                              title: "S.NO", content: "ID"));

                          for (int index = 0;
                              index < selectedVendorsList.length;
                              index++) {
                            VendorDetails vendor = selectedVendorsList[index];
                            tableRows.add(
                              getTableDeleteForMultipleId(
                                  title: (index + 1).toString(),
                                  content: vendor.displayId.toString()),
                            );
                          }

                          return AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "Delete the Selected Vendor",
                                style: GlobalHelper.textStyle(const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                )),
                              ),
                            ),
                            content: Table(
                              border: TableBorder.all(
                                borderRadius: BorderRadius.circular(10),
                                color: boolProvider.isDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              children: tableRows,
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                  "Cancel",
                                  style: GlobalHelper.textStyle(const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                  )),
                                ),
                                onPressed: () {
                                  boolProvider.setDialogVisibility(false);
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                  child: Text(
                                    "Yes",
                                    style:
                                        GlobalHelper.textStyle(const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    )),
                                  ),
                                  onPressed: () async {
                                    getDelete();
                                    boolProvider.setDialogVisibility(false);
                                    boolProviders.setVisibility(false);
                                    boolProviders.setDeleteVisibility(false);
                                    Navigator.of(context).pop();
                                  }),
                            ],
                          );
                        },
                      );
                    });
                  }
                  return Container();
                },
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
      required vendorId}) {
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
          "Delete Vendor",
          style: GlobalHelper.textStyle(TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          )),
        ),
      ),
      content: getTableDeleteForSingleId(id: vendorId, color: color),
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

  void getDelete() async {
    AssetProvider vendorProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider boolProvider =
        Provider.of<BoolProvider>(context, listen: false);

    List<String> idsToDelete = [];
    for (int i = 0; i < vendorProvider.selectedVendors.length; i++) {
      if (vendorProvider.selectedVendors[i]) {
        idsToDelete.add(vendorProvider.vendorDetailsList[i].sId.toString());
      }
    }

    for (String vendorId in idsToDelete) {
      await deleteVendor(vendorId, boolProvider, vendorProvider);
    }

    setState(() {
      vendorProvider.vendorDetailsList
          .removeWhere((vendor) => idsToDelete.contains(vendor.sId.toString()));
      selectAllCheckBox = false;
    });
  }

  List<VendorDetails> getSelectedUsers() {
    AssetProvider vendorProvider =
        Provider.of<AssetProvider>(context, listen: false);

    List<VendorDetails> selectedVendorsList = [];
    for (int i = 0; i < vendorProvider.vendorDetailsList.length; i++) {
      if (vendorProvider.selectedVendors[i]) {
        selectedVendorsList.add(vendorProvider.vendorDetailsList[i]);
      }
    }
    return selectedVendorsList;
  }

  Future<void> showLargeScreenUpdateVendor(
      BuildContext context, int index) async {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    currentVendorStep = 0;
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
                              child: ClipOval(
                                child: Builder(
                                  builder: (BuildContext context) {
                                    if (imagePicked != null) {
                                      return Image.memory(imagePicked!.bytes!,
                                          fit: BoxFit.cover);
                                    } else {
                                      return Image.network(
                                        '$websiteURL/images/$image',
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
                                            Object error,
                                            StackTrace? stackTrace) {
                                          return Image.asset(
                                            themeProvider.isDarkTheme
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
                                                      _onTapEditButton(index);
                                                      Navigator.of(context)
                                                          .pop();
                                                      if (isToastMessage ==
                                                          true) {
                                                        setState(() {
                                                          showToast(
                                                              "Vendor Updated Successfully");
                                                        });
                                                      } else if (isToastMessage ==
                                                          false) {
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

  Widget getImageWidget(int index) {
    AssetProvider vendorProvider =
        Provider.of<AssetProvider>(context, listen: false);

    if (imagePicked != null) {
      return Image.memory(imagePicked!.bytes!, fit: BoxFit.cover);
    } else {
      return Image.network(
        '$websiteURL/images/${vendorProvider.vendorDetailsList[index].image}',
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
  bool checkVendorDetailsEditedOrNot(int index) {
    AssetProvider vendorProvider =
        Provider.of<AssetProvider>(context, listen: false);

    Function eq = const ListEquality().equals;
    if (vendorProvider.vendorDetailsList[index].vendorName ==
            contactPersonNameController.text &&
        vendorProvider.vendorDetailsList[index].address!.address ==
            addressController.text &&
        vendorProvider.vendorDetailsList[index].address!.city ==
            cityController.text &&
        vendorProvider.vendorDetailsList[index].address!.state ==
            stateController.text &&
        vendorProvider.vendorDetailsList[index].address!.landMark ==
            landmarkController.text &&
        vendorProvider.vendorDetailsList[index].address!.country ==
            countryController.text &&
        vendorProvider.vendorDetailsList[index].address!.pinCode.toString() ==
            codeController.text &&
        vendorProvider.vendorDetailsList[index].gstIn == gstController.text &&
        vendorProvider.vendorDetailsList[index].name == nameController.text &&
        vendorProvider.vendorDetailsList[index].email ==
            contactPersonEmailController.text &&
        vendorProvider.vendorDetailsList[index].phoneNumber.toString() ==
            contactPersonPhoneNumberController.text &&
        eq(vendorProvider.vendorDetailsList[index].tag, tagList)) {
      return false;
    } else {
      return true;
    }
  }

  _onTapEditButton(int index) async {
    AssetProvider vendorProvider =
        Provider.of<AssetProvider>(context, listen: false);

    final result = checkVendorDetailsEditedOrNot(index);
    if (result || filePicked != null || imagePicked != null) {
      /// User Updated the Vendor Details and use to change in the DB
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
          sId: vendorId);
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

  Widget getVendorDropDownContentUI() {
    AssetProvider vendorProvider =
        Provider.of<AssetProvider>(context, listen: false);

    List<String> dropdownItems = ["All"];
    dropdownItems.addAll(vendorProvider.vendorDetailsList
        .map((company) => company.name!)
        .toSet());
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        elevation: 1,
        iconDisabledColor: Colors.blue,
        iconEnabledColor: Colors.blue,
        dropdownColor: const Color(0xfff3f1ef),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        value: dropDownValueVendor,
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
            dropDownValueVendor = value!;
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

  Future<void> deleteVendor(String vendorId, BoolProvider boolProviders,
      AssetProvider vendorProvider) async {
    await DeleteDetailsManager(
      apiURL: 'vendor/deleteVendor',
      id: vendorId,
    ).deleteDetails(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("Vendor Deleted Successfully");
        vendorProvider.fetchVendorDetails();
      });
    } else {
      setState(() {
        showToast("Unable to delete the vendor");
      });
    }
  }
}
