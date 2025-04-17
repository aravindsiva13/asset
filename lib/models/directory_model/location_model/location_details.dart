/// <!-- Data Class for Location Details --!> ///
class LocationDetails {
  String? latitude;
  String? name;
  String? longitude;
  Address? address;
  String? plusCode;
  List<String>? tag;
  String? sId;
  String? displayId;

  LocationDetails(
      {this.sId,
        this.name,
        this.latitude,
        this.longitude,
        this.address,
        this.plusCode,
        this.tag,
        this.displayId = ''
      });

  LocationDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address =
    json['address'] != null ? Address.fromJson(json['address']) : null;
    plusCode = json['plusCode'];
    tag = json['tag'].cast<String>();
    displayId = json['displayId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['plusCode'] = plusCode;
    data['tag'] = tag;
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
/// <!-- Data Class for Location Details --!> ///
