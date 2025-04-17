const express = require("express");
const router = express.Router();
const { catchErrors } = require("./../helpers/errorHandlers");
const otherControllers = require("./../controller/otherModule.controller");
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

// History Page
router.post("/historyPage", catchErrors(otherControllers.getHistory));
// Warranty
router.post("/warranty", catchErrors(otherControllers.warranty));
module.exports = router;
