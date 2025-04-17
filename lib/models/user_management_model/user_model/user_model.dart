/// <!-- Data Class for User --!> ///
class Users {
  late String name;
  late String employeeId;
  List? company;
  late List department;
  late String designation;
  late String email;
  late String phoneNumber;
  late String dateOfJoining;
  String? password;
  List? assignedRoles;
  late List tag;
  String? image;
  String? companyRefId;
  List? assignRoleRefIds;
  String? reportManagerRefId;
  String? displayId;
  String? sId;
  String? createdBy;
  String? updatedBy;

  Users(
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
      this.reportManagerRefId,
      this.sId,
      this.displayId = '',
      this.createdBy,
      this.updatedBy});

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
    map['reportManagerRefId'] = reportManagerRefId;
    map['displayId'] = displayId;
    map['sId'] = sId;
    map['createdBy'] = createdBy;
    map['updatedBy'] = updatedBy;

    return map;
  }

  Users.fromMapObject(Map<String, dynamic> map) {
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
    reportManagerRefId = map['reportManagerRefId'];
    displayId = map['displayId'];
    sId = map['sId'];
    sId = map['sId'];
    createdBy = map['createdBy'];
    updatedBy = map['updatedBy'];
  }
}
/// <!-- Data Class for User --!> ///
