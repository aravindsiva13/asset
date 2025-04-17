const mongoose = require("mongoose");

const { Schema } = require("mongoose");

const UserSessionSchema = mongoose.Schema(
  {
    ipAddress: {
      type: String,
      required: true,
    },
    additionalInfo: {
      type: String,
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("userSession", UserSessionSchema);
