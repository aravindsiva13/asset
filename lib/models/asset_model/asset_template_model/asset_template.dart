/// <!-- Data Class for Asset Template --!> ///
class AssetTemplate {
  late String name;
  List? parameters;
  List? department;
  List? tag;
  List? company;
  String? image;
  String? companyRefId;
  String? displayId;
  String? sId;

  AssetTemplate({
    required this.name,
    required this.parameters,
    required this.department,
    this.tag,
    this.company,
    this.image,
    this.companyRefId,
    this.displayId = '',
    this.sId,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['parameters'] = parameters;
    map['department'] = department;
    map['tag'] = tag;
    map['company'] = company;
    map['image'] = image;
    map['companyRefId'] = companyRefId;
    map['displayId'] = displayId;
    map['sId'] = sId;
    return map;
  }

  AssetTemplate.fromMapObject(Map<String, dynamic> map) {
    name = map['name'];
    company = map['company'];
    parameters = map['parameters'];
    department = map['department'];
    tag = map['tag'];
    image = map['image'];
    companyRefId = map['companyRefId'];
    displayId = map['displayId'];
    sId = map['sId'];
  }
}
/// <!-- Data Class for Asset Template --!> ///
