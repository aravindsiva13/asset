import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../global/global_variables.dart';
import '../global/user_interaction_timer.dart';
import 'global_helper.dart';

/// To Handle Visibility of User Dropdown ///
List<bool> isDropDownUserList = [false, false, false, false];

/// To Handle Visibility of Asset Dropdown ///
List<bool> isDropDownOpenAssetList = [
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false
];

/// To Handle Visibility of Roles ///
List<bool> openRole = [
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false
];

/// To Handle Visibility of Admin Ticket Dropdown ///
List<bool> isDropDownOpenTicketList = [
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
];

/// To Handle Visibility of User Ticket Dropdown ///
List<bool> isDropDownOpenTicketListForUser = [false];

/// To Handle Visibility of Directory Dropdown ///
List<bool> isExpansionDirectoryList = [
  false,
  false,
  false,
  false,
  false,
  false,
  false
];

/// To Handle Visibility of Location Dropdown ///
List<bool> isExpansionLocationList = [false];

/// Handle the dropdown functionality for closing ///
closeDropDown(StateSetter dialogSetState) {
  if (isDropDownUserList[0]) {
    dialogSetState(() {
      isDropDownUserList[0] = false;
    });
  } else if (isDropDownUserList[1]) {
    dialogSetState(() {
      isDropDownUserList[1] = false;
    });
  } else if (isDropDownUserList[2]) {
    dialogSetState(() {
      isDropDownUserList[2] = false;
    });
  } else if (isDropDownOpenAssetList[0]) {
    dialogSetState(() {
      isDropDownOpenAssetList[0] = false;
    });
  } else if (isDropDownOpenAssetList[1]) {
    dialogSetState(() {
      isDropDownOpenAssetList[1] = false;
    });
  } else if (isDropDownOpenAssetList[2]) {
    dialogSetState(() {
      isDropDownOpenAssetList[2] = false;
    });
  } else if (isDropDownOpenAssetList[3]) {
    dialogSetState(() {
      isDropDownOpenAssetList[3] = false;
    });
  } else if (isDropDownOpenAssetList[4]) {
    dialogSetState(() {
      isDropDownOpenAssetList[4] = false;
    });
  } else if (isDropDownOpenAssetList[5]) {
    dialogSetState(() {
      isDropDownOpenAssetList[5] = false;
    });
  } else if (isDropDownOpenAssetList[6]) {
    dialogSetState(() {
      isDropDownOpenAssetList[6] = false;
    });
  } else if (isDropDownOpenAssetList[7]) {
    dialogSetState(() {
      isDropDownOpenAssetList[7] = false;
    });
  } else if (isDropDownOpenAssetList[8]) {
    dialogSetState(() {
      isDropDownOpenAssetList[8] = false;
    });
  } else if (isDropDownOpenAssetList[9]) {
    dialogSetState(() {
      isDropDownOpenAssetList[9] = false;
    });
  } else if (isDropDownOpenTicketList[0]) {
    dialogSetState(() {
      isDropDownOpenTicketList[0] = false;
    });
  } else if (isDropDownOpenTicketList[1]) {
    dialogSetState(() {
      isDropDownOpenTicketList[1] = false;
    });
  } else if (isDropDownOpenTicketList[2]) {
    dialogSetState(() {
      isDropDownOpenTicketList[2] = false;
    });
  } else if (isDropDownOpenTicketList[3]) {
    dialogSetState(() {
      isDropDownOpenTicketList[3] = false;
    });
  } else if (isDropDownOpenTicketList[4]) {
    dialogSetState(() {
      isDropDownOpenTicketList[4] = false;
    });
  } else if (isDropDownOpenTicketList[5]) {
    dialogSetState(() {
      isDropDownOpenTicketList[5] = false;
    });
  } else if (isExpansionDirectoryList[0]) {
    dialogSetState(() {
      isExpansionDirectoryList[0] = false;
    });
  } else if (isExpansionDirectoryList[1]) {
    dialogSetState(() {
      isExpansionDirectoryList[1] = false;
    });
  } else if (isExpansionDirectoryList[2]) {
    dialogSetState(() {
      isExpansionDirectoryList[2] = false;
    });
  } else if (isExpansionDirectoryList[3]) {
    dialogSetState(() {
      isExpansionDirectoryList[3] = false;
    });
  } else if (isExpansionDirectoryList[4]) {
    dialogSetState(() {
      isExpansionDirectoryList[4] = false;
    });
  } else if (isExpansionDirectoryList[5]) {
    dialogSetState(() {
      isExpansionDirectoryList[5] = false;
    });
  } else if (isExpansionLocationList[0]) {
    dialogSetState(() {
      isExpansionLocationList[0] = false;
    });
  } else {
    return;
  }
}

/// Common Dialog used in Asset and User Page ///
Widget getDialogContentsUI(
    {IconData? suffixIcon,
    Color? iconColor,
    required String hintText,
    required TextEditingController controllers,
    required double width,
    required TextInputType type,
    validators,
    required StateSetter dialogSetState,
    borderColor,
    textColor,
    color}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: width,
      child: TextFormField(
        controller: controllers,
        keyboardType: type,
        validator: validators,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          contentPadding: const EdgeInsets.all(15),
          suffixIcon: Icon(
            suffixIcon,
            color: iconColor,
          ),
          hintText: hintText,
          hintStyle: GlobalHelper.textStyle(
            TextStyle(
              color: textColor,
              fontSize: 15,
            ),
          ),
          fillColor: color,
          filled: true,
        ),
        style: TextStyle(color: textColor),
        onTap: () {
          closeDropDown(dialogSetState);
        },
      ),
    ),
  );
}

/// Common Dialog used in Asset and User Page ///
Widget getDialogContentsUIForTicket(
    {IconData? suffixIcon,
    Color? iconColor,
    required String hintText,
    required TextEditingController controllers,
    required double width,
    required TextInputType type,
    validators,
    required bool readOnly,
    required StateSetter dialogSetState,
    borderColor,
    textColor,
    color}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: width,
      child: TextFormField(
        controller: controllers,
        keyboardType: type,
        validator: validators,
        readOnly: readOnly,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          contentPadding: const EdgeInsets.all(15),
          suffixIcon: Icon(
            suffixIcon,
            color: iconColor,
          ),
          hintText: hintText,
          hintStyle: GlobalHelper.textStyle(
            TextStyle(
              color: textColor,
              fontSize: 15,
            ),
          ),
          fillColor: color,
          filled: true,
        ),
        style: TextStyle(color: textColor),
        onTap: () {
          closeDropDown(dialogSetState);
        },
      ),
    ),
  );
}

/// Common Dialog for Large Screen ///
Widget getDialogContentsUILargeScreen(
    {required IconData suffixIcon,
    required Color iconColor,
    required String hintText,
    required TextEditingController controllers,
    required double width,
    required TextInputType type,
    required validators,
    onTap,
    borderColor,
    textColor,
    color,
    required StateSetter dialogSetState}) {
  return SizedBox(
    width: width,
    child: TextFormField(
      controller: controllers,
      keyboardType: type,
      validator: validators,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        contentPadding: const EdgeInsets.all(15),
        suffixIcon: Icon(
          suffixIcon,
          color: iconColor,
        ),
        hintText: hintText,
        hintStyle: GlobalHelper.textStyle(
          TextStyle(
            color: textColor,
            fontSize: 15,
          ),
        ),
        fillColor: color,
        filled: true,
      ),
      style: TextStyle(color: textColor),
      onTap: onTap,
    ),
  );
}

/// Phone Number Dialog for Large Screen ///
Widget getDialogContentsUILargeScreenPhoneNumber(
    {required IconData suffixIcon,
    required Color iconColor,
    required String hintText,
    required TextEditingController controllers,
    required double width,
    required TextInputType type,
    required validators,
    onTap,
    borderColor,
    textColor,
    color,
    required StateSetter dialogSetState}) {
  return SizedBox(
    width: width,
    child: TextFormField(
      controller: controllers,
      keyboardType: type,
      validator: validators,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"[0-9\s\W]"))
      ],
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        contentPadding: const EdgeInsets.all(15),
        suffixIcon: Icon(
          suffixIcon,
          color: iconColor,
        ),
        hintText: hintText,
        hintStyle: GlobalHelper.textStyle(
          TextStyle(
            color: textColor,
            fontSize: 15,
          ),
        ),
        fillColor: color,
        filled: true,
      ),
      style: TextStyle(color: textColor),
      onTap: onTap,
    ),
  );
}

/// It contain the field without the icon ///
Widget getDialogWithoutIconContentsUI(
    {required String hintText,
    required TextEditingController controllers,
    required double width,
    required TextInputType type,
    validators,
    onChanged,
    required StateSetter dialogSetState,
    borderColor,
    textColor,
    color}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: width,
      child: TextFormField(
        controller: controllers,
        validator: validators,
        keyboardType: type,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          contentPadding: const EdgeInsets.all(15),
          hintText: hintText,
          hintStyle: GlobalHelper.textStyle(
            TextStyle(
              color: textColor,
              fontSize: 15,
            ),
          ),
          fillColor: color,
          filled: true,
        ),
        style: TextStyle(color: textColor),
        onTap: () {
          closeDropDown(dialogSetState);
        },
        onChanged: onChanged,
      ),
    ),
  );
}

/// It contain the Extra details of the field ///
Widget getDialogExtraContentsUI(
    {required String hintText,
    required TextEditingController controllers,
    required double width,
    required TextInputType type,
    validators,
    required StateSetter dialogSetState,
    textColor,
    borderColor,
    color}) {
  return SizedBox(
    width: width,
    child: TextFormField(
      controller: controllers,
      keyboardType: type,
      validator: validators,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        contentPadding: const EdgeInsets.all(15),
        hintText: hintText,
        labelStyle: GlobalHelper.textStyle(
          TextStyle(
            color: textColor,
            fontSize: 15,
          ),
        ),
        hintStyle: GlobalHelper.textStyle(
          TextStyle(
            color: textColor,
            fontSize: 15,
          ),
        ),
        fillColor: color,
        filled: true,
      ),
      style: GlobalHelper.textStyle(
        TextStyle(
          color: textColor,
          fontSize: 15,
        ),
      ),
      onTap: () {
        closeDropDown(dialogSetState);
      },
    ),
  );
}

/// It contain the Address field ///
Widget getDialogAddressUI(
    {required String hintText,
    required TextEditingController controllers,
    required double width,
    required TextInputType type,
    validators,
    required StateSetter dialogSetState,
    borderColor,
    textColor,
    color}) {
  return SizedBox(
    width: width,
    child: TextFormField(
      controller: controllers,
      keyboardType: type,
      maxLines: 5,
      validator: validators,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        contentPadding: const EdgeInsets.all(15),
        hintText: hintText,
        hintStyle: GlobalHelper.textStyle(
          TextStyle(
            color: textColor,
            fontSize: 15,
          ),
        ),
        fillColor: color,
        filled: true,
      ),
      style: TextStyle(color: textColor),
    ),
  );
}

/// Common Dialog With IconButton ///
Widget getDialogIconButtonContentsUI(
    {required IconData suffixIcon,
    required Color iconColor,
    required String hintText,
    required TextEditingController controllers,
    required double width,
    required TextInputType type,
    validators,
    required onPressed,
    required StateSetter dialogSetState,
    initialValue,
    borderColor,
    textColor,
    fillColor}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: width,
      child: TextFormField(
        initialValue: initialValue,
        controller: controllers,
        keyboardType: type,
        validator: validators,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          contentPadding: const EdgeInsets.all(15),
          suffixIcon: IconButton(
            color: iconColor,
            onPressed: onPressed,
            icon: Icon(suffixIcon),
          ),
          hintText: hintText,
          hintStyle: GlobalHelper.textStyle(
            TextStyle(
              color: textColor,
              fontSize: 15,
            ),
          ),
          fillColor: fillColor,
          filled: true,
          errorMaxLines: 3,
        ),
        style: TextStyle(color: textColor),
        onTap: () {
          closeDropDown(dialogSetState);
        },
      ),
    ),
  );
}

/// Warranty Dialog box ///
Widget getDialogIconButtonContentsUIForWarranty(
    {required IconData suffixIcon,
    required Color iconColor,
    required String hintText,
    required TextEditingController controllers,
    required double width,
    required TextInputType type,
    validators,
    readOnly,
    required onPressed,
    required StateSetter dialogSetState,
    initialValue,
    borderColor,
    textColor,
    fillColor}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: width,
      child: TextFormField(
        initialValue: initialValue,
        controller: controllers,
        keyboardType: type,
        validator: validators,
        readOnly: readOnly,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          contentPadding: const EdgeInsets.all(15),
          suffixIcon: IconButton(
            color: iconColor,
            onPressed: onPressed,
            icon: Icon(suffixIcon),
          ),
          hintText: hintText,
          hintStyle: GlobalHelper.textStyle(
            TextStyle(
              color: textColor,
              fontSize: 15,
            ),
          ),
          fillColor: fillColor,
          filled: true,
          errorMaxLines: 3,
        ),
        style: TextStyle(color: textColor),
        onTap: () {
          closeDropDown(dialogSetState);
        },
      ),
    ),
  );
}

/// Dialog Box for Password with Hidden and unhidden the text ///
Widget getDialogPasswordContentsUI(
    {required IconData suffixIcon,
    required Color iconColor,
    required String hintText,
    required TextEditingController controllers,
    required double width,
    required StateSetter dialogSetState,
    required onPressed,
    required bool obSecureText,
    required validators,
    onChanged,
    borderColor,
    textColor,
    color}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: width,
      child: TextFormField(
        controller: controllers,
        obscureText: obSecureText,
        validator: validators,
        decoration: InputDecoration(
          errorMaxLines: 3,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          contentPadding: const EdgeInsets.all(15),
          suffixIcon: IconButton(
            color: iconColor,
            onPressed: onPressed,
            icon: Icon(suffixIcon),
          ),
          hintText: hintText,
          hintStyle: GlobalHelper.textStyle(
            TextStyle(
              color: textColor,
              fontSize: 15,
            ),
          ),
          fillColor: color,
          filled: true,
        ),
        style: TextStyle(color: textColor),
        onTap: () {
          closeDropDown(dialogSetState);
        },
        onChanged: onChanged,
      ),
    ),
  );
}

/// It used for File Picker ///
Widget getDialogFileContentsUI(
    {required double width,
    double? secondaryWidth,
    required StateSetter dialogSetState,
    required onPressed,
    required IconData icon,
    required String text,
    borderColor,
    textColor,
    containerColor}) {
  return Container(
    width: width,
    decoration: BoxDecoration(
      color: borderColor,
      borderRadius: const BorderRadius.all(Radius.circular(15)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
          child: Container(
            width: secondaryWidth,
            color: containerColor,
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GlobalHelper.textStyle(
                TextStyle(
                  color: textColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
        IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: const Color.fromRGBO(15, 117, 188, 1),
            ))
      ],
    ),
  );
}

/// Password Validator for Password Field in dialog ///
String? passwordValidator(value) {
  RegExp regex = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");

  if (value.isEmpty) {
    return ("Please enter password");
  } else if (!regex.hasMatch(value)) {
    return ("Password should contain Upper and Lower case letters, digits, and Special characters.");
  } else if (value.length <= 7) {
    return ("Password must contain 8 characters");
  } else {
    return null;
  }
}

/// Update Password Validator for Password Field in dialog ///
String? updatePasswordValidator(value) {
  RegExp regex = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");

  if (value.length < 8) {
    return "Password must contain at least 8 characters";
  } else if (!regex.hasMatch(value)) {
    return "Password should contain at least one uppercase letter, one lowercase letter, one digit, and one special character";
  } else {
    return null;
  }
}

/// Email Validator for Email Field in dialog ///
String? emailValidator(value) {
  if (value!.isEmpty) return 'Email should not be Empty';
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern as String);
  if (!regex.hasMatch(value)) {
    return 'Enter an Valid Email';
  } else {
    return null;
  }
}

/// Pin Code Validator for Pin Code Field in dialog ///
String? pinCodeValidator(value) {
  if (value.isEmpty) {
    return 'Field should not be Empty';
  }
  final RegExp codeRegex = RegExp(r'^[0-9]*$');
  if (!codeRegex.hasMatch(value)) {
    return "Please enter only numbers";
  }
  return null;
}

/// Common Validator for Fields used in dialog ///
String? commonValidator(value) {
  if (value!.isEmpty) {
    return 'Field should not be Empty';
  } else {
    return null;
  }
}

/// Mobile Validator for Mobile Field in dialog ///
String? mobileValidator(value) {
  if (value.isEmpty) {
    return 'Field should not be Empty';
  } else if (value.length < 10) {
    return 'Mobile Number must be of 10 digit';
  }

  final RegExp phoneNumberRegex = RegExp(r'^[0-9\s\-\+\(\)]*$');
  if (!phoneNumberRegex.hasMatch(value)) {
    return 'Invalid characters in phone number';
  }

  return null;
}

/// Date Validator for Date Field in dialog ///
String? dateValidator(date) {
  if (date.isEmpty) {
    return 'Please enter a date';
  }

  final RegExp dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
  if (!dateRegex.hasMatch(date)) {
    return 'Please enter a valid date in the format of dd/mm/yyyy';
  }
  return null;
}

/// Date & Time Validator for Date Field in dialog ///
String? dateTimeValidator(String? dateTime) {
  if (dateTime == null || dateTime.isEmpty) {
    return 'Please enter a date and time';
  }

  final RegExp dateTimeRegex =
      RegExp(r'^\d{2}/\d{2}/\d{4} (0?[1-9]|1[0-2]):[0-5][0-9] (AM|PM)$');
  if (!dateTimeRegex.hasMatch(dateTime)) {
    return 'Please enter a valid date and time in the format of dd/mm/yyyy hh:mm AM/PM';
  }

  final List<String> dateTimeParts = dateTime.split(' ');
  final String datePart = dateTimeParts[0];

  final RegExp dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
  if (!dateRegex.hasMatch(datePart)) {
    return 'Please enter a valid date in the format of dd/mm/yyyy';
  }

  return null;
}

/// GST Validator for GST Field in dialog ///
String? validateGST(value) {
  RegExp gstRegex = RegExp(r'^\d{2}[A-Z]{5}\d{4}[A-Z]\d[Z][A-Z\d]$');
  if (!gstRegex.hasMatch(value)) {
    return 'Invalid GST Number';
  } else if (value.isEmpty) {
    return 'Field should not be Empty';
  }
  return null;
}

/// It is used to display the title in ticket page ///
Widget getTicketStatusTitleContentUI({required String title, overflow}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Text(
      title,
      style: GoogleFonts.ubuntu(
          textStyle: TextStyle(
        fontSize: 15,
        overflow: overflow,
        color: const Color.fromRGBO(117, 117, 117, 1),
      )),
    ),
  );
}

/// Dialog box for Agreement ///
Widget getDialogFileContentsUIForAgreement(
    {required double width,
    required StateSetter dialogSetState,
    required IconData icon,
    required String text,
    containerColor,
    textColor}) {
  return Container(
    width: width,
    decoration: BoxDecoration(
      color: containerColor,
      borderRadius: const BorderRadius.all(Radius.circular(15)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
            child: Text(
              text,
              style: GlobalHelper.textStyle(
                TextStyle(
                  color: textColor,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Icon(
            icon,
            color: const Color.fromRGBO(117, 117, 117, 1),
          )
        ],
      ),
    ),
  );
}

/// It is used to display the content in ticket page ///
Widget getTicketStatusContentUI({required String content, width, color}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: SizedBox(
      width: width,
      child: Text(
        content,
        maxLines: 1,
        overflow: TextOverflow.clip,
        style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: color,
        )),
      ),
    ),
  );
}

/// It is used to display the content in ticket page ///
Widget getTimeContentUI(
    {required String content, width, color, required onPressed}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: SizedBox(
      width: width,
      child: Row(
        children: [
          Text(
            content,
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: GoogleFonts.ubuntu(
                textStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            )),
          ),
          IconButton(
              onPressed: onPressed,
              icon: const Icon(
                Icons.calendar_today_rounded,
                color: Colors.blue,
              ))
        ],
      ),
    ),
  );
}

/// It used to display the UserName in Short Form in Circle Avatar ///
String getShortForm(String name) {
  List<String> names = name.split(' ');
  String initials = '';

  if (names.isNotEmpty) {
    initials += names[0][0];
  }
  if (names.length > 1) {
    initials += names[1][0];
  }
  return initials;
}

/// It is text field for Comment Section in ticket page ///
Widget getTextFieldForComment(
    {required TextEditingController controllers,
    required onPressed,
    onFieldSubmitted,
    width,
    height,
    fontColor,
    color,
    required bool autoFocus,
    required IconData suffixIcon}) {
  return Material(
    color: Colors.transparent,
    child: SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        maxLines: null,
        autofocus: autoFocus,
        keyboardType: TextInputType.multiline,
        controller: controllers,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orangeAccent),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          contentPadding: const EdgeInsets.all(15),
          hintText: "Add Comments",
          hintStyle: GlobalHelper.textStyle(
            TextStyle(
              color: fontColor,
              fontSize: 15,
            ),
          ),
          filled: true,
          suffixIcon: IconButton(
            icon: Icon(suffixIcon),
            onPressed: onPressed,
            color: Colors.blue,
          ),
          fillColor: color,
        ),
        onFieldSubmitted: onFieldSubmitted,
        style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: fontColor,
        )),
      ),
    ),
  );
}

/// Elevated Button ///
Widget getElevatedButton({required onPressed, required String text}) {
  return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
      child: Text(
        text,
        style: GlobalHelper.textStyle(const TextStyle(
          color: Colors.white,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w400,
          fontSize: 15,
        )),
      ));
}

/// Elevated Button with Icon ///
Widget getElevatedButtonIcon({required onPressed, required String text}) {
  return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
      icon: const Icon(
        Icons.edit_rounded,
        color: Colors.white,
      ),
      label: Text(
        text,
        style: GlobalHelper.textStyle(const TextStyle(
          color: Colors.white,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w400,
          fontSize: 15,
        )),
      ));
}

/// Dialog Box Size or Width ///
getDialogWidth(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 600) {
    return screenWidth * 0.3;
  } else if (screenWidth > 600 && screenWidth < 100) {
    return screenWidth * 0.4;
  } else {
    return screenWidth * 0.2;
  }
}

/// Email Field in Login Screen ///
Widget getEmailTextFieldUI(
    {controllers, validators, prefixIcon, iconColor, hintText, type, width}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: width,
      child: TextFormField(
        validator: validators,
        controller: controllers,
        autofillHints: const [AutofillHints.email],
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orangeAccent),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          contentPadding: const EdgeInsets.all(15),
          prefixIcon: Icon(
            prefixIcon,
            color: iconColor,
          ),
          hintText: hintText,
          hintStyle: GlobalHelper.textStyle(
            const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          filled: true,
          fillColor: const Color.fromRGBO(255, 253, 250, 1),
        ),
        keyboardType: type,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    ),
  );
}

/// Password Field in Login Screen ///
Widget gePasswordTextField(
    {controllers,
    validators,
    prefixIcon,
    iconColor,
    hintText,
    width,
    onPressed,
    suffixIcons,
    obscureText}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: width,
      child: TextFormField(
        validator: validators,
        controller: controllers,
        autofillHints: const [AutofillHints.password],
        decoration: InputDecoration(
          errorMaxLines: 2,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orangeAccent),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          contentPadding: const EdgeInsets.all(15),
          prefixIcon: Icon(
            prefixIcon,
            color: iconColor,
          ),
          suffixIcon: IconButton(
            onPressed: onPressed,
            icon: Icon(suffixIcons),
            color: iconColor,
          ),
          hintText: hintText,
          hintStyle: GlobalHelper.textStyle(
            const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          filled: true,
          fillColor: const Color.fromRGBO(255, 253, 250, 1),
        ),
        obscureText: isHidden,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    ),
  );
}

/// Tag Dialog Content ///
Widget getTagListDialogContentsUI(
    {required double width,
    required StateSetter dialogSetState,
    required tag,
    color,
    textColor}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
    child: Container(
      width: width,
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: tag.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              if (index > 0)
                const Divider(
                  thickness: 1,
                  color: Color(0xffbdbdbd),
                  indent: 10,
                  endIndent: 10,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      tag[index],
                      style: GlobalHelper.textStyle(TextStyle(
                        color: textColor,
                        fontSize: 15,
                      )),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        dialogSetState(() {
                          tag.removeAt(index);
                        });
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Color.fromRGBO(15, 117, 188, 1),
                      ))
                ],
              ),
            ],
          );
        },
      ),
    ),
  );
}

/// Tag Dialog Box ///
Widget getDialogTagContentsUI({
  required String hintText,
  required TextEditingController controllers,
  required double width,
  required StateSetter dialogSetState,
  required TextInputType type,
  required tags,
  required onPressed,
  required list,
  borderColor,
  textColor,
  fillColor,
  containerColor,
}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
    child: SizedBox(
      width: width,
      child: Stack(
        children: [
          TextFormField(
            controller: controllers,
            keyboardType: type,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              contentPadding: const EdgeInsets.all(15),
              suffixIcon: IconButton(
                color: const Color.fromRGBO(15, 117, 188, 1),
                onPressed: onPressed,
                icon: const Icon(Icons.add_circle),
              ),
              hintText: hintText,
              hintStyle: GlobalHelper.textStyle(
                TextStyle(
                  color: textColor,
                  fontSize: 15,
                ),
              ),
              fillColor: fillColor,
              filled: true,
            ),
            style: TextStyle(color: textColor),
          ),
          if (isExpansionDirectoryList[6] && tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: containerColor,
                ),
                margin: const EdgeInsets.only(top: 50),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: tags.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        tags[index],
                        style:
                            GlobalHelper.textStyle(TextStyle(color: textColor)),
                      ),
                      onTap: () {
                        dialogSetState(() {
                          list.add(tags[index]);
                          controllers.clear();
                          isExpansionDirectoryList[6] = false;
                        });
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

/// Display Single ID in the table ///
getTableDeleteForSingleId({required id, color}) {
  return Table(
    border:
        TableBorder.all(borderRadius: BorderRadius.circular(10), color: color),
    children: [
      TableRow(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'S.NO',
                style: GoogleFonts.ubuntu(
                    textStyle: const TextStyle(
                  fontSize: 13,
                  color: Color.fromRGBO(117, 117, 117, 1),
                )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'ID',
                style: GoogleFonts.ubuntu(
                    textStyle: const TextStyle(
                  fontSize: 13,
                  color: Color.fromRGBO(117, 117, 117, 1),
                )),
              ),
            ),
          ),
        ],
      ),
      TableRow(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "1",
                style: GoogleFonts.ubuntu(
                    textStyle: const TextStyle(
                  fontSize: 13,
                  color: Color.fromRGBO(117, 117, 117, 1),
                )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                id,
                style: GoogleFonts.ubuntu(
                    textStyle: const TextStyle(
                  fontSize: 13,
                  color: Color.fromRGBO(117, 117, 117, 1),
                )),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

/// Display Multiple ID in the table ///
getTableDeleteForMultipleId({required title, required content, color}) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.ubuntu(
              textStyle: const TextStyle(
                fontSize: 13,
                color: Color.fromRGBO(117, 117, 117, 1),
              ),
            ),
          ),
        ),
      ),
      // User ID
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            content,
            style: GoogleFonts.ubuntu(
              textStyle: const TextStyle(
                fontSize: 13,
                color: Color.fromRGBO(117, 117, 117, 1),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

/// Convert the time to local time ///
String convertToLocalTime(String timestamp) {
  DateTime dateTime = DateTime.parse(timestamp);

  DateTime localTime = dateTime.toLocal();

  String formattedLocalTime = DateFormat().format(localTime);

  return formattedLocalTime;
}

/// Show Toast Function ///
void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      textColor: Colors.white,
      fontSize: 16.0,
      webPosition: "center",
      webBgColor: "0xffffffff");
}

/// Display the content title in the content overview ///
getTitleText({required text}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: GoogleFonts.ubuntu(
            textStyle: const TextStyle(
          fontSize: 15,
          color: Color.fromRGBO(117, 117, 117, 1),
        )),
      ),
    ),
  );
}

/// Display the content in the content overview ///
getContentText({required text, required maxLines, required color}) {
  return Center(
    child: Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.ubuntu(
          textStyle: TextStyle(
        fontSize: 13,
        color: color,
      )),
    ),
  );
}

/// <!-- Icon Class --!> ///
class CustomActionIcon extends StatelessWidget {
  final String message;
  final void Function()? onPressed;
  final Widget? iconImage;
  final bool preferBelow;
  final Color? color;

  const CustomActionIcon(
      {super.key,
      required this.message,
      this.onPressed,
      this.iconImage,
      this.color,
      required this.preferBelow});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      preferBelow: preferBelow,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      textStyle: GoogleFonts.ubuntu(
          textStyle: const TextStyle(
        fontSize: 13,
        color: Color.fromRGBO(117, 117, 117, 1),
      )),
      child: IconButton(
          icon: iconImage ?? const Icon(Icons.edit),
          color: color,
          onPressed: onPressed),
    );
  }
}
/// <!-- Icon Class --!> ///

/// <!-- Dropdown Class --!> ///
class CloseDropDown extends StatefulWidget {
  final Function() onTap;
  final IconData suffixIcon;
  final Color iconColor;
  final String hintText;
  final TextEditingController controllers;
  final double width;
  final TextInputType type;
  final String? Function(String?)? validators;
  final StateSetter dialogSetState;

  const CloseDropDown(
      {required Key key,
      required this.onTap,
      required this.suffixIcon,
      required this.iconColor,
      required this.hintText,
      required this.controllers,
      required this.width,
      required this.type,
      required this.validators,
      required this.dialogSetState})
      : super(key: key);

  @override
  State<CloseDropDown> createState() => _CloseDropDownState();
}

class _CloseDropDownState extends State<CloseDropDown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: widget.width,
        child: TextFormField(
          controller: widget.controllers,
          keyboardType: widget.type,
          validator: widget.validators,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            contentPadding: const EdgeInsets.all(15),
            suffixIcon: Icon(
              widget.suffixIcon,
              color: widget.iconColor,
            ),
            hintText: widget.hintText,
            hintStyle: GlobalHelper.textStyle(
              const TextStyle(
                color: Color.fromRGBO(117, 117, 117, 1),
                fontSize: 15,
              ),
            ),
            fillColor: Colors.white,
            filled: true,
          ),
          style: const TextStyle(color: Color.fromRGBO(117, 117, 117, 1)),
          onChanged: (value) {
            widget.onTap;
          },
        ),
      ),
    );
  }
}
/// <!-- Dropdown Class --!> ///

/// <!-- Dialog Root Class --!> ///
class DialogRoot extends StatelessWidget {
  final dynamic dialog;
  const DialogRoot({
    Key? key,
    required this.dialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Listener(
                  onPointerHover: (event) {
                    UserInteractionTimer.resetTimer(context);
                  },
                  onPointerDown: (event) {
                    UserInteractionTimer.resetTimer(context);
                  },
                  child: dialog);
            },
          );
        },
        icon: const Icon(Icons.add_circle),
        color: const Color.fromRGBO(15, 117, 188, 1));
  }
}
/// <!-- Dialog Root Class --!> ///

/// <!-- Expanded Dialog Root Class --!> ///
class ExpandedDialogsDialogRoot extends StatelessWidget {
  final dynamic dialog;
  const ExpandedDialogsDialogRoot({
    Key? key,
    required this.dialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomActionIcon(
        message: "View More",
        preferBelow: false,
        iconImage: Image.asset('assets/images/expand.png'),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Listener(
                  onPointerHover: (event) {
                    UserInteractionTimer.resetTimer(context);
                  },
                  onPointerDown: (event) {
                    UserInteractionTimer.resetTimer(context);
                  },
                  child: dialog);
            },
          );
        });
  }
}
/// <!-- Expanded Dialog Root Class --!> ///

/// <!-- Progress Loaders Class --!> ///
class ProgressLoaders {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          color: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              decoration: BoxDecoration(
                color:
                    Colors.white.withOpacity(0.01), // Adjust opacity as needed
                borderRadius:
                    BorderRadius.circular(10), // Adjust radius as needed
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Lottie.asset("assets/lottie/loader.json",
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height *
                              0.4)), // Message
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop(); // Close the dialog
  }
}
/// <!-- Progress Loaders Class --!> ///
