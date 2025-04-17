import 'dart:convert';
import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import '../global/global_variables.dart';
import 'package:asset_management_local/helpers/secure_storage_service.dart';
import '../provider/other_providers/bool_provider.dart';

/// <!-- HTTP Service --!> ///
class HTTPService {
  static final HTTPService _instance = HTTPService._internal();

  factory HTTPService() => _instance;
  HTTPService._internal();

  static String apiUrl = "$websiteURL/";
  static var baseHeader = {
    'Authorization': 'apiitambackend',
    'Content-Type': 'application/json',
  };

  static post(Map<String, dynamic> request, Map<String, String> header,
      endPointURL) async {
    var headers = await getHeadersForJSON();

    Map<String, String> temp = headers;
    if (header.isNotEmpty) {
      temp.addAll(header);
    }
    var requestPacket = http.Request('POST', Uri.parse('$apiUrl$endPointURL'));

    requestPacket.body = json.encode(request);
    requestPacket.headers.addAll(temp);
    http.StreamedResponse response = await requestPacket.send();
    final apiResponse = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return apiResponse;
    } else {
      log(response.reasonPhrase.toString());
      return apiResponse;
    }
  }
}
/// <!-- HTTP Service --!> ///

/// <!-- API End Points --!> ///
class APIEndpoints {
  /// Get the Company Details EndPoints
  static const getCompanyDetails = "company/companyDetails";

  /// Get the Vendor Details EndPoints
  static const getVendorDetails = "vendor/vendorDetails";

  /// Get the Role Details EndPoints
  static const getRoleDetails = "user/roleDetails";

  /// Get the Location Details EndPoints
  static const getLocationDetails = "location/locationDetails";

  /// Get the User Details EndPoints
  static const getUserDetails = "user/userDetails";
  static const getParticularUserDetails = "user/login";
  static const getOwnUserDetails = "user/particularUser";

  /// Get the Asset Template Details
  static const getTemplateDetails = "template/templateDetails";

  /// Get the Asset Model Details
  static const getModelDetails = "model/modelDetails";

  /// Get the Asset Type Details
  static const getTypeDetails = "type/typeDetails";

  /// Get the Asset Category Details
  static const getCategoryDetails = "category/categoryDetails";

  /// Get the Asset Sub-Category Details
  static const getSubCategoryDetails = "subCategory/subCategoryDetails";

  /// Get the Asset Stock Details
  static const getStockDetails = "stock/stockDetails";
  static const getParticularStockDetails = "stock/particularStockDetails";

  /// Get the Ticket Details
  static const getTicketDetails = "ticket/ticketDetails";

  /// Get Dashboard Details URL
  static const getNotificationDetails = "ticket/notification";
  static const getCountDetails = "ticket/countDetails";
}
/// <!-- API End Points --!> ///

/// Headers for API without image or file ///
Future<Map<String, String>> getHeadersForJSON() async {
  String? token = await SecureStorageManager.getToken();

  if (token != null) {
    return {
      'Authorization': token,
      'Content-Type': 'application/json',
    };
  } else {
    return {
      'Content-Type': 'application/json',
    };
  }
}

/// Headers for API with image or file
Future<Map<String, String>> getHeadersForFormData() async {
  String? token = await SecureStorageManager.getToken();

  if (token != null) {
    return {'Authorization': token, 'Content-Type': 'multipart/form-data'};
  } else {
    return {'Content-Type': 'multipart/form-data'};
  }
}

/// <!-- API CLASS --!> ///
/// Add & Update the details to the db through API without Image & File
class AddUpdateDetailsManager {
  final dynamic data;
  late String apiURL;

  AddUpdateDetailsManager({
    required this.data,
    required this.apiURL,
  });

  Future<void> addUpdateDetails(BoolProvider boolProvider) async {
    var headers = await getHeadersForJSON();

    try {
      var request = http.Request('POST', Uri.parse('$websiteURL/$apiURL'));

      request.body = json.encode(data.toMap());
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        boolProvider.setToastVisibility(true);
        log(await response.stream.bytesToString());
      } else {
        boolProvider.setToastVisibility(false);
        log(response.reasonPhrase.toString());
      }
    } catch (e) {
      log('Error: $e'.toString());
    }
  }
}

/// Add & Update the details to the db through API with Image
class AddUpdateDetailsManagerWithImage {
  final dynamic data;
  late String apiURL;
  PlatformFile? image;

  AddUpdateDetailsManagerWithImage({
    required this.data,
    required this.image,
    required this.apiURL,
  });

  Future<void> addUpdateDetailsWithImages(BoolProvider boolProvider) async {
    var headers = await getHeadersForFormData();

    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$websiteURL/$apiURL'));

      request.fields['jsonData'] = json.encode(data.toMap());

      request.headers.addAll(headers);

      if (image != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            image!.bytes!,
            filename: image!.name,
          ),
        );
      }

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        boolProvider.setToastVisibility(true);
        log(await response.stream.bytesToString());
      } else {
        boolProvider.setToastVisibility(false);
        log(response.reasonPhrase.toString());
      }
    } catch (e) {
      log('Error: $e'.toString());
    }
  }
}

/// Add & Update the details to the db through API with File
class AddUpdateDetailsManagerWithFile {
  final dynamic data;
  late String apiURL;
  PlatformFile? file;

  AddUpdateDetailsManagerWithFile({
    required this.data,
    required this.file,
    required this.apiURL,
  });

  Future<void> addUpdateDetailsWithFile(BoolProvider boolProvider) async {
    var headers = await getHeadersForFormData();

    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$websiteURL/$apiURL'));

      request.fields['jsonData'] = json.encode(data.toMap());

      request.headers.addAll(headers);

      if (file != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'attachment',
            file!.bytes!,
            filename: file!.name,
          ),
        );
      }

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        boolProvider.setToastVisibility(true);
        log(await response.stream.bytesToString());
      } else {
        boolProvider.setToastVisibility(false);
        log(response.reasonPhrase.toString());
      }
    } catch (e) {
      log('Error: $e'.toString());
    }
  }
}

/// Add the bulk details to the db through API with File
class AddBulkDetailsManager {
  final dynamic data;
  late String apiURL;
  PlatformFile? image;

  AddBulkDetailsManager({
    required this.data,
    required this.image,
    required this.apiURL,
  });

  Future<void> addBulkDetails(BoolProvider boolProvider) async {
    var headers = await getHeadersForFormData();

    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$websiteURL/$apiURL'));

      final jsonData = jsonEncode(data.map((data) => data.toMap()).toList());
      request.fields['jsonData'] = jsonData;

      request.headers.addAll(headers);

      if (image != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            image!.bytes!,
            filename: image!.name,
          ),
        );
      }

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        boolProvider.setToastVisibility(true);
        log(await response.stream.bytesToString());
      } else {
        boolProvider.setToastVisibility(false);
        log(response.reasonPhrase.toString());
      }
    } catch (e) {
      log('Error: $e'.toString());
    }
  }
}

/// Delete the details to the db through API
class DeleteDetailsManager {
  late String id;
  late String apiURL;

  DeleteDetailsManager({
    required this.id,
    required this.apiURL,
  });

  Future<void> deleteDetails(BoolProvider boolProvider) async {
    var headers = await getHeadersForJSON();

    try {
      var request = http.Request('POST', Uri.parse('$websiteURL/$apiURL'));

      request.body = json.encode({
        "id": id,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        boolProvider.setToastVisibility(true);
        log(await response.stream.bytesToString());
      } else {
        boolProvider.setToastVisibility(false);
        log(response.reasonPhrase.toString());
      }
    } catch (e) {
      log('Error: $e');
    }
  }
}
/// <!-- API CLASS --!> ///
