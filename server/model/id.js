const mongoose = require("mongoose");

const { Schema } = require("mongoose");

const IdSchema = mongoose.Schema(
  {
    tableName: {
      type: String,
    },
    displayIndex: {
      type: Number,
    },
  },
  {
    timestamps: true,
  }
);

exports.Id = mongoose.model("id", IdSchema);
