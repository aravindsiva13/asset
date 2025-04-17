// class AssignRoles {
//   String? roleTitle;
//   late bool userReadFlag;
//   late bool userWriteFlag;
//   late bool companyReadFlag;
//   late bool companyWriteFlag;
//   late bool vendorReadFlag;
//   late bool vendorWriteFlag;
//   late bool ticketReadFlag;
//   late bool ticketWriteFlag;
//   late bool assetTemplateReadFlag;
//   late bool assetTemplateWriteFlag;
//   late bool assetStockReadFlag;
//   late bool assetStockWriteFlag;
//   late bool assetModelReadFlag;
//   late bool assetModelWriteFlag;
//   late bool assignRoleReadFlag;
//   late bool assignRoleWriteFlag;
//   late bool locationReadFlag;
//   late bool locationWriteFlag;
//   late bool? locationMainFlag;
//   late bool? userMainFlag;
//   late bool? companyMainFlag;
//   late bool? vendorMainFlag;
//   late bool? ticketMainFlag;
//   late bool? assetTemplateMainFlag;
//   late bool? assetStockMainFlag;
//   late bool? assetModelMainFlag;
//   late bool? assignRoleMainFlag;
//   late bool? assetTypeMainFlag;
//   late bool? assetTypeWriteFlag;
//   late bool? assetTypeReadFlag;
//   late bool? assetCategoryMainFlag;
//   late bool? assetCategoryWriteFlag;
//   late bool? assetCategoryReadFlag;
//   late bool? assetSubCategoryMainFlag;
//   late bool? assetSubCategoryWriteFlag;
//   late bool? assetSubCategoryReadFlag;
//   String? sId;
//
//   AssignRoles(
//       {
//       this.roleTitle,
//       required this.userReadFlag,
//       required this.userWriteFlag,
//       required this.companyReadFlag,
//       required this.companyWriteFlag,
//       required this.vendorReadFlag,
//       required this.vendorWriteFlag,
//       required this.ticketReadFlag,
//       required this.ticketWriteFlag,
//       required this.assetStockReadFlag,
//       required this.assetStockWriteFlag,
//       required this.assetModelReadFlag,
//       required this.assetModelWriteFlag,
//       required this.assetTemplateReadFlag,
//       required this.assetTemplateWriteFlag,
//       required this.assignRoleReadFlag,
//       required this.assignRoleWriteFlag,
//       required this.locationReadFlag,
//       required this.locationWriteFlag,
//       required this.locationMainFlag,
//       required this.userMainFlag,
//       required this.companyMainFlag,
//       required this.vendorMainFlag,
//       required this.ticketMainFlag,
//       required this.assetTemplateMainFlag,
//       required this.assetModelMainFlag,
//       required this.assetStockMainFlag,
//       required this.assignRoleMainFlag,
//       required this.assetTypeMainFlag,
//       required this.assetTypeReadFlag,
//       required this.assetTypeWriteFlag,
//       required this.assetCategoryMainFlag,
//       required this.assetCategoryReadFlag,
//       required this.assetCategoryWriteFlag,
//       required this.assetSubCategoryMainFlag,
//       required this.assetSubCategoryReadFlag,
//       required this.assetSubCategoryWriteFlag,
//         this.sId
//          });
//
//   Map<String, dynamic> toMap() {
//     var map = <String, dynamic>{};
//
//     map['roleTitle'] = roleTitle;
//     map['userReadFlag'] = userReadFlag;
//     map['userWriteFlag'] = userWriteFlag;
//     map['companyReadFlag'] = companyReadFlag;
//     map['companyWriteFlag'] = companyWriteFlag;
//     map['vendorReadFlag'] = vendorReadFlag;
//     map['vendorWriteFlag'] = vendorWriteFlag;
//     map['ticketWriteFlag'] = ticketWriteFlag;
//     map['ticketReadFlag'] = ticketReadFlag;
//     map['assetStockReadFlag'] = assetStockReadFlag;
//     map['assetStockWriteFlag'] = assetStockWriteFlag;
//     map['assetTemplateWriteFlag'] = assetTemplateWriteFlag;
//     map['assetTemplateReadFlag'] = assetTemplateReadFlag;
//     map['assetModelWriteFlag'] = assetModelWriteFlag;
//     map['assetModelReadFlag'] = assetModelReadFlag;
//     map['assignRoleReadFlag'] = assignRoleReadFlag;
//     map['assignRoleWriteFlag'] = assignRoleWriteFlag;
//     map['locationReadFlag'] = locationReadFlag;
//     map['locationWriteFlag'] = locationWriteFlag;
//     map['locationMainFlag'] = locationMainFlag;
//     map['userMainFlag'] = userMainFlag;
//     map['ticketMainFlag'] = ticketMainFlag;
//     map['companyMainFlag'] = companyMainFlag;
//     map['vendorMainFlag'] = vendorMainFlag;
//     map['assetTemplateMainFlag'] = assetTemplateMainFlag;
//     map['assetStockMainFlag'] = assetStockMainFlag;
//     map['assetModelMainFlag'] = assetModelMainFlag;
//     map['assignRoleMainFlag'] = assignRoleMainFlag;
//     map['assetTypeMainFlag'] = assetTypeMainFlag;
//     map['assetTypeReadFlag'] = assetTypeReadFlag;
//     map['assetTypeWriteFlag'] = assetTypeWriteFlag;
//     map['assetCategoryMainFlag'] = assetCategoryMainFlag;
//     map['assetCategoryReadFlag'] = assetCategoryReadFlag;
//     map['assetCategoryWriteFlag'] = assetCategoryWriteFlag;
//     map['assetSubCategoryMainFlag'] = assetSubCategoryMainFlag;
//     map['assetSubCategoryReadFlag'] = assetSubCategoryReadFlag;
//     map['assetSubCategoryWriteFlag'] = assetSubCategoryWriteFlag;
//     map['sId'] = sId;
//
//     return map;
//   }
//
//   AssignRoles.fromMapObject(Map<String, dynamic> map) {
//     roleTitle = map['roleTitle'];
//     userReadFlag = map['userReadFlag'];
//     userWriteFlag = map['userWriteFlag'];
//     companyReadFlag = map['companyReadFlag'];
//     companyWriteFlag = map['companyWriteFlag'];
//     vendorReadFlag = map['vendorReadFlag'];
//     vendorWriteFlag = map['vendorWriteFlag'];
//     ticketWriteFlag = map['ticketWriteFlag'];
//     ticketReadFlag = map['ticketReadFlag'];
//     assetStockReadFlag = map['assetStockReadFlag'];
//     assetStockWriteFlag = map['assetStockWriteFlag'];
//     assetTemplateWriteFlag = map['assetTemplateWriteFlag'];
//     assetTemplateReadFlag = map['assetTemplateReadFlag'];
//     assetModelWriteFlag = map['assetModelWriteFlag'];
//     assetModelReadFlag = map['assetModelReadFlag'];
//     assignRoleReadFlag = map['assignRoleReadFlag'];
//     assignRoleWriteFlag = map['assignRoleWriteFlag'];
//     locationReadFlag = map['locationReadFlag'];
//     locationMainFlag = map['locationMainFlag'];
//     userMainFlag = map['userMainFlag'];
//     companyMainFlag = map['companyMainFlag'];
//     vendorMainFlag = map['vendorMainFlag'];
//     ticketMainFlag = map['ticketMainFlag'];
//     assetTemplateMainFlag = map['assetTemplateMainFlag'];
//     assetStockMainFlag = map['assetStockMainFlag'];
//     assetModelMainFlag = map['assetModelMainFlag'];
//     assignRoleMainFlag = map['assignRoleMainFlag'];
//     assetTypeMainFlag = map['assetTypeMainFlag'];
//     assetTypeReadFlag = map['assetTypeReadFlag'];
//     assetTypeWriteFlag = map['assetTypeWriteFlag'];
//     assetCategoryMainFlag = map['assetCategoryMainFlag'];
//     assetCategoryReadFlag = map['assetCategoryReadFlag'];
//     assetCategoryWriteFlag = map['assetCategoryWriteFlag'];
//     assetSubCategoryMainFlag = map['assetSubCategoryMainFlag'];
//     assetSubCategoryReadFlag = map['assetSubCategoryReadFlag'];
//     assetSubCategoryWriteFlag = map['assetSubCategoryWriteFlag'];
//     sId = map['sId'];
//   }
// }
