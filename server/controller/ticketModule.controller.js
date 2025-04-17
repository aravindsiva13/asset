const {
  raiseTicketValidator,
  commentValidator,
  deleteValidator,
} = require("../helpers/validator");
const { Stock, Model } = require("../model/asset");
const { Ticket, Tracker, Notification, Comment } = require("../model/ticket");
const User = require("../model/user");
const Vendor = require("../model/vendor");
const Location = require("../model/location");
const fs = require("fs");
const responsePacket = require("../helpers/response");
const mailTemplate = require("../helpers/mailTemplate");
const mail = require("../helpers/mail");
const { addDisplayId, modifyDisplayId } = require("../helpers/displayId");

// Get Ticket Details
exports.getTicketDetails = async (req, res) => {
  const { ticketId } = req.body;

  try {
    var allTicket = await Ticket.find().lean();
    allTicket.reverse();
    if (allTicket != null) {
      for (let i = 0; i < allTicket.length; i++) {
        if (
          allTicket[i].userRefId !== null &&
          allTicket[i].userRefId !== "null"
        ) {
          let userFound = await User.find()
            .where("_id")
            .in(allTicket[i].userRefId)
            .select("name")
            .lean();

          allTicket[i]["userName"] = userFound[0].name;
        }

        if (allTicket[i].createdBy !== null) {
          let createdByUserFound = await User.find()
            .where("_id")
            .in(allTicket[i].createdBy)
            .select("name")
            .lean();

          allTicket[i]["createdByUserName"] = createdByUserFound[0].name;
        }

        if (allTicket[i].assignedRefId !== null) {
          let assignedUserFound = await User.find()
            .where("_id")
            .in(allTicket[i].assignedRefId)
            .select("name")
            .lean();

          allTicket[i]["assignedName"] = assignedUserFound[0].name;

          let userDesignationFound = await User.find()
            .where("_id")
            .in(allTicket[i].assignedRefId)
            .select("designation")
            .lean();

          allTicket[i]["userDesignation"] = userDesignationFound[0].designation;

          let userEmpIdFound = await User.find()
            .where("_id")
            .in(allTicket[i].assignedRefId)
            .select("employeeId")
            .lean();

          allTicket[i]["userEmpId"] = userEmpIdFound[0].employeeId;

          let userImageFound = await User.find()
            .where("_id")
            .in(allTicket[i].assignedRefId)
            .select("image")
            .lean();

          allTicket[i]["userImage"] = userImageFound[0].image;
        }

        if (
          allTicket[i].vendorRefId !== null &&
          allTicket[i].vendorRefId !== "null"
        ) {
          let vendorFound = await Vendor.find()
            .where("_id")
            .in(allTicket[i].vendorRefId)
            .select("name")
            .lean();

          allTicket[i]["vendorName"] = vendorFound[0].name;
        }

        if (allTicket[i].locationRefId !== null) {
          let locationFound = await Location.find()
            .where("_id")
            .in(allTicket[i].locationRefId)
            .select("name")
            .lean();

          allTicket[i]["locationName"] = locationFound[0].name;
        }

        if (
          allTicket[i].modelRefId !== null &&
          allTicket[i].modelRefId !== "null"
        ) {
          let modelFound = await Model.find()
            .where("_id")
            .in(allTicket[i].modelRefId)
            .select("assetName")
            .lean();

          let modelIdFound = await Model.find()
            .where("_id")
            .in(allTicket[i].modelRefId)
            .select("displayId")
            .lean();

          let modelDisplayId = modelIdFound[0].displayId;

          allTicket[i][
            "modelName"
          ] = `${modelFound[0].assetName} (${modelDisplayId})`;
        }

        if (
          allTicket[i].stockRefId !== null &&
          allTicket[i].stockRefId !== "null"
        ) {
          let stockFound = await Stock.find()
            .where("_id")
            .in(allTicket[i].stockRefId)
            .select("assetRefId")
            .lean();

          let modelId = stockFound[0].assetRefId;

          let stockIdFound = await Stock.find()
            .where("_id")
            .in(allTicket[i].stockRefId)
            .select("displayId")
            .lean();

          let stockId = stockIdFound[0].displayId;

          let modelFound = await Model.find()
            .where("_id")
            .in(modelId)
            .select("assetName")
            .lean();

          allTicket[i]["stockName"] = `${modelFound[0].assetName} (${stockId})`;
        }

        allTicket[i]["trackers"] = [];

        if (
          allTicket[i].trackerRefIds !== null &&
          allTicket[i].trackerRefIds !== undefined
        ) {
          const trackerPromises = allTicket[i].trackerRefIds.map(
            async (trackerId) => {
              const track = await Tracker.findById(trackerId).lean();

              if (track.assignedRefId !== null) {
                const assignedUserFound = await User.findById(
                  track.assignedRefId
                )
                  .select("name")
                  .lean();

                const createdByUserFound = await User.findById(track.createdBy)
                  .select("name")
                  .lean();

                return {
                  trackerId: track._id,
                  trackerCreatedBy: createdByUserFound.name,
                  trackerStatus: track.status,
                  trackerEstimatedTime: track.estimatedTime,
                  trackerPriority: track.priority,
                  trackerAssignedRefId: assignedUserFound.name,
                  trackerRemarks: track.remarks,
                  createdAt: track.createdAt,
                };
              } else {
                const createdByUserFound = await User.findById(track.createdBy)
                  .select("name")
                  .lean();

                return {
                  trackerId: track._id,
                  trackerCreatedBy: createdByUserFound.name,
                  trackerStatus: track.status,
                  trackerEstimatedTime: track.estimatedTime,
                  trackerPriority: track.priority,
                  trackerRemarks: track.remarks,
                  createdAt: track.createdAt,
                };
              }
            }
          );

          const trackers = await Promise.all(trackerPromises);

          allTicket[i]["trackers"] = trackers;
        }

        allTicket[i]["comments"] = [];

        if (
          allTicket[i].commentRefIds !== null &&
          allTicket[i].trackerRefIds !== undefined &&
          Array.isArray(allTicket[i].commentRefIds)
        ) {
          const commentPromise = allTicket[i].commentRefIds.map(
            async (commentId) => {
              const comment = await Comment.findById(commentId).lean();

              return {
                commentId: comment._id,
                commentUserName: comment.userName,
                commentDateTime: comment.dateTime,
                commentTicketId: comment.ticketRefId,
                comments: comment.comment,
              };
            }
          );

          const comments = await Promise.all(commentPromise);

          allTicket[i]["comments"] = comments;
        }
      }
    }
    if (allTicket) {
      res.status(200).send(
        responsePacket.responsePacket(true, "Ticket Query Succeeded", {
          allTicket: allTicket,
        })
      );
    }
  } catch (e) {
    console.error(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Ticket Not Found", {
        null: null,
      })
    );
  }
};

// Add Ticket
exports.addTicket = async (req, res) => {
  let {
    type,
    priority,
    userRefId,
    vendorRefId,
    locationRefId,
    modelRefId,
    stockRefId,
    expectedTime,
    description,
    assignedRefId,
    status,
    estimatedTime,
    remarks,
    createdBy,
  } = JSON.parse(req.body.jsonData);

  let attachment = null;

  if (req.files && req.files["attachment"] && req.files["attachment"][0]) {
    attachment = req.files["attachment"][0].filename;
  }

  let error = [];

  error.push(...raiseTicketValidator(type, priority));

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  let idPrefix = "TICK";

  let displayId;
  try {
    displayId = await addDisplayId(idPrefix, Ticket);
  } catch (error) {
    console.error("Error while generating displayId:", error);
    res.status(500).send({
      ErrorMsg: "Error while generating displayId",
    });
    return;
  }

  try {
    let result = new Ticket({
      type: type,
      priority: priority,
      userRefId: userRefId,
      vendorRefId: vendorRefId,
      locationRefId: locationRefId,
      modelRefId: modelRefId,
      stockRefId: stockRefId,
      expectedTime: expectedTime,
      description: description,
      assignedRefId: assignedRefId,
      status: status,
      estimatedTime: estimatedTime,
      remarks: remarks,
      attachment: attachment,
      displayId: displayId,
      createdBy: createdBy,
    });
    await result.save();

    const ticketId = result._id;

    let ticketTrackerForCreate = new Tracker({
      createdBy: createdBy,
      status: "Created",
      estimatedTime: estimatedTime,
      priority: priority,
      assignedRefId: assignedRefId,
      remarks: remarks,
      ticketRefId: ticketId,
    });

    await ticketTrackerForCreate.save();

    let trackerIdCreate = ticketTrackerForCreate._id;

    const ticketDetailsForCreate = await Ticket.findById({ _id: ticketId });

    if (
      ticketDetailsForCreate &&
      !ticketDetailsForCreate.trackerRefIds.includes(trackerIdCreate)
    ) {
      ticketDetailsForCreate.trackerRefIds.push(trackerIdCreate);
      await ticketDetailsForCreate.save();
    } else {
      throw new Error(
        "Ticket not found or Tracker already exists in the category"
      );
    }

    let ticketTracker = new Tracker({
      createdBy: createdBy,
      status: status,
      estimatedTime: estimatedTime,
      priority: priority,
      assignedRefId: assignedRefId,
      remarks: remarks,
      ticketRefId: ticketId,
    });

    await ticketTracker.save();

    let trackerId = ticketTracker._id;

    const ticketDetails = await Ticket.findById({ _id: ticketId });

    if (ticketDetails && !ticketDetails.trackerRefIds.includes(trackerId)) {
      ticketDetails.trackerRefIds.push(trackerId);
      await ticketDetails.save();
    } else {
      throw new Error(
        "Ticket not found or Tracker already exists in the ticket"
      );
    }

    let userId = result.userRefId;

    let assignUserId = result.assignedRefId;

    let createdUserId = result.createdBy;

    let currentStatus = result.status;

    let userName;

    if (userId !== null) {
      let userFound = await User.find()
        .where("_id")
        .in(userId)
        .select("name")
        .lean();

      userName = userFound[0].name;
    }

    let assignUserName;

    if (assignUserId !== null) {
      let assignUserFound = await User.find()
        .where("_id")
        .in(assignUserId)
        .select("name")
        .lean();

      assignUserName = assignUserFound[0].name;
    }

    let createdUserName;

    if (createdUserId !== null) {
      let createdUserFound = await User.find()
        .where("_id")
        .in(createdUserId)
        .select("name")
        .lean();

      createdUserName = createdUserFound[0].name;
    }

    let userEmailId;

    if (userId !== null) {
      let userEmailIdFound = await User.find()
        .where("_id")
        .in(userId)
        .select("email")
        .lean();

      userEmailId = userEmailIdFound[0].email;
    }

    let assignUserEmailId;

    if (assignUserId !== null) {
      let assignUserEmailIdFound = await User.find()
        .where("_id")
        .in(assignUserId)
        .select("email")
        .lean();

      assignUserEmailId = assignUserEmailIdFound[0].email;
    }

    let createdUserEmailId;

    if (createdUserId !== null) {
      let createdUserEmailIdFound = await User.find()
        .where("_id")
        .in(createdUserId)
        .select("email")
        .lean();

      createdUserEmailId = createdUserEmailIdFound[0].email;
    }

    if (result.type == "Asset Procurement") {
      let ticketNotification = new Notification({
        ticketRefId: ticketId,
        message: `${result.type} was created by ${createdUserName}. The Ticket was assigned to ${assignUserName}. The current ticket status is ${currentStatus}`,
      });

      await ticketNotification.save();

      let message = ticketNotification.message;

      let ticketData = {
        heading: "ITAM TICKET",
        type: message,
      };

      let ticketMailTemplate = await mailTemplate.generateTemplate(
        "ticket",
        ticketData
      );

      let sendEmailToCreatedUser = mail.sendEmail(
        createdUserEmailId,
        `Ticket Notification`,
        null,
        ticketMailTemplate
      );

      let sendEmailToAssignUser = mail.sendEmail(
        assignUserEmailId,
        `Ticket Notification`,
        null,
        ticketMailTemplate
      );
    }

    if (
      result.type == "User Assignment" ||
      result.type == "Asset Return" ||
      result.type == "Service Request"
    ) {
      if (userId != null) {
        let ticketNotification = new Notification({
          ticketRefId: ticketId,
          message: `${result.type} was created for ${userName}. The Ticket was assigned to ${assignUserName}. The current ticket status is ${currentStatus}`,
        });

        await ticketNotification.save();

        let message = ticketNotification.message;

        let ticketData = {
          heading: "ITAM TICKET",
          type: message,
        };

        let ticketMailTemplate = await mailTemplate.generateTemplate(
          "ticket",
          ticketData
        );

        let sendEmailToUser = mail.sendEmail(
          userEmailId,
          `Ticket Notification`,
          null,
          ticketMailTemplate
        );

        let sendEmailToAssignUser = mail.sendEmail(
          assignUserEmailId,
          `Ticket Notification`,
          null,
          ticketMailTemplate
        );
      } else {
        let ticketNotification = new Notification({
          ticketRefId: ticketId,
          message: `${result.type} was created by ${createdUserName}. The Ticket was assigned to ${assignUserName}. The current ticket status is ${currentStatus}`,
        });

        await ticketNotification.save();

        let message = ticketNotification.message;

        let ticketData = {
          heading: "ITAM TICKET",
          type: message,
        };

        let ticketMailTemplate = await mailTemplate.generateTemplate(
          "ticket",
          ticketData
        );

        let sendEmailToCreatedUser = mail.sendEmail(
          createdUserEmailId,
          `Ticket Notification`,
          null,
          ticketMailTemplate
        );

        let sendEmailToAssignUser = mail.sendEmail(
          assignUserEmailId,
          `Ticket Notification`,
          null,
          ticketMailTemplate
        );
      }
    }

    if (
      result.type == "Request New Asset" ||
      result.type == "Service Requests"
    ) {
      let ticketNotification = new Notification({
        ticketRefId: ticketId,
        message: `${userName} was raised the ${result.type} Ticket.`,
      });

      await ticketNotification.save();

      let message = ticketNotification.message;

      let ticketData = {
        heading: "ITAM TICKET",
        type: message,
      };

      let ticketMailTemplate = await mailTemplate.generateTemplate(
        "ticket",
        ticketData
      );

      let sendEmailToUser = mail.sendEmail(
        userEmailId,
        `Ticket Notification`,
        null,
        ticketMailTemplate
      );

      let sendEmailToAssignUser = mail.sendEmail(
        process.env.from,
        `Ticket Notification`,
        null,
        ticketMailTemplate
      );
    }

    res.status(200).send(
      responsePacket.responsePacket(true, "Ticket Created Successfully", {
        null: null,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Ticket Not Created", {
        null: null,
      })
    );
  }
};

// Update Ticket
exports.updateTicket = async (req, res) => {
  let {
    type,
    priority,
    userRefId,
    vendorRefId,
    locationRefId,
    modelRefId,
    stockRefId,
    expectedTime,
    description,
    assignedRefId,
    status,
    estimatedTime,
    remarks,
    sId,
    createdBy,
    updatedBy,
  } = JSON.parse(req.body.jsonData);

  const ticketId = sId;

  let attachment = null;

  if (req.files && req.files["attachment"] && req.files["attachment"][0]) {
    attachment = req.files["attachment"][0].filename;
  }

  let error = [];

  error.push(...raiseTicketValidator(type, priority));

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  try {
    var ticketJson = {
      type: type,
      priority: priority,
      userRefId: userRefId,
      vendorRefId: vendorRefId,
      locationRefId: locationRefId,
      modelRefId: modelRefId,
      stockRefId: stockRefId,
      expectedTime: expectedTime,
      description: description,
      assignedRefId: assignedRefId,
      status: status,
      estimatedTime: estimatedTime,
      remarks: remarks,
      updatedBy: updatedBy,
    };
    if (attachment != undefined && attachment != null) {
      templateJson.attachment = attachment;
    }

    const foundTicket = await Ticket.findOneAndUpdate(
      { _id: ticketId },
      ticketJson
    );

    let ticketTracker = new Tracker({
      createdBy: createdBy,
      status: status,
      estimatedTime: estimatedTime,
      priority: priority,
      assignedRefId: assignedRefId,
      remarks: remarks,
      ticketRefId: ticketId,
    });

    await ticketTracker.save();

    let trackerId = ticketTracker._id;

    const ticketDetails = await Ticket.findById({ _id: ticketId });

    if (ticketDetails && !ticketDetails.trackerRefIds.includes(trackerId)) {
      ticketDetails.trackerRefIds.push(trackerId);
      await ticketDetails.save();
    } else {
      throw new Error(
        "Ticket not found or Tracker already exists in the category"
      );
    }

    let userId = ticketJson.userRefId;

    let assignUserId = ticketJson.assignedRefId;

    let currentStatus = ticketJson.status;

    let updateUserId = ticketJson.updatedBy;

    let userName;

    if (userId !== null) {
      let userFound = await User.find()
        .where("_id")
        .in(userId)
        .select("name")
        .lean();

      userName = userFound[0].name;
    }

    let assignUserName;

    if (assignUserId !== null) {
      let assignUserFound = await User.find()
        .where("_id")
        .in(assignUserId)
        .select("name")
        .lean();

      assignUserName = assignUserFound[0].name;
    }

    let userEmailId;

    if (userId !== null) {
      let userEmailIdFound = await User.find()
        .where("_id")
        .in(userId)
        .select("email")
        .lean();

      userEmailId = userEmailIdFound[0].email;
    }

    let assignUserEmailId;

    if (assignUserId !== null) {
      let assignUserEmailIdFound = await User.find()
        .where("_id")
        .in(assignUserId)
        .select("email")
        .lean();

      assignUserEmailId = assignUserEmailIdFound[0].email;
    }

    let updatedUserName;

    if (updateUserId !== null) {
      let updatedUserFound = await User.find()
        .where("_id")
        .in(updateUserId)
        .select("name")
        .lean();

      updatedUserName = updatedUserFound[0].name;
    }

    let updatedUserEmailId;

    if (updateUserId !== null) {
      let updatedUserEmailIdFound = await User.find()
        .where("_id")
        .in(updateUserId)
        .select("email")
        .lean();

      updatedUserEmailId = updatedUserEmailIdFound[0].email;
    }

    if (ticketJson.type == "Asset Procurement") {
      let ticketNotification = new Notification({
        ticketRefId: ticketId,
        message: `${ticketJson.type} was updated by ${updatedUserName}. The Ticket was assigned to ${assignUserName}. The current ticket status is ${currentStatus}`,
      });

      await ticketNotification.save();

      let message = ticketNotification.message;

      let ticketData = {
        heading: "ITAM TICKET",
        type: message,
      };

      let ticketMailTemplate = await mailTemplate.generateTemplate(
        "ticket",
        ticketData
      );

      let sendEmailToUpdatedUser = mail.sendEmail(
        updatedUserEmailId,
        `Ticket Notification`,
        null,
        ticketMailTemplate
      );

      let sendEmailToAssignUser = mail.sendEmail(
        assignUserEmailId,
        `Ticket Notification`,
        null,
        ticketMailTemplate
      );
    }

    if (
      ticketJson.type == "User Assignment" ||
      ticketJson.type == "Asset Return" ||
      ticketJson.type == "Service Request"
    ) {
      if (userId != null) {
        let ticketNotification = new Notification({
          ticketRefId: ticketId,
          message: `${ticketJson.type} was updated for ${userName}. The Ticket was assigned to ${assignUserName}. The current ticket status is ${currentStatus}`,
        });

        await ticketNotification.save();

        let message = ticketNotification.message;

        let ticketData = {
          heading: "ITAM TICKET",
          type: message,
        };

        let ticketMailTemplate = await mailTemplate.generateTemplate(
          "ticket",
          ticketData
        );

        let sendEmailToUser = mail.sendEmail(
          userEmailId,
          `Ticket Notification`,
          null,
          ticketMailTemplate
        );

        let sendEmailToAssignUser = mail.sendEmail(
          assignUserEmailId,
          `Ticket Notification`,
          null,
          ticketMailTemplate
        );
      } else {
        let ticketNotification = new Notification({
          ticketRefId: ticketId,
          message: `${ticketJson.type} was updated by ${updatedUserName}. The Ticket was assigned to ${assignUserName}. The current ticket status is ${currentStatus}`,
        });

        await ticketNotification.save();

        let message = ticketNotification.message;

        let ticketData = {
          heading: "ITAM TICKET",
          type: message,
        };

        let ticketMailTemplate = await mailTemplate.generateTemplate(
          "ticket",
          ticketData
        );

        let sendEmailToUpdatedUser = mail.sendEmail(
          updatedUserEmailId,
          `Ticket Notification`,
          null,
          ticketMailTemplate
        );

        let sendEmailToAssignUser = mail.sendEmail(
          assignUserEmailId,
          `Ticket Notification`,
          null,
          ticketMailTemplate
        );
      }
    }

    if (!foundTicket) {
      return res.status(404).send(
        responsePacket.responsePacket(false, "Ticket Not Found", {
          null: null,
        })
      );
    }

    const updatedTicket = await Ticket.findById(ticketId);

    res.status(200).send(
      responsePacket.responsePacket(true, "Ticket Updated Successfully", {
        oldTicketData: foundTicket,
        newTicketData: updatedTicket,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Ticket Not Updated", {
        null: null,
      })
    );
  }
};

// Delete Ticket
exports.deleteTicketDetails = async (req, res) => {
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
    let ticket = await Ticket.findById({ _id: id });

    if (!ticket) {
      res.status(404).send({
        ErrorMsg: "Ticket not found",
      });
      return;
    }

    let displayId = ticket.displayId;

    let idPrefix = "TICK";

    result = await Ticket.deleteOne({
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
      responsePacket.responsePacket(true, "Ticket is deleted successfully", {
        data: result,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Ticket is not deleted", {
        data: result,
      })
    );
  }
};

exports.addComments = async (req, res) => {
  let {
    comment,
    userName,
    dateTime,
    ticketRefId,
    userRefId,
    assignUserRefId,
    ticketDisplayId,
  } = JSON.parse(req.body.jsonData);

  let error = [];

  error.push(...commentValidator(comment, dateTime));

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  try {
    let result = new Comment({
      comment: comment,
      userName: userName,
      dateTime: dateTime,
      ticketRefId: ticketRefId,
    });

    await result.save();

    let commentId = result._id;

    let ticket = await Ticket.findById({ _id: ticketRefId });

    if (ticket && !ticket.commentRefIds.includes(commentId)) {
      ticket.commentRefIds.push(commentId);
      await ticket.save();
    } else {
      throw new Error(
        "Ticket not found or Comment already exists in the category"
      );
    }

    if (userRefId !== null && userRefId !== undefined) {
      let userNameFound = await User.find()
        .where("_id")
        .in(userRefId)
        .select("name")
        .lean();

      const userName = userNameFound[0].name;

      let userMailFound = await User.find()
        .where("_id")
        .in(userRefId)
        .select("email")
        .lean();

      let userMailId = userMailFound[0].email;

      let ticketData = {
        heading: `TICKET ID: ${ticketDisplayId}`,
        type: `${userName} commented, ${comment}`,
      };

      let ticketMailTemplate = await mailTemplate.generateTemplate(
        "ticket",
        ticketData
      );

      let sendEmailToUser = mail.sendEmail(
        userMailId,
        `Ticket Notification`,
        null,
        ticketMailTemplate
      );

      if (assignUserRefId !== null && assignUserRefId !== undefined) {
        let assignUserMailFound = await User.find()
          .where("_id")
          .in(assignUserRefId)
          .select("email")
          .lean();

        const assignUserMailId = assignUserMailFound[0].email;

        let sendEmailToAssignUser = mail.sendEmail(
          assignUserMailId,
          `Ticket Notification`,
          null,
          ticketMailTemplate
        );
      }
    }

    res.status(200).send(
      responsePacket.responsePacket(true, "Comment Created Successfully", {
        null: null,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Comment Not Created", {
        null: null,
      })
    );
  }
};

exports.updateComments = async (req, res) => {
  let { comment, userName, dateTime, ticketRefId, sId } = JSON.parse(
    req.body.jsonData
  );

  const commentId = sId;

  let error = [];

  error.push(...commentValidator(comment, dateTime));

  if (error.length != 0) {
    res.status(400).send({
      ErrorMsg: error,
    });
    return;
  }

  try {
    var CommentJson = {
      comment: comment,
      userName: userName,
      dateTime: dateTime,
      ticketRefId: ticketRefId,
    };

    const foundComment = await Comment.findOneAndUpdate(
      { _id: commentId },
      CommentJson
    );

    if (!foundComment) {
      return res.status(404).send(
        responsePacket.responsePacket(false, "Comment Not Found", {
          null: null,
        })
      );
    }

    const updatedComment = await Comment.findById(commentId);

    res.status(200).send(
      responsePacket.responsePacket(true, "Comment Updated Successfully", {
        oldCommentData: foundComment,
        newCommentData: updatedComment,
      })
    );
  } catch (e) {
    console.log(e);
    res.status(500).send(
      responsePacket.responsePacket(false, "Comment Not Updated", {
        null: null,
      })
    );
  }
};
