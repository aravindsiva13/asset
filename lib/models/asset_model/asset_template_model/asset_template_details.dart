/// <!-- Data Class for Asset Template Details --!> ///
class AssetTemplateDetails {
  String? sId;
  String? name;
  List<String>? parameters;
  List<String>? department;
  String? companyRefId;
  String? company;
  List<String>? tag;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? displayId;

  AssetTemplateDetails(
      {this.sId,
      this.name,
      this.parameters,
      this.department,
      this.companyRefId,
      this.company,
      this.tag,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.displayId = ''});

  AssetTemplateDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    parameters = json['parameters'].cast<String>();
    department = json['department'].cast<String>();
    companyRefId = json['companyRefId'];
    company = json['company'];
    tag = json['tag'].cast<String>();
    image = json['image'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    displayId = json['displayId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['_id'] = sId;
    data['name'] = name;
    data['parameters'] = parameters;
    data['department'] = department;
    data['companyRefId'] = companyRefId;
    data['company'] = company;
    data['tag'] = tag;
    data['image'] = image;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['displayId'] = displayId;

    return data;
  }
}
/// <!-- Data Class for Asset Template Details --!> ///