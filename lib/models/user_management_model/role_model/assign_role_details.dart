class AssignRoleDetails {
  String? roleTitle;
  late bool userReadFlag;
  late bool userWriteFlag;

  late bool ticketWriteFlag;
  late bool ticketReadFlag;
  late bool assetStockReadFlag;
  late bool assetStockWriteFlag;
  late bool assetTemplateWriteFlag;
  late bool assetTemplateReadFlag;
  late bool assetModelWriteFlag;
  late bool assetModelReadFlag;
  late bool assignRoleReadFlag;
  late bool assignRoleWriteFlag;

  late bool locationReadFlag;
  late bool locationWriteFlag;
  late bool vendorReadFlag;
  late bool vendorWriteFlag;
  late bool companyReadFlag;
  late bool companyWriteFlag;

  late bool locationMainFlag;

  late bool userMainFlag;
  late bool companyMainFlag;
  late bool vendorMainFlag;
  late bool ticketMainFlag;
  late bool assetTemplateMainFlag;
  late bool assetStockMainFlag;
  late bool assetModelMainFlag;
  late bool assignRoleMainFlag;
  String? sId;
  late bool assetTypeMainFlag;
  late bool assetTypeWriteFlag;
  late bool assetTypeReadFlag;
  late bool assetCategoryMainFlag;
  late bool assetCategoryWriteFlag;
  late bool assetCategoryReadFlag;
  late bool assetSubCategoryMainFlag;
  late bool assetSubCategoryWriteFlag;
  late bool assetSubCategoryReadFlag;

  AssignRoleDetails({
    this.sId,
    this.roleTitle,
    required this.userReadFlag,
    required this.userWriteFlag,
    required this.companyReadFlag,
    required this.companyWriteFlag,
    required this.vendorReadFlag,
    required this.vendorWriteFlag,
    required this.ticketWriteFlag,
    required this.ticketReadFlag,
    required this.assetStockReadFlag,
    required this.assetStockWriteFlag,
    required this.assetTemplateWriteFlag,
    required this.assetTemplateReadFlag,
    required this.assetModelWriteFlag,
    required this.assetModelReadFlag,
    required this.assignRoleReadFlag,
    required this.assignRoleWriteFlag,
    required this.locationReadFlag,
    required this.locationWriteFlag,
    required this.locationMainFlag,
    required this.userMainFlag,
    required this.companyMainFlag,
    required this.vendorMainFlag,
    required this.ticketMainFlag,
    required this.assetTemplateMainFlag,
    required this.assetModelMainFlag,
    required this.assetStockMainFlag,
    required this.assignRoleMainFlag,
    required this.assetTypeMainFlag,
    required this.assetTypeReadFlag,
    required this.assetTypeWriteFlag,
    required this.assetCategoryMainFlag,
    required this.assetCategoryReadFlag,
    required this.assetCategoryWriteFlag,
    required this.assetSubCategoryMainFlag,
    required this.assetSubCategoryReadFlag,
    required this.assetSubCategoryWriteFlag,
  });

  AssignRoleDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    roleTitle = json['roleTitle'] ?? false;
    userReadFlag = json['userReadFlag'] ?? false;
    userWriteFlag = json['userWriteFlag'] ?? false;
    companyReadFlag = json['companyReadFlag'] ?? false;
    companyWriteFlag = json['companyWriteFlag'] ?? false;
    vendorReadFlag = json['vendorReadFlag'] ?? false;
    vendorWriteFlag = json['vendorWriteFlag'] ?? false;
    ticketWriteFlag = json['ticketWriteFlag'] ?? false;
    ticketReadFlag = json['ticketReadFlag'] ?? false;
    assetStockReadFlag = json['assetStockReadFlag'] ?? false;
    assetStockWriteFlag = json['assetStockWriteFlag'] ?? false;
    assetTemplateWriteFlag = json['assetTemplateWriteFlag'] ?? false;
    assetTemplateReadFlag = json['assetTemplateReadFlag'] ?? false;
    assetModelWriteFlag = json['assetModelWriteFlag'] ?? false;
    assetModelReadFlag = json['assetModelReadFlag'] ?? false;
    assignRoleReadFlag = json['assignRoleReadFlag'] ?? false;
    assignRoleWriteFlag = json['assignRoleWriteFlag'] ?? false;
    locationReadFlag = json['locationReadFlag'] ?? false;
    locationWriteFlag = json['locationWriteFlag'] ?? false;
    locationMainFlag = json['locationMainFlag'] ?? false;
    userMainFlag = json['userMainFlag'] ?? false;
    companyMainFlag = json['companyMainFlag'] ?? false;
    vendorMainFlag = json['vendorMainFlag'] ?? false;
    ticketMainFlag = json['ticketMainFlag'] ?? false;
    assetTemplateMainFlag = json['assetTemplateMainFlag'] ?? false;
    assetStockMainFlag = json['assetStockMainFlag'] ?? false;
    assetModelMainFlag = json['assetModelMainFlag'] ?? false;
    assignRoleMainFlag = json['assignRoleMainFlag'] ?? false;
    assetTypeMainFlag = json['assetTypeMainFlag'] ?? false;
    assetTypeWriteFlag = json['assetTypeWriteFlag'] ?? false;
    assetTypeReadFlag = json['assetTypeReadFlag'] ?? false;
    assetCategoryMainFlag = json['assetCategoryMainFlag'] ?? false;
    assetCategoryReadFlag = json['assetCategoryReadFlag'] ?? false;
    assetCategoryWriteFlag = json['assetCategoryWriteFlag'] ?? false;
    assetSubCategoryMainFlag = json['assetSubCategoryMainFlag'] ?? false;
    assetSubCategoryReadFlag = json['assetSubCategoryReadFlag'] ?? false;
    assetSubCategoryWriteFlag = json['assetSubCategoryWriteFlag'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['roleTitle'] = roleTitle;
    data['userReadFlag'] = userReadFlag;
    data['userWriteFlag'] = userWriteFlag;
    data['companyReadFlag'] = companyReadFlag;
    data['companyWriteFlag'] = companyWriteFlag;
    data['vendorReadFlag'] = vendorReadFlag;
    data['vendorWriteFlag'] = vendorWriteFlag;
    data['ticketWriteFlag'] = ticketWriteFlag;
    data['ticketReadFlag'] = ticketReadFlag;
    data['assetStockReadFlag'] = assetStockReadFlag;
    data['assetStockWriteFlag'] = assetStockWriteFlag;
    data['assetTemplateWriteFlag'] = assetTemplateWriteFlag;
    data['assetTemplateReadFlag'] = assetTemplateReadFlag;
    data['assetModelWriteFlag'] = assetModelWriteFlag;
    data['assetModelReadFlag'] = assetModelReadFlag;
    data['assignRoleReadFlag'] = assignRoleReadFlag;
    data['assignRoleWriteFlag'] = assignRoleWriteFlag;
    data['locationReadFlag'] = locationReadFlag;
    data['locationWriteFlag'] = locationWriteFlag;
    data['locationMainFlag'] = locationMainFlag;
    data['userMainFlag'] = userMainFlag;
    data['ticketMainFlag'] = ticketMainFlag;
    data['companyMainFlag'] = companyMainFlag;
    data['vendorMainFlag'] = vendorMainFlag;
    data['assetTemplateMainFlag'] = assetTemplateMainFlag;
    data['assetStockMainFlag'] = assetStockMainFlag;
    data['assetModelMainFlag'] = assetModelMainFlag;
    data['assignRoleMainFlag'] = assignRoleMainFlag;
    data['assetTypeMainFlag'] = assetTypeMainFlag;
    data['assetTypeReadFlag'] = assetTypeReadFlag;
    data['assetTypeWriteFlag'] = assetTypeWriteFlag;
    data['assetCategoryMainFlag'] = assetCategoryMainFlag;
    data['assetCategoryReadFlag'] = assetCategoryReadFlag;
    data['assetCategoryWriteFlag'] = assetCategoryWriteFlag;
    data['assetSubCategoryMainFlag'] = assetSubCategoryMainFlag;
    data['assetSubCategoryReadFlag'] = assetSubCategoryReadFlag;
    data['assetSubCategoryWriteFlag'] = assetSubCategoryWriteFlag;
    return data;
  }

}
