const mongoose = require("mongoose");

const { Schema } = require("mongoose");

const CompanySchema = mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },

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
    phoneNumber: {
      type: Number,
      required: true,
      unique: false,
    },
    email: {
      type: String,
      required: true,
    },
    website: {
      type: String,
      required: true,
    },
    contactPersonName: {
      type: String,
      required: true,
    },
    contactPersonPhoneNumber: {
      type: Number,
      required: true,
      unique: false,
    },
    contactPersonEmail: {
      type: String,
      required: true,
    },
    departments: {
      type: Array,
      required: true,
    },
    image: {
      type: String,
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
module.exports = mongoose.model("company", CompanySchema);
