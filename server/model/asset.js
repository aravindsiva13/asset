const mongoose = require("mongoose");

const { Schema } = require("mongoose");

const AssetStockSchema = mongoose.Schema(
  {
    vendorRefId: {
      type: String,
      required: true,
    },
    userRefId: {
      type: String,
    },
    locationRefId: {
      type: String,
      required: true,
    },
    assetRefId: {
      type: String,
      required: true,
    },
    ticketRefId: {
      type: String,
    },
    serialNo: {
      type: String,
      required: true,
    },
    issuedDateTime: {
      type: String,
      required: true,
    },
    purchaseDate: {
      type: String,
    },
    warrantyPeriod: {
      type: String,
    },
    warrantyExpiry: {
      type: String,
      required: true,
    },
    image: {
      type: String,
      required: false,
    },
    remarks: {
      type: String,
    },
    tag: {
      type: Array,
    },
    displayId: {
      type: String,
    },
    assignedTo: {
      type: String,
    },
    checkListRefIds: {
      type: Array,
    },
    warrantyRefIds: {
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

exports.Stock = mongoose.model("stock", AssetStockSchema);

const AssetModelSchema = mongoose.Schema(
  {
    modelId: {
      type: String,
      required: true,
    },
    additionalModelId: {
      type: String,
      required: true,
    },
    assetName: {
      type: String,
      required: true,
    },
    manufacturer: {
      type: String,
      required: true,
    },
    templateRefId: {
      type: String,
      required: true,
    },
    typeRefId: {
      type: String,
    },
    categoryRefId: {
      type: String,
    },
    subCategoryRefId: {
      type: String,
    },
    specificationRefId: {
      type: Array,
    },
    image: {
      type: String,
      required: false,
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

exports.Model = mongoose.model("model", AssetModelSchema);

const AssetTemplateSchema = mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    companyRefId: {
      type: String,
      required: true,
    },
    department: {
      type: Array,
      required: true,
    },
    parameters: {
      type: Array,
      required: true,
    },
    image: {
      type: String,
      required: false,
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

exports.Template = mongoose.model("template", AssetTemplateSchema);

const AssetTypeSchema = mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    image: {
      type: String,
      required: false,
    },
    tag: {
      type: Array,
    },
    categoryRefIds: {
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

exports.Type = mongoose.model("type", AssetTypeSchema);

const AssetCategorySchema = mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    image: {
      type: String,
      required: false,
    },
    tag: {
      type: Array,
    },
    typeRefIds: {
      type: Array,
      required: true,
    },
    subCategoryRefIds: {
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

exports.Categorys = mongoose.model("category", AssetCategorySchema);

const AssetSubCategorySchema = mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    image: {
      type: String,
      required: false,
    },
    tag: {
      type: Array,
    },
    categoryRefIds: {
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

exports.SubCategorys = mongoose.model("subCategory", AssetSubCategorySchema);

const SpecificationSchema = mongoose.Schema(
  {
    key: {
      type: String,
    },
    value: {
      type: String,
    },
    modelRefId: {
      type: String,
    },
    templateRefId: {
      type: String,
    },
  },
  {
    timestamps: true,
  }
);

exports.Specifications = mongoose.model("specification", SpecificationSchema);

const CheckListSchema = mongoose.Schema(
  {
    entryName: {
      type: String,
    },
    functionalFlag: {
      type: String,
    },
    stockRefId: {
      type: String,
    },
    remarks: {
      type: String,
    },
  },
  { timestamps: true }
);

exports.CheckList = mongoose.model("checkList", CheckListSchema);

const WarrantySchema = mongoose.Schema({
  stockRefId: {
    type: String,
  },
  modelRefId: {
    type: String,
  },
  warrantyName: {
    type: String,
  },
  warrantyExpiry: {
    type: String,
  },
  warrantyAttachment: { type: String },
});

exports.Warranty = mongoose.model("warranty", WarrantySchema);
