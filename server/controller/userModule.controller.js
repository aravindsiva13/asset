const User = require("../model/user");
const Role = require("../model/role");
const { Stock, Model } = require("../model/asset");
const responsePacket = require("../helpers/response");
const mail = require("../helpers/mail");
const mailTemplate = require("../helpers/mailTemplate");
const jwt = require("jwt-then");
const Company = require("../model/company");
const { encryptPassword, comparePassword } = require("../helpers/encryption");
const { addDisplayId, modifyDisplayId } = require("../helpers/displayId");
const {
  loginUserValidator,
  assignRoleValidator,
  createUserValidator,
  updateUserValidator,
  deleteValidator,
} = require("../helpers/validator");

exports.loginUser = async (req, res) => {
  const { email, password } = req.body;

  let error = [];

  error.push(...loginUserValidator(email, password));

  if (error.length != 0) {
    res.status(400).send(
      responsePacket.responsePacket(false, "validation error", {
        ErrorMsg: error,
      })
    );
    return;
  }
  console.log(email);
  try {
    let result = await User.find({ email: email });
    console.log(result);
    if (result != 0) {
      const validationSuccessful = comparePassword(
        password,
        result[0].password
      );

      if (validationSuccessful) {
        let token = await jwt.sign(
          { userId: result[0]._id, type: "user" },
          process.env.SECRET
        );

        const roleIds = result[0].assignRoleRefIds;

        let roles = await Role.find({ _id: { $in: roleIds } });

        res.status(200).send(
          responsePacket.responsePacket(true, "User Login successful", {
            token: token,
            userDetails: result[0],
            roles: roles.length > 0 ? roles[0] : {},
          })
        );
      } else {
        res
          .status(500)
          .send(
            responsePacket.responsePacket(
              false,
              "Wrong Password! Please enter the valid password."
            )
          );
      }
    } else {
      res
        .status(500)
        .send(responsePacket.responsePacket(false, "User not found"));
    }
  } catch (e) {
    console.log(e);
    res
      .status(500)
      .send(responsePacket.responsePacket(false, "User unable to log in"));
  }
};

/// Get User Details
exports.getUserDetails = async (req, res) => {
  const { userId } = req.body;

  try {
    var allUsers = await User.find().lean();

    if (allUsers != null) {
      for (let i = 0; i < allUsers.length; i++) {
        allUsers[i]["company"] = [];
        allUsers[i]["assignedRoles"] = [];
        allUsers[i]["assetName"] = [];
        let companiesFound = await Company.find()
          .where("_id")
          .in(allUsers[i].companyRefId)
          .select("name")
          .lean();

        companiesFound.forEach((el) => {
          allUsers[i]["company"].push(el.name);
        });

        let rolesFound = await Role.find()
          .where("_id")
          .in(allUsers[i].assignRoleRefIds)
          .select("roleTitle")
          .lean();

        rolesFound.forEach((el) => {
          allUsers[i]["assignedRoles"].push(el.roleTitle);
        });

        if (allUsers[i].assetStockRefId !== null) {
          let stockFound = await Stock.find()
            .where("_id")
            .in(allUsers[i].assetStockRefId)
            .select("assetRefId")
            .lean();
          let modelArray = [];
          stockFound.forEach((el) => {
            modelArray.push(el.assetRefId);
          });

          allUsers[i]["modelId"] = modelArray;
          let modelIds = modelArray;

          let modelFound = await Model.find()
            .where("_id")
            .in(modelIds)
            .select("assetName")
            .lean();

          modelFound.forEach((el) => {
            allUsers[i]["assetName"].push(el.assetName);
          });
        }

        if (
          allUsers[i].reportManagerRefId !== null &&
          allUsers[i].reportManagerRefId !== undefined &&
          allUsers[i].reportManagerRefId !== ""
        ) {
          let userFound = await User.find()
            .where("_id")
            .in(allUsers[i].reportManagerRefId)
            .select("name")
            .lean();

          if (
            userFound !== null &&
            userFound !== undefined &&
            userFound.length > 0
          ) {
            allUsers[i]["managerName"] = userFound[0].name;
          }
        }
      }
    }

    if (allUsers) {
      res.status(200).send(
        responsePacket.responsePacket(true, "User Found", {
          allUsers: allUsers,
        })
      );
    }
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "User Not Found", {
        allUsers: allUsers,
      })
    );
  }
};

exports.getParticularUserDetails = async (req, res) => {
  const { userId } = req.body;

  var allUsers = [];

  try {
    let userIdArray;

    if (Array.isArray(userId)) {
      userIdArray = userId;
    } else {
      userIdArray = userId.split(",");
    }

    const userIdsFetcher = userIdArray.map(async (particularUserId) => {
      var userDetails;
      try {
        const userDetailsList = await User.find({ _id: particularUserId });

        userDetails = userDetailsList[0].toObject();

        if (userDetails === undefined || userDetails === null) {
          userDetails = {
            _id: particularUserId,
            error: "Null or Undefined",
          };
        } else {
          userDetails["company"] = [];
          userDetails["assignedRoles"] = [];

          let companiesFound = await Company.find()
            .where("_id")
            .in(userDetails.companyRefId)
            .select("name")
            .lean();

          companiesFound.forEach((el) => {
            userDetails["company"].push(el.name);
          });

          let rolesFound = await Role.find()
            .where("_id")
            .in(userDetails.assignRoleRefIds)
            .select("roleTitle")
            .lean();

          rolesFound.forEach((el) => {
            userDetails["assignedRoles"].push(el.roleTitle);
          });

          if (
            userDetails.reportManagerRefId !== null &&
            userDetails.reportManagerRefId !== undefined &&
            userDetails.reportManagerRefId !== ""
          ) {
            let userFound = await User.find()
              .where("_id")
              .in(userDetails.reportManagerRefId)
              .select("name")
              .lean();

            if (
              userFound !== null &&
              userFound !== undefined &&
              userFound.length > 0
            ) {
              userDetails["managerName"] = userFound[0].name;
            }
          }
        }

        allUsers.push(userDetails);
      } catch (e) {
        userDetails = {
          _id: particularUserId,
          error: String(e),
        };
      }
    });

    await Promise.allSettled(userIdsFetcher);

    if (allUsers) {
      res.status(200).send(
        responsePacket.responsePacket(true, "User Found", {
          allUsers: allUsers,
        })
      );
    }
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "User Not Found", {
        null: null,
      })
    );
  }
};

/// Add User
exports.addUser = async (req, res) => {
  let {
    name,
    email,
    phoneNumber,
    employeeId,
    dateOfJoining,
    password,
    designation,
    department,
    createdBy,
    updatedBy,
    companyRefId,
    assignRoleRefIds,
    reportManagerRefId,
    tag,
  } = JSON.parse(req.body.jsonData);

  let originalPassowrd = password;

  let image = null;

  if (req.files != undefined && req.files != null) {
    try {
      image = req.files["image"][0].filename;
    } catch (e) {
      console.log(e);
    }
  }

  let error = [];

  error.push(
    ...createUserValidator(
      name,
      email,
      phoneNumber,
      employeeId,
      dateOfJoining,
      password,
      designation,
      department
    )
  );

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  let idPrefix = "USER";

  let displayId;
  try {
    displayId = await addDisplayId(idPrefix, User);
  } catch (error) {
    console.error("Error while generating displayId:", error);
    res.status(500).send({
      ErrorMsg: "Error while generating displayId",
    });
    return;
  }

  const encryptedPassword = encryptPassword(password);

  try {
    let result = new User({
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      employeeId: employeeId,
      dateOfJoining: dateOfJoining,
      password: encryptedPassword,
      designation: designation,
      department: department,
      createdBy: createdBy,
      updatedBy: updatedBy,
      companyRefId: companyRefId,
      assignRoleRefIds: assignRoleRefIds,
      reportManagerRefId: reportManagerRefId,
      image: image,
      tag: tag,
      displayId: displayId,
    });

    await result.save();

    let data = {
      type: "Your account for IT Asset Management has been created",
      userName: result.name,
      userEmailId: result.email,
      originalPassowrd: originalPassowrd,
    };

    let template = await mailTemplate.generateTemplate("account", data);

    let sendEmail = mail.sendEmail(
      result.email,
      "Welcome to ITAM",
      null,
      template
    );

    let rsspData = {
      type: "Your account for Self Service Portal has been created",
      userName: result.name,
      userEmailId: result.email,
      originalPassowrd: originalPassowrd,
    };

    let rsspTemplate = await mailTemplate.generateTemplate("rssp", rsspData);

    let sendEmailForRSSP = mail.sendEmail(
      result.email,
      "Welcome to Self Service Portal",
      null,
      rsspTemplate
    );

    res.status(200).send(
      responsePacket.responsePacket(true, "User Created Successfully", {
        null: null,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "User Not Created", {
        null: null,
      })
    );
  }
};

/// Add Bulk User
exports.addBulkUsers = async (req, res) => {
  let usersData;

  try {
    usersData = JSON.parse(req.body.jsonData);
  } catch (e) {
    return res.status(400).send({
      ErrorMsg: "Invalid JSON data",
    });
  }

  if (!Array.isArray(usersData)) {
    return res.status(400).send({
      ErrorMsg: "Data should be in array format",
    });
  }

  let errors = [];
  let successfulCreations = 0;
  let failedUsers = [];

  for (let userData of usersData) {
    let {
      name,
      email,
      phoneNumber,
      employeeId,
      dateOfJoining,
      password,
      designation,
      department,
      createdBy,
      updatedBy,
      companyRefId,
      assignRoleRefIds,
      reportManagerRefId,
      tag,
    } = userData;

    let originalPassword = password;
    let image = null;

    if (req.files != undefined && req.files != null) {
      try {
        image = req.files["image"] ? req.files["image"][0].filename : null;
      } catch (e) {
        console.log(e);
      }
    }

    let error = [];

    error.push(
      ...createUserValidator(
        name,
        email,
        phoneNumber,
        employeeId,
        dateOfJoining,
        password,
        designation,
        department
      )
    );

    if (error.length > 0) {
      failedUsers.push({
        userData: { email },
        ErrorMsg: error,
      });
      continue;
    }

    let idPrefix = "USER";

    let displayId;
    try {
      displayId = await addDisplayId(idPrefix, User);
    } catch (error) {
      console.error("Error while generating displayId:", error);
      errors.push({
        userData: userData,
        ErrorMsg: "Error while generating displayId",
      });
      continue;
    }

    const encryptedPassword = encryptPassword(password);

    try {
      let result = new User({
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        employeeId: employeeId,
        dateOfJoining: dateOfJoining,
        password: encryptedPassword,
        designation: designation,
        department: department,
        createdBy: createdBy,
        updatedBy: updatedBy,
        companyRefId: companyRefId,
        assignRoleRefIds: assignRoleRefIds,
        reportManagerRefId: reportManagerRefId,
        image: image,
        tag: tag,
        displayId: displayId,
      });

      await result.save();

      successfulCreations++;

      let data = {
        type: "Your account for IT Asset Management has been created",
        userName: result.name,
        userEmailId: result.email,
        originalPassword: originalPassword,
      };

      let template = await mailTemplate.generateTemplate("account", data);

      let sendEmail = mail.sendEmail(
        result.email,
        "Welcome to ITAM",
        null,
        template
      );

      let rsspData = {
        type: "Your account for Self Service Portal has been created",
        userName: result.name,
        userEmailId: result.email,
        originalPassword: originalPassword,
      };

      let rsspTemplate = await mailTemplate.generateTemplate("rssp", rsspData);

      let sendEmailForRSSP = mail.sendEmail(
        result.email,
        "Welcome to Self Service Portal",
        null,
        rsspTemplate
      );
    } catch (e) {
      console.log(e);
      if (error.code === 11000 && error.keyPattern.email === 1) {
        const { email, ...filteredUserData } = userData;
        failedUsers.push({
          filteredUserData,
          ErrorMsg: `Duplicate email: ${email}`,
        });
      } else {
        failedUsers.push({
          userData: userData,
          ErrorMsg: "Internal Server Error",
        });
      }
    }
  }

  if (failedUsers.length > 0) {
    return res.status(200).send(
      responsePacket.responsePacket(
        true,
        "Some users were not created successfully.",
        {
          failedUsers: failedUsers,
        }
      )
    );
  } else {
    return res.status(200).send(
      responsePacket.responsePacket(true, "All Users Created Successfully", {
        null: null,
      })
    );
  }
};

/// Update or Edit User
exports.updateUser = async (req, res) => {
  let {
    name,
    email,
    phoneNumber,
    employeeId,
    dateOfJoining,
    password,
    designation,
    department,
    companyRefId,
    assignRoleRefIds,
    reportManagerRefId,
    createdBy,
    updatedBy,
    tag,
    sId,
  } = JSON.parse(req.body.jsonData);

  const userId = sId;

  let originalPassowrd = password;

  let image = null;

  if (req.file != null) {
    image = req.file.filename;
  }

  let error = [];

  error.push(
    ...updateUserValidator(
      name,
      email,
      phoneNumber,
      employeeId,
      dateOfJoining,
      designation,
      department
    )
  );

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  let updateFields = {
    name: name,
    email: email,
    phoneNumber: phoneNumber,
    employeeId: employeeId,
    dateOfJoining: dateOfJoining,
    designation: designation,
    department: department,
    companyRefId: companyRefId,
    assignRoleRefIds: assignRoleRefIds,
    reportManagerRefId: reportManagerRefId,
    createdBy: createdBy,
    updatedBy: updatedBy,
    image: image,
    tag: tag,
  };

  if (password) {
    const encryptedPassword = encryptPassword(password);
    updateFields.password = encryptedPassword;

    let data = {
      type: "Your account for IT Asset Management has been updated",
      userName: updateFields.name,
      userEmailId: updateFields.email,
      originalPassowrd: originalPassowrd,
    };

    let template = await mailTemplate.generateTemplate("account", data);

    let sendEmail = mail.sendEmail(
      updateFields.email,
      "Welcome to ITAM",
      null,
      template
    );

    let rsspData = {
      type: "Your account for Self Service Portal has been updated",
      userName: updateFields.name,
      userEmailId: updateFields.email,
      originalPassowrd: originalPassowrd,
    };

    let rsspTemplate = await mailTemplate.generateTemplate("rssp", rsspData);

    let sendEmailForRSSP = mail.sendEmail(
      updateFields.email,
      "Welcome to Self Service Portal",
      null,
      rsspTemplate
    );
  }

  try {
    const foundUser = await User.findOneAndUpdate(
      { _id: userId },
      updateFields
    );

    if (!foundUser) {
      return res.status(404).send(
        responsePacket.responsePacket(false, "User not found", {
          null: null,
        })
      );
    }

    res.status(200).send(
      responsePacket.responsePacket(true, "User updated successfully", {
        oldUserData: foundUser,
        newUserData: foundUser,
      })
    );
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "User Not Updated", {
        null: null,
      })
    );
  }
};

// Delete User
exports.deleteUser = async (req, res) => {
  const { id } = req.body;

  let error = [];

  error.push(...deleteValidator(id));

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  let result = null;
  try {
    let user = await User.findById({ _id: id });

    if (!user) {
      res.status(404).send({
        ErrorMsg: "User not found",
      });
      return;
    }

    let displayId = user.displayId;

    let idPrefix = "USER";

    result = await User.deleteOne({
      _id: id,
    });

    try {
      await modifyDisplayId(displayId, idPrefix);
    } catch (error) {
      console.error("Error while removing displayId:", error);
      res.status(500).send({
        ErrorMsg: "Error while removing displayId",
      });
      return;
    }

    res.status(200).send(
      responsePacket.responsePacket(true, "User is deleted successfully", {
        null: null,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "User is not deleted", {
        null: null,
      })
    );
  }
};

// Get Assign Role Details
exports.getAssignRoleDetails = async (req, res) => {
  const { roleIds } = req.body;

  var roles = [];

  if (roleIds === null || roleIds === undefined || roleIds.length <= 0) {
    roles = await Role.find();
  } else {
    const roleIdsFetcher = roleIds.map(async (roleId) => {
      var assignRoleDetails;
      try {
        const assignRoleDetails = await Company.find({
          _id: roleId,
        });
        assignRoleDetails = assignRoleDetails[0];
      } catch (e) {
        assignRoleDetails = {
          _id: roleId,
          error: String(e),
        };
      }

      roles.push(assignRoleDetails);
    });

    await Promise.allSettled(roleIdsFetcher);
  }

  res.status(200).send(
    responsePacket.responsePacket(true, "Roles Query Succeeded", {
      roles: roles,
    })
  );
};

/// Assign Role
exports.assignRole = async (req, res) => {
  const {
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
    assetSubCategoryWriteFlag,
  } = req.body;

  let error = [];

  error.push(
    ...assignRoleValidator(
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
    )
  );

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  try {
    let result = new Role({
      roleTitle: roleTitle,
      userReadFlag: userReadFlag,
      userWriteFlag: userWriteFlag,
      companyReadFlag: companyReadFlag,
      companyWriteFlag: companyWriteFlag,
      vendorReadFlag: vendorReadFlag,
      vendorWriteFlag: vendorWriteFlag,
      ticketReadFlag: ticketReadFlag,
      ticketWriteFlag: ticketWriteFlag,
      assetTemplateReadFlag: assetTemplateReadFlag,
      assetTemplateWriteFlag: assetTemplateWriteFlag,
      assetStockReadFlag: assetStockReadFlag,
      assetStockWriteFlag: assetStockWriteFlag,
      assetModelReadFlag: assetModelReadFlag,
      assetModelWriteFlag: assetModelWriteFlag,
      assignRoleReadFlag: assignRoleReadFlag,
      assignRoleWriteFlag: assignRoleWriteFlag,
      locationReadFlag: locationReadFlag,
      locationWriteFlag: locationWriteFlag,
      locationMainFlag: locationMainFlag,
      userMainFlag: userMainFlag,
      companyMainFlag: companyMainFlag,
      vendorMainFlag: vendorMainFlag,
      ticketMainFlag: ticketMainFlag,
      assetTemplateMainFlag: assetTemplateMainFlag,
      assetStockMainFlag: assetStockMainFlag,
      assetModelMainFlag: assetModelMainFlag,
      assignRoleMainFlag: assignRoleMainFlag,
      assetTypeMainFlag: assetTypeMainFlag,
      assetTypeReadFlag: assetTypeReadFlag,
      assetTypeWriteFlag: assetTypeWriteFlag,
      assetCategoryMainFlag: assetCategoryMainFlag,
      assetCategoryReadFlag: assetCategoryReadFlag,
      assetCategoryWriteFlag: assetCategoryWriteFlag,
      assetSubCategoryMainFlag: assetSubCategoryMainFlag,
      assetSubCategoryReadFlag: assetSubCategoryReadFlag,
      assetSubCategoryWriteFlag: assetSubCategoryWriteFlag,
    });
    await result.save();
    res.status(200).send(
      responsePacket.responsePacket(true, "Assign Role Created Successfully", {
        null: null,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Assign Role Not Created", {
        null: null,
      })
    );
  }
};

/// Update Assign Role
exports.updateAssignRole = async (req, res) => {
  const {
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
    assetSubCategoryWriteFlag,
    _id,
  } = req.body;

  const roleId = _id;

  let error = [];

  error.push(
    ...assignRoleValidator(
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
    )
  );

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  try {
    const foundRole = await Role.findOneAndUpdate(
      { _id: roleId },
      {
        roleTitle: roleTitle,
        userReadFlag: userReadFlag,
        userWriteFlag: userWriteFlag,
        companyReadFlag: companyReadFlag,
        companyWriteFlag: companyWriteFlag,
        vendorReadFlag: vendorReadFlag,
        vendorWriteFlag: vendorWriteFlag,
        ticketReadFlag: ticketReadFlag,
        ticketWriteFlag: ticketWriteFlag,
        assetTemplateReadFlag: assetTemplateReadFlag,
        assetTemplateWriteFlag: assetTemplateWriteFlag,
        assetStockReadFlag: assetStockReadFlag,
        assetStockWriteFlag: assetStockWriteFlag,
        assetModelReadFlag: assetModelReadFlag,
        assetModelWriteFlag: assetModelWriteFlag,
        assignRoleReadFlag: assignRoleReadFlag,
        assignRoleWriteFlag: assignRoleWriteFlag,
        locationReadFlag: locationReadFlag,
        locationWriteFlag: locationWriteFlag,
        locationMainFlag: locationMainFlag,
        userMainFlag: userMainFlag,
        companyMainFlag: companyMainFlag,
        vendorMainFlag: vendorMainFlag,
        ticketMainFlag: ticketMainFlag,
        assetTemplateMainFlag: assetTemplateMainFlag,
        assetStockMainFlag: assetStockMainFlag,
        assetModelMainFlag: assetModelMainFlag,
        assignRoleMainFlag: assignRoleMainFlag,
        assetTypeMainFlag: assetTypeMainFlag,
        assetTypeReadFlag: assetTypeReadFlag,
        assetTypeWriteFlag: assetTypeWriteFlag,
        assetCategoryMainFlag: assetCategoryMainFlag,
        assetCategoryReadFlag: assetCategoryReadFlag,
        assetCategoryWriteFlag: assetCategoryWriteFlag,
        assetSubCategoryMainFlag: assetSubCategoryMainFlag,
        assetSubCategoryReadFlag: assetSubCategoryReadFlag,
        assetSubCategoryWriteFlag: assetSubCategoryWriteFlag,
      }
    );
    if (!foundRole) {
      return res.status(404).send(
        responsePacket.responsePacket(false, "Assign Role not found", {
          null: null,
        })
      );
    }

    const updatedRole = await Role.findById(roleId);

    res.status(200).send(
      responsePacket.responsePacket(true, "Assign Role updated successfully", {
        oldRoleData: foundRole,
        newROleData: updatedRole,
      })
    );
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Assign Role Not Updated", {
        null: null,
      })
    );
  }
};

exports.deleteRoleDetails = async (req, res) => {
  const { id } = req.body;

  let error = [];

  error.push(...deleteValidator(id));

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  let result = null;
  try {
    result = await Role.deleteOne({
      _id: id,
    });
    res.status(200).send(
      responsePacket.responsePacket(true, "Role is deleted successfully", {
        null: null,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Role is not deleted", {
        null: null,
      })
    );
  }
};
