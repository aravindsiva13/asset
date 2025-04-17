const express = require("express");
const router = express.Router();
const { catchErrors } = require("./../helpers/errorHandlers");
const assetTypeControllers = require("./../controller/assetModule.controller");
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

// Get Asset Model Details
router.post(
  "/typeDetails",
  auth,
  catchErrors(assetTypeControllers.getAssetTypeDetails)
);
// Create Asset Model
router.post(
  "/addType",
  auth,
  upload.fields([{ name: "image", maxCount: 1 }]),
  catchErrors(assetTypeControllers.createAssetTypeDetails)
);
// Update Asset Model
router.post(
  "/updateType",
  auth,
  upload.fields([{ name: "image", maxCount: 1 }]),
  catchErrors(assetTypeControllers.updateAssetTypeDetails)
);
// Delete Model
router.post(
  "/deleteType",
  auth,
  catchErrors(assetTypeControllers.deleteTypeDetails)
);
module.exports = router;
