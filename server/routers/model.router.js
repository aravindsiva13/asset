const express = require("express");
const router = express.Router();
const { catchErrors } = require("./../helpers/errorHandlers");
const assetModelControllers = require("./../controller/assetModule.controller");
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
  "/modelDetails",
  auth,
  catchErrors(assetModelControllers.getAssetModelDetails)
);
// Create Asset Model
router.post(
  "/addModel",
  auth,
  upload.fields([{ name: "image", maxCount: 1 }]),
  catchErrors(assetModelControllers.createAssetModelDetails)
);
// Update Asset Model
router.post(
  "/updateModel",
  auth,
  upload.fields([{ name: "image", maxCount: 1 }]),
  catchErrors(assetModelControllers.updateAssetModelDetails)
);
// Delete Model
router.post(
  "/deleteModel",
  auth,
  catchErrors(assetModelControllers.deleteModelDetails)
);
module.exports = router;
