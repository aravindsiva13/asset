import 'dart:typed_data';

/// <!-- Data Class for Asset Category --!> ///
class AssetCategory {
  late String id;
  late String categoryId;
  late String name;
  late Uint8List attachment;
  late String subCategoryRefId;
  late bool deleteFlag;
  late String tag;

  AssetCategory({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.attachment,
    required this.subCategoryRefId,
    required this.deleteFlag,
    required this.tag,
  });
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['id'] = id;
    map['categoryId'] = categoryId;
    map['name'] = name;
    map['attachment'] = attachment;
    map['subCategoryRefId'] = subCategoryRefId;
    map['deleteFlag'] = deleteFlag;
    map['tag'] = tag;

    return map;
  }

  AssetCategory.fromMapObject(Map<String, dynamic> map) {
    id = map['id'];
    categoryId = map['categoryId'];
    name = map['name'];
    attachment = map['attachment'];
    subCategoryRefId = map['subCategoryRefId'];
    deleteFlag = map['deleteFlag'];
    tag = map['tag'];
  }
}
/// <!-- Data Class for Asset Category --!> ///
