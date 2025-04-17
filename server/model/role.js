const mongoose = require("mongoose");

const { Schema } = require("mongoose");

// Assign Role for User
const RoleSchema = mongoose.Schema({
  roleTitle: {
    type: String,
    default: false,
  },

  userReadFlag: {
    type: Boolean,
    default: false,
  },
  userWriteFlag: {
    type: Boolean,
    default: false,
  },

  companyReadFlag: {
    type: Boolean,
    default: false,
  },

  companyWriteFlag: {
    type: Boolean,
    default: false,
  },

  vendorReadFlag: {
    type: Boolean,
    default: false,
  },

  vendorWriteFlag: {
    type: Boolean,
    default: false,
  },

  ticketReadFlag: {
    type: Boolean,
    default: false,
  },

  ticketWriteFlag: {
    type: Boolean,
    default: false,
  },

  assetTemplateReadFlag: {
    type: Boolean,
    default: false,
  },

  assetTemplateWriteFlag: {
    type: Boolean,
    default: false,
  },

  assetStockReadFlag: {
    type: Boolean,
    default: false,
  },

  assetStockWriteFlag: {
    type: Boolean,
    default: false,
  },

  assetModelReadFlag: {
    type: Boolean,
    default: false,
  },

  assetModelWriteFlag: {
    type: Boolean,
    default: false,
  },

  assignRoleReadFlag: {
    type: Boolean,
    default: false,
  },

  assignRoleWriteFlag: {
    type: Boolean,
    default: false,
  },

  locationReadFlag: {
    type: Boolean,
    default: false,
  },

  locationWriteFlag: {
    type: Boolean,
    default: false,
  },

  locationMainFlag: {
    type: Boolean,
    default: false,
  },

  userMainFlag: {
    type: Boolean,
    default: false,
  },

  companyMainFlag: {
    type: Boolean,
    default: false,
  },

  vendorMainFlag: {
    type: Boolean,
    default: false,
  },

  ticketMainFlag: {
    type: Boolean,
    default: false,
  },

  assetTemplateMainFlag: {
    type: Boolean,
    default: false,
  },

  assetStockMainFlag: {
    type: Boolean,
    default: false,
  },

  assetModelMainFlag: {
    type: Boolean,
    default: false,
  },

  assignRoleMainFlag: {
    type: Boolean,
    default: false,
  },

  assetTypeMainFlag: {
    type: Boolean,
    default: false,
  },

  assetTypeReadFlag: {
    type: Boolean,
    default: false,
  },

  assetTypeWriteFlag: {
    type: Boolean,
    default: false,
  },

  assetCategoryMainFlag: {
    type: Boolean,
    default: false,
  },

  assetCategoryReadFlag: {
    type: Boolean,
    default: false,
  },

  assetCategoryWriteFlag: {
    type: Boolean,
    default: false,
  },

  assetSubCategoryMainFlag: {
    type: Boolean,
    default: false,
  },

  assetSubCategoryReadFlag: {
    type: Boolean,
    default: false,
  },

  assetSubCategoryWriteFlag: {
    type: Boolean,
    default: false,
  },
  deleteFlag: {
    type: Boolean,
  },
});

module.exports = mongoose.model("assignRole", RoleSchema);
