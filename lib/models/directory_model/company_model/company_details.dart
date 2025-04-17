/// <!-- Data Class for Company Details --!> ///
class CompanyDetails {
  Address? address;
  String? sId;
  String? name;
  int? phoneNumber;
  String? email;
  String? website;
  String? contactPersonName;
  int? contactPersonPhoneNumber;
  String? contactPersonEmail;
  List<String>? departments;
  List<String>? tag;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? displayId;

  CompanyDetails({
    this.address,
    this.sId,
    this.name,
    this.phoneNumber,
    this.email,
    this.website,
    this.contactPersonName,
    this.contactPersonPhoneNumber,
    this.contactPersonEmail,
    this.departments,
    this.tag,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.displayId = '',
  });

  CompanyDetails.fromJson(Map<String, dynamic> json) {
    address =
    json['address'] != null ? Address.fromJson(json['address']) : null;
    sId = json['_id'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    website = json['website'];
    contactPersonName = json['contactPersonName'];
    contactPersonPhoneNumber = json['contactPersonPhoneNumber'];
    contactPersonEmail = json['contactPersonEmail'];
    departments = json['departments'].cast<String>();
    tag = json['tag'].cast<String>();
    image = json['image'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    displayId = json['displayId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['_id'] = sId;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['website'] = website;
    data['contactPersonName'] = contactPersonName;
    data['contactPersonPhoneNumber'] = contactPersonPhoneNumber;
    data['contactPersonEmail'] = contactPersonEmail;
    data['departments'] = departments;
    data['tag'] = tag;
    data['image'] = image;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['displayId'] = displayId;
    return data;
  }
}

/// <!-- Address Details --!> ///
class Address {
  String? address;
  String? city;
  String? state;
  String? country;
  String? landMark;
  int? pinCode;

  Address(
      {this.address,
        this.city,
        this.state,
        this.country,
        this.landMark,
        this.pinCode});

  Address.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    landMark = json['landMark'];
    pinCode = json['pinCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['landMark'] = landMark;
    data['pinCode'] = pinCode;
    return data;
  }
}
/// <!-- Address Details --!> ///
/// <!-- Data Class for Company Details --!> ///
