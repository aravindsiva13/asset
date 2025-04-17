const mongoose = require("mongoose");

const { Schema } = require("mongoose");

const UserSchema = mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    email: {
      type: String,
      required: true,
      unique: true,
    },
    phoneNumber: {
      type: Number,
      required: true,
      unique: false,
    },
    employeeId: {
      type: String,
      required: true,
      unique: false,
    },
    dateOfJoining: {
      type: String,
      required: true,
    },
    password: {
      type: String,
      required: true,
    },
    designation: {
      type: String,
      default: false,
    },
    reportManagerRefId: {
      type: String,
    },
    department: {
      type: Array,
      required: true,
    },
    companyRefId: {
      type: String,
      required: true,
    },
    assignRoleRefIds: {
      type: Array,
      required: true,
    },
    assetStockRefId: {
      type: Array,
    },
    ticketRefId: {
      type: Array,
    },
    createdBy: {
      type: String,
    },
    updatedBy: {
      type: String,
    },

    userConfigRefId: {
      type: Array,
    },
    userSessionRefId: {
      type: Array,
    },
    image: {
      type: String,
      required: false,
    },
    deleteFlag: {
      type: Boolean,
    },

    tag: {
      type: Array,
    },
    displayId: {
      type: String,
    },
    deleteFlag: {
      type: Boolean,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("user", UserSchema);
