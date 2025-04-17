const mongoose = require("mongoose");

const { Schema } = require("mongoose");

const TicketSchema = mongoose.Schema(
  {
    type: {
      type: String,
      required: true,
    },
    priority: {
      type: String,
    },
    userRefId: {
      type: String,
    },
    vendorRefId: {
      type: String,
    },
    locationRefId: {
      type: String,
    },
    modelRefId: {
      type: String,
    },
    stockRefId: {
      type: String,
    },
    expectedTime: {
      type: String,
    },
    description: {
      type: String,
    },
    assignedRefId: {
      type: String,
    },
    status: {
      type: String,
    },
    estimatedTime: {
      type: String,
    },
    remarks: {
      type: String,
    },
    attachment: { type: String },
    displayId: {
      type: String,
    },
    createdBy: {
      type: String,
    },
    updatedBy: {
      type: String,
    },
    trackerRefIds: {
      type: Array,
    },
    commentRefIds: {
      type: Array,
    },
    deleteFlag: {
      type: Boolean,
    },
  },

  {
    timestamps: true,
  }
);

exports.Ticket = mongoose.model("ticket", TicketSchema);

const TrackerSchema = mongoose.Schema(
  {
    createdBy: {
      type: String,
    },
    updatedBy: {
      type: String,
    },
    status: {
      type: String,
    },
    estimatedTime: {
      type: String,
    },
    assignedRefId: {
      type: String,
    },
    priority: {
      type: String,
    },
    remarks: {
      type: String,
    },
    ticketRefId: {
      type: String,
    },
  },
  {
    timestamps: true,
  }
);

exports.Tracker = mongoose.model("tracker", TrackerSchema);

const NotificationSchema = mongoose.Schema(
  {
    ticketRefId: {
      type: String,
      required: false,
    },
    message: {
      type: String,
      required: false,
    },
  },
  {
    timestamps: true,
  }
);

exports.Notification = mongoose.model("notification", NotificationSchema);

const CommentSchema = mongoose.Schema(
  {
    ticketRefId: {
      type: String,
    },
    comment: {
      type: String,
    },
    userName: {
      type: String,
    },
    dateTime: {
      type: String,
    },
  },
  {
    timestamps: true,
  }
);

exports.Comment = mongoose.model("comment", CommentSchema);
