/// <!-- Data Class for Asset Type --!> ///
class AssetType {
  String? image;
  String? name;
  List? tag;
  String? displayId;
  String? sId;

  AssetType({
    this.image,
    this.name,
    this.tag,
    this.displayId = '',
    this.sId,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['name'] = name;
    map['tag'] = tag;
    map['image'] = image;
    map['displayId'] = displayId;
    map['sId'] = sId;

    return map;
  }

  AssetType.fromJson(Map<String, dynamic> map) {
    name = map['name'];
    tag = map['tag'];
    image = map['image'];
    displayId = map['displayId'];
    sId = map['sId'];
  }
}
/// <!-- Data Class for Asset Type --!> ///

/// <!-- Data Class for Asset Category --!> ///
class AssetCategory {
  String? image;
  String? name;
  List? typeName;
  List? typeRefIds;
  List? tag;
  String? displayId;
  String? sId;

  AssetCategory({
    this.image,
    this.name,
    this.tag,
    this.typeName,
    this.typeRefIds,
    this.displayId = '',
    this.sId,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['name'] = name;
    map['tag'] = tag;
    map['image'] = image;
    map['typeName'] = typeName;
    map['typeRefIds'] = typeRefIds;
    map['displayId'] = displayId;
    map['sId'] = sId;

    return map;
  }

  AssetCategory.fromJson(Map<String, dynamic> map) {
    name = map['name'];
    tag = map['tag'];
    image = map['image'];
    typeName = map['typeName'];
    typeRefIds = map['typeRefIds'];
    displayId = map['displayId'];
    sId = map['sId'];
  }
}
/// <!-- Data Class for Asset Category --!> ///

/// <!-- Data Class for Asset Sub-Category --!> ///
class AssetSubCategory {
  String? image;
  String? name;
  List? categoryId;
  List? categoryRefIds;
  List? tag;
  String? displayId;
  String? sId;

  AssetSubCategory({
    this.image,
    this.name,
    this.tag,
    this.categoryId,
    this.categoryRefIds,
    this.displayId = '',
    this.sId,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['name'] = name;
    map['tag'] = tag;
    map['image'] = image;
    map['categoryId'] = categoryId;
    map['categoryRefIds'] = categoryRefIds;
    map['displayId'] = displayId;
    map['sId'] = sId;

    return map;
  }

  AssetSubCategory.fromJson(Map<String, dynamic> map) {
    name = map['name'];
    tag = map['tag'];
    image = map['image'];
    categoryId = map['categoryId'];
    categoryRefIds = map['categoryRefIds'];
    displayId = map['displayId'];
    sId = map['sId'];
  }
}
/// <!-- Data Class for Asset Sub-Category --!> ///
