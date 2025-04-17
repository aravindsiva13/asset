/// <!-- Data Class for User Details --!> ///
class UserDetails {
  String? sId;
  String? name;
  String? employeeId;
  List<String>? company;
  List<String>? department;
  String? designation;
  String? email;
  int? phoneNumber;
  String? dateOfJoining;
  String? password;
  List<String>? tag;
  List<String>? assignedRoles;
  String? companyRefId;
  String? reportManagerRefId;
  List<String>? assignRoleRefIds;
  List<String>? assetStockRefId;
  List<String>? assetName;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? displayId;
  String? managerName;

  UserDetails(
      {this.name,
      this.employeeId,
      this.company,
      this.department,
      this.assignedRoles,
      this.designation,
      this.email,
      this.phoneNumber,
      this.dateOfJoining,
      this.password,
      this.tag,
      this.image,
      this.sId,
      this.companyRefId,
      this.reportManagerRefId,
      this.assignRoleRefIds,
      this.assetStockRefId,
      this.assetName,
      this.createdAt,
      this.updatedAt,
      this.managerName,
      this.displayId = ''});

  UserDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    employeeId = json['employeeId'];
    designation = json['designation'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    dateOfJoining = json['dateOfJoining'];
    image = json['image'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    password = json['password'];
    displayId = json['displayId'];
    company = json['company']?.cast<String>();
    department = json['department']?.cast<String>();
    assignedRoles = json['assignedRoles']?.cast<String>();
    assetName = json['assetName']?.cast<String>();
    companyRefId = json['companyRefId'];
    managerName = json['managerName'];
    reportManagerRefId = json['reportManagerRefId'];
    assignRoleRefIds = json['assignRoleRefIds']?.cast<String>();
    assetStockRefId = json['assetStockRefId']?.cast<String>();
    tag = json['tag'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['_id'] = sId;
    data['name'] = name;
    data['employeeId'] = employeeId;
    data['company'] = company;
    data['department'] = department;
    data['designation'] = designation;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['dateOfJoining'] = dateOfJoining;
    data['password'] = password;
    data['assignedRoles'] = assignedRoles;
    data['companyRefId'] = companyRefId;
    data['assignRoleRefIds'] = assignRoleRefIds;
    data['assetName'] = assetName;
    data['assetStockRefId'] = assetStockRefId;
    data['reportManagerRefId'] = reportManagerRefId;
    data['tag'] = tag;
    data['image'] = image;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['displayId'] = displayId;
    data['managerName'] = managerName;

    return data;
  }
}
/// <!-- Data Class for User Details --!> ///
