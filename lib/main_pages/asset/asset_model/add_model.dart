import 'package:asset_management_local/models/asset_model/asset_template_model/asset_template_details.dart';
import 'package:asset_management_local/provider/main_providers/asset_provider.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../global/global_variables.dart';
import '../../../helpers/global_helper.dart';
import '../../../helpers/http_helper.dart';
import '../../../helpers/ui_components.dart';
import '../../../models/asset_model/asset_model_model/asset_model.dart';
import '../../../models/asset_model/asset_type_model/asset_type_details.dart';

class AddModel extends StatefulWidget {
  const AddModel({super.key});

  @override
  State<AddModel> createState() => _AddModelState();
}

class _AddModelState extends State<AddModel> {
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
  AssetCategoryDetails? selectedCategoryList;

  List<AssetSubCategoryDetails> completeSubCategoryList = [];
  AssetSubCategoryDetails? selectedSubCategoryList;

  List<String> tag = [];
  List<String> tagList = [];

  List<Map<String, dynamic>> specList = [];

  List<String> specKeys = [];
  List<String> specValues = [];

  @override
  void initState() {
    super.initState();
    Provider.of<AssetProvider>(context, listen: false).fetchTemplateDetails();
    Provider.of<AssetProvider>(context, listen: false).fetchTypeDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BoolProvider, AssetProvider>(
        builder: (context, themeProvider, modelProvider, child) {
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
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "ADD MODEL",
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
                                  height: MediaQuery.of(context).size.height *
                                      0.050,
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
                                  if (currentStep != 0)
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.050,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.075,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                currentStep -= 1;
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.050,
                                      width: MediaQuery.of(context).size.width *
                                          0.075,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              isApiCallInProgress = true;
                                            });
                                            final steps = getStepsModelDialog(
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

                                            if (formKeyStepModel[currentStep]
                                                .currentState!
                                                .validate()) {
                                              if (currentStep ==
                                                  steps.length - 1) {
                                                for (int i = 0;
                                                    i < specList.length;
                                                    i++) {
                                                  specKeys.add(
                                                      specList[i]['specKey']);
                                                  specValues.add(
                                                      specList[i]['specValue']);
                                                }

                                                AssetModel model = AssetModel(
                                                  modelId: modelController.text
                                                      .toString(),
                                                  additionalModelId:
                                                      assetController.text
                                                          .toString(),
                                                  assetName: nameController.text
                                                      .toString(),
                                                  type: typeController.text
                                                      .toString(),
                                                  manufacturer:
                                                      manufactureController.text
                                                          .toString(),
                                                  image: imagePicked?.name,
                                                  tag: tagList,
                                                  templateRefId:
                                                      selectedTemplate?.sId,
                                                  typeRefId: selectedType?.sId,
                                                  categoryRefId:
                                                      selectedCategoryList?.sId,
                                                  subCategoryRefId:
                                                      selectedSubCategoryList
                                                          ?.sId,
                                                  specKey: specKeys,
                                                  specValue: specValues,
                                                );
                                                await addModel(
                                                    model,
                                                    themeProvider,
                                                    modelProvider);

                                                if (mounted) {
                                                  Navigator.of(context).pop();
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
                                                              Radius.circular(
                                                                  10)))),
                                          child: Text(
                                            currentStep == 2 ? "Save" : "Next",
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
          ],
        ),
      ));
    });
  }

  List<Step> getStepsModelDialog(StateSetter dialogSetState,
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
                                    dialogSetState: dialogSetState,
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
                                    dialogSetState: dialogSetState,
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
                                    dialogSetState: dialogSetState,
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
                                      dialogSetState: dialogSetState),
                                  getDialogDropDownContentsCategoryUI(
                                      hintText: 'Category',
                                      controllers: categoryController,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      type: TextInputType.none,
                                      dropdownType: 13,
                                      dialogSetState: dialogSetState),
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
                                    dialogSetState: dialogSetState,
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
        ),
      ];

  /// It contain Dropdown of the All Asset List
  Widget getDialogDropDownContentsUI({
    required String hintText,
    required TextEditingController controllers,
    required double width,
    required TextInputType type,
    required validators,
    required int dropdownType,
    required StateSetter dialogSetState,
  }) {
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
                          dialogSetState(() {
                            selectedType = null;
                            selectedType = completeTypeList[index];
                            typeController.text = selectedType!.name.toString();
                            onDropdownTap(
                              dropdownType,
                              selectedType!.name.toString(),
                              dialogSetState,
                            );
                            var categoryIds = selectedType?.categoryRefIds;
                            categoryProvider.fetchParticularCategoryDetails(
                              categoryIds: categoryIds,
                            );
                            categoryIds!.clear();
                            categoryController.clear();
                            subCategoryController.clear();
                            if (!completeTypeList.contains(selectedType)) {


                              completeTypeList.add(selectedType!);
                            }
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
                          typeController.text.isEmpty ||
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
                            selectedCategoryList = null;
                            selectedCategoryList = completeCategoryList[index];
                            onDropdownTap(
                                dropdownType,
                                completeCategoryList[index].name.toString(),
                                dialogSetState);
                            var subCategoryIds =
                                selectedCategoryList?.subCategoryRefIds;
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
                            selectedSubCategoryList = null;
                            selectedSubCategoryList =
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

  Future<void> addModel(AssetModel model, BoolProvider boolProviders,
      AssetProvider modelProvider) async {
    await AddUpdateDetailsManagerWithImage(
      data: model,
      image: imagePicked,
      apiURL: 'model/addModel',
    ).addUpdateDetailsWithImages(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("Model Added Successfully");
        modelProvider.fetchModelDetails();
      });
    } else {
      setState(() {
        showToast("Unable to add the model");
      });
    }
  }
}
