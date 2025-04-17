const express = require("express");
const router = express.Router();
const { catchErrors } = require("./../helpers/errorHandlers");
const assetStockControllers = require("./../controller/assetModule.controller");
const otherModule = require("./../controller/otherModule.controller");
const auth = require("./../helpers/auth");
const multer = require("multer");
const { GridFsStorage } = require("multer-gridfs-storage");
const crypto = require("crypto");
const path = require("path");

// Used for Storage in Mongo DB
const storage = new GridFsStorage({
  url: process.env.MONGO_URL,
  file: (req, file) => {
    return new Promise((resolve, reject) => {
      crypto.randomBytes(16, (err, buf) => {
        if (err) {
          return reject(err);
        }
        const filename = buf.toString("hex") + path.extname(file.originalname);
        const fileInfo = {
          filename: filename,
          bucketName: "uploads",
        };
        resolve(fileInfo);
      });
    });
  },
});

const upload = multer({
  storage: storage,
  limits: { fieldSize: 10 * 1024 * 1024 },
});

// Get Asset Stock Details
router.post(
  "/stockDetails",
  auth,
  catchErrors(assetStockControllers.getAssetStockDetails)
);
router.post(
  "/particularStockDetails",
  auth,
  catchErrors(assetStockControllers.getParticularAssetStockDetails)
);
// Create Asset Stock
router.post(
  "/addStock",
  auth,
  upload.fields([{ name: "image", maxCount: 1 }]),
  catchErrors(assetStockControllers.createAssetStockDetails)
);
// Update Asset Stock
router.post(
  "/updateStock",
  auth,
  upload.fields([{ name: "image", maxCount: 1 }]),
  catchErrors(assetStockControllers.updateAssetStockDetails)
);
// User Assignment
router.post(
  "/userAssignment",
  auth,
  catchErrors(assetStockControllers.userAssignment)
);
//  Asset Return
router.post(
  "/assetReturn",
  auth,
  upload.fields([{ name: "image", maxCount: 1 }]),
  catchErrors(assetStockControllers.assetReturn)
);
// Delete Stock
router.post(
  "/deleteStock",
  auth,
  catchErrors(assetStockControllers.deleteStockDetails)
);
router.post(
  "/addWarranty",
  auth,
  upload.fields([{ name: "warrantyAttachment" }]),
  catchErrors(otherModule.addWarranty)
);
router.post(
  "/updateWarranty",
  auth,
  upload.fields([{ name: "warrantyAttachment" }]),
  catchErrors(otherModule.updateWarrantyDetails)
);

module.exports = router;
