const { Notification, Ticket } = require("../model/ticket");
const User = require("../model/user");
const { Stock, Warranty, CheckList } = require("../model/asset");
const responsePacket = require("../helpers/response");

/// Add Warranty Details for Particular Stock
exports.addWarranty = async (req, res) => {
  let { stockRefId, modelRefId, warrantyExpiry, warrantyName } = JSON.parse(
    req.body.jsonData
  );

  let warrantyAttachment = null;

  if (
    req.files &&
    req.files["warrantyAttachment"] &&
    req.files["warrantyAttachment"][0]
  ) {
    warrantyAttachment = req.files["warrantyAttachment"][0].filename;
  }

  try {
    let result = new Warranty({
      stockRefId: stockRefId,
      modelRefId: modelRefId,
      warrantyName: warrantyName,
      warrantyExpiry: warrantyExpiry,
      warrantyAttachment: warrantyAttachment,
    });
    await result.save();

    const warrantyId = result._id;

    let stock = await Stock.findById({ _id: stockRefId });

    if (stock && !stock.warrantyRefIds.includes(warrantyId)) {
      stock.warrantyRefIds.push(warrantyId);
      await stock.save();
    } else {
      throw new Error(
        "Stock not found or Warranty already exists in the warranty"
      );
    }

    res.status(200).send(
      responsePacket.responsePacket(true, "Warranty Created Successfully", {
        null: null,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Warranty Not Created", {
        null: null,
      })
    );
  }
};

/// Update Warranty Details for Particular Stock
exports.updateWarrantyDetails = async (req, res) => {
  let { stockRefId, modelRefId, warrantyExpiry, warrantyId, warrantyName } =
    JSON.parse(req.body.jsonData);

  let warrantyAttachment = null;

  if (
    req.files &&
    req.files["warrantyAttachment"] &&
    req.files["warrantyAttachment"][0]
  ) {
    warrantyAttachment = req.files["warrantyAttachment"][0].filename;
  }

  try {
    var warrantyJson = {
      stockRefId: stockRefId,
      modelRefId: modelRefId,
      warrantyName: warrantyName,
      warrantyExpiry: warrantyExpiry,
    };

    if (warrantyAttachment != undefined && warrantyAttachment != null) {
      warrantyJson.warrantyAttachment = warrantyAttachment;
    }

    const foundWarranty = await Warranty.findOneAndUpdate(
      { _id: warrantyId },
      warrantyJson
    );

    if (!foundWarranty) {
      return res.status(404).send(
        responsePacket.responsePacket(false, "Warranty Not Found", {
          null: null,
        })
      );
    }

    const updatedWarranty = await Warranty.findById(warrantyId);

    let oldStock = await Stock.findOne({
      warrantyRefIds: warrantyId,
    });

    if (oldStock) {
      oldStock.warrantyRefIds.pull(warrantyId);
      await oldStock.save();
    }

    let newStock = await Stock.findById(stockRefId);
    if (newStock) {
      newStock.warrantyRefIds.push(warrantyId);
      await newStock.save();
    } else {
      throw new Error("New Stock not found");
    }

    res.status(200).send(
      responsePacket.responsePacket(true, "Warranty Updated Successfully", {
        oldWarrantyData: foundWarranty,
        newWarrantyData: updatedWarranty,
      })
    );
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Warranty Not Updated", {
        null: null,
      })
    );
  }
};

/// Check List For Asset
exports.addCheckList = async (req, res) => {
  let { entryName, functionalFlag, stockRefId, remarks } = req.body;

  try {
    let checkListResults = [];

    const checkListUpdate = await Stock.findOneAndUpdate(
      { _id: stockRefId },
      {
        checkListRefIds: [],
      }
    );

    for (let i = 0; i < entryName.length; i++) {
      const currentEntryName = entryName[i];
      const currentFlag = functionalFlag[i];
      const currentRemarks = remarks[i];

      let checkListResult = new CheckList({
        entryName: currentEntryName,
        functionalFlag: currentFlag,
        stockRefId: stockRefId,
        remarks: currentRemarks,
      });
      await checkListResult.save();
      checkListResults.push(checkListResult);

      const checkListId = checkListResult._id;

      let stock = await Stock.findById(stockRefId);
      let checkList = await CheckList.findById(checkListId);

      if (stock && checkList) {
        if (!stock.checkListRefIds.includes(checkListId)) {
          stock.checkListRefIds.push(checkListId);
          await stock.save();
        }
      } else {
        throw new Error("Stock or CheckList not found");
      }
    }

    res.status(200).send({
      success: true,
      message: "CheckList Created Successfully",
      data: {
        checkList: checkListResults,
      },
    });
  } catch (e) {
    console.log(e);
    res.status(500).send({
      success: false,
      message: "CheckList Not Created",
      error: e.message,
    });
  }
};

/// Get the notification details for dashboard
exports.getNotificationDetails = async (req, res) => {
  const { notificationId } = req.body;

  try {
    var allNotification = await Notification.find();
    if (allNotification && allNotification.length > 0) {
      res.status(200).send(
        responsePacket.responsePacket(true, "Notification Query Succeeded", {
          allNotification: allNotification,
        })
      );
    } else {
      res.status(200).send(
        responsePacket.responsePacket(false, "Notification not Found", {
          allNotification: [],
        })
      );
    }
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Notification Not Found", {
        allNotification: allNotification,
      })
    );
  }
};

/// Get the count  details of all data for dashboard
exports.getCountOfAllDetails = async (req, res) => {
  try {
    var allUsers = await User.find().lean();
    var allStock = await Stock.find().lean();
    var allTicket = await Ticket.find().lean();

    if (allUsers != null && allStock != null && allTicket != null) {
      const userServiceTickets = allTicket.filter(
        (ticket) => ticket.type === "Service Requests"
      );
      const adminServicesTickets = allTicket.filter(
        (ticket) => ticket.type === "Service Request"
      );
      const procurementTickets = allTicket.filter(
        (ticket) => ticket.type === "Asset Procurement"
      );

      const userServiceLength = userServiceTickets.length;
      const adminServicesLength = adminServicesTickets.length;

      const totalServiceLength = userServiceLength + adminServicesLength;

      allUsers["userCounts"] = allUsers.length;
      allStock["assetCounts"] = allStock.length;
      allTicket["procurementCounts"] = procurementTickets.length;
      allTicket["serviceCounts"] = totalServiceLength;

      if (allUsers && allTicket && allStock) {
        res.status(200).send(
          responsePacket.responsePacket(true, "Count Query Succeeded", {
            userCounts: allUsers.length,
            assetCounts: allStock.length,
            procurementCounts: procurementTickets.length,
            serviceCounts: totalServiceLength,
          })
        );
      }
    }
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Count Not Found", {
        null: null,
      })
    );
  }
};
