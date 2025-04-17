const express = require("express");
const router = express.Router();
const { catchErrors } = require("./../helpers/errorHandlers");
const assetControllers = require("./../controller/assetModule.controller");
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
const upload = multer({ storage });

// Asset List User
router.post("/assetListUser", catchErrors(assetControllers.assetListUser));

// Asset Model View Admin
router.post("/assetModelAdmin", catchErrors(assetControllers.assetModelView));

// Asset Template View Admin
router.post(
  "/assetTemplateAdmin",
  auth,
  catchErrors(assetControllers.assetTemplateView)
);
// Asset Stock View Admin
router.post(
  "/assetStockAdmin",
  auth,
  catchErrors(assetControllers.assetStockView)
);
module.exports = router;
