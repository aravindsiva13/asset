const timeHelper = require("../helpers/timeHelper");

import phoneNumbers from "libphonenumber-js";

let emailPattern = /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/;
// let passwordPattern =
//   /^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*_=+-]).{8,15}$/;

let passwordPattern =
  /^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*_=+-]).{8,}$/;

//Login User Validator
exports.loginUserValidator = (email, password) => {
  let validatorErrors = [];
  if (email == null || email === undefined) {
    validatorErrors.push("Email Not Found");
  } else if (!emailPattern.test(email)) {
    validatorErrors.push("Enter an Valid Email ");
  } else if (!(typeof email === "string")) {
    validatorErrors.push("Email: Invalid Data Type");
  } else if (password == null || password == undefined) {
    validatorErrors.push("Password Not Found");
  } else if (!passwordPattern.test(password)) {
    validatorErrors.push(
      "Password should contain Upper and Lower case letters, digits, and Special characters"
    );
  } else if (!(typeof password === "string")) {
    validatorErrors.push("Password: Invalid Data Type");
  }
  return validatorErrors;
};

// Used in Ticket Page
exports.ticketValidator = (
  id,
  ticketId,
  type,
  ticketStatus,
  priority,
  assignedTo,
  closedBy,
  userRefID,
  assetRefId,
  createdBy,
  assignee,
  comment,
  attachment,
  message,
  updatedBy,
  assingedBy,
  deleteFlag,
  tag,
  vendorRefId,
  trackerId
) => {
  let validatorErrors = [];

  if (id == null || id === undefined) {
    validatorErrors.push("Invalid ID");
  } else if (ticketId == null || ticketId === undefined) {
    validatorErrors.push("Invalid TicketID");
  } else if (!(typeof ticketId === "string")) {
    validatorErrors.push("TicketId: Invalid Data Type");
  } else if (type == null || type === undefined) {
    validatorErrors.push("Invalid Type");
  } else if (!(typeof type === "string")) {
    validatorErrors.push("Type: Invalid Data Type");
  } else if (ticketStatus == null || ticketStatus === undefined) {
    validatorErrors.push("Invalid TicketStatus");
  } else if (!(typeof ticketStatus === "string")) {
    validatorErrors.push("TicketStatus: Invalid Data Type");
  } else if (priority == null || priority === undefined) {
    validatorErrors.push("Invalid Priority");
  } else if (!(typeof priority === "string")) {
    validatorErrors.push("Priority: Invalid Data Type");
  } else if (assignedTo == null || assignedTo === undefined) {
    validatorErrors.push("Invalid AssignedTo");
  } else if (closedBy == null || closedBy === undefined) {
    validatorErrors.push("Invalid ClosedBy");
  } else if (userRefID == null || userRefID === undefined) {
    validatorErrors.push("Invalid UserRefID");
  } else if (!Array.isArray(userRefID)) {
    validatorErrors.push("UserRefID: Invalid Data Type");
  } else if (assetRefId == null || assetRefId === undefined) {
    validatorErrors.push("Invalid AssetRefId");
  } else if (!Array.isArray(assetRefId)) {
    validatorErrors.push("AssetRefId: Invalid Data Type");
  } else if (createdBy == null || createdBy === undefined) {
    validatorErrors.push("Invalid CreatedBy");
  } else if (!(typeof createdBy === "string")) {
    validatorErrors.push("CreatedBy: Invalid Data Type");
  } else if (assignee == null || assignee === undefined) {
    validatorErrors.push("Invalid AssignedBar");
  } else if (!(typeof assignee === "boolean")) {
    validatorErrors.push("Assignee: Invalid Data Type");
  } else if (comment == null || comment === undefined) {
    validatorErrors.push("Invalid Comment");
  } else if (attachment == null || attachment === undefined) {
    validatorErrors.push("Invalid Attachment");
  } else if (message == null || message === undefined) {
    validatorErrors.push("Invalid Message");
  } else if (updatedBy == null || updatedBy === undefined) {
    validatorErrors.push("Invalid UpdatedBy");
  } else if (assingedBy == null || assingedBy === undefined) {
    validatorErrors.push("Invalid AssingedBy");
  } else if (deleteFlag == null || deleteFlag === undefined) {
    validatorErrors.push("Invalid DeleteFlag");
  } else if (!(typeof deleteFlag === "boolean")) {
    validatorErrors.push("DeleteFlag: Invalid Data Type");
  } else if (tag == null || deleteFlag === tag) {
    validatorErrors.push("Invalid Tag");
  } else if (!(typeof tag === "string")) {
    validatorErrors.push("Tag: Invalid Data Type");
  } else if (vendorRefId == null || vendorRefId === undefined) {
    validatorErrors.push("Invalid VendorRefId");
  } else if (trackerId == null || trackerId === undefined) {
    validatorErrors.push("Invalid TrackerId");
  }
  locationPage;
};

// Location Validator  for Create & Update Location Page
exports.createlocationValidator = (plusCode, address, latitude, longitude) => {
  let validatorErrors = [];

  if (plusCode == null || plusCode === undefined) {
    validatorErrors.push("Invalid PlusCode");
  } else if (!(typeof plusCode === "string")) {
    validatorErrors.push("plusCode: Invalid Data Type");
  } else if (latitude == null || latitude === undefined) {
    validatorErrors.push("Invalid Latitude");
  } else if (!(typeof latitude === "string")) {
    validatorErrors.push("Latitude: Invalid Data Type");
  } else if (longitude == null || longitude === undefined) {
    validatorErrors.push("Invalid Longitude");
  } else if (!(typeof longitude === "string")) {
    validatorErrors.push("Longitude: Invalid Data Type");
  } else {
    let add = address.address;
    let city = address.city;
    let state = address.state;
    let country = address.country;
    let landMark = address.landMark;
    let pinCode = address.pinCode;
    if (add == null || add === undefined) {
      validatorErrors.push("Invalid Address");
    } else if (add.constructor !== String) {
      validatorErrors.push("Address: Invalid Data Type");
    } else if (city == null || city === undefined) {
      validatorErrors.push("Invalid City");
    } else if (city.constructor !== String) {
      validatorErrors.push("City: Invalid Data Type");
    } else if (state == null || state === undefined) {
      validatorErrors.push("Invalid State");
    } else if (state.constructor !== String) {
      validatorErrors.push("State: Invalid Data Type");
    } else if (country == null || country === undefined) {
      validatorErrors.push("Invalid Country");
    } else if (country.constructor !== String) {
      validatorErrors.push("Country: Invalid Data Type");
    } else if (landMark == null || landMark === undefined) {
      validatorErrors.push("Invalid LandMark");
    } else if (landMark.constructor !== String) {
      validatorErrors.push("LandMark: Invalid Data Type");
    } else if (pinCode == null || pinCode === undefined) {
      validatorErrors.push("Invalid PinCode");
    } else if (pinCode.constructor !== Number) {
      validatorErrors.push("PinCode: Invalid Data Type");
    }
  }

  return validatorErrors;
};

// Company Validator
exports.createCompanyValidator = (
  name,
  address,
  phoneNumber,
  email,
  website,
  contactPersonName,
  contactPersonPhoneNumber,
  contactPersonEmail,
  departments
) => {
  let validatorErrors = [];

  if (name == null || name === undefined) {
    validatorErrors.push("Invalid Name");
  } else if (!(typeof name === "string")) {
    validatorErrors.push("Name: Invalid Data Type");
  } else if (address == null || address === undefined) {
    validatorErrors.push("Invalid address");
  } else if (!(typeof address === "object")) {
    validatorErrors.push("address: Invalid Data Type");
  } else if (phoneNumber == null || phoneNumber === undefined) {
    validatorErrors.push("Invalid PhoneNumber");
  } else if (
    (phoneNumbers(phoneNumber, "IN") &&
      phoneNumbers(phoneNumber, "IN").isValid()) == false ||
    (phoneNumbers(phoneNumber, "IN") &&
      phoneNumbers(phoneNumber, "IN").isValid()) === undefined
  ) {
    validatorErrors.push("PhoneNumber: Invalid Data Type");
  } else if (email == null || email === undefined) {
    validatorErrors.push("Invalid Email");
  } else if (!(typeof email === "string")) {
    validatorErrors.push("Email: Invalid Data Type");
  } else if (!emailPattern.test(email)) {
    validatorErrors.push("Enter an Valid Email ");
  } else if (website == null || website === undefined) {
    validatorErrors.push("Invalid Website");
  } else if (!(typeof website === "string")) {
    validatorErrors.push("Website: Invalid Data Type");
  } else if (contactPersonName == null || contactPersonName === undefined) {
    validatorErrors.push("Invalid ContactPersonName");
  } else if (!(typeof contactPersonName === "string")) {
    validatorErrors.push("ContactPersonName: Invalid Data Type");
  } else if (
    contactPersonPhoneNumber == null ||
    contactPersonPhoneNumber === undefined
  ) {
    validatorErrors.push("Invalid ContactPersonPhoneNumber");
  } else if (
    (phoneNumbers(contactPersonPhoneNumber, "IN") &&
      phoneNumbers(contactPersonPhoneNumber, "IN").isValid()) == false ||
    (phoneNumbers(contactPersonPhoneNumber, "IN") &&
      phoneNumbers(contactPersonPhoneNumber, "IN").isValid()) === undefined
  ) {
    validatorErrors.push("ContactPersonPhoneNumber: Invalid Data Type");
  } else if (contactPersonEmail == null || contactPersonEmail === undefined) {
    validatorErrors.push("Invalid ContactPersonEmail");
  } else if (!(typeof contactPersonEmail === "string")) {
    validatorErrors.push("ContactPersonEmail: Invalid Data Type");
  } else if (!emailPattern.test(contactPersonEmail)) {
    validatorErrors.push("Enter an Valid Email ");
  } else if (departments == null || departments === undefined) {
    validatorErrors.push("Invalid Deparments");
  } else if (!Array.isArray(departments)) {
    validatorErrors.push("Deparments: Invalid Data Type");
  } else {
    let add = address.address;
    let city = address.city;
    let state = address.state;
    let country = address.country;
    let landMark = address.landMark;
    let pinCode = address.pinCode;
    if (add == null || add === undefined) {
      validatorErrors.push("Invalid Address");
    } else if (add.constructor !== String) {
      validatorErrors.push("Address: Invalid Data Type");
    } else if (city == null || city === undefined) {
      validatorErrors.push("Invalid City");
    } else if (city.constructor !== String) {
      validatorErrors.push("City: Invalid Data Type");
    } else if (state == null || state === undefined) {
      validatorErrors.push("Invalid State");
    } else if (state.constructor !== String) {
      validatorErrors.push("State: Invalid Data Type");
    } else if (country == null || country === undefined) {
      validatorErrors.push("Invalid Country");
    } else if (country.constructor !== String) {
      validatorErrors.push("Country: Invalid Data Type");
    } else if (landMark == null || landMark === undefined) {
      validatorErrors.push("Invalid LandMark");
    } else if (landMark.constructor !== String) {
      validatorErrors.push("LandMark: Invalid Data Type");
    } else if (pinCode == null || pinCode === undefined) {
      validatorErrors.push("Invalid PinCode");
    } else if (pinCode.constructor !== Number) {
      validatorErrors.push("PinCode: Invalid Data Type");
    }
  }

  return validatorErrors;
};

// Vendor Validator
exports.createVendorValidator = (
  vendorName,
  address,
  phoneNumber,
  email,
  name,
  gstIn
) => {
  let validatorErrors = [];

  if (vendorName == null || vendorName === undefined) {
    validatorErrors.push("Invalid VendorName");
  } else if (!(typeof vendorName === "string")) {
    validatorErrors.push("VendorName: Invalid Data Type");
  } else if (phoneNumber == null || phoneNumber === undefined) {
    validatorErrors.push("Invalid PhoneNumber");
  } else if (
    (phoneNumbers(phoneNumber, "IN") &&
      phoneNumbers(phoneNumber, "IN").isValid()) == false ||
    (phoneNumbers(phoneNumber, "IN") &&
      phoneNumbers(phoneNumber, "IN").isValid()) === undefined
  ) {
    validatorErrors.push("PhoneNumber: Invalid Data Type");
  } else if (email == null || email === undefined) {
    validatorErrors.push("Invalid Email");
  } else if (!(typeof email === "string")) {
    validatorErrors.push("Email: Invalid Data Type");
  } else if (!emailPattern.test(email)) {
    validatorErrors.push("Enter an Valid Email ");
  } else if (name == null || name === undefined) {
    validatorErrors.push("Invalid Name");
  } else if (!(typeof name === "string")) {
    validatorErrors.push("Name: Invalid Data Type");
  } else if (gstIn == null || gstIn === undefined) {
    validatorErrors.push("Invalid GST IN");
  } else if (!(typeof gstIn === "string")) {
    validatorErrors.push("GST IN: Invalid Data Type");
  } else if (address == null || address === undefined) {
    validatorErrors.push("Invalid address");
  } else if (!(typeof address === "object")) {
    validatorErrors.push("address: Invalid Data Type");
  } else {
    let add = address.address;
    let city = address.city;
    let state = address.state;
    let country = address.country;
    let landMark = address.landMark;
    let pinCode = address.pinCode;
    if (add == null || add === undefined) {
      validatorErrors.push("Invalid Address");
    } else if (add.constructor !== String) {
      validatorErrors.push("Address: Invalid Data Type");
    } else if (city == null || city === undefined) {
      validatorErrors.push("Invalid City");
    } else if (city.constructor !== String) {
      validatorErrors.push("City: Invalid Data Type");
    } else if (state == null || state === undefined) {
      validatorErrors.push("Invalid State");
    } else if (state.constructor !== String) {
      validatorErrors.push("State: Invalid Data Type");
    } else if (country == null || country === undefined) {
      validatorErrors.push("Invalid Country");
    } else if (country.constructor !== String) {
      validatorErrors.push("Country: Invalid Data Type");
    } else if (landMark == null || landMark === undefined) {
      validatorErrors.push("Invalid LandMark");
    } else if (landMark.constructor !== String) {
      validatorErrors.push("LandMark: Invalid Data Type");
    } else if (pinCode == null || pinCode === undefined) {
      validatorErrors.push("Invalid PinCode");
    } else if (pinCode.constructor !== Number) {
      validatorErrors.push("PinCode: Invalid Data Type");
    }
  }
  return validatorErrors;
};

// Update Vendor Validator
exports.updateVendorValidator = (
  vendorName,
  address,
  phoneNumber,
  email,
  name,
  gstIn
) => {
  let validatorErrors = [];

  if (vendorName == null || vendorName === undefined) {
    validatorErrors.push("Invalid VendorName");
  } else if (!(typeof vendorName === "string")) {
    validatorErrors.push("VendorName: Invalid Data Type");
  } else if (phoneNumber == null || phoneNumber === undefined) {
    validatorErrors.push("Invalid PhoneNumber");
  } else if (
    (phoneNumbers(phoneNumber, "IN") &&
      phoneNumbers(phoneNumber, "IN").isValid()) == false ||
    (phoneNumbers(phoneNumber, "IN") &&
      phoneNumbers(phoneNumber, "IN").isValid()) === undefined
  ) {
    validatorErrors.push("PhoneNumber: Invalid Data Type");
  } else if (email == null || email === undefined) {
    validatorErrors.push("Invalid Email");
  } else if (!(typeof email === "string")) {
    validatorErrors.push("Email: Invalid Data Type");
  } else if (!emailPattern.test(email)) {
    validatorErrors.push("Enter an Valid Email ");
  } else if (name == null || name === undefined) {
    validatorErrors.push("Invalid Name");
  } else if (!(typeof name === "string")) {
    validatorErrors.push("Name: Invalid Data Type");
  } else if (gstIn == null || gstIn === undefined) {
    validatorErrors.push("Invalid GST IN");
  } else if (!(typeof gstIn === "string")) {
    validatorErrors.push("GST IN: Invalid Data Type");
  } else if (address == null || address === undefined) {
    validatorErrors.push("Invalid address");
  } else if (!(typeof address === "object")) {
    validatorErrors.push("address: Invalid Data Type");
  } else {
    let add = address.address;
    let city = address.city;
    let state = address.state;
    let country = address.country;
    let landMark = address.landMark;
    let pinCode = address.pinCode;
    if (add == null || add === undefined) {
      validatorErrors.push("Invalid Address");
    } else if (add.constructor !== String) {
      validatorErrors.push("Address: Invalid Data Type");
    } else if (city == null || city === undefined) {
      validatorErrors.push("Invalid City");
    } else if (city.constructor !== String) {
      validatorErrors.push("City: Invalid Data Type");
    } else if (state == null || state === undefined) {
      validatorErrors.push("Invalid State");
    } else if (state.constructor !== String) {
      validatorErrors.push("State: Invalid Data Type");
    } else if (country == null || country === undefined) {
      validatorErrors.push("Invalid Country");
    } else if (country.constructor !== String) {
      validatorErrors.push("Country: Invalid Data Type");
    } else if (landMark == null || landMark === undefined) {
      validatorErrors.push("Invalid LandMark");
    } else if (landMark.constructor !== String) {
      validatorErrors.push("LandMark: Invalid Data Type");
    } else if (pinCode == null || pinCode === undefined) {
      validatorErrors.push("Invalid PinCode");
    } else if (pinCode.constructor !== Number) {
      validatorErrors.push("PinCode: Invalid Data Type");
    }
  }
  return validatorErrors;
};

// User Validator
exports.createUserValidator = (
  name,
  email,
  phoneNumber,
  employeeId,
  dateOfJoining,
  password,
  designation,
  department
) => {
  let validatorErrors = [];
  if (name == null || name === undefined) {
    validatorErrors.push("Invalid Name");
  } else if (!(typeof name === "string")) {
    validatorErrors.push("Name: Invalid Data Type");
  } else if (email == null || email === undefined) {
    validatorErrors.push("Invalid Email");
  } else if (!(typeof email === "string")) {
    validatorErrors.push("Email: Invalid Data Type");
  } else if (!emailPattern.test(email)) {
    validatorErrors.push("Enter an Valid Email ");
  } else if (phoneNumber == null || phoneNumber === undefined) {
    validatorErrors.push("Invalid PhoneNumber");
  } else if (
    (phoneNumbers(phoneNumber, "IN") &&
      phoneNumbers(phoneNumber, "IN").isValid()) == false ||
    (phoneNumbers(phoneNumber, "IN") &&
      phoneNumbers(phoneNumber, "IN").isValid()) === undefined
  ) {
    validatorErrors.push("PhoneNumber: Invalid Data Type");
  } else if (employeeId == null || employeeId === undefined) {
    validatorErrors.push("Invalid EmployeeId");
  } else if (!(typeof employeeId === "string")) {
    validatorErrors.push("EmployeeId: Invalid Data Type");
  } else if (dateOfJoining == null || dateOfJoining === undefined) {
    validatorErrors.push("Please Enter Date");
  } else if (
    !timeHelper.validateDateWithTimezone(
      dateOfJoining,
      "DD/MM/YY",
      process.env.timezone
    )
  ) {
    validatorErrors.push("Invalid Date Format");
  } else if (password == null || password == undefined) {
    validatorErrors.push("Password Not Found");
  } else if (!passwordPattern.test(password)) {
    validatorErrors.push(
      "Password should contain Upper and Lower case letters, digits, and Special characters"
    );
  } else if (!(typeof password === "string")) {
    validatorErrors.push("Password: Invalid Data Type");
  } else if (designation == null || designation === undefined) {
    validatorErrors.push("Designation Not Found");
  } else if (!(typeof designation === "string")) {
    validatorErrors.push("Designation: Invalid Data Type");
  } else if (department == null || department === undefined) {
    validatorErrors.push("Department Not Found");
  } else if (!Array.isArray(department)) {
    validatorErrors.push("Department: Invalid Data Type");
  }
  return validatorErrors;
};

// Update User Validator
exports.updateUserValidator = (
  name,
  email,
  phoneNumber,
  employeeId,
  dateOfJoining,
  designation,
  department
) => {
  let validatorErrors = [];
  if (name == null || name === undefined) {
    validatorErrors.push("Invalid Name");
  } else if (!(typeof name === "string")) {
    validatorErrors.push("Name: Invalid Data Type");
  } else if (email == null || email === undefined) {
    validatorErrors.push("Invalid Email");
  } else if (!(typeof email === "string")) {
    validatorErrors.push("Email: Invalid Data Type");
  } else if (!emailPattern.test(email)) {
    validatorErrors.push("Enter an Valid Email ");
  } else if (phoneNumber == null || phoneNumber === undefined) {
    validatorErrors.push("Invalid PhoneNumber");
  } else if (
    (phoneNumbers(phoneNumber, "IN") &&
      phoneNumbers(phoneNumber, "IN").isValid()) == false ||
    (phoneNumbers(phoneNumber, "IN") &&
      phoneNumbers(phoneNumber, "IN").isValid()) === undefined
  ) {
    validatorErrors.push("PhoneNumber: Invalid Data Type");
  } else if (employeeId == null || employeeId === undefined) {
    validatorErrors.push("Invalid EmployeeId");
  } else if (!(typeof employeeId === "string")) {
    validatorErrors.push("EmployeeId: Invalid Data Type");
  } else if (dateOfJoining == null || dateOfJoining === undefined) {
    validatorErrors.push("Please Enter Date");
  } else if (
    !timeHelper.validateDateWithTimezone(
      dateOfJoining,
      "DD/MM/YY",
      process.env.timezone
    )
  ) {
    validatorErrors.push("Invalid Date Format");
  } else if (designation == null || designation === undefined) {
    validatorErrors.push("Designation Not Found");
  } else if (!(typeof designation === "string")) {
    validatorErrors.push("Designation: Invalid Data Type");
  } else if (department == null || department === undefined) {
    validatorErrors.push("Department Not Found");
  } else if (!Array.isArray(department)) {
    validatorErrors.push("Department: Invalid Data Type");
  }
  return validatorErrors;
};

// Create & Update Asset Template Validator
exports.createAssetTemplateValidator = (name, department, parameters) => {
  let validatorErrors = [];

  if (name == null || name === undefined) {
    validatorErrors.push("Invalid Name");
  } else if (!(typeof name === "string")) {
    validatorErrors.push("Name: Invalid Data Type");
  } else if (department == null || department === undefined) {
    validatorErrors.push("Department Not Found");
  } else if (!Array.isArray(department)) {
    validatorErrors.push("Department: Invalid Data Type");
  } else if (parameters == null || parameters === undefined) {
    validatorErrors.push("Invalid Parameters");
  } else if (!Array.isArray(parameters)) {
    validatorErrors.push("Parameters: Invalid Data Type");
  }
  return validatorErrors;
};

// Create & Update Asset Model Validator
exports.createAssetModelValidator = (
  modelId,
  additionalModelId,
  assetName,
  manufacturer
) => {
  let validatorErrors = [];

  if (modelId == null || modelId === undefined) {
    validatorErrors.push("Invalid ModelId");
  } else if (!(typeof modelId === "string")) {
    validatorErrors.push("ModelId: Invalid Data Type");
  } else if (additionalModelId == null || additionalModelId === undefined) {
    validatorErrors.push("Invalid AdditionalModelId");
  } else if (!(typeof additionalModelId === "string")) {
    validatorErrors.push("AdditionalModelId: Invalid Data Type");
  } else if (assetName == null || assetName === undefined) {
    validatorErrors.push("Invalid AssetName");
  } else if (!(typeof assetName === "string")) {
    validatorErrors.push("AssetName: Invalid Data Type");
  } else if (manufacturer == null || manufacturer === undefined) {
    validatorErrors.push("Invalid Manufacturer");
  } else if (!(typeof manufacturer === "string")) {
    validatorErrors.push("Manufacturer: Invalid Data Type");
  }
  return validatorErrors;
};

// Create & Update Asset Stock Validator
exports.createAssetStockValidator = (
  serialNo,
  issuedDateTime,
  warrantyExpiry
) => {
  let validatorErrors = [];

  if (serialNo == null || serialNo === undefined) {
    validatorErrors.push("Invalid SerialNo");
  } else if (!(typeof serialNo === "string")) {
    validatorErrors.push("SerilaNo: Invalid Data Type");
  } else if (issuedDateTime == null || issuedDateTime === undefined) {
    validatorErrors.push("Please Enter Date");
  } else if (
    !timeHelper.validateDateWithTimezone(
      issuedDateTime,
      "DD/MM/YY",
      process.env.timezone
    )
  ) {
    validatorErrors.push("Invalid Date Format");
  } else if (warrantyExpiry == null || warrantyExpiry === undefined) {
    validatorErrors.push("Please Enter Date");
  } else if (
    !timeHelper.validateDateWithTimezone(
      warrantyExpiry,
      "DD/MM/YY",
      process.env.timezone
    )
  ) {
    validatorErrors.push("Invalid Date Format");
  }
  return validatorErrors;
};

// Raise a Ticket Validator
exports.raiseTicketValidator = (type, priority) => {
  let validatorErrors = [];

  if (type == null || type === undefined) {
    validatorErrors.push("Invalid Type");
  } else if (!(typeof type === "string")) {
    validatorErrors.push("Type: Invalid Data Type");
  } else if (priority == null || priority === undefined) {
    validatorErrors.push("Invalid Priority");
  } else if (!(typeof priority === "string")) {
    validatorErrors.push("Priority: Invalid Data Type");
  }

  return validatorErrors;
};

// Comment Validator
exports.commentValidator = (comment, dateTime) => {
  let validatorErrors = [];

  if (comment == null || comment === undefined) {
    validatorErrors.push("Invalid Comment");
  } else if (!(typeof comment === "string")) {
    validatorErrors.push("Comment: Invalid Data Type");
  } else if (dateTime == null || dateTime === undefined) {
    validatorErrors.push("Invalid DateTime");
  } else if (!(typeof dateTime === "string")) {
    validatorErrors.push("DateTime: Invalid Data Type");
  }

  return validatorErrors;
};

// Delete Validator
exports.deleteValidator = (id) => {
  let validatorErrors = [];

  if (id == null || id === undefined) {
    validatorErrors.push("Invalid ID");
  }
  return validatorErrors;
};

// Other Validators
exports.otherAssetDetailsValidator = (name) => {
  let validatorErrors = [];

  if (name == null || name === undefined) {
    validatorErrors.push("Invalid Name");
  } else if (!(typeof name === "string")) {
    validatorErrors.push("Name: Invalid Data Type");
  }
  return validatorErrors;
};

// Assign Role Validator
exports.assignRoleValidator = (
  roleTitle,
  userReadFlag,
  userWriteFlag,
  companyReadFlag,
  companyWriteFlag,
  vendorReadFlag,
  vendorWriteFlag,
  ticketReadFlag,
  ticketWriteFlag,
  assetTemplateReadFlag,
  assetTemplateWriteFlag,
  assetStockReadFlag,
  assetStockWriteFlag,
  assetModelReadFlag,
  assetModelWriteFlag,
  assignRoleReadFlag,
  assignRoleWriteFlag,
  locationReadFlag,
  locationWriteFlag,
  locationMainFlag,
  userMainFlag,
  companyMainFlag,
  vendorMainFlag,
  ticketMainFlag,
  assetTemplateMainFlag,
  assetStockMainFlag,
  assetModelMainFlag,
  assignRoleMainFlag,
  assetTypeMainFlag,
  assetTypeReadFlag,
  assetTypeWriteFlag,
  assetCategoryMainFlag,
  assetCategoryReadFlag,
  assetCategoryWriteFlag,
  assetSubCategoryMainFlag,
  assetSubCategoryReadFlag,
  assetSubCategoryWriteFlag
) => {
  let validatorErrors = [];

  if (roleTitle == null || roleTitle === undefined) {
    validatorErrors.push("Invalid RoleTitle");
  } else if (!(typeof roleTitle === "string")) {
    validatorErrors.push("RoleTitle: Invalid Data Type");
  } else if (userReadFlag == null || userReadFlag === undefined) {
    validatorErrors.push("Invalid UserReadFlag");
  } else if (!(typeof userReadFlag === "boolean")) {
    validatorErrors.push("UserReadFlag: Invalid Data Type");
  } else if (userWriteFlag == null || userWriteFlag === undefined) {
    validatorErrors.push("Invalid UserWriteFlag");
  } else if (!(typeof userWriteFlag === "boolean")) {
    validatorErrors.push("UserWriteFlag: Invalid Data Type");
  } else if (companyReadFlag == null || companyReadFlag === undefined) {
    validatorErrors.push("Invalid CompanyReadFlag");
  } else if (!(typeof companyReadFlag === "boolean")) {
    validatorErrors.push("CompanyReadFlag: Invalid Data Type");
  } else if (companyWriteFlag == null || companyWriteFlag === undefined) {
    validatorErrors.push("Invalid CompanyWriteFlag");
  } else if (!(typeof companyWriteFlag === "boolean")) {
    validatorErrors.push("CompanyWriteFlag: Invalid Data Type");
  } else if (vendorReadFlag == null || vendorReadFlag === undefined) {
    validatorErrors.push("Invalid VendorReadFlag");
  } else if (!(typeof vendorReadFlag === "boolean")) {
    validatorErrors.push("VendorReadFlag: Invalid Data Type");
  } else if (vendorWriteFlag == null || vendorWriteFlag === undefined) {
    validatorErrors.push("Invalid vendorWriteFlag");
  } else if (!(typeof vendorWriteFlag === "boolean")) {
    validatorErrors.push("VendorWriteFlag: Invalid Data Type");
  } else if (ticketReadFlag == null || ticketReadFlag === undefined) {
    validatorErrors.push("Invalid TicketReadFlag");
  } else if (!(typeof ticketReadFlag === "boolean")) {
    validatorErrors.push("TicketReadFlag: Invalid Data Type");
  } else if (ticketWriteFlag == null || ticketWriteFlag === undefined) {
    validatorErrors.push("Invalid TicketWriteFlag");
  } else if (!(typeof ticketWriteFlag === "boolean")) {
    validatorErrors.push("TicketWriteFlag: Invalid Data Type");
  } else if (
    assetTemplateReadFlag == null ||
    assetTemplateReadFlag === undefined
  ) {
    validatorErrors.push("Invalid AssetTemplateReadFlag");
  } else if (!(typeof assetTemplateReadFlag === "boolean")) {
    validatorErrors.push("AssetTemplateReadFlag: Invalid Data Type");
  } else if (
    assetTemplateWriteFlag == null ||
    assetTemplateWriteFlag === undefined
  ) {
    validatorErrors.push("Invalid AssetTemplateWriteFlag");
  } else if (!(typeof assetTemplateWriteFlag === "boolean")) {
    validatorErrors.push("AssetTemplateWriteFlag: Invalid Data Type");
  } else if (assetStockReadFlag == null || assetStockReadFlag === undefined) {
    validatorErrors.push("Invalid AssetStockReadFlag");
  } else if (!(typeof assetStockReadFlag === "boolean")) {
    validatorErrors.push("AssetStockReadFlag: Invalid Data Type");
  } else if (assetStockWriteFlag == null || assetStockWriteFlag === undefined) {
    validatorErrors.push("Invalid AssetStockWriteFlag");
  } else if (!(typeof assetStockWriteFlag === "boolean")) {
    validatorErrors.push("AssetStockWriteFlag: Invalid Data Type");
  } else if (assetModelReadFlag == null || assetModelReadFlag === undefined) {
    validatorErrors.push("Invalid AssetModelReadFlag");
  } else if (!(typeof assetModelReadFlag === "boolean")) {
    validatorErrors.push("AssetModelReadFlag: Invalid Data Type");
  } else if (assetModelWriteFlag == null || assetModelWriteFlag === undefined) {
    validatorErrors.push("Invalid AssetModelWriteFlag");
  } else if (!(typeof assetModelWriteFlag === "boolean")) {
    validatorErrors.push("AssetModelWriteFlag: Invalid Data Type");
  } else if (assignRoleReadFlag == null || assignRoleReadFlag === undefined) {
    validatorErrors.push("Invalid AssignRoleReadFlag");
  } else if (!(typeof assignRoleReadFlag === "boolean")) {
    validatorErrors.push("AssignRoleReadFlag: Invalid Data Type");
  } else if (assignRoleWriteFlag == null || assignRoleWriteFlag === undefined) {
    validatorErrors.push("Invalid AssignRoleWriteFlag");
  } else if (!(typeof assignRoleWriteFlag === "boolean")) {
    validatorErrors.push("AssignRoleWriteFlag: Invalid Data Type");
  } else if (locationReadFlag == null || locationReadFlag === undefined) {
    validatorErrors.push("Invalid LocationReadFlag");
  } else if (!(typeof locationReadFlag === "boolean")) {
    validatorErrors.push("LocationReadFlag: Invalid Data Type");
  } else if (locationWriteFlag == null || locationWriteFlag === undefined) {
    validatorErrors.push("Invalid LocationWriteFlag");
  } else if (!(typeof locationWriteFlag === "boolean")) {
    validatorErrors.push("LocationWriteFlag: Invalid Data Type");
  } else if (locationMainFlag == null || locationMainFlag === undefined) {
    validatorErrors.push("Invalid LocationMainFlag");
  } else if (!(typeof locationMainFlag === "boolean")) {
    validatorErrors.push("LocationMainFlag: Invalid Data Type");
  } else if (userMainFlag == null || userMainFlag === undefined) {
    validatorErrors.push("Invalid UserMainFlag");
  } else if (!(typeof userMainFlag === "boolean")) {
    validatorErrors.push("UserMainFlag: Invalid Data Type");
  } else if (companyMainFlag == null || companyMainFlag === undefined) {
    validatorErrors.push("Invalid CompanyMainFlag");
  } else if (!(typeof companyMainFlag === "boolean")) {
    validatorErrors.push("CompanyMainFlag: Invalid Data Type");
  } else if (vendorMainFlag == null || vendorMainFlag === undefined) {
    validatorErrors.push("Invalid VendorMainFlag");
  } else if (!(typeof vendorMainFlag === "boolean")) {
    validatorErrors.push("VendorMainFlag: Invalid Data Type");
  } else if (ticketMainFlag == null || ticketMainFlag === undefined) {
    validatorErrors.push("Invalid TicketMainFlag");
  } else if (!(typeof ticketMainFlag === "boolean")) {
    validatorErrors.push("TicketMainFlag: Invalid Data Type");
  } else if (
    assetTemplateMainFlag == null ||
    assetTemplateMainFlag === undefined
  ) {
    validatorErrors.push("Invalid AssetTemplateMainFlag");
  } else if (!(typeof assetTemplateMainFlag === "boolean")) {
    validatorErrors.push("AssetTemplateMainFlag: Invalid Data Type");
  } else if (assetStockMainFlag == null || assetStockMainFlag === undefined) {
    validatorErrors.push("Invalid AssetStockMainFlag");
  } else if (!(typeof assetStockMainFlag === "boolean")) {
    validatorErrors.push("AssetStockMainFlag: Invalid Data Type");
  } else if (assetModelMainFlag == null || assetModelMainFlag === undefined) {
    validatorErrors.push("Invalid AssetModelMainFlag");
  } else if (!(typeof assetModelMainFlag === "boolean")) {
    validatorErrors.push("AssetModelMainFlag: Invalid Data Type");
  } else if (assignRoleMainFlag == null || assignRoleMainFlag === undefined) {
    validatorErrors.push("Invalid AssignRoleMainFlag");
  } else if (!(typeof assignRoleMainFlag === "boolean")) {
    validatorErrors.push("AssignRoleMainFlag: Invalid Data Type");
  } else if (assetTypeMainFlag == null || assetTypeMainFlag === undefined) {
    validatorErrors.push("Invalid AssetTypeMainFlag");
  } else if (!(typeof assetTypeMainFlag === "boolean")) {
    validatorErrors.push("AssetTypeMainFlag: Invalid Data Type");
  } else if (assetTypeWriteFlag == null || assetTypeWriteFlag === undefined) {
    validatorErrors.push("Invalid AssetTypeWriteFlag");
  } else if (!(typeof assetTypeWriteFlag === "boolean")) {
    validatorErrors.push("AssetTypeWriteFlag: Invalid Data Type");
  } else if (assetTypeReadFlag == null || assetTypeReadFlag === undefined) {
    validatorErrors.push("Invalid AssetTypeReadFlag");
  } else if (!(typeof assetTypeReadFlag === "boolean")) {
    validatorErrors.push("AssetTypeReadFlag: Invalid Data Type");
  } else if (
    assetCategoryMainFlag == null ||
    assetCategoryMainFlag === undefined
  ) {
    validatorErrors.push("Invalid AssetCategoryMainFlag");
  } else if (!(typeof assetCategoryMainFlag === "boolean")) {
    validatorErrors.push("AssetCategoryMainFlag: Invalid Data Type");
  } else if (
    assetCategoryWriteFlag == null ||
    assetCategoryWriteFlag === undefined
  ) {
    validatorErrors.push("Invalid AssetCategoryWriteFlag");
  } else if (!(typeof assetCategoryWriteFlag === "boolean")) {
    validatorErrors.push("AssetCategoryWriteFlag: Invalid Data Type");
  } else if (
    assetCategoryReadFlag == null ||
    assetCategoryReadFlag === undefined
  ) {
    validatorErrors.push("Invalid AssetCategoryReadFlag");
  } else if (!(typeof assetCategoryReadFlag === "boolean")) {
    validatorErrors.push("AssetCategoryReadFlag: Invalid Data Type");
  } else if (
    assetSubCategoryMainFlag == null ||
    assetSubCategoryMainFlag === undefined
  ) {
    validatorErrors.push("Invalid AssetSubCategoryMainFlag");
  } else if (!(typeof assetSubCategoryMainFlag === "boolean")) {
    validatorErrors.push("AssetSubCategoryMainFlag: Invalid Data Type");
  } else if (
    assetSubCategoryWriteFlag == null ||
    assetSubCategoryWriteFlag === undefined
  ) {
    validatorErrors.push("Invalid AssetSubCategoryWriteFlag");
  } else if (!(typeof assetSubCategoryWriteFlag === "boolean")) {
    validatorErrors.push("AssetSubCategoryWriteFlag: Invalid Data Type");
  } else if (
    assetSubCategoryReadFlag == null ||
    assetSubCategoryReadFlag === undefined
  ) {
    validatorErrors.push("Invalid AssetSubCategoryReadFlag");
  } else if (!(typeof assetSubCategoryReadFlag === "boolean")) {
    validatorErrors.push("AssetSubCategoryReadFlag: Invalid Data Type");
  }

  return validatorErrors;
};
