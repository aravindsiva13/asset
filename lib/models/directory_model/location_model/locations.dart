/// <!-- Data Class for Locations --!> ///
class AddLocations {
  late String name;
  late String latitude;
  late String longitude;
  late Map address;
  late String plusCode;
  late List tag;
  String? displayId;
  String? sId;

  AddLocations(
      {required this.latitude,
      required this.name,
      required this.longitude,
      required this.address,
      required this.plusCode,
      required this.tag,
      this.displayId = '',
      this.sId,
      });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['address'] = address;
    map['plusCode'] = plusCode;
    map['tag'] = tag;
    map['name'] = name;
    map['displayId'] = displayId;
    map['sId'] = sId;

    return map;
  }

  AddLocations.fromMapObject(Map<String, dynamic> map) {
    latitude = map['latitude'];
    longitude = map['longitude'];
    address = map['address'];
    plusCode = map['plusCode'];
    tag = map['tag'];
    name = map['name'];
    displayId = map['displayId'];
    sId = map['sId'];
  }
}
/// <!-- Data Class for Locations --!> ///
