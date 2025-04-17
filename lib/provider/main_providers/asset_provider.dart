import 'dart:convert';
import 'dart:developer';
import 'package:asset_management_local/models/asset_model/asset_model_model/asset_model_details.dart';
import 'package:asset_management_local/models/asset_model/asset_stock_model/asset_stock_details.dart';
import 'package:asset_management_local/models/asset_model/asset_type_model/asset_type_details.dart';
import 'package:flutter/material.dart';
import '../../global/global_variables.dart';
import '../../helpers/http_helper.dart';
import '../../helpers/ui_components.dart';
import '../../models/asset_model/asset_template_model/asset_template_details.dart';
import '../../models/dashboard_model/count_details.dart';
import '../../models/dashboard_model/notification_details.dart';
import '../../models/directory_model/company_model/company_details.dart';
import '../../models/directory_model/location_model/location_details.dart';
import '../../models/directory_model/vendor_model/vendor_details.dart';
import '../../models/ticket_model/ticket_details.dart';
import '../../models/user_management_model/role_model/assign_role_details.dart';
import '../../models/user_management_model/user_model/particular_user_model.dart';
import '../../models/user_management_model/user_model/user_details.dart';

/// <!-- Asset Providers --!> ///
class AssetProvider extends ChangeNotifier {
  /// <!-- Dashboard List --!> ///

  List<NotificationDetails> notificationDetailsList = <NotificationDetails>[];
  List<CountDetails> countDetailsList = <CountDetails>[];

  /// <!-- Dashboard List --!> ///

  /// <!-- Asset List --!> ///

  List<AssetTemplateDetails> templateDetailsList = <AssetTemplateDetails>[];
  List<AssetTemplateDetails> particularTemplateDetailsList =
      <AssetTemplateDetails>[];
  List<bool> selectedTemplates = [];

  List<AssetModelDetails> modelDetailsList = <AssetModelDetails>[];
  List<AssetModelDetails> particularModelDetailsList = <AssetModelDetails>[];
  List<bool> selectedModel = [];

  List<AssetTypeDetails> typeDetailsList = <AssetTypeDetails>[];
  List<AssetTypeDetails> sortedTypeDetailsList = <AssetTypeDetails>[];

  List<AssetCategoryDetails> categoryDetailsList = <AssetCategoryDetails>[];
  List<AssetCategoryDetails> particularCategoryDetailsList =
      <AssetCategoryDetails>[];
  List<AssetCategoryDetails> sortedCategoryDetailsList =
      <AssetCategoryDetails>[];

  List<AssetSubCategoryDetails> subCategoryDetailsList =
      <AssetSubCategoryDetails>[];
  List<AssetSubCategoryDetails> particularSubCategoryDetailsList =
      <AssetSubCategoryDetails>[];
  List<AssetSubCategoryDetails> sortedSubCategoryDetailsList =
      <AssetSubCategoryDetails>[];

  List<AssetStockDetails> stockDetailsList = <AssetStockDetails>[];
  List<AssetStockDetails> particularStockDetailsList = <AssetStockDetails>[];
  List<AssetStockDetails> sortedStockList = <AssetStockDetails>[];
  List<bool> selectedStocks = [];

  /// <!-- Asset List --!> ///

  /// <!-- User List --!> ///

  List<UserDetails> userDetailsList = <UserDetails>[];
  List<UserDetails> particularUserDetailsList = <UserDetails>[];
  List<UserDetails> ownUserDetailsList = <UserDetails>[];

  AssignRoleDetails userRole = AssignRoleDetails(
    roleTitle: 'user',
    userReadFlag: false,
    userWriteFlag: false,
    ticketWriteFlag: false,
    ticketReadFlag: true,
    assetStockReadFlag: true,
    assetStockWriteFlag: false,
    assetTemplateWriteFlag: false,
    assetTemplateReadFlag: false,
    assetModelWriteFlag: false,
    assetModelReadFlag: false,
    assignRoleReadFlag: false,
    assignRoleWriteFlag: false,
    locationReadFlag: false,
    locationWriteFlag: false,
    vendorReadFlag: false,
    vendorWriteFlag: false,
    companyReadFlag: false,
    companyWriteFlag: false,
    locationMainFlag: false,
    userMainFlag: false,
    companyMainFlag: false,
    vendorMainFlag: false,
    ticketMainFlag: false,
    assetTemplateMainFlag: false,
    assetStockMainFlag: false,
    assetModelMainFlag: false,
    assignRoleMainFlag: false,
    assetTypeMainFlag: false,
    assetTypeReadFlag: false,
    assetTypeWriteFlag: false,
    assetCategoryMainFlag: false,
    assetCategoryReadFlag: false,
    assetCategoryWriteFlag: false,
    assetSubCategoryMainFlag: false,
    assetSubCategoryReadFlag: false,
    assetSubCategoryWriteFlag: false,
  );

  List<AssignRoleDetails> fetchedRoleDetailsList = <AssignRoleDetails>[];
  List<AssignRoleDetails> updatedRoleDetailsList = <AssignRoleDetails>[];
  List<bool> selectedUsers = [];

  /// <!-- User List --!> ///

  /// <!-- Particular User List --!> ///

  ParticularUserDetails? particularUser;
  ParticularUserDetails? get user => particularUser;

  /// <!-- Particular User List --!> ///

  /// <!-- Ticket List --!> ///

  List<TicketDetails> ticketDetailsList = <TicketDetails>[];
  List<bool> selectedTickets = [];

  /// <!-- Ticket List --!> ///

  /// <!-- Directory List --!> ///

  List<CompanyDetails> companyDetailsList = <CompanyDetails>[];
  List<CompanyDetails> particularCompanyDetailsList = <CompanyDetails>[];
  List<bool> selectedCompanies = [];

  List<VendorDetails> vendorDetailsList = <VendorDetails>[];
  List<bool> selectedVendors = [];

  List<LocationDetails> locationDetailsList = <LocationDetails>[];
  List<LocationDetails> sortedLocationDetailsList = <LocationDetails>[];

  /// <!-- Directory List --!> ///

  /// <!-- Dashboard Provider --!> ///

  /// Fetch the Notification Details
  Future<List<NotificationDetails>> fetchNotificationDetails() async {
    try {
      var response =
          await HTTPService.post({}, {}, APIEndpoints.getNotificationDetails);
      response = jsonDecode(response);
      List<NotificationDetails> notificationList = <NotificationDetails>[];
      if (response.isNotEmpty) {
        if (response[0]) {
          Map map = response[1];
          if (map["msg"] == "Notification Query Succeeded") {
            for (int i = 0; i < map["data"]["allNotification"].length; i++) {
              NotificationDetails notificationDetails =
                  NotificationDetails.fromJson(
                      map["data"]["allNotification"][i]);

              notificationList.add(notificationDetails);
            }
            notificationDetailsList = List.from(notificationList);
            isApiCallInProgress = false;
            notifyListeners();
            return notificationDetailsList;
          }
        }
      }
      log("Unable to Show the Notification Details");
      isApiCallInProgress = false;
      return [];
    } catch (error) {
      log("Unable to Show the Notification Details");
      isApiCallInProgress = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Fetch the Count Details of Asset Count and Ticket Count
  Future<List<CountDetails>> fetchCountDetails() async {
    try {
      var response =
          await HTTPService.post({}, {}, APIEndpoints.getCountDetails);
      response = jsonDecode(response);
      if (response.isNotEmpty) {
        if (response[0]) {
          Map map = response[1];
          if (map["msg"] == "Count Query Succeeded") {
            var data = map["data"];
            CountDetails countDetails = CountDetails.fromJson(data);
            countDetailsList = [countDetails];
            notifyListeners();
            return countDetailsList;
          }
        }
      }
      log("Unable to Show the Count Details");
      return [];
    } catch (error) {
      log("Unable to Show the Count Details");
      notifyListeners();
      rethrow;
    }
  }

  /// <!-- Dashboard Provider --!> ///

  /// <!-- Asset Providers --!> ///

  /// Fetch All Stock Details
  Future<void> fetchStockDetails({String? assetStockId}) async {
    try {
      var response = await HTTPService.post(
          {'assetStockId': assetStockId}, {}, APIEndpoints.getStockDetails);
      List<AssetStockDetails> stockList = <AssetStockDetails>[];
      response = jsonDecode(response);

      if (response.isNotEmpty) {
        if (response[0]) {
          final map = response[1];

          if (map["msg"] == "Stock Query Succeeded") {
            List stock = map["data"]["allStock"] ?? [];

            for (int i = 0; i < stock.length; i++) {
              AssetStockDetails stockDetails =
                  AssetStockDetails.fromJson(stock[i]);

              stockList.add(stockDetails);
            }

            stockDetailsList = List.from(stockList);
            selectedStocks = List.filled(stockList.length, false);
            isApiCallInProgress = false;
            notifyListeners();
          }
        } else {
          showToast("Unable to Show the Stock Details");
          isApiCallInProgress = false;
        }
      } else {
        showToast("Unable to Show the Stock Details");
        isApiCallInProgress = false;
      }
    } catch (error) {
      showToast("Unable to Show the Stock Details");
      isApiCallInProgress = false;
      notifyListeners();
    }
  }

  /// Fetch Particular Stock Details
  Future<void> fetchParticularStockDetails(
      {required dynamic assetStockId}) async {
    try {
      List<String> stockIds = [];

      if (assetStockId is String) {
        stockIds.add(assetStockId);
      } else if (assetStockId is List<String>) {
        stockIds.addAll(assetStockId);
      } else {
        throw ArgumentError(
            'AssetStockId must be a string or a list of strings');
      }

      var response = await HTTPService.post({'assetStockId': stockIds}, {},
          APIEndpoints.getParticularStockDetails);
      response = jsonDecode(response);
      List<AssetStockDetails> particularStockList = <AssetStockDetails>[];
      if (response.isNotEmpty) {
        if (response[0]) {
          Map map = response[1];

          if (map["msg"] == "Stock Query Succeeded") {
            for (int i = 0; i < map["data"]["allStock"].length; i++) {
              AssetStockDetails particularStockDetails =
                  AssetStockDetails.fromJson(map["data"]["allStock"][i]);

              particularStockList.add(particularStockDetails);
            }

            particularStockDetailsList = List.from(particularStockList);
            isApiCallInProgress = false;
            notifyListeners();
          }
        } else {
          showToast("Unable to Show the Stock Details");
          isApiCallInProgress = false;
        }
      } else {
        showToast("Unable to Show the Stock Details");
        isApiCallInProgress = false;
      }
    } catch (error) {
      showToast("Unable to Show the Stock Details");
      isApiCallInProgress = false;
      notifyListeners();
    }
  }

  /// Fetch Model Details
  Future<void> fetchModelDetails() async {
    try {
      var response =
          await HTTPService.post({}, {}, APIEndpoints.getModelDetails);
      response = jsonDecode(response);
      List<AssetModelDetails> modelList = <AssetModelDetails>[];
      if (response.isNotEmpty) {
        if (response[0]) {
          Map map = response[1];
          if (map["msg"] == "Model Query Succeeded") {
            for (int i = 0; i < map["data"]["allModel"].length; i++) {
              AssetModelDetails modelDetails =
                  AssetModelDetails.fromJson(map["data"]["allModel"][i]);
              modelList.add(modelDetails);
            }
            modelDetailsList = List.from(modelList);
            selectedModel = List.filled(modelList.length, false);
            isApiCallInProgress = false;
            notifyListeners();
          }
        } else {
          showToast("Unable to Show the Model Details");
          isApiCallInProgress = false;
        }
      } else {
        showToast("Unable to Show the Model Details");
        isApiCallInProgress = false;
      }
    } catch (error) {
      showToast("Unable to Show the Model Details");
      isApiCallInProgress = false;
      notifyListeners();
    }
  }

  /// Fetch Particular Model Details
  Future<void> fetchParticularModelDetails({List<String>? assetModelId}) async {
    try {
      var response = await HTTPService.post(
          {'assetModelId': assetModelId}, {}, APIEndpoints.getModelDetails);
      response = jsonDecode(response);
      List<AssetModelDetails> particularModelList = <AssetModelDetails>[];
      if (response.isNotEmpty) {
        if (response[0]) {
          Map map = response[1];
          if (map["msg"] == "Model Query Succeeded") {
            for (int i = 0; i < map["data"]["allModel"].length; i++) {
              AssetModelDetails particularModelDetails =
                  AssetModelDetails.fromJson(map["data"]["allModel"][i]);
              particularModelList.add(particularModelDetails);
            }

            particularModelDetailsList = List.from(particularModelList);
            isApiCallInProgress = false;
            notifyListeners();
          }
        } else {
          isApiCallInProgress = false;
        }
      } else {
        isApiCallInProgress = false;
      }
    } catch (error) {
      isApiCallInProgress = false;
      notifyListeners();
    }
  }

  /// Fetch Template Details
  Future<void> fetchTemplateDetails() async {
    try {
      var response =
          await HTTPService.post({}, {}, APIEndpoints.getTemplateDetails);
      response = jsonDecode(response);
      List<AssetTemplateDetails> templateList = <AssetTemplateDetails>[];
      if (response.isNotEmpty) {
        if (response[0]) {
          Map map = response[1];
          if (map["msg"] == "Template Query Succeeded") {
            for (int i = 0; i < map["data"]["allTemplate"].length; i++) {
              AssetTemplateDetails templateDetails =
                  AssetTemplateDetails.fromJson(map["data"]["allTemplate"][i]);
              templateList.add(templateDetails);
            }

            templateDetailsList = List.from(templateList);
            selectedTemplates = List.filled(templateList.length, false);
            isApiCallInProgress = false;
            notifyListeners();
          }
        } else {
          showToast("Unable to Show the Template Details");
          isApiCallInProgress = false;
        }
      } else {
        showToast("Unable to Show the Template Details");
        isApiCallInProgress = false;
      }
    } catch (error) {
      showToast("Unable to Show the Template Details");
      isApiCallInProgress = false;
      notifyListeners();
    }
  }

  /// Fetch Particular Template Details
  Future<void> fetchParticularTemplateDetails(
      {List<String>? assetTemplateId}) async {
    try {
      var response = await HTTPService.post(
          {'assetTemplateId': assetTemplateId},
          {},
          APIEndpoints.getTemplateDetails);
      response = jsonDecode(response);
      List<AssetTemplateDetails> particularTemplateList =
          <AssetTemplateDetails>[];
      if (response.isNotEmpty) {
        if (response[0]) {
          Map map = response[1];
          if (map["msg"] == "Template Query Succeeded") {
            for (int i = 0; i < map["data"]["allTemplate"].length; i++) {
              AssetTemplateDetails particularTemplateDetails =
                  AssetTemplateDetails.fromJson(map["data"]["allModel"][i]);
              particularTemplateList.add(particularTemplateDetails);
            }

            particularTemplateList = List.from(particularTemplateDetailsList);
            isApiCallInProgress = false;
            notifyListeners();
          }
        } else {
          showToast("Unable to Show the Model Details");
          isApiCallInProgress = false;
        }
      } else {
        showToast("Unable to Show the Model Details");
        isApiCallInProgress = false;
      }
    } catch (error) {
      showToast("Unable to Show the Model Details");
      isApiCallInProgress = false;
      notifyListeners();
    }
  }

  /// Fetch Sub-Category Details
  Future<void> fetchSubCategoryDetails() async {
    try {
      var response =
          await HTTPService.post({}, {}, APIEndpoints.getSubCategoryDetails);
      response = jsonDecode(response);
      List<AssetSubCategoryDetails> subCategoryList =
          <AssetSubCategoryDetails>[];
      if (response.isNotEmpty) {
        if (response[0]) {
          Map map = response[1];
          if (map["msg"] == "SubCategory Query Succeeded") {
            for (int i = 0; i < map["data"]["allSubCategory"].length; i++) {
              AssetSubCategoryDetails subCategoryDetails =
                  AssetSubCategoryDetails.fromJson(
                      map["data"]["allSubCategory"][i]);
              subCategoryList.add(subCategoryDetails);
            }

            subCategoryDetailsList = List.from(subCategoryList);
            sortedSubCategoryDetailsList = List.from(subCategoryList);
            isApiCallInProgress = false;
            notifyListeners();
          }
        } else {
          showToast("Unable to Show the SubCategory Details");
          isApiCallInProgress = false;
        }
      } else {
        showToast("Unable to Show the SubCategory Details");
        isApiCallInProgress = false;
      }
    } catch (error) {
      showToast("Unable to Show the SubCategory Details");
      isApiCallInProgress = false;
      notifyListeners();
    }
  }

  /// Fetch Particular Sub-Category Details
  Future<void> fetchParticularSubCategoryDetails(
      {List<String>? subCategoryIds}) async {
    try {
      var response = await HTTPService.post({'subCategoryIds': subCategoryIds},
          {}, APIEndpoints.getSubCategoryDetails);
      response = jsonDecode(response);
      List<AssetSubCategoryDetails> particularSubCategoryList =
          <AssetSubCategoryDetails>[];
      if (response.isNotEmpty) {
        if (response[0]) {
          Map map = response[1];
          if (map["msg"] == "SubCategory Query Succeeded") {
            for (int i = 0; i < map["data"]["allSubCategory"].length; i++) {
              AssetSubCategoryDetails particularSubCategoryDetails =
                  AssetSubCategoryDetails.fromJson(
                      map["data"]["allSubCategory"][i]);
              particularSubCategoryList.add(particularSubCategoryDetails);
            }

            particularSubCategoryDetailsList =
                List.from(particularSubCategoryList);
            isApiCallInProgress = false;
            notifyListeners();
          }
        } else {
          showToast("Unable to Show the SubCategory Details");
          isApiCallInProgress = false;
        }
      } else {
        showToast("Unable to Show the SubCategory Details");
        isApiCallInProgress = false;
      }
    } catch (error) {
      showToast("Unable to Show the SubCategory Details");
      isApiCallInProgress = false;
      notifyListeners();
    }
  }

  /// Fetch Category Details
  Future<void> fetchCategoryDetails() async {
    try {
      var response =
          await HTTPService.post({}, {}, APIEndpoints.getCategoryDetails);
      response = jsonDecode(response);
      List<AssetCategoryDetails> categoryList = <AssetCategoryDetails>[];
      if (response.isNotEmpty) {
        if (response[0]) {
          Map map = response[1];
          if (map["msg"] == "Category Query Succeeded") {
            for (int i = 0; i < map["data"]["allCategory"].length; i++) {
              AssetCategoryDetails categoryDetails =
                  AssetCategoryDetails.fromJson(map["data"]["allCategory"][i]);
              categoryList.add(categoryDetails);
            }

            categoryDetailsList = List.from(categoryList);
            isApiCallInProgress = false;
            notifyListeners();
          }
        } else {
          showToast("Unable to Show the Category Details");
          isApiCallInProgress = false;
        }
      } else {
        showToast("Unable to Show the Category Details");
        isApiCallInProgress = false;
      }
    } catch (error) {
      showToast("Unable to Show the Category Details");
      isApiCallInProgress = false;
      notifyListeners();
    }
  }

  /// Fetch Category Details
  Future<void> fetchParticularCategoryDetails(
      {required List<String>? categoryIds}) async {
    try {
      var response = await HTTPService.post(
          {'categoryIds': categoryIds}, {}, APIEndpoints.getCategoryDetails);
      response = jsonDecode(response);
      List<AssetCategoryDetails> particularCategoryList =
          <AssetCategoryDetails>[];
      if (response.isNotEmpty) {
        if (response[0]) {
          Map map = response[1];
          if (map["msg"] == "Category Query Succeeded") {
            for (int i = 0; i < map["data"]["allCategory"].length; i++) {
              AssetCategoryDetails particularCategoryDetails =
                  AssetCategoryDetails.fromJson(map["data"]["allCategory"][i]);
              particularCategoryList.add(particularCategoryDetails);
            }

            particularCategoryDetailsList = List.from(particularCategoryList);
            isApiCallInProgress = false;
            notifyListeners();
          }
        } else {
          showToast("Unable to Show the Category Details");
          isApiCallInProgress = false;
        }
      } else {
        showToast("Unable to Show the Category Details");
        isApiCallInProgress = false;
      }
    } catch (error) {
      showToast("Unable to Show the Category Details");
      isApiCallInProgress = false;
      notifyListeners();
    }
  }

  /// Fetch Type Details
  Future<void> fetchTypeDetails({List<String>? typeIds}) async {
    try {
      var response = await HTTPService.post(
          {'typeIds': typeIds}, {}, APIEndpoints.getTypeDetails);
      response = jsonDecode(response);
      List<AssetTypeDetails> typeList = <AssetTypeDetails>[];
      if (response.isNotEmpty) {
        if (response[0]) {
          Map map = response[1];
          if (map["msg"] == "Type Query Succeeded") {
            for (int i = 0; i < map["data"]["types"].length; i++) {
              AssetTypeDetails typeDetails =
                  AssetTypeDetails.fromJson(map["data"]["types"][i]);
              typeList.add(typeDetails);
            }

            typeDetailsList = List.from(typeList);
            sortedTypeDetailsList = List.from(typeList);
            isApiCallInProgress = false;
            notifyListeners();
          }
        } else {
          showToast("Unable to Show the Type Details");
          isApiCallInProgress = false;
        }
      } else {
        showToast("Unable to Show the Type Details");
        isApiCallInProgress = false;
      }
    } catch (error) {
      showToast("Unable to Show the Type Details");
      isApiCallInProgress = false;
      notifyListeners();
    }
  }

  /// <!-- Asset Providers --!> ///

  /// <!-- User Providers --!> ///

  /// Fetch User Details
  Future<void> fetchUserDetails() async {
    try {
      var response =
          await HTTPService.post({}, {}, APIEndpoints.getUserDetails);
      response = jsonDecode(response);
      List<UserDetails> userList = <UserDetails>[];
      if (response.isNotEmpty) {
        if (response[0]) {
          Map map = response[1];
          if (map["msg"] == "User Found") {
            for (Map<String, dynamic> userJson in map["data"]["allUsers"]) {
              userList.add(UserDetails.fromJson(userJson));
            }
            userDetailsList = List.from(userList);
            selectedUsers = List.filled(userList.length, false);
            isApiCallInProgress = false;
            notifyListeners();
          }
        } else {
          showToast("Unable to Show the User Details");
          isApiCallInProgress = false;
        }
      } else {
        showToast("Unable to Show the User Details");
        isApiCallInProgress = false;
      }
    } catch (error) {
      showToast("Unable to Show the User Details");
      isApiCallInProgress = false;
      notifyListeners();
    }
  }

  /// Fetch Particular User Details
  Future<void> fetchParticularUserDetails(String userId) async {
    try {
      Map<String, dynamic> req = {"userId": userId};

      var response = await HTTPService.post(
          req, {}, APIEndpoints.getParticularUserDetails);
      response = jsonDecode(response);
      List<UserDetails> particularUserList = <UserDetails>[];
      if (response.isNotEmpty) {
        if (response[0]) {
          Map map = response[1];
          log(map.toString());
          if (map["msg"] == "User Login Successful") {
            for (Map<String, dynamic> userJson in map["data"]
                ["particularUser"]) {
              particularUserList.add(UserDetails.fromJson(userJson));

              log(particularUserList.toString());
            }
            particularUserDetailsList = List.from(particularUserList);
            isApiCallInProgress = false;
            notifyListeners();

            log(particularUserDetailsList.toString());
          }
        } else {
          showToast("Unable to Show the User Details");
          isApiCallInProgress = false;
        }
      } else {
        showToast("Unable to Show the User Details");
        isApiCallInProgress = false;
      }
    } catch (error) {
      showToast("Unable to Show the User Details");
      isApiCallInProgress = false;
      notifyListeners();
    }
  }

  Future<void> fetchOwnUserDetails({String? userId}) async {
    try {
      Map<String, dynamic> req = {"userId": userId};

      var response =
          await HTTPService.post(req, {}, APIEndpoints.getOwnUserDetails);
      response = jsonDecode(response);
      List<UserDetails> userList = <UserDetails>[];
      if (response.isNotEmpty) {
        if (response[0]) {
          Map map = response[1];
          if (map["msg"] == "User Found") {
            for (Map<String, dynamic> userJson in map["data"]["allUsers"]) {
              userList.add(UserDetails.fromJson(userJson));
            }
            ownUserDetailsList = List.from(userList);
            notifyListeners();
          }
        } else {
          showToast("Unable to Show the User Details");
        }
      } else {
        showToast("Unable to Show the User Details");
      }
    } catch (error) {
      showToast("Unable to Show the User Details");
      notifyListeners();
    }
  }

  /// Fetch Role Details
  Future<void> fetchRoleDetails() async {
    try {
      var response =
          await HTTPService.post({}, {}, APIEndpoints.getRoleDetails);
      response = jsonDecode(response);
      List<AssignRoleDetails> roleList = <AssignRoleDetails>[];
      if (response.isNotEmpty) {
        if (response[0]) {
          Map map = response[1];
          if (map["msg"] == "Roles Query Succeeded") {
            for (int i = 0; i < map["data"]["roles"].length; i++) {
              roleList.add(AssignRoleDetails.fromJson(map["data"]["roles"][i]));
            }
            fetchedRoleDetailsList = List.from(roleList);
            updatedRoleDetailsList = List.from(roleList);
            isApiCallInProgress = false;
            notifyListeners();
          }
        } else {
          showToast("Unable to Show the Role Details");
          isApiCallInProgress = false;
        }
      } else {
        showToast("Unable to Show the Role Details");
        isApiCallInProgress = false;
      }
    } catch (error) {
      showToast("Unable to Show the Role Details");
      isApiCallInProgress = false;
      notifyListeners();
    }
  }

  /// <!-- User Providers --!> ///

  /// <!-- Particular User Providers --!> ///

  void setUser(ParticularUserDetails newUser) {
    particularUser = newUser;
    notifyListeners();
  }

  /// <!-- Particular User Providers --!> ///

  /// <!-- Ticket Provider --!> ///

  /// Fetch the Ticket Details
  Future<void> fetchTicketDetails() async {
    try {
      var response =
          await HTTPService.post({}, {}, APIEndpoints.getTicketDetails);

      response = jsonDecode(response);

      List<TicketDetails> ticketList = <TicketDetails>[];

      if (response.isNotEmpty) {
        if (response[0]) {
          Map map = response[1];
          if (map["msg"] == "Ticket Query Succeeded") {
            for (int i = 0; i < map["data"]["allTicket"].length; i++) {
              TicketDetails ticketDetails =
                  TicketDetails.fromJson(map["data"]["allTicket"][i]);
              ticketList.add(ticketDetails);
            }

            ticketDetailsList = List.from(ticketList);
            selectedTickets = List.filled(ticketList.length, false);
            isApiCallInProgress = false;
            notifyListeners();
          }
        } else {
          showToast("Unable to Show the Ticket Details");
          isApiCallInProgress = false;
        }
      } else {
        showToast("Unable to Show the Ticket Details");
        isApiCallInProgress = false;
      }
    } catch (error) {
      showToast("Unable to Show the Ticket Details");
      isApiCallInProgress = false;
      notifyListeners();
    }
  }

  /// <!-- Ticket Provider --!> ///

  /// <!-- Directory Provider --!> ///

  /// Fetch the Company Details
  Future<void> fetchCompanyDetails() async {
    try {
      var response =
          await HTTPService.post({}, {}, APIEndpoints.getCompanyDetails);
      response = jsonDecode(response);
      List<CompanyDetails> companyList = <CompanyDetails>[];
      if (response.isNotEmpty) {
        if (response[0]) {
          Map map = response[1];
          if (map["msg"] == "Companies Query Succeeded") {
            for (int i = 0; i < map["data"]["companies"].length; i++) {
              CompanyDetails companyDetails =
                  CompanyDetails.fromJson(map["data"]["companies"][i]);
              companyList.add(companyDetails);
            }

            companyDetailsList = List.from(companyList);
            selectedCompanies = List.filled(companyList.length, false);
            isApiCallInProgress = false;
            notifyListeners();
          }
        } else {
          showToast("Unable to Show the Company Details");
          isApiCallInProgress = false;
        }
      } else {
        showToast("Unable to Show the Company Details");
        isApiCallInProgress = false;
      }
    } catch (error) {
      showToast("Unable to Show the Company Details");
      isApiCallInProgress = false;
      notifyListeners();
    }
  }

  /// Fetch the Particular Company Details
  Future<void> fetchParticularCompanyDetails(
      {required List<String>? companyIds}) async {
    try {
      var response = await HTTPService.post(
          {'companyIds': companyIds}, {}, APIEndpoints.getCompanyDetails);
      response = jsonDecode(response);
      List<CompanyDetails> particularCompanyList = <CompanyDetails>[];
      if (response.isNotEmpty) {
        if (response[0]) {
          Map map = response[1];
          if (map["msg"] == "Companies Query Succeeded") {
            for (int i = 0; i < map["data"]["companies"].length; i++) {
              CompanyDetails particularCompanyDetails =
                  CompanyDetails.fromJson(map["data"]["companies"][i]);
              particularCompanyList.add(particularCompanyDetails);
            }

            particularCompanyDetailsList = List.from(particularCompanyList);
            isApiCallInProgress = false;
            notifyListeners();
          }
        } else {
          showToast("Unable to Show the Company Details");
          isApiCallInProgress = false;
        }
      } else {
        showToast("Unable to Show the Company Details");
        isApiCallInProgress = false;
      }
    } catch (error) {
      showToast("Unable to Show the Company Details");
      isApiCallInProgress = false;
      notifyListeners();
    }
  }

  /// Fetch the Vendor Details
  Future<void> fetchVendorDetails() async {
    try {
      var response =
          await HTTPService.post({}, {}, APIEndpoints.getVendorDetails);
      response = jsonDecode(response);
      List<VendorDetails> vendorList = <VendorDetails>[];
      if (response.isNotEmpty) {
        if (response[0]) {
          Map map = response[1];
          if (map["msg"] == "Vendor Found") {
            for (int i = 0; i < map["data"]["allVendor"].length; i++) {
              vendorList
                  .add(VendorDetails.fromJson(map["data"]["allVendor"][i]));
            }
            vendorDetailsList = List.from(vendorList);
            selectedVendors = List.filled(vendorList.length, false);
            isApiCallInProgress = false;
            notifyListeners();
          } else {
            showToast("Unable to Show the Vendor Details");
            isApiCallInProgress = false;
          }
        } else {
          showToast("Unable to Show the Vendor Details");
          isApiCallInProgress = false;
        }
      }
    } catch (error) {
      showToast("Unable to Show the Vendor Details");
      isApiCallInProgress = false;
      notifyListeners();
    }
  }

  /// Fetch the Location Details
  Future<void> fetchLocationDetails() async {
    try {
      var response =
          await HTTPService.post({}, {}, APIEndpoints.getLocationDetails);
      response = jsonDecode(response);
      List<LocationDetails> locationList = <LocationDetails>[];
      if (response.isNotEmpty) {
        if (response[0]) {
          Map map = response[1];
          if (map["msg"] == "Location Found") {
            for (int i = 0; i < map["data"]["allLocation"].length; i++) {
              locationList
                  .add(LocationDetails.fromJson(map["data"]["allLocation"][i]));
            }
            locationDetailsList = List.from(locationList);
            sortedLocationDetailsList = List.from(locationList);
            notifyListeners();
          }
        } else {
          showToast("Unable to Show the Location Details");
          isApiCallInProgress = false;
        }
      } else {
        showToast("Unable to Show the Location Details");
        isApiCallInProgress = false;
      }
    } catch (error) {
      showToast("Unable to Show the Location Details");
      isApiCallInProgress = false;
      notifyListeners();
    }
  }

  /// <!-- Directory Provider --!> ///
}
/// <!-- Asset Providers --!> ///
