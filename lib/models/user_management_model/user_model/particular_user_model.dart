/// <!-- Data Class for Particular User Details --!> ///
class ParticularUserDetails {
  late String name;
  late String employeeId;
  List? company;
  late List department;
  late String designation;
  late String email;
  late int phoneNumber;
  late String dateOfJoining;
  String? password;
  List? assignedRoles;
  late List tag;
  String? image;
  String? companyRefId;
  List? assignRoleRefIds;
  List? assetStockRefIds;
  String? displayId;
  String? sId;

  ParticularUserDetails(
      {required this.name,
      required this.employeeId,
      required this.department,
      required this.designation,
      required this.email,
      required this.phoneNumber,
      required this.dateOfJoining,
      this.password,
      required this.tag,
      this.assignedRoles,
      this.image,
      this.company,
      this.companyRefId,
      this.assignRoleRefIds,
      this.sId,
      this.displayId = ''});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['name'] = name;
    map['employeeId'] = employeeId;
    map['company'] = company;
    map['department'] = department;
    map['designation'] = designation;
    map['email'] = email;
    map['phoneNumber'] = phoneNumber;
    map['dateOfJoining'] = dateOfJoining;
    map['password'] = password;
    map['assignedRoles'] = assignedRoles;
    map['tag'] = tag;
    map['image'] = image;
    map['companyRefId'] = companyRefId;
    map['assignRoleRefIds'] = assignRoleRefIds;
    map['assetStockRefId'] = assetStockRefIds;
    map['displayId'] = displayId;
    map['_id'] = sId;

    return map;
  }

  ParticularUserDetails.fromMapObject(Map<String, dynamic> map) {
    name = map['name'];
    employeeId = map['employeeId'];
    company = map['company'];
    department = map['department'];
    designation = map['designation'];
    email = map['email'];
    phoneNumber = map['phoneNumber'];
    dateOfJoining = map['dateOfJoining'];
    password = map['password'];
    assignedRoles = map['assignedRoles'];
    tag = map['tag'];
    image = map['image'];
    companyRefId = map['companyRefId'];
    assignRoleRefIds = map['assignRoleRefIds'];
    assetStockRefIds = map['assetStockRefId'];
    displayId = map['displayId'];
    sId = map['_id'];
  }
}
/// <!-- Data Class for Particular User Details --!> ///
