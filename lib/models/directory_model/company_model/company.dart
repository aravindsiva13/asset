/// <!-- Data Class for Company --!> ///
class Company {
  late String name;
  late Map address;
  late String phoneNumber;
  late String email;
  late String website;
  late String contactPersonName;
  late String contactPersonPhoneNumber;
  late String contactPersonEmail;
  late List departments;
  late List tag;
  String? displayId;
  String? image;
  String? sId;


  Company({
    required this.name,
    required this.address,
    required this.email,
    required this.phoneNumber,
    required this.website,
    required this.contactPersonName,
    required this.contactPersonPhoneNumber,
    required this.contactPersonEmail,
    required this.departments,
    required this.tag,
    this.image,
    this.sId,
    this.displayId = ''
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['name'] = name;
    map['address'] = address;
    map['email'] = email;
    map['phoneNumber'] = phoneNumber;
    map['website'] = website;
    map['contactPersonName'] = contactPersonName;
    map['contactPersonPhoneNumber'] = contactPersonPhoneNumber;
    map['contactPersonEmail'] = contactPersonEmail;
    map['departments'] = departments;
    map['tag'] = tag;
    map['displayId'] = displayId;
    map['image'] = image;
    map['sId'] = sId;

    return map;
  }

  Company.fromMapObject(Map<String, dynamic> map) {
    name = map['name'];
    address = map['address'];
    email = map['email'];
    website = map['website'];
    contactPersonName = map['contactPersonName'];
    contactPersonEmail = map['contactPersonEmail'];
    contactPersonPhoneNumber = map['contactPersonPhoneNumber'];
    departments = map['departments'];
    tag = map['tag'];
    displayId = map['displayId'];
    image = map['image'];
    sId = map['sId'];
  }
}
/// <!-- Data Class for Company --!> ///
