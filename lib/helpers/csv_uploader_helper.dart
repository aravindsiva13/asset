import 'package:asset_management_local/helpers/ui_components.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import '../models/user_management_model/user_model/user_model.dart';
import '../provider/main_providers/asset_provider.dart';
import '../provider/other_providers/bool_provider.dart';
import 'csv_file_handler.dart';
import 'http_helper.dart';

/// CSV Uploader ///
class CsvUploader {
  PlatformFile? imagePicked;
  String? selectedFileName;

  Future<void> pickCSVFile(BuildContext context, StateSetter dialogSetState,
      {required List<String> allowedExtension}) async {
    BoolProvider themeProvider =
    Provider.of<BoolProvider>(context, listen: false);

    AssetProvider userProvider =
    Provider.of<AssetProvider>(context, listen: false);

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: allowedExtension,
      );

      if (result != null) {
        PlatformFile filePicked = result.files.first;

        String fileName = filePicked.name;

        dialogSetState(() {
          selectedFileName = fileName;
        });

        List<List<dynamic>> csvData;

        if (filePicked.bytes != null) {
          List<int> fileBytes = filePicked.bytes!;
          String csvContent = utf8.decode(fileBytes);
          csvData = const CsvToListConverter().convert(csvContent);
        } else if (filePicked.path != null) {
          File csvFile = File(filePicked.path!);
          csvData = await CsvFileHandler.loadCSV(csvFile);
        } else {
          log("Error: Both filePicked.bytes and filePicked.path are null");
          return;
        }
        List<Users> users = parseCSVData(csvData);

        Set<String> addedUsers = {};
        List<Users> usersToAdd = [];

        for (Users user in users) {
          try {
            if (!addedUsers.contains(user.name)) {
              usersToAdd.add(user);
              addedUsers.add(user.name);
            }
          } catch (e) {
            log('Error: $e');
          }
        }

        if (usersToAdd.isNotEmpty) {
          try {
            var response = await addUserBulk(
                usersToAdd, themeProvider, userProvider, dialogSetState);
            if (response['failedUsers'] != null &&
                response['failedUsers']!.isNotEmpty) {
              showFailedUsersDialog(
                  context, response['failedUsers'] as List<dynamic>,
                  themeProvider);
            } else {
              showToast("All users added successfully.");
            }
          } catch (e) {
            log('Error while adding users in bulk: $e');
          }
        }
      } else {
        log("File picking canceled");
      }
    } catch (e) {
      log("Error: $e");
    }
  }


  List<Users> parseCSVData(List<List<dynamic>> csvData) {
    List<Users> users = [];

    List<String> requiredParameters = [
      'name',
      'employeeId',
      'email',
      'phoneNumber',
      'dateOfJoining',
      'designation',
      'password',
      'companyRefId',
      'assignRoleRefIds'
    ];

    List<dynamic> parameters = csvData[0];

    for (String param in requiredParameters) {
      if (!parameters.contains(param)) {
        showToast(
            "CSV format is incorrect. Missing required parameter: $param");
        return [];
      }
    }

    for (var i = 1; i < csvData.length; i++) {
      var row = csvData[i];

      if (row.every(
              (element) =>
          element == null || element
              .toString()
              .trim()
              .isEmpty)) {
        continue;
      }

      Map<String, dynamic> rowMap = {};

      for (var j = 0; j < parameters.length; j++) {
        rowMap[parameters[j]] = row[j];
      }

      String csvDate = rowMap['dateOfJoining'];
      String formattedDate = csvDate.replaceAll("-", "/");

      Users user = Users(
          name: rowMap['name'],
          employeeId: rowMap['employeeId'],
          email: rowMap['email'],
          phoneNumber: rowMap['phoneNumber'].toString(),
          dateOfJoining: formattedDate,
          designation: rowMap['designation'],
          password: rowMap['password'],
          department: rowMap['department']?.split(','),
          companyRefId: rowMap['companyRefId'],
          assignRoleRefIds: rowMap['assignRoleRefIds']?.split(','),
          tag: []);

      users.add(user);
    }
    return users;
  }

  /// <!-- Send the user details to the backend via the API --!> ///
  Future<Map<String, List<Users>>> addUserBulk(List<Users> user,
      BoolProvider boolProviders,
      AssetProvider userProvider, StateSetter dialogSetState) async {
    List<Users> failedUsers = [];

    await AddBulkDetailsManager(
      data: user,
      image: imagePicked,
      apiURL: 'user/addBulkUser',
    ).addBulkDetails(boolProviders);

    if (boolProviders.toastMessages) {
      dialogSetState(() {
        log("User Added Successfully");
        userProvider.fetchUserDetails();
      });
    } else {
      dialogSetState(() {
        showToast("Unable to add the user");
        failedUsers = user;
      });
    }
    return {
      'failedUsers': failedUsers,
    };
  }
  /// <!-- Send the user details to the backend via the API --!> ///


  /// Display the non-added users in a dialog ///
  showFailedUsersDialog(BuildContext context, List<dynamic> failedUsers,
       BoolProvider themeProvider) {
    List<TableRow> tableRows = [
      TableRow(
        decoration: BoxDecoration(
          color: themeProvider.isDarkTheme ? Colors.grey[850] : Colors
              .grey[300],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "User Data",
              style: TextStyle(
                color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Error Message",
              style: TextStyle(
                color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ];

    // Add rows for each failed user
    for (var user in failedUsers) {
      tableRows.add(
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                user['filteredUserData']?.toString() ??
                    user['userData'].toString(),
                style: TextStyle(
                  color: themeProvider.isDarkTheme ? Colors.white : Colors
                      .black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                user['ErrorMsg'],
                style: TextStyle(
                  color: themeProvider.isDarkTheme ? Colors.white : Colors
                      .black,
                ),
              ),
            ),
          ],
        ),
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
          themeProvider.isDarkTheme ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "Failed to Add Users",
              style: TextStyle(
                color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Table(
              border: TableBorder.all(
                borderRadius: BorderRadius.circular(10),
                color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
              ),
              children: tableRows,
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text(
                "Retry",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                try {
                  // Retry logic if necessary
                } catch (e) {
                  log('Error while retrying: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }
  /// Display the non-added users in a dialog ///
}
/// CSV Uploader ///
