/// <!-- Data Class for Asset Model --!> ///
class AssetModel {
  String? modelId;
  String? additionalModelId;
  String? assetName;
  String? type;
  String? manufacturer;
  String? templateId;
  String? templateRefId;
  String? oldTemplateRefId;
  List? tag;
  String? image;
  String? typeName;
  String? typeRefId;
  String? categoryName;
  String? categoryRefId;
  String? subCategoryName;
  String? subCategoryRefId;
  List? specKey;
  List? specValue;
  List? specificationId;
  String? displayId;
  String? sId;

  AssetModel(
      {this.modelId,
      this.additionalModelId,
      this.assetName,
      this.type,
      this.manufacturer,
      this.templateId,
      this.templateRefId,
      this.oldTemplateRefId,
      this.tag,
      this.image,
      this.categoryName,
      this.categoryRefId,
      this.typeName,
      this.typeRefId,
      this.subCategoryName,
      this.subCategoryRefId,
      this.specKey,
      this.specValue,
      this.specificationId,
      this.displayId = '',
      this.sId});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['modelId'] = modelId;
    map['additionalModelId'] = additionalModelId;
    map['assetName'] = assetName;
    map['type'] = type;
    map['manufacturer'] = manufacturer;
    map['templateId'] = templateId;
    map['templateRefId'] = templateRefId;
    map['tag'] = tag;
    map['image'] = image;
    map['typeName'] = typeName;
    map['typeRefId'] = typeRefId;
    map['categoryName'] = categoryName;
    map['categoryRefId'] = categoryRefId;
    map['subCategoryName'] = subCategoryName;
    map['subCategoryRefId'] = subCategoryRefId;
    map['specKey'] = specKey;
    map['specValue'] = specValue;
    map['specificationRefId'] = specificationId;
    map['displayId'] = displayId;
    map['oldTemplateRefId'] = oldTemplateRefId;
    map['sId'] = sId;

    return map;
  }

  AssetModel.fromMapObject(Map<String, dynamic> map) {
    modelId = map['modelId'];
    additionalModelId = map['additionalModelId'];
    assetName = map['assetName'];
    type = map['type'];
    manufacturer = map['manufacturer'];
    templateId = map['templateId'];
    templateRefId = map['templateRefId'];
    tag = map['tag'];
    image = map['image'];
    typeName = map['typeName'];
    typeRefId = map['typeRefId'];
    categoryName = map['categoryName'];
    categoryRefId = map['categoryRefId'];
    subCategoryName = map['subCategoryName'];
    subCategoryRefId = map['subCategoryRefId'];
    specKey = map['specKey'];
    specValue = map['specValue'];
    specificationId = map['specificationRefId'];
    displayId = map['displayId'];
    oldTemplateRefId = map['oldTemplateRefId'];
    oldTemplateRefId = map['oldTemplateRefId'];
    map['sId'] = sId;
  }
}
/// <!-- Data Class for Asset Model --!> ///
