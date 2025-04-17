const express = require("express");
const router = express.Router();
const { catchErrors } = require("./../helpers/errorHandlers");
const assetTemplateControllers = require("./../controller/assetModule.controller");
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

// Get Asset Template Details
router.post(
  "/templateDetails",
  auth,
  catchErrors(assetTemplateControllers.getAssetTemplateDetails)
);
// Create Asset Template
router.post(
  "/addTemplate",
  auth,
  upload.fields([{ name: "image", maxCount: 1 }]),
  catchErrors(assetTemplateControllers.createAssetTemplateDetails)
);
// Update Asset Template
router.post(
  "/updateTemplate",
  auth,
  upload.fields([{ name: "image", maxCount: 1 }]),
  catchErrors(assetTemplateControllers.updateAssetTemplateDetails)
);
// Delete Template
router.post(
  "/deleteTemplate",
  auth,
  catchErrors(assetTemplateControllers.deleteTemplateDetails)
);
module.exports = router;
