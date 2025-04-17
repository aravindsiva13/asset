/// <!-- Data Class for Asset Stock --!> ///
class AssetStock {
  String? assetName;
  String? image;
  String? assetRefId;
  String? locationName;
  String? locationRefId;
  String? ticketName;
  String? ticketRefId;
  String? vendorName;
  String? vendorRefId;
  String? serialNo;
  String? purchaseDate;
  String? warrantyPeriod;
  String? warrantyExpiry;
  String? issuedDateTime;
  String? remarks;
  List? tag;
  String? displayId;
  String? assignedTo;
  String? userRefId;
  List<String>? specRefId;
  List<String>? warrantyRefIds;
  String? sId;

  AssetStock({
    this.image,
    this.assetName,
    this.assetRefId,
    this.locationName,
    this.locationRefId,
    this.issuedDateTime,
    this.ticketName,
    this.vendorName,
    this.vendorRefId,
    this.serialNo,
    this.ticketRefId,
    this.remarks,
    this.tag,
    this.purchaseDate,
    this.warrantyPeriod,
    this.warrantyExpiry,
    this.displayId = '',
    this.assignedTo,
    this.userRefId,
    this.specRefId,
    this.warrantyRefIds,
    this.sId,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['image'] = image;
    map['assetName'] = assetName;
    map['assetRefId'] = assetRefId;
    map['locationName'] = locationName;
    map['locationRefId'] = locationRefId;
    map['issuedDateTime'] = issuedDateTime;
    map['purchaseDate'] = purchaseDate;
    map['warrantyPeriod'] = warrantyPeriod;
    map['warrantyExpiry'] = warrantyExpiry;
    map['vendorName'] = vendorName;
    map['vendorRefId'] = vendorRefId;
    map['serialNo'] = serialNo;
    map['ticketName'] = ticketName;
    map['ticketRefId'] = ticketRefId;
    map['remarks'] = remarks;
    map['tag'] = tag;
    map['displayId'] = displayId;
    map['assignedTo'] = assignedTo;
    map['userRefId'] = userRefId;
    map['specRefId'] = specRefId;
    map['warrantyRefIds'] = warrantyRefIds;
    map['sId'] = sId;

    return map;
  }

  AssetStock.fromMapObject(Map<String, dynamic> map) {
    image = map["image"];
    assetName = map["assetName"];
    assetRefId = map["assetRefId"];
    vendorName = map["vendorName"];
    vendorRefId = map["vendorRefId"];
    locationRefId = map["locationRefId"];
    locationName = map["locationName"];
    ticketRefId = map["ticketRefId"];
    ticketName = map["ticketName"];
    serialNo = map["serialNo"];
    purchaseDate = map["purchaseDate"];
    warrantyPeriod = map["warrantyPeriod"];
    warrantyExpiry = map["warrantyExpiry"];
    issuedDateTime = map["issuedDateTime"];
    remarks = map["remarks"];
    tag = map["tag"];
    displayId = map["displayId"];
    assignedTo = map["assignedTo"];
    userRefId = map["userRefId"];
    specRefId = map["specRefId"];
    warrantyRefIds = map["warrantyRefIds"];
    sId = map["sId"];
  }
}
/// <!-- Data Class for Asset Stock --!> ///