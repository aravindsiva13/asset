/// <!-- Data Class for Asset Type Details --!> ///
class AssetTypeDetails {
  String? sId;
  String? image;
  String? name;
  List? tag;
  List<String>? categoryRefIds;
  String? displayId;

  AssetTypeDetails({
    this.sId,
    this.image,
    this.name,
    this.tag,
    this.categoryRefIds,
    this.displayId = '',
  });

  AssetTypeDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    tag = json['tag'].cast<String>();
    name = json['name'];
    image = json['image'];
    displayId = json['displayId'];
    categoryRefIds = json['categoryRefIds'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['_id'] = sId;
    data['tag'] = tag;
    data['name'] = name;
    data['image'] = image;
    data['categoryRefIds'] = categoryRefIds;
    data['displayId'] = displayId;

    return data;
  }
}
/// <!-- Data Class for Asset Type Details --!> ///

/// <!-- Data Class for Asset Category Details --!> ///
class AssetCategoryDetails {
  String? sId;
  String? image;
  String? name;
  String? typeName;
  List<String>? typeRefIds;
  List<String>? tag;
  List<String>? subCategoryRefIds;
  String? displayId;

  AssetCategoryDetails({
    this.sId,
    this.image,
    this.name,
    this.tag,
    this.typeName,
    this.typeRefIds,
    this.subCategoryRefIds,
    this.displayId = '',
  });

  AssetCategoryDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    tag = json['tag'].cast<String>();
    typeName = json['typeName'];
    typeRefIds = json['typeRefIds'].cast<String>();
    subCategoryRefIds = json['subCategoryRefIds'].cast<String>();
    name = json['name'];
    image = json['image'];
    displayId = json['displayId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['_id'] = sId;
    data['tag'] = tag;
    data['typeName'] = typeName;
    data['typeRefIds'] = typeRefIds;
    data['subCategoryRefIds'] = subCategoryRefIds;
    data['name'] = name;
    data['image'] = image;
    data['displayId'] = displayId;

    return data;
  }
}
/// <!-- Data Class for Asset Category Details --!> ///

/// <!-- Data Class for Asset Sub-Category Details --!> ///
class AssetSubCategoryDetails {
  String? sId;
  String? image;
  String? name;
  String? categoryName;
  List<String>? categoryRefIds;
  List<String>? tag;
  String? displayId;

  AssetSubCategoryDetails({
    this.sId,
    this.image,
    this.name,
    this.tag,
    this.categoryName,
    this.categoryRefIds,
    this.displayId = '',
  });

  AssetSubCategoryDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    tag = json['tag'].cast<String>();
    categoryName = json['categoryName'];
    categoryRefIds = json['categoryRefIds'].cast<String>();
    name = json['name'];
    image = json['image'];
    displayId = json['displayId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['_id'] = sId;
    data['tag'] = tag;
    data['categoryName'] = categoryName;
    data['categoryRefIds'] = categoryRefIds;
    data['name'] = name;
    data['image'] = image;
    data['displayId'] = displayId;

    return data;
  }
}
/// <!-- Data Class for Asset Sub-Category Details --!> ///

