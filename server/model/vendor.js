const mongoose = require("mongoose");

const { Schema } = require("mongoose");

const VendorSchema = mongoose.Schema(
  {
    vendorName: { type: String, required: true },

    address: {
      address: {
        type: String,
        required: true,
      },
      city: {
        type: String,
        required: true,
      },
      state: {
        type: String,
        required: true,
      },
      country: {
        type: String,
        required: true,
      },

      landMark: {
        type: String,
        required: true,
      },

      pinCode: {
        type: Number,
        required: true,
      },
    },
    contractDocument: { type: String },
    image: { type: String },
    phoneNumber: {
      type: Number,
      required: true,
      unique: false,
    },
    email: {
      type: String,
      required: true,
    },
    name: {
      type: String,
      required: true,
    },
    gstIn: {
      type: String,
      required: true,
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
module.exports = mongoose.model("vendor", VendorSchema);
