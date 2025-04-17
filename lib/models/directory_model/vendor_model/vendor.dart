/// <!-- Data Class for Vendor --!> ///
class Vendor {
  late String name;
  late String vendorName;
  late String email;
  late String phoneNumber;
  late Map address;
  late List tag;
  late String gstIn;
  String? contractDocument;
  String? image;
  String? displayId;
  String? sId;

  Vendor(
      {required this.name,
      required this.vendorName,
      required this.email,
      required this.phoneNumber,
      required this.address,
      required this.tag,
      required this.gstIn,
      this.contractDocument, this.image,this.displayId = '',this.sId
      });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['name'] = name;
    map['vendorName'] = vendorName;
    map['email'] = email;
    map['phoneNumber'] = phoneNumber;
    map['address'] = address;
    map['tag'] = tag;
    map['gstIn'] = gstIn;
    map['contractDocument'] = contractDocument;
    map['image'] = image;
    map['displayId'] = displayId;
    map['sId'] = sId;

    return map;
  }

  Vendor.fromMapObject(Map<String, dynamic> map) {
    name = map['name'];
    vendorName = map['vendorName'];
    email = map['email'];
    phoneNumber = map['phoneNumber'];
    address = map['address'];
    tag = map['tag'];
    gstIn = map['gstIn'];
    contractDocument = map['contractDocument'];
    image = map['image'];
    displayId = map['displayId'];
    sId = map['sId'];
  }
}
/// <!-- Data Class for Vendor --!> ///
