import 'dart:async';
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

class TypeList extends StatefulWidget {
  const TypeList({super.key});

  @override
  State<TypeList> createState() => _TypeListState();
}

class _TypeListState extends State<TypeList> with TickerProviderStateMixin {
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
  TextEditingController tagController = TextEditingController();

  List<String> tag = [];
  List<String> tagList = [];

  List<AssetTypeDetails> getPaginatedData() {
    AssetProvider typeProvider =
        Provider.of<AssetProvider>(context, listen: false);

    final startIndex = currentPage * listPerPage;
    final endIndex = (startIndex + listPerPage)
        .clamp(0, typeProvider.typeDetailsList.length);
    return typeProvider.typeDetailsList.sublist(startIndex, endIndex);
  }

  String getDisplayedRange() {
    AssetProvider typeProvider =
        Provider.of<AssetProvider>(context, listen: false);
    final startIndex = currentPage * listPerPage + 1;
    final endIndex = (startIndex + listPerPage - 1)
        .clamp(0, typeProvider.typeDetailsList.length);
    return '$startIndex-$endIndex of ${typeProvider.typeDetailsList.length}';
  }

  @override
  void initState() {
    super.initState();
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
        builder: (context, boolProvider, typeProvider, child) {
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
                                "Type Lists",
                                style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                  fontSize: 20,
                                  color: boolProvider.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                              ),
                              if (typeProvider.userRole.assetTypeWriteFlag) ...[
                                IconButton(
                                    onPressed: () {
                                      nameController.clear();
                                      tagController.clear();
                                      tagList.clear();
                                      showLargeAddType(context);
                                    },
                                    icon: const Icon(Icons.add_circle),
                                    color:
                                        const Color.fromRGBO(15, 117, 188, 1))
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
                                    text: typeProvider.typeDetailsList.length
                                        .toString(),
                                    style: GoogleFonts.ubuntu(
                                        textStyle: const TextStyle(
                                      fontSize: 20,
                                      color: Color.fromRGBO(15, 117, 188, 1),
                                    )),
                                  ),
                                  TextSpan(
                                    text: " Types",
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
                                          typeProvider.typeDetailsList.length
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
                        : typeProvider.typeDetailsList.isNotEmpty
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
                                        text: "Actions",
                                      ),
                                    ]),
                                    ...getPaginatedData()
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      int index = entry.key;
                                      AssetTypeDetails type = entry.value;

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
                                                        '$websiteURL/images/${type.image}',
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
                                                text: type.displayId.toString(),
                                                maxLines: 1,
                                                color: themeProvider.isDarkTheme
                                                    ? const Color.fromRGBO(
                                                        200, 200, 200, 1)
                                                    : const Color.fromRGBO(
                                                        117, 117, 117, 1)),
                                            getContentText(
                                                text: type.name.toString(),
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
                                                if (typeProvider.userRole
                                                    .assetTypeWriteFlag) ...[
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

                                                      image = typeProvider
                                                              .typeDetailsList[
                                                                  actualIndex]
                                                              .image ??
                                                          '';
                                                      nameController.text =
                                                          typeProvider
                                                              .typeDetailsList[
                                                                  actualIndex]
                                                              .name!;
                                                      tagList = List.from(
                                                          typeProvider
                                                              .typeDetailsList[
                                                                  actualIndex]
                                                              .tag!);
                                                      showLargeUpdateType(
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
                                                          typeId: type.displayId
                                                              .toString(),
                                                          color: boolProvider
                                                                  .isDarkTheme
                                                              ? Colors.white
                                                              : Colors.black,
                                                          containerColor:
                                                              boolProvider
                                                                      .isDarkTheme
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                          onPressed: () async {
                                                        String? typeIdDelete =
                                                            type.sId.toString();

                                                        if (mounted) {
                                                          Navigator.of(context)
                                                              .pop();
                                                        }

                                                        await deleteType(
                                                            typeIdDelete,
                                                            boolProvider,
                                                            typeProvider);
                                                      });
                                                    },
                                                  )
                                                ] else ...[
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

  Future<void> showLargeAddType(BuildContext context) async {
    BoolProvider themeProvider =
        Provider.of<BoolProvider>(context, listen: false);

    AssetProvider typeProvider =
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
                                "ADD TYPE",
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
                                                        hintText: 'Tag',
                                                        controllers:
                                                            tagController,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.20,
                                                        dialogSetState:
                                                            setState,
                                                        type:
                                                            TextInputType.text,
                                                        tags: tag,
                                                        onPressed: () {
                                                          final tagExtraText =
                                                              tagController
                                                                  .text;
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
                                                                    ? Colors
                                                                        .black
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
                                                          : const Color
                                                              .fromRGBO(
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
                                              ],
                                            ),
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

                                            AssetType type = AssetType(
                                              name: nameController.text
                                                  .toString(),
                                              image: imagePicked?.name,
                                              tag: tagList,
                                            );
                                            await addType(type, themeProvider,
                                                typeProvider);
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

  Future<void> showLargeUpdateType(BuildContext context, int index) async {
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
                                    "UPDATE TYPE",
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
                                                    Column(
                                                      children: [
                                                        getDialogTagContentsUI(
                                                            borderColor:
                                                                themeProvider
                                                                        .isDarkTheme
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white,
                                                            textColor: themeProvider
                                                                    .isDarkTheme
                                                                ? Colors.white
                                                                : const Color
                                                                    .fromRGBO(
                                                                    117,
                                                                    117,
                                                                    117,
                                                                    1),
                                                            fillColor: themeProvider
                                                                    .isDarkTheme
                                                                ? Colors.black
                                                                : Colors.white,
                                                            containerColor:
                                                                themeProvider
                                                                        .isDarkTheme
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white,
                                                            hintText: 'Tag',
                                                            controllers:
                                                                tagController,
                                                            width: MediaQuery
                                                                        .of(
                                                                            context)
                                                                    .size
                                                                    .width *
                                                                0.20,
                                                            dialogSetState:
                                                                setState,
                                                            type: TextInputType
                                                                .text,
                                                            tags: tag,
                                                            onPressed: () {
                                                              final tagExtraText =
                                                                  tagController
                                                                      .text;
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
                                                                    thickness:
                                                                        3.5,
                                                                    color: themeProvider.isDarkTheme
                                                                        ? Colors
                                                                            .black
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
                                                              : const Color
                                                                  .fromRGBO(117,
                                                                  117, 117, 1),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.20,
                                                          dialogSetState:
                                                              setState,
                                                          tag: tagList,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
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

  showAlertDialog(BuildContext context,
      {required onPressed,
      required color,
      required containerColor,
      required typeId}) {
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
          "Delete Type",
          style: GlobalHelper.textStyle(TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          )),
        ),
      ),
      content: getTableDeleteForSingleId(id: typeId, color: color),
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

  bool checkTypeDetailsEditedOrNot(int index) {
    AssetProvider typeProvider =
        Provider.of<AssetProvider>(context, listen: false);

    Function eq = const ListEquality().equals;
    if (typeProvider.typeDetailsList[index].name == nameController.text &&
        eq(typeProvider.typeDetailsList[index].tag, tagList)) {
      return false;
    } else {
      return true;
    }
  }

  _onTapEditButton(int index) async {
    BoolProvider boolProvider =
        Provider.of<BoolProvider>(context, listen: false);

    AssetProvider typeProvider =
        Provider.of<AssetProvider>(context, listen: false);

    final result = checkTypeDetailsEditedOrNot(index);
    if (result || imagePicked != null) {
      AssetType type = AssetType(
          name: nameController.text.toString(),
          image: imagePicked?.name,
          tag: tagList,
          sId: typeProvider.typeDetailsList[index].sId.toString());

      await updateType(type, boolProvider, typeProvider);
    } else {
      /// User not changed anything...
    }
  }

  Future<void> addType(AssetType type, BoolProvider boolProviders,
      AssetProvider typeProvider) async {
    await AddUpdateDetailsManagerWithImage(
      data: type,
      image: imagePicked,
      apiURL: 'type/addType',
    ).addUpdateDetailsWithImages(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("Type Added Successfully");
        typeProvider.fetchTypeDetails();
      });
    } else {
      setState(() {
        showToast("Unable to add the type");
      });
    }
  }

  Future<void> updateType(AssetType type, BoolProvider boolProviders,
      AssetProvider typeProvider) async {
    await AddUpdateDetailsManagerWithImage(
      data: type,
      image: imagePicked,
      apiURL: 'type/updateType',
    ).addUpdateDetailsWithImages(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("Type Updated Successfully");
        typeProvider.fetchTypeDetails();
      });
    } else {
      setState(() {
        showToast("Unable to update the type");
      });
    }
  }

  Future<void> deleteType(String typeId, BoolProvider boolProviders,
      AssetProvider typeProvider) async {
    await DeleteDetailsManager(
      apiURL: 'type/deleteType',
      id: typeId,
    ).deleteDetails(boolProviders);

    if (boolProviders.toastMessages) {
      setState(() {
        showToast("Type Deleted Successfully");
        typeProvider.fetchTypeDetails();
      });
    } else {
      setState(() {
        showToast("Unable to delete the type");
      });
    }
  }
}
