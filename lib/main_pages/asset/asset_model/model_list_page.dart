import 'dart:convert';
import 'dart:developer';
import 'package:asset_management_local/models/asset_model/asset_model_model/asset_model.dart';
import 'package:asset_management_local/models/asset_model/asset_model_model/asset_model_details.dart';
import 'package:asset_management_local/provider/main_providers/asset_provider.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../global/global_variables.dart';
import '../../../global/user_interaction_timer.dart';
import '../../../helpers/global_helper.dart';
import '../../../helpers/http_helper.dart';
import '../../../helpers/ui_components.dart';
import '../../../models/asset_model/asset_template_model/asset_template_details.dart';
import '../../../models/asset_model/asset_type_model/asset_type_details.dart';
import 'add_model.dart';
import 'model_list_expanded_view.dart';

class ModelList extends StatefulWidget {
  const ModelList({super.key});

  @override
  State<ModelList> createState() => _ModelListState();
}

class _ModelListState extends State<ModelList> with TickerProviderStateMixin {
  String? dropDownValueType = "All";

  int selectedIndex = 0;
  int listPerPage = 5;
  int currentPage = 0;

  bool selectAllCheckBox = false;

  late AnimationController controller;
  late TableBorder startBorder;
  late TableBorder endBorder;
  late TableBorder currentBorder;

  String selectedImageName = 'Image';

  PlatformFile? imagePicked;

  List<GlobalKey<FormState>> formKeyStepModel = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  int currentStep = 0;
  StepperType stepperType = StepperType.horizontal;

  TextEditingController modelController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController assetController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController templateController = TextEditingController();
  TextEditingController manufactureController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController subCategoryController = TextEditingController();
  List<TextEditingController> specificationController = [];

  List<AssetTemplateDetails> completeTemplateList = [];
  AssetTemplateDetails? selectedTemplate;

  List<AssetTypeDetails> completeTypeList = [];
  AssetTypeDetails? selectedType;

  List<AssetCategoryDetails> completeCategoryList = [];
  AssetCategoryDetails? selectedCategory;

  List<AssetSubCategoryDetails> completeSubCategoryList = [];
  AssetSubCategoryDetails? selectedSubCategory;

  List<String> tag = [];
  List<String> tagList = [];

  List<Map<String, dynamic>> specList = [];

  List<String> specKeys = [];
  List<String> specValues = [];

  late String image;
  late String modelId;

  List<AssetModelDetails> filteredList = [];

  List<AssetModelDetails> getPaginatedData() {
    AssetProvider modelProvider =
        Provider.of<AssetProvider>(context, listen: false);

    filteredList = (dropDownValueType == "All")
        ? modelProvider.modelDetailsList
        : modelProvider.modelDetailsList
            .where((model) => model.typeName == dropDownValueType)
            .toList();

    final startIndex = currentPage * listPerPage;
    final endIndex = (startIndex + listPerPage).clamp(0, filteredList.length);

    return filteredList.sublist(startIndex, endIndex);
  }

  String getDisplayedRange() {
    AssetProvider modelProvider =
        Provider.of<AssetProvider>(context, listen: false);

    filteredList = (dropDownValueType == "All")
        ? modelProvider.modelDetailsList
        : modelProvider.modelDetailsList
            .where((model) => model.typeName == dropDownValueType)
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
    Provider.of<AssetProvider>(context, listen: false).fetchModelDetails();
    Provider.of<AssetProvider>(context, listen: false).fetchTemplateDetails();
    Provider.of<AssetProvider>(context, listen: false).fetchTypeDetails();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BoolProvider boolProviders = Provider.of<BoolProvider>(context);
    AssetProvider templateProvider = Provider.of<AssetProvider>(context);

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
    final userRole = templateProvider.userRole;

    final assetAccess = userRole.assetStockWriteFlag ||
        userRole.assetModelWriteFlag ||
        userRole.assetTemplateWriteFlag ||
        userRole.assetSubCategoryWriteFlag ||
        userRole.assetCategoryWriteFlag ||
        userRole.assetTypeWriteFlag ||
        userRole.assetStockReadFlag ||
        userRole.assetModelReadFlag ||
        userRole.assetTemplateReadFlag ||
        userRole.assetSubCategoryReadFlag ||
        userRole.assetCategoryReadFlag ||
        userRole.assetTypeReadFlag;

    final userManagementAccess = userRole.userWriteFlag ||
        userRole.assignRoleWriteFlag ||
        userRole.userReadFlag ||
        userRole.assignRoleReadFlag;

    final directoryAccess = userRole.companyWriteFlag ||
        userRole.vendorWriteFlag ||
        userRole.locationWriteFlag ||
        userRole.companyReadFlag ||
        userRole.vendorReadFlag ||
        userRole.locationReadFlag;

    return Consumer2<BoolProvider, AssetProvider>(
        builder: (context, boolProvider, modelProvider, child) {
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
                                "Model List",
                                style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                  fontSize: 20,
                                  color: boolProvider.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                              ),
                              if (userRole.assetModelWriteFlag) ...[
                                const DialogRoot(dialog: AddModel())
                              ]
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 40, 0),
                          child: Row(
                            children: [
                              Text(
                                "Type",
                                style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                  fontSize: 17,
                                  color: boolProvider.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                              ),
                              getTypeDropDownContentUI(),
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
                                text: " Model",
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
                            child: Lottie.asset("assets/lottie/loader.json",
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.4))
                        : modelProvider.modelDetailsList.isNotEmpty
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
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Checkbox(
                                                  side: MaterialStateBorderSide
                                                      .resolveWith(
                                                    (states) =>
                                                        const BorderSide(
                                                            width: 1.0,
                                                            color: Colors.blue),
                                                  ),
                                                  value: selectAllCheckBox,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      selectAllCheckBox =
                                                          value ?? false;
                                                      modelProvider
                                                              .selectedModel =
                                                          List.generate(
                                                              modelProvider
                                                                  .selectedModel
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
                                          if (assetAccess &&
                                              directoryAccess &&
                                              userManagementAccess) ...[
                                            Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    boolProviders.setVisibility(
                                                        !boolProvider
                                                            .isVisible);
                                                  },
                                                  child: Text(
                                                    "Select",
                                                    style: GoogleFonts.ubuntu(
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
                                          ]
                                        ],
                                      ),
                                      getTitleText(
                                        text: "ID",
                                      ),
                                      getTitleText(
                                        text: "Model ID",
                                      ),
                                      getTitleText(
                                        text: "Additional ID",
                                      ),
                                      getTitleText(
                                        text: "Asset Name",
                                      ),
                                      getTitleText(
                                        text: "Type",
                                      ),
                                      getTitleText(
                                        text: "Manufacture",
                                      ),
                                      getTitleText(
                                        text: "Template ID",
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
                                      AssetModelDetails model = entry.value;

                                      return TableRow(
                                          decoration: BoxDecoration(
                                              color: boolProvider.isDarkTheme
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
                                                  visible:
                                                      boolProvider.isVisible,
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
                                                        value: modelProvider
                                                                .selectedModel
                                                                .isNotEmpty
                                                            ? modelProvider
                                                                    .selectedModel[
                                                                index]
                                                            : false,
                                                        onChanged:
                                                            (bool? value) {
                                                          setState(() {
                                                            modelProvider
                                                                        .selectedModel[
                                                                    index] =
                                                                value ?? false;
                                                            selectAllCheckBox =
                                                                modelProvider
                                                                    .selectedModel
                                                                    .every(
                                                                        (item) =>
                                                                            item);
                                                          });

                                                          bool showDelete =
                                                              modelProvider
                                                                  .selectedModel
                                                                  .any((item) =>
                                                                      item);
                                                          boolProviders
                                                              .setDeleteVisibility(
                                                                  showDelete);
                                                        }),
                                                  ),
                                                ),
                                                Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 20),
                                                    child: CircleAvatar(
                                                      radius: 25,
                                                      backgroundColor:
                                                          themeProvider
                                                                  .isDarkTheme
                                                              ? const Color
                                                                  .fromRGBO(
                                                                  16, 18, 33, 1)
                                                              : const Color(
                                                                  0xfff3f1ef),
                                                      child: SizedBox(
                                                        width: 100,
                                                        height: 100,
                                                        child: ClipOval(
                                                          child: Image.network(
                                                            '$websiteURL/images/${model.image}',
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
                                                              return Image.asset(
                                                                  'assets/images/riota_logo.png');
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            getContentText(
                                                text:
                                                    model.displayId.toString(),
                                                maxLines: 1,
                                                color: themeProvider.isDarkTheme
                                                    ? const Color.fromRGBO(
                                                        200, 200, 200, 1)
                                                    : const Color.fromRGBO(
                                                        117, 117, 117, 1)),
                                            getContentText(
                                                text: model.modelId.toString(),
                                                maxLines: 1,
                                                color: themeProvider.isDarkTheme
                                                    ? const Color.fromRGBO(
                                                        200, 200, 200, 1)
                                                    : const Color.fromRGBO(
                                                        117, 117, 117, 1)),
                                            getContentText(
                                                text: model.additionalModelId
                                                    .toString(),
                                                maxLines: 1,
                                                color: themeProvider.isDarkTheme
                                                    ? const Color.fromRGBO(
                                                        200, 200, 200, 1)
                                                    : const Color.fromRGBO(
                                                        117, 117, 117, 1)),
                                            getContentText(
                                                text:
                                                    model.assetName.toString(),
                                                maxLines: 1,
                                                color: themeProvider.isDarkTheme
                                                    ? const Color.fromRGBO(
                                                        200, 200, 200, 1)
                                                    : const Color.fromRGBO(
                                                        117, 117, 117, 1)),
                                            getContentText(
                                                text: model.typeName.toString(),
                                                maxLines: 1,
                                                color: themeProvider.isDarkTheme
                                                    ? const Color.fromRGBO(
                                                        200, 200, 200, 1)
                                                    : const Color.fromRGBO(
                                                        117, 117, 117, 1)),
                                            getContentText(
                                                text: model.manufacturer
                                                    .toString(),
                                                maxLines: 1,
                                                color: themeProvider.isDarkTheme
                                                    ? const Color.fromRGBO(
                                                        200, 200, 200, 1)
                                                    : const Color.fromRGBO(
                                                        117, 117, 117, 1)),
                                            getContentText(
                                                text:
                                                    model.templateId.toString(),
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
                                                  dialog: ModelListExpandedView(
                                                      model: model),
                                                ),
                                                if (userRole
                                                    .assetModelWriteFlag) ...[
                                                  CustomActionIcon(
                                                    message: "Edit",
                                                    preferBelow: true,
                                                    iconImage: const Icon(
                                                        Icons.edit_rounded),
                                                    color: const Color.fromRGBO(
                                                        15, 117, 188, 1),
                                                    onPressed: () async {
                                                      int actualIndex =
                                                          (currentPage *
                                                                  listPerPage) +
                                                              index;

                                                      AssetModelDetails
                                                          assetModel =
                                                          filteredList[
                                                              actualIndex];

                                                      AssetProvider
                                                          commonAssetProvider =
                                                          Provider.of<
                                                                  AssetProvider>(
                                                              context,
                                                              listen: false);
                                                      templateController
                                                          .clear();
                                                      specificationController
                                                          .clear();
                                                      await templateProvider
                                                          .fetchTemplateDetails();
                                                      await commonAssetProvider
                                                          .fetchCategoryDetails();
                                                      await commonAssetProvider
                                                          .fetchSubCategoryDetails();

                                                      modelId =
                                                          assetModel.sId ?? "";

                                                      image =
                                                          assetModel.image ??
                                                              '';
                                                      nameController.text =
                                                          assetModel.assetName!;
                                                      assetController.text =
                                                          assetModel
                                                              .additionalModelId!;
                                                      modelController.text =
                                                          assetModel.modelId!;
                                                      manufactureController
                                                              .text =
                                                          assetModel
                                                              .manufacturer!;

                                                      tagList = List.from(
                                                          assetModel.tag!);

                                                      selectedType = commonAssetProvider
                                                          .typeDetailsList
                                                          .firstWhereOrNull(
                                                              (typeDetails) =>
                                                                  assetModel
                                                                      .typeName!
                                                                      .contains(
                                                                          typeDetails.name ??
                                                                              ""));

                                                      final concatenatedTypeText =
                                                          selectedType?.name;

                                                      typeController.text =
                                                          concatenatedTypeText!;

                                                      selectedCategory = commonAssetProvider
                                                          .categoryDetailsList
                                                          .firstWhereOrNull(
                                                              (categoryDetails) => assetModel
                                                                  .categoryName!
                                                                  .contains(
                                                                      categoryDetails
                                                                              .name ??
                                                                          ''));

                                                      final concatenatedCategoryText =
                                                          selectedCategory
                                                              ?.name;
                                                      categoryController.text =
                                                          concatenatedCategoryText!;

                                                      selectedSubCategory = commonAssetProvider
                                                          .subCategoryDetailsList
                                                          .firstWhereOrNull(
                                                              (subCategoryDetails) => assetModel
                                                                  .subCategoryName!
                                                                  .contains(
                                                                      subCategoryDetails
                                                                              .name ??
                                                                          ''));

                                                      final concatenatedSubCategoryText =
                                                          selectedSubCategory
                                                              ?.name;

                                                      subCategoryController
                                                              .text =
                                                          concatenatedSubCategoryText!;

                                                      selectedTemplate = templateProvider
                                                          .templateDetailsList
                                                          .firstWhereOrNull(
                                                              (modelDetails) => assetModel
                                                                  .templateId!
                                                                  .contains(
                                                                      modelDetails
                                                                              .displayId ??
                                                                          ''));

                                                      final concatenatedText =
                                                          "${selectedTemplate?.name} (${selectedTemplate?.displayId})";
                                                      templateController.text =
                                                          concatenatedText;

                                                      assetModel.specifications
                                                          ?.forEach((element) {
                                                        var textEditingController =
                                                            TextEditingController();
                                                        textEditingController
                                                                .text =
                                                            element.value ?? "";

                                                        specificationController.add(
                                                            textEditingController);
                                                      });

                                                      if (mounted) {
                                                        showLargeUpdateModel(
                                                            context,
                                                            actualIndex);
                                                      }
                                                    },
                                                  ),
                                                  CustomActionIcon(
                                                      message: "Delete",
                                                      preferBelow: false,
                                                      iconImage: const Icon(
                                                          Icons.delete_rounded),
                                                      color: Colors.red,
                                                      onPressed: () {
                                                        showAlertDialog(context,
                                                            modelId: model
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
                                                              modelIdDelete =
                                                              model.sId
                                                                  .toString();
                                                          String?
                                                              specificationIdDelete =
                                                              model
                                                                  .specifications
                                                                  ?.map((e) =>
                                                                      e.sId)
                                                                  .toString();
                                                          await deleteModel(
                                                              modelIdDelete,
                                                              specificationIdDelete!);
                                                          await modelProvider
                                                              .fetchModelDetails();
                                                          if (mounted) {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }
                                                          if (isToastMessage ==
                                                              true) {
                                                            setState(() {
                                                              showToast(
                                                                  "Model Deleted Successfully");
                                                            });
                                                          } else if (isToastMessage ==
                                                              false) {
                                                            setState(() {
                                                              showToast(
                                                                  "Unable to delete the model");
                                                            });
                                                          }
                                                        });
                                                      })
                                                ]
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
                    const SizedBox(
                      height: 15,
                    ),
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
                          List<AssetModelDetails> selectedModelsList =
                              getSelectedModel();

                          List<TableRow> tableRows = [];

                          tableRows.add(getTableDeleteForMultipleId(
                              title: "S.NO", content: "ID"));

                          for (int index = 0;
                              index < selectedModelsList.length;
                              index++) {
                            AssetModelDetails model = selectedModelsList[index];
                            tableRows.add(
                              getTableDeleteForMultipleId(
                                  title: (index + 1).toString(),
                                  content: model.displayId.toString()),
                            );
                          }

                          return AlertDialog(
                            backgroundColor: boolProvider.isDarkTheme
                                ? Colors.black
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Text(
                              "Delete the Selected Model",
                              style: GlobalHelper.textStyle(TextStyle(
                                color: boolProvider.isDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              )),
                            ),
                            content: Text(
                              "Are you sure want to delete?",
                              style: GlobalHelper.textStyle(TextStyle(
                                color: boolProvider.isDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              )),
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
                                    if (isToastMessage == true) {
                                      setState(() {
                                        showToast("Model Deleted Successfully");
                                      });
                                    } else if (isToastMessage == false) {
                                      setState(() {
                                        showToast("Unable to delete the model");
                                      });
                                    }
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

  Future<void> showLargeUpdateModel(BuildContext context, int index) async {
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
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "UPDATE MODEL",
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
                                child: ClipOval(child: Builder(
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
                                currentStep: currentStep,
                                elevation: 0,
                                onStepTapped: (step) {
                                  if (formKeyStepModel[currentStep]
                                      .currentState!
                                      .validate()) {
                                    setState(() {
                                      currentStep = step;
                                    });
                                  }
                                },
                                steps: getStepsModelDialog(setState,
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
                                        : Colors.white),
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
                                                  backgroundColor: Colors.blue,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
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
                                          if (currentStep != 0)
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
                                                    final steps = getStepsModelDialog(
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
                                                      if (formKeyStepModel[
                                                              currentStep]
                                                          .currentState!
                                                          .validate()) {
                                                        setState(() {
                                                          currentStep++;
                                                        });
                                                      } else {
                                                        return;
                                                      }
                                                    } else {
                                                      if (formKeyStepModel[
                                                              currentStep]
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
                                                                  Radius
                                                                      .circular(
                                                                          10)))),
                                                  child: Text(
                                                    currentStep == 2
                                                        ? "Save"
                                                        : "Next",
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
                  ],
                ),
              )),
            );
          });
        });
  }

  List<Step> getStepsModelDialog(StateSetter setState,
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
            'Model Details',
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Form(
            key: formKeyStepModel[0],
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  getDialogWithoutIconContentsUI(
                                    hintText: 'Model ID',
                                    controllers: modelController,
                                    width: MediaQuery.of(context).size.width *
                                        0.20,
                                    type: TextInputType.none,
                                    validators: commonValidator,
                                    dialogSetState: setState,
                                    color: colors,
                                    borderColor: borderColor,
                                    textColor: textColor,
                                  ),
                                  getDialogWithoutIconContentsUI(
                                    hintText: 'Additional ID',
                                    controllers: assetController,
                                    width: MediaQuery.of(context).size.width *
                                        0.20,
                                    type: TextInputType.none,
                                    validators: commonValidator,
                                    dialogSetState: setState,
                                    color: colors,
                                    borderColor: borderColor,
                                    textColor: textColor,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  getDialogWithoutIconContentsUI(
                                    hintText: 'Asset Name',
                                    controllers: nameController,
                                    width: MediaQuery.of(context).size.width *
                                        0.20,
                                    type: TextInputType.none,
                                    validators: commonValidator,
                                    dialogSetState: setState,
                                    color: colors,
                                    borderColor: borderColor,
                                    textColor: textColor,
                                  ),
                                  getDialogWithoutIconContentsUI(
                                    hintText: 'Manufacture',
                                    controllers: manufactureController,
                                    width: MediaQuery.of(context).size.width *
                                        0.20,
                                    type: TextInputType.none,
                                    validators: commonValidator,
                                    dialogSetState: setState,
                                    color: colors,
                                    borderColor: borderColor,
                                    textColor: textColor,
                                  ),
                                ],
                              ),
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
                  height: 70,
                )
              ],
            ),
          ),
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 0,
        ),
        Step(
          title: Text(
            'Template Details',
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Form(
            key: formKeyStepModel[1],
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
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getDialogDropDownContentsUI(
                                    hintText: 'Template',
                                    controllers: templateController,
                                    width: MediaQuery.of(context).size.width *
                                        0.20,
                                    type: TextInputType.none,
                                    validators: commonValidator,
                                    dropdownType: 5,
                                    dialogSetState: setState,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 170,
                )
              ],
            ),
          ),
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 1,
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
            key: formKeyStepModel[2],
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getDialogDropDownContentsTypeUI(
                                      hintText: 'Type',
                                      controllers: typeController,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      type: TextInputType.none,
                                      validators: commonValidator,
                                      dropdownType: 12,
                                      dialogSetState: setState),
                                  getDialogDropDownContentsCategoryUI(
                                      hintText: 'Category',
                                      controllers: categoryController,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      type: TextInputType.none,
                                      dropdownType: 13,
                                      dialogSetState: setState),
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
                                  getDialogDropDownContentsSubCategoryUI(
                                    hintText: 'Sub-Category',
                                    controllers: subCategoryController,
                                    width: MediaQuery.of(context).size.width *
                                        0.20,
                                    type: TextInputType.none,
                                    dialogSetState: setState,
                                    dropdownType: 14,
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
                                                  color: dividerColor,
                                                )),
                                          ],
                                        ),
                                      getTagListDialogContentsUI(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        dialogSetState: setState,
                                        tag: tagList,
                                        color: colors,
                                        textColor: textColor,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 80,
                )
              ],
            ),
          ),
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 2,
        )
      ];

  /// It contain Dropdown of the All Asset List
  Widget getDialogDropDownContentsUI(
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
        child: Column(
          children: [
            Stack(
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
                      completeTemplateList = modelProvider.templateDetailsList
                          .where((item) =>
                              templateController.text.isEmpty ||
                              ("${item.name} (${item.displayId})"
                                      .toLowerCase()
                                      .contains(templateController.text
                                          .toLowerCase()) ==
                                  true))
                          .toList();
                      isDropDownOpenAssetList[5] = true;
                    });
                  },
                  onChanged: (value) {
                    dialogSetState(() {
                      completeTemplateList = modelProvider.templateDetailsList
                          .where((item) =>
                              templateController.text.isEmpty ||
                              ("${item.name} (${item.displayId})"
                                      .toLowerCase()
                                      .contains(templateController.text
                                          .toLowerCase()) ==
                                  true))
                          .toList();
                      specificationController.clear();
                      specList.clear();
                      specKeys.clear();
                      specValues.clear();
                    });
                  },
                ),
                if (isDropDownOpenAssetList[dropdownType])
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: themeProvider.isDarkTheme
                            ? Colors.black
                            : Colors.white,
                      ),
                      margin: const EdgeInsets.only(top: 50),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: completeTemplateList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                              title: Text(
                                "${completeTemplateList[index].name.toString()} (${completeTemplateList[index].displayId.toString()})",
                                style: GlobalHelper.textStyle(TextStyle(
                                    color: themeProvider.isDarkTheme
                                        ? Colors.white
                                        : const Color.fromRGBO(
                                            117, 117, 117, 1))),
                              ),
                              onTap: () {
                                selectedTemplate = null;
                                selectedTemplate = completeTemplateList[index];
                                onDropdownTap(
                                    dropdownType,
                                    "${completeTemplateList[index].name.toString()} (${completeTemplateList[index].displayId.toString()})",
                                    dialogSetState);
                              });
                        },
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount:
                  ((selectedTemplate?.parameters?.length ?? 0) / 2).ceil(),
              itemBuilder: (context, index) {
                for (int i = 0;
                    i < (selectedTemplate?.parameters?.length ?? 0);
                    i++) {
                  specificationController.add(TextEditingController());
                }

                int startIndex = index * 2;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: specificationController[startIndex],
                            validator: validators,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: themeProvider.isDarkTheme
                                        ? Colors.black
                                        : Colors.white),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: themeProvider.isDarkTheme
                                        ? Colors.black
                                        : Colors.white),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              contentPadding: const EdgeInsets.all(15),
                              hintText: startIndex <
                                      selectedTemplate!.parameters!.length
                                  ? selectedTemplate?.parameters![startIndex]
                                  : "",
                              hintStyle: GlobalHelper.textStyle(
                                TextStyle(
                                  color: themeProvider.isDarkTheme
                                      ? Colors.white
                                      : const Color.fromRGBO(117, 117, 117, 1),
                                  fontSize: 15,
                                ),
                              ),
                              fillColor: themeProvider.isDarkTheme
                                  ? Colors.black
                                  : Colors.white,
                              filled: true,
                            ),
                            style: TextStyle(
                              color: themeProvider.isDarkTheme
                                  ? Colors.white
                                  : const Color.fromRGBO(117, 117, 117, 1),
                            ),
                            onChanged: (value) {
                              specKeys.clear();
                              specValues.clear();
                              while (specList.length <= startIndex) {
                                specList.add({'specKey': '', 'specValue': ''});
                              }

                              specList[startIndex] = {
                                'specKey':
                                    selectedTemplate?.parameters?[startIndex],
                                'specValue': value,
                              };
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (startIndex + 1 <
                            (selectedTemplate?.parameters?.length ?? -1))
                          Expanded(
                            child: TextFormField(
                              controller:
                                  specificationController[startIndex + 1],
                              validator: validators,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: themeProvider.isDarkTheme
                                          ? Colors.black
                                          : Colors.white),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: themeProvider.isDarkTheme
                                          ? Colors.black
                                          : Colors.white),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.redAccent),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                contentPadding: const EdgeInsets.all(15),
                                hintText: (startIndex + 1) <
                                        selectedTemplate!.parameters!.length
                                    ? selectedTemplate
                                        ?.parameters![startIndex + 1]
                                    : "",
                                hintStyle: GlobalHelper.textStyle(
                                  TextStyle(
                                    color: themeProvider.isDarkTheme
                                        ? Colors.white
                                        : const Color.fromRGBO(
                                            117, 117, 117, 1),
                                    fontSize: 15,
                                  ),
                                ),
                                fillColor: themeProvider.isDarkTheme
                                    ? Colors.black
                                    : Colors.white,
                                filled: true,
                              ),
                              style: TextStyle(
                                color: themeProvider.isDarkTheme
                                    ? Colors.white
                                    : const Color.fromRGBO(117, 117, 117, 1),
                              ),
                              onChanged: (value) {
                                while (specList.length <= startIndex + 1) {
                                  specList
                                      .add({'specKey': '', 'specValue': ''});
                                }

                                specList[startIndex + 1] = {
                                  'specKey': selectedTemplate
                                      ?.parameters?[startIndex + 1],
                                  'specValue': value,
                                };
                              },
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  /// It contain Dropdown of the All Asset List
  Widget getDialogDropDownContentsTypeUI(
      {required String hintText,
      required TextEditingController controllers,
      required double width,
      required TextInputType type,
      validators,
      required int dropdownType,
      required StateSetter dialogSetState}) {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    AssetProvider typeProvider =
        Provider.of<AssetProvider>(context, listen: false);

    AssetProvider categoryProvider =
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
                  completeTypeList = typeProvider.typeDetailsList
                      .where((item) =>
                          typeController.text.isEmpty ||
                          (item.name?.toLowerCase().contains(
                                  typeController.text.toLowerCase()) ==
                              true))
                      .toList();
                  isDropDownOpenAssetList[12] = true;
                });
              },
              onChanged: (value) {
                dialogSetState(() {
                  completeTypeList = typeProvider.typeDetailsList
                      .where((item) =>
                          typeController.text.isEmpty ||
                          (item.name?.toLowerCase().contains(
                                  typeController.text.toLowerCase()) ==
                              true))
                      .toList();
                  categoryController.clear();
                  completeCategoryList.clear();
                  subCategoryController.clear();
                  completeSubCategoryList.clear();
                });
              },
            ),
            if (isDropDownOpenAssetList[dropdownType])
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
                    itemCount: completeTypeList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(
                            completeTypeList[index].name.toString(),
                            style: GlobalHelper.textStyle(TextStyle(
                                color: themeProvider.isDarkTheme
                                    ? Colors.white
                                    : const Color.fromRGBO(117, 117, 117, 1))),
                          ),
                          onTap: () {
                            selectedType = null;
                            selectedType = completeTypeList[index];
                            typeController.text = selectedType!.name.toString();
                            onDropdownTap(dropdownType,
                                selectedType!.name.toString(), dialogSetState);
                            var categoryIds = selectedType?.categoryRefIds;
                            categoryProvider.fetchParticularCategoryDetails(
                                categoryIds: categoryIds);
                            categoryController.clear();
                            subCategoryController.clear();
                            if (!completeTypeList.contains(selectedType)) {
                              completeTypeList.add(selectedType!);
                            }
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

  Widget getDialogDropDownContentsCategoryUI(
      {required String hintText,
      required TextEditingController controllers,
      required double width,
      required TextInputType type,
      validators,
      required int dropdownType,
      required StateSetter dialogSetState}) {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    AssetProvider categoryProvider =
        Provider.of<AssetProvider>(context, listen: false);

    AssetProvider subCategoryProvider =
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
                  completeCategoryList = categoryProvider
                      .particularCategoryDetailsList
                      .where((item) =>
                          categoryController.text.isEmpty ||
                          (item.name?.toLowerCase().contains(
                                  categoryController.text.toLowerCase()) ==
                              true))
                      .toList();

                  isDropDownOpenAssetList[13] = true;
                });
              },
              onChanged: (value) {
                dialogSetState(() {
                  completeCategoryList = categoryProvider
                      .particularCategoryDetailsList
                      .where((item) =>
                          categoryController.text.isEmpty ||
                          (item.name?.toLowerCase().contains(
                                  categoryController.text.toLowerCase()) ==
                              true))
                      .toList();
                });
              },
            ),
            if (isDropDownOpenAssetList[dropdownType])
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
                    itemCount: completeCategoryList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(
                            completeCategoryList[index].name.toString(),
                            style: GlobalHelper.textStyle(TextStyle(
                                color: themeProvider.isDarkTheme
                                    ? Colors.white
                                    : const Color.fromRGBO(117, 117, 117, 1))),
                          ),
                          onTap: () {
                            selectedCategory = null;
                            selectedCategory = completeCategoryList[index];
                            onDropdownTap(
                                dropdownType,
                                completeCategoryList[index].name.toString(),
                                dialogSetState);
                            var subCategoryIds =
                                selectedCategory?.subCategoryRefIds;
                            subCategoryProvider
                                .fetchParticularSubCategoryDetails(
                                    subCategoryIds: subCategoryIds);
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

  Widget getDialogDropDownContentsSubCategoryUI(
      {required String hintText,
      required TextEditingController controllers,
      required double width,
      required TextInputType type,
      validators,
      required int dropdownType,
      required StateSetter dialogSetState}) {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    AssetProvider subCategoryProvider =
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
                  completeSubCategoryList = subCategoryProvider
                      .particularSubCategoryDetailsList
                      .where((item) =>
                          subCategoryController.text.isEmpty ||
                          (item.name?.toLowerCase().contains(
                                  subCategoryController.text.toLowerCase()) ==
                              true))
                      .toList();

                  isDropDownOpenAssetList[14] = true;
                });
              },
              onChanged: (value) {
                dialogSetState(() {
                  completeSubCategoryList = subCategoryProvider
                      .particularSubCategoryDetailsList
                      .where((item) =>
                          subCategoryController.text.isEmpty ||
                          (item.name?.toLowerCase().contains(
                                  subCategoryController.text.toLowerCase()) ==
                              true))
                      .toList();
                });
              },
            ),
            if (isDropDownOpenAssetList[dropdownType])
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
                    itemCount: completeSubCategoryList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(
                            completeSubCategoryList[index].name.toString(),
                            style: GlobalHelper.textStyle(TextStyle(
                                color: themeProvider.isDarkTheme
                                    ? Colors.white
                                    : const Color.fromRGBO(117, 117, 117, 1))),
                          ),
                          onTap: () {
                            selectedSubCategory = null;
                            selectedSubCategory =
                                completeSubCategoryList[index];
                            onDropdownTap(
                                dropdownType,
                                completeSubCategoryList[index].name.toString(),
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

  onDropdownTap(int dropdownType, String selectedOption, setState) {
    if (dropdownType == 5) {
      setState(() {
        templateController.text = selectedOption;
        isDropDownOpenAssetList[5] = false;
      });
    } else if (dropdownType == 12) {
      setState(() {
        typeController.text = selectedOption;
        isDropDownOpenAssetList[12] = false;
      });
    } else if (dropdownType == 13) {
      setState(() {
        categoryController.text = selectedOption;
        isDropDownOpenAssetList[13] = false;
      });
    } else if (dropdownType == 14) {
      setState(() {
        subCategoryController.text = selectedOption;
        isDropDownOpenAssetList[14] = false;
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

  showAlertDialog(BuildContext context,
      {required onPressed,
      required color,
      required containerColor,
      required modelId}) {
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
          "Delete Model",
          style: GlobalHelper.textStyle(TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          )),
        ),
      ),
      content: getTableDeleteForSingleId(id: modelId, color: color),
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

  List<AssetModelDetails> getSelectedModel() {
    AssetProvider modelProvider =
        Provider.of<AssetProvider>(context, listen: false);

    List<AssetModelDetails> selectedModelsList = [];
    for (int i = 0; i < modelProvider.modelDetailsList.length; i++) {
      if (modelProvider.selectedModel[i]) {
        selectedModelsList.add(modelProvider.modelDetailsList[i]);
      }
    }
    return selectedModelsList;
  }

  String fetchModel(List<String> model) {
    if (model.isEmpty) {
      return "";
    } else if (model.length == 1) {
      return model[0];
    } else if (model.length > 1) {
      return "${model.first}...";
    } else {
      return model.join(', ');
    }
  }

  void getDelete() async {
    AssetProvider modelProvider =
        Provider.of<AssetProvider>(context, listen: false);

    List<String> specificationIdsToDelete = [];
    for (int i = 0; i < modelProvider.selectedModel.length; i++) {
      if (modelProvider.selectedModel[i]) {
        specificationIdsToDelete.add(modelProvider
            .modelDetailsList[i].specifications!
            .map((e) => e.sId)
            .toString());
      }
    }

    for (int i = 0; i < modelProvider.modelDetailsList.length; i++) {
      if (modelProvider.selectedModel[i]) {
        String modelId = modelProvider.modelDetailsList[i].sId.toString();
        String specificationId = specificationIdsToDelete[i];
        await deleteModel(modelId, specificationId);
      }
    }

    setState(() {
      modelProvider.modelDetailsList.removeWhere((model) =>
          modelProvider.selectedModel.contains(model.sId.toString()));
      modelProvider.modelDetailsList.removeWhere((model) =>
          specificationIdsToDelete
              .contains(model.specificationRefIds.toString()));
      selectAllCheckBox = false;
      modelProvider.fetchModelDetails();
    });
  }

  bool checkModelDetailsEditedOrNot(
      int index, List<String> specKeys, List<String> specValues) {
    AssetProvider modelProvider =
        Provider.of<AssetProvider>(context, listen: false);

    Function eq = const ListEquality().equals;
    if (modelProvider.modelDetailsList[index].modelId == nameController.text &&
        modelProvider.modelDetailsList[index].additionalModelId ==
            assetController.text &&
        modelProvider.modelDetailsList[index].assetName ==
            nameController.text &&
        modelProvider.modelDetailsList[index].manufacturer ==
            manufactureController.text &&
        eq(
            modelProvider.modelDetailsList[index].specifications
                ?.map((e) => e.value)
                .toList(),
            specValues) &&
        eq(
            modelProvider.modelDetailsList[index].specifications
                ?.map((e) => e.key)
                .toList(),
            specKeys) &&
        modelProvider.modelDetailsList[index].templateId ==
            selectedTemplate?.displayId &&
        modelProvider.modelDetailsList[index].typeName == selectedType?.name &&
        modelProvider.modelDetailsList[index].categoryName ==
            selectedCategory?.name &&
        modelProvider.modelDetailsList[index].subCategoryName ==
            selectedSubCategory?.name &&
        eq(modelProvider.modelDetailsList[index].tag, tagList)) {
      return false;
    } else {
      return true;
    }
  }

  _onTapEditButton(int index) async {
    AssetProvider modelProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider boolProvider =
        Provider.of<BoolProvider>(context, listen: false);

    for (int i = 0; i < specList.length; i++) {
      specKeys.add(specList[i]['specKey']);
      specValues.add(specList[i]['specValue']);
    }

    final result = checkModelDetailsEditedOrNot(index, specKeys, specValues);

    if (result || imagePicked != null) {
      AssetModel model = AssetModel(
        modelId: modelController.text.toString(),
        additionalModelId: assetController.text.toString(),
        assetName: nameController.text.toString(),
        manufacturer: manufactureController.text.toString(),
        image: imagePicked?.name,
        tag: tagList,
        templateRefId: selectedTemplate?.sId,
        typeRefId: selectedType?.sId,
        categoryRefId: selectedCategory?.sId,
        subCategoryRefId: selectedSubCategory?.sId,
        specKey: specKeys,
        specValue: specValues,
        sId: modelId,
      );
      await updateModel(model, boolProvider, modelProvider);
    } else {
      /// User not changed anything...
    }
  }

  Widget getTypeDropDownContentUI() {
    AssetProvider modelProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    List<String> dropdownItems = ["All"];
    dropdownItems.addAll(
        modelProvider.modelDetailsList.map((model) => model.typeName!).toSet());
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

  Future<void> updateModel(AssetModel model, BoolProvider boolProviders,
      AssetProvider modelProvider) async {
    await AddUpdateDetailsManagerWithImage(
      data: model,
      image: imagePicked,
      apiURL: 'model/updateModel',
    ).addUpdateDetailsWithImages(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("Model Updated Successfully");
        modelProvider.fetchModelDetails();
      });
    } else {
      setState(() {
        showToast("Unable to update the model");
      });
    }
  }

  Future<void> deleteModel(String modelId, String specificationId) async {
    var headers = await getHeadersForJSON();

    try {
      var request =
          http.Request('POST', Uri.parse('$websiteURL/model/deleteModel'));

      request.body =
          json.encode({"id": modelId, "specificationId": specificationId});

      request.headers.addAll(headers);

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
