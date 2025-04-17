/// <!-- Data Class for Asset Warranty Details --!> ///
class Warranty {
  String? stockRefId;
  String? modelRefId;
  String? warrantyExpiry;
  String? warrantyName;
  String? warrantyAttachment;
  String? sId;

  Warranty(
      {this.stockRefId,
      this.modelRefId,
      this.warrantyExpiry,
      this.warrantyName,
      this.warrantyAttachment,
      this.sId});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['modelRefId'] = modelRefId;
    map['stockRefId'] = stockRefId;
    map['warrantyName'] = warrantyName;
    map['warrantyExpiry'] = warrantyExpiry;
    map['warrantyAttachment'] = warrantyAttachment;
    map['warrantyId'] = sId;

    return map;
  }

  Warranty.fromMapObject(Map<String, dynamic> map) {
    modelRefId = map['modelRefId'];
    stockRefId = map['stockRefId'];
    warrantyName = map['warrantyName'];
    warrantyExpiry = map['warrantyExpiry'];
    warrantyAttachment = map['warrantyAttachment'];
    sId = map['warrantyId'];
  }
}
/// <!-- Data Class for Asset Warranty Details --!> ///
