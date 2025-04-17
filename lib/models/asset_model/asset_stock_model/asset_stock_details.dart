/// <!-- Data Class for Asset Stock Details --!> ///
class AssetStockDetails {
  String? sId;
  String? image;
  String? assetName;
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
  List<String>? tag;
  List<String>? parameters;
  String? displayId;
  String? assignedTo;
  String? userRefId;
  String? createdAt;
  String? updatedAt;
  String? userEmpId;
  String? companyName;
  String? overAllStatus;
  List<String>? departments;
  List<String>? specRefId;
  List<String>? warrantyRefIds;
  List<AssetSpecification>? specifications;
  List<WarrantyDetails>? warrantyDetails;
  List<AssetCheckListDetails>? checkListDetails;

  AssetStockDetails({
    this.sId,
    this.image,
    this.assetName,
    this.assetRefId,
    this.locationName,
    this.locationRefId,
    this.ticketName,
    this.ticketRefId,
    this.vendorName,
    this.vendorRefId,
    this.serialNo,
    this.purchaseDate,
    this.warrantyPeriod,
    this.warrantyExpiry,
    this.issuedDateTime,
    this.remarks,
    this.tag,
    this.parameters,
    this.displayId = '',
    this.assignedTo,
    this.userRefId,
    this.createdAt,
    this.updatedAt,
    this.specifications,
    this.warrantyDetails,
    this.checkListDetails,
    this.userEmpId,
    this.companyName,
    this.departments,
    this.specRefId,
    this.warrantyRefIds,
    this.overAllStatus,
  });

  AssetStockDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    image = json['image'];
    assetName = json['assetName'];
    assetRefId = json['assetRefId'];
    vendorName = json['vendorName'];
    vendorRefId = json['vendorRefId'];
    locationName = json['locationName'];
    locationRefId = json['locationRefId'];
    ticketName = json['ticketName'];
    ticketRefId = json['ticketRefId'];
    serialNo = json['serialNo'];
    warrantyPeriod = json['warrantyPeriod'];
    purchaseDate = json['purchaseDate'];
    warrantyExpiry = json['warrantyExpiry'];
    issuedDateTime = json['issuedDateTime'];
    remarks = json['remarks'];
    tag = json['tag']?.cast<String>();
    parameters = json['parameters']?.cast<String>();
    displayId = json['displayId'];
    assignedTo = json['assignedTo'];
    userRefId = json['userRefId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userEmpId = json['userEmpId'];
    companyName = json['companyName'];
    overAllStatus = json['overAllStatus'];
    departments = json['departments']?.cast<String>();
    specRefId = json['specRefId']?.cast<String>();
    warrantyRefIds = json['warrantyRefIds']?.cast<String>();

    List<AssetSpecification> specs = [];
    if (json["specifications"] != null) {
      for (int i = 0; i < json["specifications"].length; i++) {
        AssetSpecification specification =
            AssetSpecification.fromJson(json["specifications"][i]);

        specs.add(specification);
      }
    }

    specifications = specs;

    List<WarrantyDetails> warranty = [];

    if (json["warrantyDetails"] != null) {
      for (int i = 0; i < json["warrantyDetails"].length; i++) {
        WarrantyDetails warranties =
            WarrantyDetails.fromJson(json["warrantyDetails"][i]);

        warranty.add(warranties);
      }
    }
    warrantyDetails = warranty;

    List<AssetCheckListDetails> checkList = [];

    if (json["checkListDetails"] != null) {
      for (int i = 0; i < json["checkListDetails"].length; i++) {
        AssetCheckListDetails checkLists =
            AssetCheckListDetails.fromJson(json["checkListDetails"][i]);

        checkList.add(checkLists);
      }
    }

    checkListDetails = checkList;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['_id'] = sId;
    data['image'] = image;
    data['assetName'] = assetName;
    data['assetRefId'] = assetRefId;
    data['vendorName'] = vendorName;
    data['vendorRefId'] = vendorRefId;
    data['locationName'] = locationName;
    data['locationRefId'] = locationRefId;
    data['ticketName'] = ticketName;
    data['ticketRefId'] = ticketRefId;
    data['serialNo'] = serialNo;
    data['issuedDateTime'] = issuedDateTime;
    data['purchaseDate'] = purchaseDate;
    data['warrantyPeriod'] = warrantyPeriod;
    data['warrantyExpiry'] = warrantyExpiry;
    data['remarks'] = remarks;
    data['tag'] = tag;
    data['parameters'] = parameters;
    data['displayId'] = displayId;
    data['assignedTo'] = assignedTo;
    data['userRefId'] = userRefId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['specifications'] = specifications;
    data['warrantyDetails'] = warrantyDetails;
    data['checkListDetails'] = checkListDetails;
    data['userEmpId'] = userEmpId;
    data['companyName'] = companyName;
    data['departments'] = departments;
    data['specRefId'] = specRefId;
    data['warrantyRefIds'] = warrantyRefIds;
    data['overAllStatus'] = overAllStatus;

    return data;
  }
}
/// <!-- Data Class for Asset Stock Details --!> ///

/// <!-- Data Class for Asset Specification Details --!> ///
class AssetSpecification {
  String? sId;
  String? key;
  String? value;
  String? modelRefId;
  String? templateRefId;

  AssetSpecification({
    this.sId,
    this.key,
    this.value,
    this.modelRefId,
    this.templateRefId,
  });

  AssetSpecification.fromJson(Map<String, dynamic> json) {
    sId = json['specId'];
    key = json['specKey'];
    value = json['specValue'];
    modelRefId = json['modelRefId'];
    templateRefId = json['templateRefId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['specId'] = sId;
    data['specKey'] = key;
    data['specValue'] = value;
    data['modelRefId'] = modelRefId;
    data['templateRefId'] = templateRefId;
    return data;
  }
}
/// <!-- Data Class for Asset Specification Details --!> ///

/// <!-- Data Class for Asset Warranty Details --!> ///
class WarrantyDetails {
  String? stockRefId;
  String? modelRefId;
  String? warrantyExpiry;
  String? warrantyName;
  String? warrantyAttachment;
  String? sId;

  WarrantyDetails(
      {this.stockRefId,
      this.modelRefId,
      this.warrantyExpiry,
      this.warrantyName,
      this.warrantyAttachment,
      this.sId});

  WarrantyDetails.fromJson(Map<String, dynamic> json) {
    modelRefId = json['modelRefId'];
    stockRefId = json['stockRefId'];
    warrantyExpiry = json['warrantyExpiry'];
    warrantyName = json['warrantyName'];
    warrantyAttachment = json['warrantyAttachment'];
    sId = json['warrantyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['modelRefId'] = modelRefId;
    data['stockRefId'] = stockRefId;
    data['warrantyExpiry'] = warrantyExpiry;
    data['warrantyName'] = warrantyName;
    data['warrantyAttachment'] = warrantyAttachment;
    data['warrantyId'] = sId;

    return data;
  }
}
/// <!-- Data Class for Asset Specification Details --!> ///

/// <!-- Data Class for Asset Checklist Details --!> ///
class AssetCheckListDetails {
  String? entryName;
  String? functionalFlag;
  String? remarks;
  String? checkListId;
  String? overAllStatus;

  AssetCheckListDetails(
      {this.entryName, this.functionalFlag, this.remarks, this.checkListId,this.overAllStatus});

  AssetCheckListDetails.fromJson(Map<String, dynamic> json) {
    entryName = json['name'];
    functionalFlag = json['status'];
    remarks = json['remarks'];
    checkListId = json['checkListId'];
    overAllStatus = json['overAllStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['name'] = entryName;
    data['status'] = functionalFlag;
    data['remarks'] = remarks;
    data['checkListId'] = checkListId;
    data['overAllStatus'] = overAllStatus;

    return data;
  }
}
/// <!-- Data Class for Asset Checklist Details --!> ///
