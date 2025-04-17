/// <!-- Data Class for Vendor Details --!> ///
class VendorDetails {
  Address? address;
  String? sId;
  String? vendorName;
  String? contractDocument;
  String? image;
  int? phoneNumber;
  String? email;
  String? name;
  String? gstIn;
  List<String>? tag;
  String? createdAt;
  String? updatedAt;
  String? displayId;

  VendorDetails({
    this.address,
    this.sId,
    this.vendorName,
    this.contractDocument,
    this.image,
    this.phoneNumber,
    this.email,
    this.name,
    this.gstIn,
    this.tag,
    this.createdAt,
    this.updatedAt,
    this.displayId = '',
  });

  VendorDetails.fromJson(Map<String, dynamic> json) {
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    sId = json['_id'];
    vendorName = json['vendorName'];
    contractDocument = json['contractDocument'];
    image = json['image'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    name = json['name'];
    gstIn = json['gstIn'];
    tag = json['tag'].cast<String>();
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
    data['vendorName'] = vendorName;
    data['contractDocument'] = contractDocument;
    data['image'] = image;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['name'] = name;
    data['gstIn'] = gstIn;
    data['tag'] = tag;
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
/// <!-- Data Class for Vendor Details --!> ///
