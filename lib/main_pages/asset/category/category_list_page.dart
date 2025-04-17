import 'package:asset_management_local/models/asset_model/asset_type_model/asset_type_details.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../global/global_variables.dart';
import '../../../global/user_interaction_timer.dart';
import '../../../helpers/global_helper.dart';
import '../../../helpers/http_helper.dart';
import '../../../helpers/ui_components.dart';
import '../../../models/asset_model/asset_type_model/asset_type.dart';
import 'package:asset_management_local/provider/main_providers/asset_provider.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList>
    with TickerProviderStateMixin {
  int selectedIndex = 0;
  int listPerPage = 5;
  int currentPage = 0;

  late AnimationController controller;
  late TableBorder startBorder;
  late TableBorder endBorder;
  late TableBorder currentBorder;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String selectedImageName = 'Image';

  PlatformFile? imagePicked;

  late String image;

  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController tagController = TextEditingController();

  List<String> tag = [];
  List<String> tagList = [];

  List<AssetTypeDetails> completeTypeList = [];
  List<AssetTypeDetails> selectedTypeList = [];

  List<AssetCategoryDetails> getPaginatedData() {
    AssetProvider categoryProvider =
        Provider.of<AssetProvider>(context, listen: false);

    final startIndex = currentPage * listPerPage;
    final endIndex = (startIndex + listPerPage)
        .clamp(0, categoryProvider.categoryDetailsList.length);
    return categoryProvider.categoryDetailsList.sublist(startIndex, endIndex);
  }

  String getDisplayedRange() {
    AssetProvider categoryDetailsList =
        Provider.of<AssetProvider>(context, listen: false);
    final startIndex = currentPage * listPerPage + 1;
    final endIndex = (startIndex + listPerPage - 1)
        .clamp(0, categoryDetailsList.categoryDetailsList.length);
    return '$startIndex-$endIndex of ${categoryDetailsList.categoryDetailsList.length}';
  }

  @override
  void initState() {
    super.initState();
    Provider.of<AssetProvider>(context, listen: false).fetchCategoryDetails();
    Provider.of<AssetProvider>(context, listen: false).fetchTypeDetails();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BoolProvider, AssetProvider>(
        builder: (context, boolProvider, categoryProvider, child) {
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
                                "Category Lists",
                                style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                  fontSize: 20,
                                  color: boolProvider.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                              ),
                              if(categoryProvider.userRole.assetCategoryWriteFlag)...[
                                IconButton(
                                    onPressed: () {
                                      nameController.clear();
                                      tagController.clear();
                                      typeController.clear();
                                      tagList.clear();
                                      selectedTypeList.clear();
                                      showLargeAddCategory(context);
                                    },
                                    icon: const Icon(Icons.add_circle),
                                    color: const Color.fromRGBO(15, 117, 188, 1))
                              ]

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
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
                              child: RichText(
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                    text: categoryProvider
                                        .categoryDetailsList.length
                                        .toString(),
                                    style: GoogleFonts.ubuntu(
                                        textStyle: const TextStyle(
                                      fontSize: 20,
                                      color: Color.fromRGBO(15, 117, 188, 1),
                                    )),
                                  ),
                                  TextSpan(
                                    text: " Category",
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
                                  color: Colors.blue,
                                  disabledColor: Colors.grey,
                                  onPressed: currentPage > 0
                                      ? () => setState(() => currentPage--)
                                      : null,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_circle_right_rounded,
                                  ),
                                  color: Colors.blue,
                                  disabledColor: Colors.grey,
                                  onPressed: (currentPage + 1) * listPerPage <
                                          categoryProvider
                                              .categoryDetailsList.length
                                      ? () => setState(() => currentPage++)
                                      : null,
                                ),
                              ),
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
                        : categoryProvider.categoryDetailsList.isNotEmpty
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
                                        text: "Name",
                                      ),
                                      getTitleText(
                                        text: "Type",
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
                                      AssetCategoryDetails category =
                                          entry.value;

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
                                                        '$websiteURL/images/${category.image}',
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
                                                text: category.displayId
                                                    .toString(),
                                                maxLines: 1,
                                                color: themeProvider.isDarkTheme
                                                    ? const Color.fromRGBO(
                                                        200, 200, 200, 1)
                                                    : const Color.fromRGBO(
                                                        117, 117, 117, 1)),
                                            getContentText(
                                                text: category.name.toString(),
                                                maxLines: 1,
                                                color: themeProvider.isDarkTheme
                                                    ? const Color.fromRGBO(
                                                        200, 200, 200, 1)
                                                    : const Color.fromRGBO(
                                                        117, 117, 117, 1)),
                                            getContentText(
                                                text: category.typeName
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
                                                if(categoryProvider.userRole.assetCategoryWriteFlag)...[
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

                                                      image = categoryProvider
                                                          .categoryDetailsList[
                                                      actualIndex]
                                                          .image ??
                                                          '';
                                                      nameController.text =
                                                      categoryProvider
                                                          .categoryDetailsList[
                                                      actualIndex]
                                                          .name!;
                                                      typeController.text =
                                                      categoryProvider
                                                          .categoryDetailsList[
                                                      actualIndex]
                                                          .typeName!;
                                                      tagList = List.from(
                                                          categoryProvider
                                                              .categoryDetailsList[
                                                          actualIndex]
                                                              .tag!);
                                                      showLargeUpdateCategory(
                                                          context, actualIndex);
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
                                                          categoryId: category
                                                              .displayId
                                                              .toString(),
                                                          color: boolProvider
                                                              .isDarkTheme
                                                              ? Colors.white
                                                              : Colors.black,
                                                          containerColor:
                                                          boolProvider
                                                              .isDarkTheme
                                                              ? Colors.black
                                                              : Colors.white,
                                                          onPressed: () async {
                                                            String? categoryIdDelete =
                                                            category.sId
                                                                .toString();

                                                            if (mounted) {
                                                              Navigator.of(context)
                                                                  .pop();
                                                            }

                                                            await deleteCategory(
                                                                categoryIdDelete,
                                                                themeProvider,
                                                                categoryProvider);
                                                          });
                                                    },
                                                  )
                                                ]
                                                else ...[
                                                  Text(
                                                    "-",
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: GoogleFonts.ubuntu(
                                                        textStyle: TextStyle(
                                                          fontSize: 13,
                                                          color: themeProvider
                                                              .isDarkTheme
                                                              ? const Color
                                                              .fromRGBO(
                                                              200, 200, 200, 1)
                                                              : const Color
                                                              .fromRGBO(
                                                              117, 117, 117, 1),
                                                        )),
                                                  )
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
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  Future<void> showLargeAddCategory(BuildContext context) async {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    AssetProvider categoryProvider =
        Provider.of<AssetProvider>(context, listen: false);
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
                  child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                        color: themeProvider.isDarkTheme
                            ? const Color.fromRGBO(16, 18, 33, 1)
                            : const Color(0xfff3f1ef),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    width: MediaQuery.of(context).size.width * 0.47,
                    child: Wrap(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "ADD CATEGORY",
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
                            Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(
                                    child: Container(
                                      margin: const EdgeInsets.all(2.0),
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromRGBO(67, 66, 66, 0.060),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                getDialogWithoutIconContentsUI(
                                                  hintText: 'Name',
                                                  controllers: nameController,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  type: TextInputType.none,
                                                  validators: commonValidator,
                                                  dialogSetState: setState,
                                                  color:
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
                                                ),
                                                getDialogDropDownContentsUI(
                                                    hintText: 'Type',
                                                    controllers: typeController,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.20,
                                                    type: TextInputType.none,
                                                    validators: commonValidator,
                                                    dropdownType: 10,
                                                    dialogSetState: setState),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              getDialogTagContentsUI(
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
                                                  hintText: 'Tag',
                                                  controllers: tagController,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  dialogSetState: setState,
                                                  type: TextInputType.text,
                                                  tags: tag,
                                                  onPressed: () {
                                                    final tagExtraText =
                                                        tagController.text;
                                                    if (tagExtraText
                                                        .isNotEmpty) {
                                                      setState(() {
                                                        tagList
                                                            .add(tagExtraText);
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
                                                          color: themeProvider
                                                                  .isDarkTheme
                                                              ? Colors.black
                                                              : Colors.white,
                                                        )),
                                                  ],
                                                ),
                                              getTagListDialogContentsUI(
                                                color: themeProvider.isDarkTheme
                                                    ? Colors.black
                                                    : Colors.white,
                                                textColor:
                                                    themeProvider.isDarkTheme
                                                        ? Colors.white
                                                        : const Color.fromRGBO(
                                                            117, 117, 117, 1),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.20,
                                                dialogSetState: setState,
                                                tag: tagList,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.050,
                                    width: MediaQuery.of(context).size.width *
                                        0.075,
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
                                          "Cancel",
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
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.050,
                                    width: MediaQuery.of(context).size.width *
                                        0.075,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            if (mounted) {
                                              Navigator.of(context).pop();
                                            }

                                            AssetCategory category =
                                                AssetCategory(
                                              name: nameController.text
                                                  .toString(),
                                              image: imagePicked?.name,
                                              typeRefIds: selectedTypeList
                                                  .map((e) => e.sId)
                                                  .toList(),
                                              tag: tagList,
                                            );
                                            await addCategory(
                                                category,
                                                themeProvider,
                                                categoryProvider);
                                          } else {
                                            return;
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)))),
                                        child: Text(
                                          "Save",
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
                        ),
                      ],
                    ),
                  ),
                ),
              )),
            );
          });
        });
  }

  Future<void> showLargeUpdateCategory(BuildContext context, int index) async {
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
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                            color: themeProvider.isDarkTheme
                                ? const Color.fromRGBO(16, 18, 33, 1)
                                : const Color(0xfff3f1ef),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15))),
                        width: MediaQuery.of(context).size.width * 0.47,
                        child: Wrap(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    "UPDATE CATEGORY",
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
                                        child: Builder(
                                          builder: (BuildContext context) {
                                            if (imagePicked != null) {
                                              return Image.memory(
                                                  imagePicked!.bytes!,
                                                  fit: BoxFit.cover);
                                            } else {
                                              return Image.network(
                                                '$websiteURL/images/$image',
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  } else {
                                                    return const CircularProgressIndicator();
                                                  }
                                                },
                                                errorBuilder: (BuildContext
                                                        context,
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
                                  height: 15,
                                ),
                                Wrap(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SingleChildScrollView(
                                        child: Container(
                                          margin: const EdgeInsets.all(2.0),
                                          decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  67, 66, 66, 0.060),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    getDialogWithoutIconContentsUI(
                                                      hintText: 'Name',
                                                      controllers:
                                                          nameController,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.20,
                                                      type: TextInputType.none,
                                                      validators:
                                                          commonValidator,
                                                      dialogSetState: setState,
                                                      color: themeProvider
                                                              .isDarkTheme
                                                          ? Colors.black
                                                          : Colors.white,
                                                      borderColor: themeProvider
                                                              .isDarkTheme
                                                          ? Colors.black
                                                          : Colors.white,
                                                      textColor: themeProvider
                                                              .isDarkTheme
                                                          ? Colors.white
                                                          : const Color
                                                              .fromRGBO(
                                                              117, 117, 117, 1),
                                                    ),
                                                    getDialogDropDownContentsUI(
                                                        hintText: 'Type',
                                                        controllers:
                                                            typeController,
                                                        width: MediaQuery
                                                                    .of(context)
                                                                .size
                                                                .width *
                                                            0.20,
                                                        type:
                                                            TextInputType.none,
                                                        validators:
                                                            commonValidator,
                                                        dropdownType: 10,
                                                        dialogSetState:
                                                            setState),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  getDialogTagContentsUI(
                                                      borderColor: themeProvider
                                                              .isDarkTheme
                                                          ? Colors.black
                                                          : Colors.white,
                                                      textColor: themeProvider
                                                              .isDarkTheme
                                                          ? Colors.white
                                                          : const Color
                                                              .fromRGBO(
                                                              117, 117, 117, 1),
                                                      fillColor:
                                                          themeProvider
                                                                  .isDarkTheme
                                                              ? Colors.black
                                                              : Colors.white,
                                                      containerColor:
                                                          themeProvider
                                                                  .isDarkTheme
                                                              ? Colors.black
                                                              : Colors.white,
                                                      hintText: 'Tag',
                                                      controllers:
                                                          tagController,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.20,
                                                      dialogSetState: setState,
                                                      type: TextInputType.text,
                                                      tags: tag,
                                                      onPressed: () {
                                                        final tagExtraText =
                                                            tagController.text;
                                                        if (tagExtraText
                                                            .isNotEmpty) {
                                                          setState(() {
                                                            tagList.add(
                                                                tagExtraText);
                                                            tagController
                                                                .clear();
                                                          });
                                                        } else {
                                                          return;
                                                        }
                                                      },
                                                      list: tagList),
                                                  if (tagList.isNotEmpty)
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                            height: 30,
                                                            child:
                                                                VerticalDivider(
                                                              thickness: 3.5,
                                                              color: themeProvider
                                                                      .isDarkTheme
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                            )),
                                                      ],
                                                    ),
                                                  getTagListDialogContentsUI(
                                                    color: themeProvider
                                                            .isDarkTheme
                                                        ? Colors.black
                                                        : Colors.white,
                                                    textColor: themeProvider
                                                            .isDarkTheme
                                                        ? Colors.white
                                                        : const Color.fromRGBO(
                                                            117, 117, 117, 1),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.20,
                                                    dialogSetState: setState,
                                                    tag: tagList,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15),
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
                                              "Cancel",
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
                                          const EdgeInsets.only(bottom: 15),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.050,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.075,
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                _onTapEditButton(index);
                                                Navigator.of(context).pop();
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
                                              "Save",
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
            );
          });
        });
  }

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

    AssetProvider typeProvider =
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
                  isDropDownOpenAssetList[10] = true;
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
                            selectedTypeList.clear();
                            selectedTypeList.add(completeTypeList[index]);
                            onDropdownTap(
                                dropdownType,
                                completeTypeList[index].name.toString(),
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
    if (dropdownType == 10) {
      setState(() {
        typeController.text = selectedOption;
        isDropDownOpenAssetList[10] = false;
      });
    } else {
      return;
    }
  }

  showAlertDialog(BuildContext context,
      {required onPressed,
      required color,
      required containerColor,
      required categoryId}) {
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
          "Delete Category",
          style: GlobalHelper.textStyle(TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          )),
        ),
      ),
      content: getTableDeleteForSingleId(id: categoryId, color: color),
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

  String fetchCategory(List<String> category) {
    if (category.isEmpty) {
      return "";
    } else if (category.length == 1) {
      return category[0];
    } else if (category.length > 1) {
      return "${category.first}...";
    } else {
      return category.join(', ');
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

  bool checkCategoryDetailsEditedOrNot(int index) {
    AssetProvider categoryProvider =
        Provider.of<AssetProvider>(context, listen: false);

    Function eq = const ListEquality().equals;
    if (categoryProvider.categoryDetailsList[index].name ==
            nameController.text &&
        eq(categoryProvider.categoryDetailsList[index].typeName,
            selectedTypeList) &&
        eq(categoryProvider.categoryDetailsList[index].tag, tagList)) {
      return false;
    } else {
      return true;
    }
  }

  _onTapEditButton(int index) async {
    AssetProvider categoryProvider =
        Provider.of<AssetProvider>(context, listen: false);

    BoolProvider boolProvider =
        Provider.of<BoolProvider>(context, listen: false);

    final result = checkCategoryDetailsEditedOrNot(index);
    if (result || imagePicked != null) {
      AssetCategory category = AssetCategory(
          name: nameController.text.toString(),
          image: imagePicked?.name,
          typeRefIds: selectedTypeList.map((e) => e.sId).toList(),
          tag: tagList,
          sId: categoryProvider.categoryDetailsList[index].sId.toString());

      await updateCategory(category, boolProvider, categoryProvider);
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

  Future<void> addCategory(AssetCategory category, BoolProvider boolProviders,
      AssetProvider categoryProvider) async {
    await AddUpdateDetailsManagerWithImage(
      data: category,
      image: imagePicked,
      apiURL: 'category/addCategory',
    ).addUpdateDetailsWithImages(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("Category Added Successfully");
        categoryProvider.fetchCategoryDetails();
      });
    } else {
      setState(() {
        showToast("Unable to add the category");
      });
    }
  }

  Future<void> updateCategory(AssetCategory category,
      BoolProvider boolProviders, AssetProvider categoryProvider) async {
    await AddUpdateDetailsManagerWithImage(
      data: category,
      image: imagePicked,
      apiURL: 'category/updateCategory',
    ).addUpdateDetailsWithImages(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("Category Updated Successfully");
        categoryProvider.fetchCategoryDetails();
      });
    } else {
      setState(() {
        showToast("Unable to update the category");
      });
    }
  }

  Future<void> deleteCategory(String categoryId, BoolProvider boolProviders,
      AssetProvider categoryProvider) async {
    await DeleteDetailsManager(
      apiURL: 'category/deleteCategory',
      id: categoryId,
    ).deleteDetails(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("Category Deleted Successfully");
        categoryProvider.fetchCategoryDetails();
      });
    } else {
      setState(() {
        showToast("Unable to delete the category");
      });
    }
  }
}
