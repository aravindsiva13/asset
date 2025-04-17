const {
  Stock,
  Model,
  Template,
  Type,
  Categorys,
  SubCategorys,
  Specifications,
  Warranty,
  CheckList,
} = require("../model/asset");
const Location = require("../model/location");
const Vendor = require("../model/vendor");
const User = require("../model/user");
const {
  otherAssetDetailsValidator,
  createAssetTemplateValidator,
  createAssetModelValidator,
  createAssetStockValidator,
  deleteValidator,
} = require("../helpers/validator");
const Company = require("../model/company");
const fs = require("fs");
const responsePacket = require("../helpers/response");
const {
  addDisplayId,
  modifyDisplayId,
  addDisplayIdForStock,
} = require("../helpers/displayId");

//Get Asset Stock Details
exports.getAssetStockDetails = async (req, res) => {
  const { assetStockId, userId } = req.body;

  var stockList = [];

  try {
    if (
      assetStockId === undefined ||
      assetStockId === null ||
      assetStockId.length <= 0
    ) {
      stockList = await Stock.find().lean();
      if (stockList != null) {
        for (let i = 0; i < stockList.length; i++) {
          let locationFound = await Location.find()
            .where("_id")
            .in(stockList[i].locationRefId)
            .select("name")
            .lean();

          if (locationFound !== null && locationFound.length > 0) {
            stockList[i]["locationName"] = locationFound[0].name;
          }

          let assetFound = await Model.find()
            .where("_id")
            .in(stockList[i].assetRefId)
            .select("assetName")
            .lean();
          if (assetFound !== null && assetFound.length > 0) {
            stockList[i]["assetName"] = assetFound[0].assetName;
          }

          let templateId;

          stockList[i]["specificationId"] = [];
          stockList[i]["specifications"] = [];
          stockList[i]["warrantyDetails"] = [];
          stockList[i]["checkListDetails"] = [];
          stockList[i]["parameters"] = [];

          let assetSpecificationIdFound = await Model.findById(
            stockList[i].assetRefId
          )
            .select("specificationRefId")
            .lean();

          if (
            assetSpecificationIdFound &&
            assetSpecificationIdFound.specificationRefId
          ) {
            stockList[i]["specificationId"] =
              assetSpecificationIdFound.specificationRefId;
          }

          if (stockList[i]["specificationId"].length > 0) {
            for (const specId of stockList[i]["specificationId"]) {
              let specificationFound = await Specifications.findById(specId)
                .select("_id key value")
                .lean();

              if (specificationFound) {
                stockList[i]["specifications"].push({
                  specId: specificationFound._id,
                  specKey: specificationFound.key,
                  specValue: specificationFound.value,
                });
              }
            }
          }

          let templateFound = await Model.find()
            .where("_id")
            .in(stockList[i].assetRefId)
            .select("templateRefId")
            .lean();
          if (templateFound !== null && templateFound.length > 0) {
            stockList[i]["templateRefId"] = templateFound[0].templateRefId;
            templateId = templateFound[0].templateRefId;
          }

          if (templateId !== null && templateId.length > 0) {
            let parametersFound = await Template.find()
              .where("_id")
              .in(templateId)
              .select("parameters")
              .lean();

            parametersFound.forEach((el) => {
              stockList[i]["parameters"].push(...el.parameters);
            });
          }

          if (stockList[i].warrantyRefIds != null) {
            let warrantyFound = await Warranty.find()
              .where("_id")
              .in(stockList[i].warrantyRefIds)
              .select("_id warrantyExpiry warrantyName warrantyAttachment")
              .lean();

            if (warrantyFound) {
              warrantyFound.forEach((warranty) => {
                stockList[i]["warrantyDetails"].push({
                  warrantyId: warranty._id,
                  warrantyExpiry: warranty.warrantyExpiry,
                  warrantyName: warranty.warrantyName,
                  warrantyAttachment: warranty.warrantyAttachment,
                });
              });
            }
          }

          if (stockList[i].checkListRefIds != null) {
            let checkListFound = await CheckList.find()
              .where("_id")
              .in(stockList[i].checkListRefIds)
              .select("_id entryName functionalFlag remarks")
              .lean();

            if (checkListFound) {
              checkListFound.forEach((checkList) => {
                const overallStatus =
                  checkList.functionalFlag === "true"
                    ? "Functional"
                    : "Damaged";
                stockList[i]["checkListDetails"].push({
                  checkListId: checkList._id,
                  name: checkList.entryName,
                  status: checkList.functionalFlag,
                  remarks: checkList.remarks,
                  overAllStatus: overallStatus,
                });
              });
            }
          }

          if (stockList[i]["checkListDetails"].length === 0) {
            stockList[i]["overAllStatus"] = "Functional";
          } else {
            const anyFalse = stockList[i]["checkListDetails"].some(
              (checkList) => checkList.status === "false"
            );

            if (anyFalse) {
              stockList[i]["overAllStatus"] = "Damaged";
            } else {
              stockList[i]["overAllStatus"] = "Functional";
            }
          }

          if (stockList[i].vendorRefId !== null) {
            let vendorFound = await Vendor.find()
              .where("_id")
              .in(stockList[i].vendorRefId)
              .select("name")
              .lean();

            if (vendorFound !== null && vendorFound.length > 0) {
              stockList[i]["vendorName"] = vendorFound[0].name;
            }
          }

          let templateIdForCompany;
          let companyId;
          stockList[i]["departments"] = [];

          let templateFoundForCompany = await Model.find()
            .where("_id")
            .in(stockList[i].assetRefId)
            .select("templateRefId")
            .lean();
          if (
            templateFoundForCompany !== null &&
            templateFoundForCompany !== undefined &&
            templateFoundForCompany.length > 0
          ) {
            templateIdForCompany = templateFoundForCompany[0].templateRefId;
          }

          let companyIdFound = await Template.find()
            .where("_id")
            .in(templateId)
            .select("companyRefId")
            .lean();
          if (
            companyIdFound !== null &&
            companyIdFound !== undefined &&
            companyIdFound.length > 0
          ) {
            companyId = companyIdFound[0].companyRefId;
          }

          let companyNameFound = await Company.find()
            .where("_id")
            .in(companyId)
            .select("name")
            .lean();
          if (
            companyNameFound !== null &&
            companyNameFound !== undefined &&
            companyNameFound.length > 0
          ) {
            stockList[i]["companyName"] = companyNameFound[0].name;
          }

          let departmentNameFound = await Company.find()
            .where("_id")
            .in(companyId)
            .select("departments")
            .lean();
          if (
            departmentNameFound !== null &&
            departmentNameFound !== undefined &&
            departmentNameFound.length > 0
          ) {
            departmentNameFound.forEach((el) => {
              stockList[i]["departments"].push(...el.departments);
            });
          }

          if (
            stockList[i].userRefId !== null &&
            stockList[i].userRefId !== "null" &&
            stockList[i].userRefId !== ""
          ) {
            let userFound = await User.find()
              .where("_id")
              .in(stockList[i].userRefId)
              .select("name")
              .lean();

            if (userFound !== null && userFound.length > 0) {
              stockList[i]["assignedTo"] = userFound[0].name;
            }

            let userEmpIdFound = await User.find()
              .where("_id")
              .in(stockList[i].userRefId)
              .select("employeeId")
              .lean();

            stockList[i]["userEmpId"] = userEmpIdFound[0].employeeId;
          }
        }
      }
    } else if (userId === undefined || userId === null || userId.length <= 0) {
      stockList = await Stock.find({ _id: assetStockId }).lean();
      if (stockList != null) {
        for (let i = 0; i < stockList.length; i++) {
          let locationFound = await Location.find()
            .where("_id")
            .in(stockList[i].locationRefId)
            .select("name")
            .lean();

          stockList[i]["locationName"] = locationFound[0].name;

          let assetFound = await Model.find()
            .where("_id")
            .in(stockList[i].assetRefId)
            .select("assetName")
            .lean();

          stockList[i]["assetName"] = assetFound[0].assetName;

          stockList[i]["specificationId"] = [];
          stockList[i]["specifications"] = [];

          let assetSpecificationIdFound = await Model.find()
            .where("_id")
            .in(stockList[i].assetRefId)
            .select("specificationRefId")
            .lean();

          assetSpecificationIdFound.forEach((el) => {
            stockList[i]["specificationId"].push(el.specificationRefId);
          });

          let specificationIds = assetSpecificationIdFound.map(
            (el) => el.specificationRefId
          );

          if (specificationIds != null) {
            specificationIds.forEach(async (element) => {
              let specificationFound = await Specifications.find()
                .where("_id")
                .in(element)
                .select("_id key value")
                .lean();

              console.log(specificationFound, "Specification");

              specificationFound.forEach((spec) => {
                stockList[i]["specifications"].push({
                  specId: spec._id,
                  specKey: spec.key,
                  specValue: spec.value,
                });
              });
            });
          }

          if (stockList[i].vendorRefId !== null) {
            let vendorFound = await Vendor.find()
              .where("_id")
              .in(stockList[i].vendorRefId)
              .select("name")
              .lean();

            stockList[i]["vendorName"] = vendorFound[0].name;
          }

          if (
            stockList[i].userRefId !== null &&
            stockList[i].userRefId !== "null"
          ) {
            let userFound = await User.find()
              .where("_id")
              .in(stockList[i].userRefId)
              .select("name")
              .lean();

            stockList[i]["assignedTo"] = userFound[0].name;
          }
        }
      }
    } else {
      const assetStockIdsFetcher = assetStockId.map(async (stockId) => {
        var stockDetails;
        try {
          const stockDetailsList = await Stock.find({ _id: stockId });

          stockDetails = stockDetailsList[0];

          if (stockDetails === undefined || stockDetails === null) {
            stockDetails = {
              _id: stockId,
              error: "Null or Undefined",
            };
          } else {
            const matchingUserList = await User.find()
              .where("_id")
              .in(stockDetails.userRefId)
              .select("name")
              .lean();
            const matchingUser = matchingUserList[0];
            stockDetails = JSON.parse(JSON.stringify(stockDetails));
            stockDetails["userName"] = matchingUser.name;
          }
        } catch (e) {
          stockDetails = {
            _id: stockId,
            error: String(e),
          };
        }

        stockList.push(stockDetails);
      });

      await Promise.allSettled(assetStockIdsFetcher);
    }

    if (stockList) {
      res.status(200).send(
        responsePacket.responsePacket(true, "Stock Query Succeeded", {
          allStock: stockList,
        })
      );
    }
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Stock Not Found", {
        null: null,
      })
    );
  }
};

/// Get Particular Asset Stock Details
exports.getParticularAssetStockDetails = async (req, res) => {
  const { assetStockId } = req.body;

  var allStock = [];

  try {
    let assetStockIdArray;

    if (Array.isArray(assetStockId)) {
      assetStockIdArray = assetStockId;
    } else {
      assetStockIdArray = assetStockId.split(",");
    }

    const assetStockIdsFetcher = assetStockIdArray.map(async (stockId) => {
      var stockDetails;
      try {
        const stockDetailsList = await Stock.find({ _id: stockId });

        stockDetails = stockDetailsList[0].toObject();

        if (stockDetails === undefined || stockDetails === null) {
          stockDetails = {
            _id: stockId,
            error: "Null or Undefined",
          };
        } else {
          stockDetails["parameters"] = [];

          let templateId;

          let templateFound = await Model.find()
            .where("_id")
            .in(stockDetails.assetRefId)
            .select("templateRefId")
            .lean();
          if (templateFound !== null && templateFound.length > 0) {
            stockDetails["templateRefId"] = templateFound[0].templateRefId;
            templateId = templateFound[0].templateRefId;
          }

          if (templateId !== null && templateId.length > 0) {
            let parametersFound = await Template.find()
              .where("_id")
              .in(templateId)
              .select("parameters")
              .lean();

            parametersFound.forEach((el) => {
              stockDetails["parameters"] = el.parameters;
            });
          }

          if (stockDetails.userRefId != null) {
            const matchingUserList = await User.find()
              .where("_id")
              .in(stockDetails.userRefId)
              .select("name")
              .lean();
            const matchingUser = matchingUserList[0];
            stockDetails = JSON.parse(JSON.stringify(stockDetails));
            stockDetails["userName"] = matchingUser.name;
          }

          const matchingModelList = await Model.find()
            .where("_id")
            .in(stockDetails.assetRefId)
            .select("assetName")
            .lean();
          const matchingModel = matchingModelList[0];
          stockDetails = JSON.parse(JSON.stringify(stockDetails));
          stockDetails["assetName"] = matchingModel.assetName;
        }

        allStock.push(stockDetails);
      } catch (e) {
        stockDetails = {
          _id: stockId,
          error: String(e),
        };
      }
    });

    await Promise.allSettled(assetStockIdsFetcher);

    if (allStock) {
      res.status(200).send(
        responsePacket.responsePacket(true, "Stock Query Succeeded", {
          allStock: allStock,
        })
      );
    }
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Stock Not Found", {
        null: null,
      })
    );
  }
};

// Create Asset Stock
exports.createAssetStockDetails = async (req, res) => {
  let {
    userRefId,
    locationRefId,
    vendorRefId,
    assetRefId,
    ticketRefId,
    serialNo,
    issuedDateTime,
    warrantyExpiry,
    remarks,
    purchaseDate,
    warrantyPeriod,
    tag,
  } = JSON.parse(req.body.jsonData);

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
    ...createAssetStockValidator(serialNo, issuedDateTime, warrantyExpiry)
  );

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  let manufacturerName;
  let editedManafacturerName;
  let typeId;
  let typeName;
  let editedTypeName;
  let companyId;
  let companyName;
  let editedCompanyName;
  let templateId;

  if (assetRefId !== null) {
    let manufacturerFound = await Model.find()
      .where("_id")
      .in(assetRefId)
      .select("manufacturer")
      .lean();

    if (manufacturerFound !== null && manufacturerFound.length > 0) {
      manufacturerName = manufacturerFound[0].manufacturer;
      editedManafacturerName = manufacturerName.slice(0, 2).toUpperCase();
    }

    let typeReferenceId = await Model.find()
      .where("_id")
      .in(assetRefId)
      .select("typeRefId")
      .lean();

    if (typeReferenceId !== null && typeReferenceId.length > 0) {
      typeId = typeReferenceId[0].typeRefId;
    }

    if (typeId !== null) {
      let findTypeNames = await Type.find()
        .where("_id")
        .in(typeId)
        .select("name")
        .lean();

      if (findTypeNames !== null && findTypeNames.length > 0) {
        typeName = findTypeNames[0].name;
        editedTypeName = typeName.slice(0, 2).toUpperCase();
      }

      let templateReferenceId = await Model.find()
        .where("_id")
        .in(assetRefId)
        .select("templateRefId")
        .lean();

      if (templateReferenceId !== null && templateReferenceId.length > 0) {
        templateId = templateReferenceId[0].templateRefId;
      }

      if (templateId !== null) {
        let companyReferenceId = await Template.find()
          .where("_id")
          .in(templateId)
          .select("companyRefId")
          .lean();

        if (companyReferenceId !== null && companyReferenceId.length > 0) {
          companyId = companyReferenceId[0].companyRefId;
        }
      }

      if (companyId !== null) {
        let findCompanyNames = await Company.find()
          .where("_id")
          .in(companyId)
          .select("name")
          .lean();

        if (findCompanyNames !== null && findCompanyNames.length > 0) {
          companyName = findCompanyNames[0].name;
          editedCompanyName = companyName.slice(0, 2).toUpperCase();
        }
      }
    }
  }

  let displayId;

  let tableName = "STOCK";

  let idPrefix = editedCompanyName + editedTypeName + editedManafacturerName;

  try {
    displayId = await addDisplayIdForStock(idPrefix, tableName, Stock);
  } catch (error) {
    console.error("Error while generating displayId:", error);
    res.status(500).send({
      ErrorMsg: "Error while generating displayId",
    });
    return;
  }

  try {
    let result = new Stock({
      userRefId: userRefId,
      locationRefId: locationRefId,
      vendorRefId: vendorRefId,
      assetRefId: assetRefId,
      ticketRefId: ticketRefId,
      serialNo: serialNo,
      issuedDateTime: issuedDateTime,
      warrantyExpiry: warrantyExpiry,
      image: image,
      remarks: remarks,
      tag: tag,
      displayId: displayId,
      warrantyPeriod: warrantyPeriod,
      purchaseDate: purchaseDate,
    });
    await result.save();

    const stockId = result._id;
    res.status(200).send(
      responsePacket.responsePacket(
        true,
        `Stock Created Successfully Id:${stockId}`,
        {
          null: null,
        }
      )
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Stock Not Created", {
        null: null,
      })
    );
  }
};

// Update Asset Stock
exports.updateAssetStockDetails = async (req, res) => {
  let {
    userRefId,
    locationRefId,
    vendorRefId,
    assetRefId,
    ticketRefId,
    serialNo,
    issuedDateTime,
    warrantyExpiry,
    remarks,
    purchaseDate,
    warrantyPeriod,
    tag,
    sId,
  } = JSON.parse(req.body.jsonData);

  const stockId = sId;

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
    ...createAssetStockValidator(serialNo, issuedDateTime, warrantyExpiry)
  );

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  try {
    var stockJson = {
      userRefId: userRefId,
      locationRefId: locationRefId,
      vendorRefId: vendorRefId,
      assetRefId: assetRefId,
      ticketRefId: ticketRefId,
      serialNo: serialNo,
      issuedDateTime: issuedDateTime,
      warrantyExpiry: warrantyExpiry,
      remarks: remarks,
      tag: tag,
      warrantyPeriod: warrantyPeriod,
      purchaseDate: purchaseDate,
    };

    if (image != undefined && image != null) {
      stockJson.image = image;
    }

    const foundStock = await Stock.findOneAndUpdate(
      { _id: stockId },
      stockJson
    );

    if (!foundStock) {
      return res.status(404).send(
        responsePacket.responsePacket(false, "Stock Not Found", {
          null: null,
        })
      );
    }

    const updatedStock = await Stock.findById(stockId);

    let stockRefId = foundStock._id;

    if (userRefId != null) {
      let user = await User.findById({ _id: userRefId });
      if (user && !user.assetStockRefId.includes(stockRefId)) {
        user.assetStockRefId.push(stockRefId);
        await user.save();
      } else {
        console.log("User not found or Stock already exists in the user");
      }
    }

    res.status(200).send(
      responsePacket.responsePacket(true, "Stock Updated Successfully", {
        oldStockData: foundStock,
        newStockData: updatedStock,
      })
    );
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Stock Not Updated", {
        null: null,
      })
    );
  }
};

// Update User Assignment
exports.userAssignment = async (req, res) => {
  const { userRefId, sId } = req.body;

  const stockId = sId;
  const userId = userRefId;

  try {
    if (userId != null) {
      let user = await User.findById({ _id: userId });
      if (user && !user.assetStockRefId.includes(stockId)) {
        user.assetStockRefId.push(stockId);
        await user.save();
      } else {
        console.log("User not found or Stock already exists in the stock");
      }
    }

    if (stockId !== null) {
      let stock = await Stock.findById({ _id: stockId });
      if (stock) {
        if (!stock.userRefId) {
          stock.userRefId = userId;
          await stock.save();
        } else if (stock.userRefId !== userId) {
          console.log("User already exists in the stock");
        } else {
          console.log("User already exists in the stock");
        }
      } else {
        console.log("Stock not found");
      }
    }

    let updateStock = await Stock.findById(stockId);

    res.status(200).send(
      responsePacket.responsePacket(true, "Stock Updated Successfully", {
        newStockData: updateStock,
      })
    );
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Stock Not Updated", {
        null: null,
      })
    );
  }
};

// Update Asset Return
exports.assetReturn = async (req, res) => {
  const { userRefId, sId } = req.body;

  const stockId = sId;
  const userId = userRefId;

  try {
    if (userId !== null) {
      let userData = await User.findOne({ assetStockRefId: stockId });
      userData.assetStockRefId.pull(stockId);
      await userData.save();
    }

    if (stockId !== null) {
      let stock = await Stock.findById({ _id: stockId });
      if (stock) {
        if (stock.userRefId && stock.userRefId === userId) {
          stock.userRefId = null;
          await stock.save();
        } else if (!stock.userRefId || stock.userRefId !== userId) {
          stock.userRefId = userId;
          await stock.save();
        } else {
          console.log("User already exists in the stock");
        }
      } else {
        console.log("Stock not found");
      }
    }

    let updatedStock = await Stock.findById(stockId);

    res.status(200).send(
      responsePacket.responsePacket(true, "Stock Updated Successfully", {
        newStockData: updatedStock,
      })
    );
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Stock Not Updated", {
        null: null,
      })
    );
  }
};

// Delete Stock
exports.deleteStockDetails = async (req, res) => {
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
    let stock = await Stock.findById({ _id: id });

    if (!stock) {
      res.status(404).send({
        ErrorMsg: "Stock not found",
      });
      return;
    }

    let displayId = stock.displayId;

    let idPrefix = displayId.slice(6, 10);

    result = await Stock.deleteOne({
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
      responsePacket.responsePacket(true, "Stock is deleted successfully", {
        data: result,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Stock is not deleted", {
        data: result,
      })
    );
  }
};

// Get Asset Model Details
exports.getAssetModelDetails = async (req, res) => {
  const { assetModelId } = req.body;
  try {
    var allModel = [];

    if (
      assetModelId === undefined ||
      assetModelId === null ||
      assetModelId.length <= 0
    ) {
      allModel = await Model.find().lean();
      if (allModel != null) {
        for (let i = 0; i < allModel.length; i++) {
          allModel[i]["specifications"] = [];
          allModel[i]["parameters"] = [];

          let templatesFound = await Template.find()
            .where("_id")
            .in(allModel[i].templateRefId)
            .select("displayId")
            .lean();

          allModel[i]["templateId"] = templatesFound[0].displayId;

          let typeFound = await Type.find()
            .where("_id")
            .in(allModel[i].typeRefId)
            .select("name")
            .lean();

          allModel[i]["typeName"] = typeFound[0].name;

          let categoryFound = await Categorys.find()
            .where("_id")
            .in(allModel[i].categoryRefId)
            .select("name")
            .lean();

          allModel[i]["categoryName"] = categoryFound[0].name;

          let subCategoryFound = await SubCategorys.find()
            .where("_id")
            .in(allModel[i].subCategoryRefId)
            .select("name")
            .lean();

          allModel[i]["subCategoryName"] = subCategoryFound[0].name;

          let specificationFound = await Specifications.find()
            .where("_id")
            .in(allModel[i].specificationRefId)
            .select("_id key value")
            .lean();

          specificationFound.forEach((spec) => {
            allModel[i]["specifications"].push({
              specId: spec._id,
              specKey: spec.key,
              specValue: spec.value,
            });
          });

          let parametersFound = await Template.find()
            .where("_id")
            .in(allModel[i].templateRefId)
            .select("parameters")
            .lean();

          parametersFound.forEach((el) => {
            allModel[i]["parameters"].push(el.parameters);
          });
        }
      }

      if (allModel) {
        res.status(200).send(
          responsePacket.responsePacket(true, "Model Query Succeeded", {
            allModel: allModel,
          })
        );
      }
    } else {
      const modelIdsFetcher = assetModelId.map(async (modelId) => {
        var modelDetails;
        try {
          const modelDetailsList = await Model.find({
            _id: modelId,
          });
          modelDetails = modelDetailsList[0];

          if (modelDetails === undefined || modelDetails === null) {
            modelDetails = {
              _id: modelId,
              error: "Null or Undefined",
            };
          } else {
            const matchingTemplateList = await Template.find()
              .where("_id")
              .in(modelDetails.templateRefId)
              .select("parameters")
              .lean();
            const matchingTemplate = matchingTemplateList[0];
            modelDetails = {
              ...modelDetails.toObject(),
              parameters: matchingTemplate.parameters,
            };
          }
        } catch (e) {
          modelDetails = {
            _id: modelId,
            error: String(e),
          };
        }

        allModel.push(modelDetails);
      });

      await Promise.allSettled(modelIdsFetcher);
    }

    res.status(200).send(
      responsePacket.responsePacket(true, "Model Query Succeeded", {
        allModel: allModel,
      })
    );
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Model Not Found", {
        null: null,
      })
    );
  }
};

// Create Asset Model
exports.createAssetModelDetails = async (req, res) => {
  let {
    modelId,
    additionalModelId,
    assetName,
    typeRefId,
    categoryRefId,
    subCategoryRefId,
    manufacturer,
    templateRefId,
    specKey,
    specValue,
    tag,
  } = JSON.parse(req.body.jsonData);

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
    ...createAssetModelValidator(
      modelId,
      additionalModelId,
      assetName,
      manufacturer
    )
  );

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  let idPrefix = "MOD";

  let displayId;
  try {
    displayId = await addDisplayId(idPrefix, Model);
  } catch (error) {
    console.error("Error while generating displayId:", error);
    res.status(500).send({
      ErrorMsg: "Error while generating displayId",
    });
    return;
  }

  try {
    let result = new Model({
      modelId: modelId,
      additionalModelId: additionalModelId,
      assetName: assetName,
      manufacturer: manufacturer,
      typeRefId: typeRefId,
      categoryRefId: categoryRefId,
      subCategoryRefId: subCategoryRefId,
      templateRefId: templateRefId,
      image: image,
      tag: tag,
      displayId: displayId,
    });
    await result.save();
    const modelObjectId = result._id;

    let specificationResults = [];

    for (let i = 0; i < specKey.length; i++) {
      const currentSpecKey = specKey[i];
      const currentSpecValue = specValue[i];

      let specificationResult = new Specifications({
        key: currentSpecKey,
        value: currentSpecValue,
        modelRefId: modelObjectId,
        templateRefId: templateRefId,
      });
      await specificationResult.save();
      specificationResults.push(specificationResult);

      const specificationId = specificationResult._id;

      let model = await Model.findById(modelObjectId);
      let specification = await Specifications.findById(specificationId);

      if (model && specification) {
        if (!model.specificationRefId.includes(specificationId)) {
          model.specificationRefId.push(specificationId);
          await model.save();
        }
      } else {
        throw new Error("Model or Specification not found");
      }
    }

    res.status(200).send({
      success: true,
      message: "Model Created Successfully",
      data: {
        model: result,
        specifications: specificationResults,
      },
    });
  } catch (e) {
    console.log(e);
    res.status(500).send({
      success: false,
      message: "Model Not Created",
      error: e.message,
    });
  }
};

// // Update Asset Model
exports.updateAssetModelDetails = async (req, res) => {
  let {
    modelId,
    additionalModelId,
    assetName,
    typeRefId,
    categoryRefId,
    subCategoryRefId,
    manufacturer,
    templateRefId,
    specKey,
    specValue,
    tag,
    sId,
  } = JSON.parse(req.body.jsonData);

  const assetModelId = sId;

  let image = null;

  if (req.files && req.files["image"] && req.files["image"][0]) {
    image = req.files["image"][0].filename;
  }

  let error = [];
  error.push(
    ...createAssetModelValidator(
      modelId,
      additionalModelId,
      assetName,
      manufacturer
    )
  );

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  try {
    var modelJson = {
      modelId: modelId,
      additionalModelId: additionalModelId,
      assetName: assetName,
      manufacturer: manufacturer,
      typeRefId: typeRefId,
      categoryRefId: categoryRefId,
      subCategoryRefId: subCategoryRefId,
      templateRefId: templateRefId,
      tag: tag,
    };

    if (image != undefined && image != null) {
      modelJson.image = image;
    }

    // Update the old Model and get updated Model
    // -----------------------------------------------------------------
    const oldModel = await Model.findOneAndUpdate(
      { _id: assetModelId },
      modelJson
    );

    const updatedModel = await Model.findById(assetModelId);

    // -----------------------------------------------------------------

    // ######################### UPDATE SPECS FOR TEMPLATE CHANGE ######################### //
    if (oldModel.templateRefId !== updatedModel.templateRefId) {
      // Delete the specifications and clear the specificationRefIds in model
      // -----------------------------------------------------------------
      const specificationIds = oldModel.specificationRefId;

      const specificationDelete = await Specifications.deleteMany({
        _id: { $in: specificationIds },
      });

      if (specificationDelete.deletedCount !== specificationIds.length) {
        await Model.findOneAndUpdate({ _id: assetModelId }, oldModel);
        return res.status(500).send(
          responsePacket.responsePacket(
            false,
            "Specifications delete failed. Model update reverted. ",
            {
              null: null,
            }
          )
        );
      }

      updatedModel.specificationRefId = [];

      // -----------------------------------------------------------------

      // Adding the specifications
      // -----------------------------------------------------------------
      let specificationResults = [];

      for (let i = 0; i < specKey.length; i++) {
        const currentSpecKey = specKey[i];
        const currentSpecValue = specValue[i];

        let specification = new Specifications({
          key: currentSpecKey,
          value: currentSpecValue,
          modelRefId: assetModelId,
          templateRefId: updatedModel.templateRefId,
        });
        await specification.save();
        specificationResults.push(specification);

        const specificationId = specification._id;

        if (updatedModel && specification) {
          if (!updatedModel.specificationRefId.includes(specificationId)) {
            updatedModel.specificationRefId.push(specificationId);
          }
        } else {
          await Model.findOneAndUpdate({ _id: assetModelId }, oldModel);
          return res.status(500).send(
            responsePacket.responsePacket(
              false,
              "Addition of Specifications failed. Model update reverted. ",
              {
                null: null,
              }
            )
          );
        }
      }

      // -----------------------------------------------------------------
      await updatedModel.save();
    }
    // ######################### UPDATE SPECS FOR TEMPLATE CHANGE ######################### //

    // ######################### UPDATE SPECS FOR EXISTING TEMPLATE ######################### //
    else {
      try {
        const existingSpecificationIds = oldModel.specificationRefId;
        const existingSpecifications = await Specifications.find({
          _id: { $in: existingSpecificationIds },
        });

        for (let i = 0; i < existingSpecifications.length; i++) {
          const existingSpec = existingSpecifications[i];
          const existingSpecKey = existingSpec.key;

          // Find the corresponding new specValue for the oldSpecKey
          const index = specKey.indexOf(existingSpecKey);
          if (index >= 0) {
            // Replace old specValue with new specValue
            const newSpecValue = specValue[index];
            existingSpec.value = newSpecValue;
            await existingSpec.save();
          } else {
            await Model.findOneAndUpdate({ _id: assetModelId }, oldModel);
            return res.status(500).send(
              responsePacket.responsePacket(
                false,
                "Updation of Specifications failed. Model update reverted. ",
                {
                  null: null,
                }
              )
            );
          }
        }

        console.log(existingSpecificationIds);

        res.status(200).send(
          responsePacket.responsePacket(true, "Model Updated Successfully", {
            oldModelData: oldModel,
            newModelData: updatedModel,
          })
        );
      } catch (error) {
        console.error(error);
        return res.status(500).send(
          responsePacket.responsePacket(false, "Failed to update model", {
            error: error.message,
          })
        );
      }
    }

    // ######################### UPDATE SPECS FOR EXISTING TEMPLATE ######################### //

    if (!oldModel) {
      return res.status(404).send(
        responsePacket.responsePacket(false, "Model Not Found", {
          null: null,
        })
      );
    }

    res.status(200).send(
      responsePacket.responsePacket(true, "Model Updated Successfully", {
        oldModelData: oldModel,
        newModelData: updatedModel,
      })
    );
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Model Not Updated", {
        null: null,
      })
    );
  }
};

// Delete Model
exports.deleteModelDetails = async (req, res) => {
  const { id, specificationId } = req.body;

  let error = [];

  error.push(...deleteValidator(id));

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  try {
    let model = await Model.findById({ _id: id });

    if (!model) {
      res.status(404).send({
        ErrorMsg: "Model not found",
      });
      return;
    }

    let displayId = model.displayId;

    let idPrefix = "MOD";

    const modelDelete = await Model.deleteOne({ _id: id });

    try {
      await modifyDisplayId(displayId, idPrefix);
    } catch (error) {
      console.error("Error while removing displayId:", error);
      res.status(500).send({
        ErrorMsg: "Error while removing displayId",
      });
      return;
    }

    let specifications = await Specifications.find({
      _id: specificationId.replace(/[()]/g, ""),
    });

    const specificationIds = specifications._id;

    const specificationIdsArray = specificationIds;

    const specificationDelete = await Specifications.deleteOne({
      _id: specificationIdsArray,
    });

    if (modelDelete.deletedCount > 0 && specificationDelete.deletedCount > 0) {
      return res.status(200).send(
        responsePacket.responsePacket(true, "Model is deleted successfully", {
          data: modelDelete,
        })
      );
    } else {
      return res.status(404).send(
        responsePacket.responsePacket(
          false,
          "Model or Specification not found",
          {
            data: null,
          }
        )
      );
    }
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Model is not deleted", {
        data: null,
      })
    );
  }
};

// Get Asset Template Details
exports.getAssetTemplateDetails = async (req, res) => {
  const { assetTemplateId } = req.body;
  try {
    var allTemplate = [];

    if (
      assetTemplateId === undefined ||
      assetTemplateId === null ||
      assetTemplateId.length <= 0
    ) {
      allTemplate = await Template.find().lean();
      if (allTemplate != null) {
        for (let i = 0; i < allTemplate.length; i++) {
          allTemplate[i]["company"] = [];
          let companiesFound = await Company.find()
            .where("_id")
            .in(allTemplate[i].companyRefId)
            .select("name")
            .lean();

          allTemplate[i]["company"] = companiesFound[0].name;
        }
      }

      if (allTemplate) {
        res.status(200).send(
          responsePacket.responsePacket(true, "Template Query Succeeded", {
            allTemplate: allTemplate,
          })
        );
      }
    } else {
      const templateIdsFetcher = assetTemplateId.map(async (templateId) => {
        var templateDetails;
        try {
          const templateDetailsList = await Template.find({
            _id: templateId,
          });
          templateDetails = templateDetailsList[0];

          if (templateDetails === undefined || templateDetails === null) {
            templateDetails = {
              _id: templateId,
              error: "Null or Undefined",
            };
          } else {
            const matchingTemplateList = await Template.find()
              .where("_id")
              .in(templateDetails._id)
              .select("parameters")
              .lean();
            const matchingTemplate = matchingTemplateList[0];
            templateDetails = {
              ...templateDetails.toObject(),
              parameters: matchingTemplate.parameters,
            };
          }
        } catch (e) {
          templateDetails = {
            _id: templateId,
            error: String(e),
          };
        }

        allTemplate.push(templateDetails);
      });

      await Promise.allSettled(templateIdsFetcher);
    }
    res.status(200).send(
      responsePacket.responsePacket(true, "Template Query Succeeded", {
        allTemplate: allTemplate,
      })
    );
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Template Not Found", {
        data: null,
      })
    );
  }
};

// Create Asset Template
exports.createAssetTemplateDetails = async (req, res) => {
  let { name, companyRefId, department, parameters, tag } = JSON.parse(
    req.body.jsonData
  );

  let image = null;

  if (req.files != undefined && req.files != null) {
    try {
      image = req.files["image"][0].filename;
    } catch (e) {
      console.log(e);
    }
  }

  let error = [];

  error.push(...createAssetTemplateValidator(name, department, parameters));

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  let idPrefix = "TEMP";

  let displayId;
  try {
    displayId = await addDisplayId(idPrefix, Template);
  } catch (error) {
    console.error("Error while generating displayId:", error);
    res.status(500).send({
      ErrorMsg: "Error while generating displayId",
    });
    return;
  }

  try {
    let result = new Template({
      name: name,
      companyRefId: companyRefId,
      department: department,
      parameters: parameters,
      image: image,
      tag: tag,
      displayId: displayId,
    });

    await result.save();
    res.status(200).send(
      responsePacket.responsePacket(true, "Template Created Successfully", {
        null: null,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Template Not Created", {
        null: null,
      })
    );
  }
};

// Update Asset Template
exports.updateAssetTemplateDetails = async (req, res) => {
  let { name, companyRefId, department, parameters, tag, sId } = JSON.parse(
    req.body.jsonData
  );

  const templateId = sId;

  let image = null;

  if (req.files && req.files["image"] && req.files["image"][0]) {
    image = req.files["image"][0].filename;
  }

  let error = [];
  error.push(...createAssetTemplateValidator(name, department, parameters));

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  try {
    var templateJson = {
      name: name,
      companyRefId: companyRefId,
      department: department,
      parameters: parameters,
      tag: tag,
    };

    if (image != undefined && image != null) {
      templateJson.image = image;
    }

    const foundTemplate = await Template.findOneAndUpdate(
      { _id: templateId },
      templateJson
    );

    if (!foundTemplate) {
      return res.status(404).send(
        responsePacket.responsePacket(false, "Template Not Found", {
          null: null,
        })
      );
    }

    const updatedTemplate = await Template.findById(templateId);

    res.status(200).send(
      responsePacket.responsePacket(true, "Template Updated Successfully", {
        oldTemplateData: foundTemplate,
        newTemplateData: updatedTemplate,
      })
    );
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Template Not Updated", {
        null: null,
      })
    );
  }
};

// Delete Template
exports.deleteTemplateDetails = async (req, res) => {
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
    let template = await Template.findById({ _id: id });

    if (!template) {
      res.status(404).send({
        ErrorMsg: "Template not found",
      });
      return;
    }

    let displayId = template.displayId;

    let idPrefix = "TEMP";

    result = await Template.deleteOne({
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
      responsePacket.responsePacket(true, "Template is deleted successfully", {
        data: result,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Template is not deleted", {
        data: result,
      })
    );
  }
};

/// Get Type Details
exports.getAssetTypeDetails = async (req, res) => {
  const { typeIds } = req.body;

  var types = [];

  if (typeIds === undefined || typeIds === null || typeIds.length <= 0) {
    types = await Type.find();
  } else {
    const typeIdsFetcher = typeIds.map(async (typeId) => {
      var typeDetails;
      try {
        const typeDetailsList = await Type.find({
          _id: typeId,
        });
        typeDetails = typeDetailsList[0];
      } catch (e) {
        typeDetails = {
          _id: typeId,
          error: String(e),
        };
      }

      types.push(typeDetails);
    });

    await Promise.allSettled(typeIdsFetcher);
  }

  res.status(200).send(
    responsePacket.responsePacket(true, "Type Query Succeeded", {
      types: types,
    })
  );
};

/// Create Asset Type
exports.createAssetTypeDetails = async (req, res) => {
  let { name, tag } = JSON.parse(req.body.jsonData);

  let image = null;

  if (req.files != undefined && req.files != null) {
    try {
      image = req.files["image"][0].filename;
    } catch (e) {
      console.log(e);
    }
  }

  let error = [];

  error.push(...otherAssetDetailsValidator(name));

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  let idPrefix = "TYPE";

  let displayId;
  try {
    displayId = await addDisplayId(idPrefix, Type);
  } catch (error) {
    console.error("Error while generating displayId:", error);
    res.status(500).send({
      ErrorMsg: "Error while generating displayId",
    });
    return;
  }

  try {
    let result = new Type({
      name: name,
      tag: tag,
      image: image,
      displayId: displayId,
    });

    await result.save();
    res.status(200).send(
      responsePacket.responsePacket(true, "Type Created Successfully", {
        null: null,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Type Not Created", {
        null: null,
      })
    );
  }
};

/// Update Asset Type
exports.updateAssetTypeDetails = async (req, res) => {
  let { name, tag, sId } = JSON.parse(req.body.jsonData);

  const typelId = sId;

  let image = null;

  if (req.files && req.files["image"] && req.files["image"][0]) {
    image = req.files["image"][0].filename;
  }

  let error = [];

  error.push(...otherAssetDetailsValidator(name));

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  try {
    var typeJson = {
      name: name,
      tag: tag,
    };

    if (image != undefined && image != null) {
      typeJson.image = image;
    }

    const foundType = await Type.findOneAndUpdate({ _id: typelId }, typeJson);

    if (!foundType) {
      return res.status(404).send(
        responsePacket.responsePacket(false, "Type Not Found", {
          null: null,
        })
      );
    }

    const updatedType = await Type.findById(typelId);

    res.status(200).send(
      responsePacket.responsePacket(true, "Type Updated Successfully", {
        oldTypeData: foundType,
        newTypeData: updatedType,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Type Not Updated", {
        null: null,
      })
    );
  }
};

// Delete Type
exports.deleteTypeDetails = async (req, res) => {
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
    let type = await Type.findById({ _id: id });

    if (!type) {
      res.status(404).send({
        ErrorMsg: "Type not found",
      });
      return;
    }

    let displayId = type.displayId;

    let idPrefix = "TYPE";

    result = await Type.deleteOne({
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
      responsePacket.responsePacket(true, "Type is deleted successfully", {
        data: result,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Type is not deleted", {
        data: result,
      })
    );
  }
};

/// Get Category Details
exports.getAssetCategoryDetails = async (req, res) => {
  const { categoryIds } = req.body;

  var allCategory = [];
  try {
    if (
      categoryIds === undefined ||
      categoryIds === null ||
      categoryIds.length <= 0
    ) {
      allCategory = await Categorys.find().lean();
      if (allCategory != null) {
        for (let i = 0; i < allCategory.length; i++) {
          let categorysFound = await Type.find()
            .where("_id")
            .in(allCategory[i].typeRefIds)
            .select("name")
            .lean();

          allCategory[i]["typeName"] = categorysFound[0].name;
        }
      }

      if (allCategory) {
        res.status(200).send(
          responsePacket.responsePacket(true, "Category Query Succeeded", {
            allCategory: allCategory,
          })
        );
      }
    } else {
      const categoryIdsFetcher = categoryIds.map(async (categoryId) => {
        var categoryDetails;
        try {
          const categoryDetailsList = await Categorys.find({
            _id: categoryId,
          });
          categoryDetails = categoryDetailsList[0];

          if (categoryDetails === undefined || categoryDetails === null) {
            categoryDetails = {
              _id: categoryId,
              error: "Null or Undefined",
            };
          } else {
            const matchingTypesList = await Type.find()
              .where("_id")
              .in(categoryDetails.typeRefIds)
              .select("name")
              .lean();
            const matchingType = matchingTypesList[0];
            categoryDetails = JSON.parse(JSON.stringify(categoryDetails));
            categoryDetails["typeName"] = matchingType.name;
          }
        } catch (e) {
          categoryDetails = {
            _id: categoryId,
            error: String(e),
          };
        }

        allCategory.push(categoryDetails);
      });

      await Promise.allSettled(categoryIdsFetcher);
    }
    res.status(200).send(
      responsePacket.responsePacket(true, "Category Query Succeeded", {
        allCategory: allCategory,
      })
    );
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Category Not Found", {
        data: null,
      })
    );
  }
};

/// Create Asset Category
exports.createAssetCategoryDetails = async (req, res) => {
  let { name, tag, typeRefIds } = JSON.parse(req.body.jsonData);

  let image = null;

  if (req.files != undefined && req.files != null) {
    try {
      image = req.files["image"][0].filename;
    } catch (e) {
      console.log(e);
    }
  }

  let error = [];

  error.push(...otherAssetDetailsValidator(name));

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  let idPrefix = "CAT";

  let displayId;
  try {
    displayId = await addDisplayId(idPrefix, Categorys);
  } catch (error) {
    console.error("Error while generating displayId:", error);
    res.status(500).send({
      ErrorMsg: "Error while generating displayId",
    });
    return;
  }

  try {
    let result = new Categorys({
      name: name,
      tag: tag,
      image: image,
      typeRefIds: typeRefIds,
      displayId: displayId,
    });
    await result.save();

    const categoryId = result._id;

    let type = await Type.findById({ _id: typeRefIds });

    if (type && !type.categoryRefIds.includes(categoryId)) {
      type.categoryRefIds.push(categoryId);
      await type.save();
    } else {
      throw new Error(
        "Type not found or Category already exists in the category"
      );
    }

    res.status(200).send(
      responsePacket.responsePacket(
        true,
        `Category Created Successfully Id:${categoryId}`,
        {
          null: null,
        }
      )
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Category Not Created", {
        null: null,
      })
    );
  }
};

/// Update Asset Category
exports.updateAssetCategoryDetails = async (req, res) => {
  let { name, tag, typeRefIds, sId } = JSON.parse(req.body.jsonData);

  const categoryId = sId;

  let image = null;

  if (req.files && req.files["image"] && req.files["image"][0]) {
    image = req.files["image"][0].filename;
  }

  let error = [];

  error.push(...otherAssetDetailsValidator(name));

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  try {
    var categoryJson = {
      name: name,
      tag: tag,
      typeRefIds: typeRefIds,
    };

    if (image != undefined && image != null) {
      categoryJson.image = image;
    }

    const foundCategory = await Categorys.findOneAndUpdate(
      { _id: categoryId },
      categoryJson
    );

    if (!foundCategory) {
      return res.status(404).send(
        responsePacket.responsePacket(false, "Category Not Found", {
          null: null,
        })
      );
    }

    const updatedCategory = await Categorys.findById(categoryId);

    let oldType = await Type.findOne({ categoryRefIds: categoryId });
    if (oldType) {
      oldType.categoryRefIds.pull(categoryId);
      await oldType.save();
    }

    let newType = await Type.findById(typeRefIds);
    if (newType) {
      newType.categoryRefIds.push(categoryId);
      await newType.save();
    } else {
      throw new Error("New Type not found");
    }

    res.status(200).send(
      responsePacket.responsePacket(true, "Category Updated Successfully", {
        oldCategoryeData: foundCategory,
        newCatgoryeData: updatedCategory,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Category Not Updated", {
        null: null,
      })
    );
  }
};

// Delete Category
exports.deleteCategoryDetails = async (req, res) => {
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
    let category = await Categorys.findById({ _id: id });

    if (!category) {
      res.status(404).send({
        ErrorMsg: "Category not found",
      });
      return;
    }

    let displayId = category.displayId;

    let idPrefix = "CAT";

    result = await Categorys.deleteOne({
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
      responsePacket.responsePacket(true, "Category is deleted successfully", {
        data: result,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Category is not deleted", {
        data: result,
      })
    );
  }
};

/// Get Category Details
exports.getAssetSubCategoryDetails = async (req, res) => {
  const { subCategoryIds } = req.body;

  var allSubCategory = [];

  try {
    if (
      subCategoryIds === undefined ||
      subCategoryIds === null ||
      subCategoryIds.length <= 0
    ) {
      allSubCategory = await SubCategorys.find().lean();
      if (allSubCategory != null) {
        for (let i = 0; i < allSubCategory.length; i++) {
          let subCategorysFound = await Categorys.find()
            .where("_id")
            .in(allSubCategory[i].categoryRefIds)
            .select("name")
            .lean();
          allSubCategory[i]["categoryName"] = subCategorysFound[0].name;
        }
      }
      if (allSubCategory) {
        res.status(200).send(
          responsePacket.responsePacket(true, "SubCategory Query Succeeded", {
            allSubCategory: allSubCategory,
          })
        );
      }
    } else {
      const subCategoryIdsFetcher = subCategoryIds.map(
        async (subCategoryId) => {
          var subCategoryDetails;
          try {
            const subCategoryDetailsList = await SubCategorys.find({
              _id: subCategoryId,
            });
            subCategoryDetails = subCategoryDetailsList[0];

            if (
              subCategoryDetails === undefined ||
              subCategoryDetails === null
            ) {
              subCategoryDetails = {
                _id: subCategoryId,
                error: "Null or Undefined",
              };
            } else {
              const matchingCategoryList = await Categorys.find()
                .where("_id")
                .in(subCategoryDetails.categoryRefIds)
                .select("name")
                .lean();
              const matchingCategory = matchingCategoryList[0];
              subCategoryDetails = JSON.parse(
                JSON.stringify(subCategoryDetails)
              );
              subCategoryDetails["categoryName"] = matchingCategory.name;
            }
          } catch (e) {
            subCategoryDetails = {
              _id: subCategoryId,
              error: String(e),
            };
          }

          allSubCategory.push(subCategoryDetails);
        }
      );

      await Promise.allSettled(subCategoryIdsFetcher);
    }
    res.status(200).send(
      responsePacket.responsePacket(true, "SubCategory Query Succeeded", {
        allSubCategory: allSubCategory,
      })
    );
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "SubCategory Not Found", {
        data: null,
      })
    );
  }
};

/// Create Asset Sub-Category
exports.createAssetSubCategoryDetails = async (req, res) => {
  let { name, tag, categoryRefIds } = JSON.parse(req.body.jsonData);

  let image = null;

  if (req.files != undefined && req.files != null) {
    try {
      image = req.files["image"][0].filename;
    } catch (e) {
      console.log(e);
    }
  }

  let error = [];

  error.push(...otherAssetDetailsValidator(name));

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  let idPrefix = "SCAT";

  let displayId;
  try {
    displayId = await addDisplayId(idPrefix, SubCategorys);
  } catch (error) {
    console.error("Error while generating displayId:", error);
    res.status(500).send({
      ErrorMsg: "Error while generating displayId",
    });
    return;
  }

  try {
    let result = new SubCategorys({
      name: name,
      tag: tag,
      image: image,
      categoryRefIds: categoryRefIds,
      displayId: displayId,
    });
    await result.save();

    const subCategoryId = result._id;

    let category = await Categorys.findById({ _id: categoryRefIds });

    if (category && !category.subCategoryRefIds.includes(subCategoryId)) {
      category.subCategoryRefIds.push(subCategoryId);
      await category.save();
    } else {
      throw new Error(
        "Category not found or Subcategory already exists in the category"
      );
    }

    res.status(200).send(
      responsePacket.responsePacket(true, "Sub-Category Created Successfully", {
        null: null,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Sub-Category Not Created", {
        null: null,
      })
    );
  }
};

/// Update Asset Sub-Category
exports.updateAssetSubCategoryDetails = async (req, res) => {
  let { name, tag, categoryRefIds, sId } = JSON.parse(req.body.jsonData);

  const subCategoryId = sId;

  let image = null;

  if (req.files && req.files["image"] && req.files["image"][0]) {
    image = req.files["image"][0].filename;
  }

  let error = [];

  error.push(...otherAssetDetailsValidator(name));

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  try {
    var SubCategoryJson = {
      name: name,
      tag: tag,
      categoryRefIds: categoryRefIds,
    };

    if (image != undefined && image != null) {
      SubCategoryJson.image = image;
    }

    const foundSubCategory = await SubCategorys.findOneAndUpdate(
      { _id: subCategoryId },
      SubCategoryJson
    );

    if (!foundSubCategory) {
      return res.status(404).send(
        responsePacket.responsePacket(false, "Sub-Category Not Found", {
          null: null,
        })
      );
    }

    const updatedSubCategory = await SubCategorys.findById(subCategoryId);

    let oldCategory = await Categorys.findOne({
      subCategoryRefIds: subCategoryId,
    });
    if (oldCategory) {
      oldCategory.subCategoryRefIds.pull(subCategoryId);
      await oldCategory.save();
    }

    let newCategory = await Categorys.findById(categoryRefIds);
    if (newCategory) {
      newCategory.subCategoryRefIds.push(subCategoryId);
      await newCategory.save();
    } else {
      throw new Error("New Category not found");
    }

    res.status(200).send(
      responsePacket.responsePacket(true, "Sub-Category Updated Successfully", {
        oldSubCategoryeData: foundSubCategory,
        newSubCatgoryeData: updatedSubCategory,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Sub-Category Not Updated", {
        null: null,
      })
    );
  }
};

// Delete Sub-Category
exports.deleteSubCategoryDetails = async (req, res) => {
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
    let subCategory = await SubCategorys.findById({ _id: id });

    if (!subCategory) {
      res.status(404).send({
        ErrorMsg: "Sub-Category not found",
      });
      return;
    }

    let displayId = subCategory.displayId;

    let idPrefix = "SCAT";

    result = await SubCategorys.deleteOne({
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
      responsePacket.responsePacket(
        true,
        "Sub-Category is deleted successfully",
        {
          data: result,
        }
      )
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Sub-Category is not deleted", {
        data: result,
      })
    );
  }
};
