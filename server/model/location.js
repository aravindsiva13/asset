const mongoose = require("mongoose");

const { Schema } = require("mongoose");

const LocationSchema = mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    latitude: {
      type: String,
      required: true,
    },

    longitude: {
      type: String,
      required: true,
    },
    address: {
      address: { type: String, required: true },
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
    plusCode: {
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

module.exports = mongoose.model("location", LocationSchema);
