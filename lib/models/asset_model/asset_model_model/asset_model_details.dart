/// <!-- Data Class for Asset Model Details --!> ///
class AssetModelDetails {
  String? sId;
  String? modelId;
  String? additionalModelId;
  String? assetName;
  String? type;
  String? manufacturer;
  String? templateId;
  List<String>? tag;
  String? templateRefId;
  String? oldTemplateRefId;
  String? typeName;
  String? typeRefId;
  String? categoryName;
  String? categoryRefId;
  String? subCategoryName;
  String? subCategoryRefId;
  String? image;
  List<String>? specificationRefIds;
  List<AssetSpecification>? specifications;
  String? displayId;
  List<String>? specificationId;
  List<String>? parameters;

  AssetModelDetails({
    this.modelId,
    this.additionalModelId,
    this.assetName,
    this.type,
    this.manufacturer,
    this.templateId,
    this.templateRefId,
    this.tag,
    this.image,
    this.sId,
    this.typeRefId,
    this.typeName,
    this.categoryRefId,
    this.categoryName,
    this.subCategoryRefId,
    this.subCategoryName,
    this.specificationRefIds,
    this.specifications,
    this.displayId,
    this.oldTemplateRefId,
    this.specificationId,
    this.parameters,
  });

  AssetModelDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    modelId = json['modelId'];
    additionalModelId = json['additionalModelId']??"";
    assetName = json['assetName'];
    type = json['type'];
    manufacturer = json['manufacturer'];
    templateId = json['templateId'];
    templateRefId = json['templateRefId'];
    tag = json['tag'].cast<String>();
    typeName = json['typeName'];
    typeRefId = json['typeRefId'];
    categoryRefId = json['categoryRefId'];
    categoryName = json['categoryName'];
    subCategoryRefId = json['subCategoryRefId'];
    subCategoryName = json['subCategoryName'];
    image = json['image'];
    specificationRefIds = json['specificationRefIds'];
    displayId = json['displayId'];
    oldTemplateRefId = json['oldTemplateRefId'];
    parameters = json['parameters'].cast<String>();
    specificationId = json['specificationRefId'].cast<String>();

    List<AssetSpecification> specs = [];

    if (json["specifications"] != null) {
      for (int i = 0; i < json["specifications"].length; i++) {
        AssetSpecification specification =
            AssetSpecification.fromJson(json["specifications"][i]);

        specs.add(specification);
      }
    }

    specifications = specs;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['_id'] = sId;
    data['modelId'] = modelId;
    data['additionalModelId'] = additionalModelId;
    data['assetName'] = assetName;
    data['type'] = type;
    data['manufacturer'] = manufacturer;
    data['templateId'] = templateId;
    data['templateRefId'] = templateRefId;
    data['tag'] = tag;
    data['image'] = image;
    data['subCategoryName'] = subCategoryName;
    data['subCategoryRefId'] = subCategoryRefId;
    data['categoryName'] = categoryName;
    data['categoryRefId'] = categoryRefId;
    data['typeName'] = typeName;
    data['typeRefId'] = typeRefId;
    data['specifications'] = specifications;
    data['specificationRefIds'] = specificationRefIds;
    data['displayId'] = displayId;
    data['oldTemplateRefId'] = oldTemplateRefId;
    data['parameters'] = parameters;
    data['specificationRefId'] = specificationId;

    return data;
  }
}
/// <!-- Data Class for Asset Model Details --!> ///

/// <!-- Data Class for Asset Specification Details --!> ///
class AssetSpecification {
  String? sId;
  String? key;
  String? value;
  String? modelRefId;
  String? templateRefId;

  AssetSpecification({
    this.sId,
    this.key,
    this.value,
    this.modelRefId,
    this.templateRefId,
  });

  AssetSpecification.fromJson(Map<String, dynamic> json) {
    sId = json['specId'];
    key = json['specKey'];
    value = json['specValue'];
    modelRefId = json['modelRefId'];
    templateRefId = json['templateRefId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['specId'] = sId;
    data['specKey'] = key;
    data['specValue'] = value;
    data['modelRefId'] = modelRefId;
    data['templateRefId'] = templateRefId;
    return data;
  }
}
/// <!-- Data Class for Asset Specification Details --!> ///
